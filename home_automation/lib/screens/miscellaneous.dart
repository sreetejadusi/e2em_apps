import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_automation/sidebar/bloc.navigation_bloc/navigation_bloc.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather/weather.dart';
import 'index.dart';
import 'package:http/http.dart' as http;
import 'package:line_icons/line_icons.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'index.dart';
import '../providers/index.dart';
import '../utils/index.dart';
import '../widgets/index.dart';
import '../models/index.dart';

class Miscellaneous extends StatefulWidget with NavigationStates {
  @override
  _MiscellaneousState createState() => _MiscellaneousState();
}

class _MiscellaneousState extends State<Miscellaneous> {
  bool isLoading = false;
  load() async {
    setState(() {
      isLoading = true;
    });

    setState(() {
      isLoading = false;
    });
  }

  onSet() async {
    setState(() {});
  }

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    setStateProvider.addListener(onSet);
    load();
    super.initState();
  }

  @override
  void dispose() {
    setStateProvider.removeListener(onSet);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DataProvider dataProvider = context.watch<DataProvider>();
    List<MiscellaneousModel> miscellaneous = [];
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return FutureBuilder<List<MiscellaneousModel>>(
        future: DatabaseProvider.db.fetchMiscellaneous(),
        builder: (BuildContext context,
            AsyncSnapshot<List<MiscellaneousModel>> snapshot) {
          if (snapshot.hasData) {
            miscellaneous = snapshot.data;
          }
          return WillPopScope(
            onWillPop: () async {
              showDialog(
                  context: context,
                  builder: (context) {
                    return YesNoDialog(
                      icon: Icons.fullscreen_exit,
                      text: "Sure you want to exit the app    ",
                      noPressed: () {
                        Navigator.pop(context);
                      },
                      yesPressed: () {
                        exit(0);
                        //print("yes");
                      },
                    );
                  });
              return false;
            },
            child: Scaffold(
              body: isLoading
                  ? Center(child: loaderSpin(context))
                  : SingleChildScrollView(
                      physics: ClampingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            for (var i = 0; i < miscellaneous.length; i++) ...[
                              if (miscellaneous[i].hasControl == '1') ...[
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 30),
                                  child: MiscellaneousItems1(
                                    miscellaneous: miscellaneous[i],
                                    text1: miscellaneous[i].name,
                                    text2: "",
                                    img: miscellaneous[i].image,
                                    on: miscellaneous[i].data[0] == '1',
                                    deviceOnLoad: dataProvider.waitingDevice ==
                                        miscellaneous[i].deviceId,
                                    onTap: !dataProvider.online
                                        ? () {
                                            messageDialog(context,
                                                'Connection is Offline');
                                          }
                                        : dataProvider.waitingDevice != ''
                                            ? () {}
                                            : () {
                                                if (miscellaneous[i].timer ==
                                                        1 &&
                                                    miscellaneous[i].data[0] ==
                                                        "1") {
                                                  showTimer(miscellaneous[i],
                                                      () async {
                                                    await dataProvider
                                                        .waitingDeviceStatus(
                                                            context,
                                                            miscellaneous[i]
                                                                .deviceId,
                                                            DateTime.now());
                                                  });
                                                }
                                              },
                                    onClick: !dataProvider.online
                                        ? () {
                                            messageDialog(context,
                                                'Connection is Offline');
                                          }
                                        : dataProvider.waitingDevice != ''
                                            ? () {}
                                            : /* dataProvider
                                                            .waitingDevice !=
                                                        ''
                                                    ? () {
                                                        messageDialog(
                                                            context,
                                                            'Other device request in process');
                                                      }
                                                    : */
                                            () async {
                                                SharedPreferences prefs =
                                                    await SharedPreferences
                                                        .getInstance();
                                                String homeId = (prefs
                                                        .getString('homeId') ??
                                                    '');
                                                String newStatus =
                                                    miscellaneous[i].data[0] ==
                                                            "1"
                                                        ? '0'
                                                        : '1';
                                                String newDuration =
                                                    newStatus == "1"
                                                        ? miscellaneous[i]
                                                            .data[2]
                                                        : '0';
                                                await MQTTConnection.mqtt
                                                    .onPublishMessageToTopic(
                                                        homeId, [
                                                  miscellaneous[i]
                                                          .deviceId
                                                          .toString() +
                                                      ',' +
                                                      newStatus +
                                                      ',' +
                                                      miscellaneous[i].data[1] +
                                                      ',' +
                                                      newDuration
                                                ]);
                                                await dataProvider
                                                    .waitingDeviceStatus(
                                                        context,
                                                        miscellaneous[i]
                                                            .deviceId,
                                                        DateTime.now());
                                              },
                                  ),
                                ),
                              ]
                            ],
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Divider(
                                thickness: 5,
                                color: Colors.blue.withOpacity(0.4),
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Center(
                              child: GridView.count(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                primary: false,
                                childAspectRatio: 0.9,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                crossAxisSpacing: 30,
                                mainAxisSpacing: 30,
                                crossAxisCount: 2,
                                children: [
                                  for (var i = 0;
                                      i < miscellaneous.length;
                                      i++) ...[
                                    if (miscellaneous[i].hasControl == '0') ...[
                                      MiscellaneousItems2(
                                        text1: miscellaneous[i].name,
                                        img: miscellaneous[i].image,
                                        onTap: () {},
                                      ),
                                    ],
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          );
        });
  }

  showTimer(MiscellaneousModel miscellaneous, Function onApply) async {
    DataProvider dataProvider = context.read<DataProvider>();
    Duration _duration = Duration(hours: 0, minutes: 0);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SimpleDialog(
                // backgroundColor: Color(0xFFBB86FC),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                children: [
                  SizedBox(
                    height: 35,
                  ),
                  if (miscellaneous.timer == 1) ...[
                    ListTile(
                      title: Text(
                        'Timer',
                        style: GoogleFonts.breeSerif(
                          textStyle: TextStyle(
                            //color: Color(0xFF121212),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: DurationPicker(
                          snapToMins: 0,
                          duration: _duration,
                          onChange: (val) {
                            this.setState(() => _duration = val);
                            setState(() {
                              // device.data[device.data.length - 1] =
                              //     val.inMinutes.toString();
                            });
                          },
                          // snapToMins: 5.0,
                        ),
                      ),
                    ),
                  ],
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ActionChip(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          label: Text('Close'),
                        ),
                        ActionChip(
                          onPressed: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            String homeId = (prefs.getString('homeId') ?? '');
                            await MQTTConnection.mqtt
                                .onPublishMessageToTopic(homeId, [
                              miscellaneous.deviceId.toString(),
                              ',' + miscellaneous.data[0],
                              ',' + miscellaneous.data[1],
                              ',' + _duration.inMinutes.toString()
                            ]).then((value) {
                              onApply();
                            });
                            await dataProvider.waitingDeviceStatus(context,
                                miscellaneous.deviceId, DateTime.now());
                            Navigator.pop(context);
                          },
                          label: Text('Apply'),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class MiscellaneousItems1 extends StatelessWidget {
  final MiscellaneousModel miscellaneous;
  final String text1;
  final String text2;
  final bool on;
  final bool deviceOnLoad;
  final String img;
  final Function onTap;
  final Function onClick;

  const MiscellaneousItems1(
      {this.miscellaneous,
      this.text1,
      this.text2,
      this.img,
      this.on,
      this.deviceOnLoad,
      this.onTap,
      this.onClick});

  @override
  Widget build(BuildContext context) {
    format(Duration d) => d.toString().split('.').first.padLeft(8, "0");
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                  //   color: Color(color),
                  border:
                      Border.all(color: Colors.blue.withOpacity(0.2), width: 2),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20))),
              child: Container(
                child: ListTile(
                  onTap: onTap,
                  isThreeLine: false,
                  // tileColor: Theme.of(context).cardColor,
                  title: Text(
                    text1,
                    style: GoogleFonts.breeSerif(
                      textStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  subtitle: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (text2 != '') ...[
                        Text(
                          text2,
                          style: GoogleFonts.breeSerif(
                            textStyle: TextStyle(
                                fontSize: 14, color: Colors.redAccent),
                          ),
                        ),
                      ],
                      if (miscellaneous.timerTime != '' &&
                          miscellaneous.timerTime != null) ...[
                        if (DateTime.parse(miscellaneous.timerTime)
                            .isAfter(DateTime.now())) ...[
                          SizedBox(
                            height: 2,
                          ),
                          LaunchCountdown(
                              DateTime.parse(miscellaneous.timerTime)),
                        ],
                      ],
                    ],
                  ),
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Transform.scale(
                            scale: 0.9, child: Image.asset(img)),
                      ),
                    ],
                  ),
                  // trailing:
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20)),
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: deviceOnLoad
                ? Center(child: CircularProgressIndicator())
                : InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: onClick,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50.0)),
                          border: Border.all(
                              width: 1.2,
                              color: on ? Colors.green : Colors.red)),
                      child: Padding(
                        padding: const EdgeInsets.all(2.5),
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: on ? Colors.green : Colors.red,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(50.0)),
                          ),
                          child: Center(
                            child: Text(
                              on ? 'ON' : 'OFF',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class MiscellaneousItems2 extends StatelessWidget {
  final String text1;
  final String img;
  final Function onTap;

  const MiscellaneousItems2({this.text1, this.img, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      splashColor: Colors.red,
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            //   color: Color(color),
            border: Border.all(color: Colors.blue.withOpacity(0.2), width: 2),
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Tab(
                icon: Transform.scale(scale: 1.1, child: Image.asset(img)
                    // Image.asset(img)
                    )),
            SizedBox(
              height: 14,
            ),
            Column(
              children: [
                Text(
                  text1,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.breeSerif(
                      textStyle: TextStyle(
                          //   color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w400)),
                ),
                Text(
                  '45',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.breeSerif(
                      textStyle: TextStyle(
                          //   color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w300)),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }
}
