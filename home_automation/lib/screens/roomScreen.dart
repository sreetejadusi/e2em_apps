import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:flutter_duration_picker/flutter_duration_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State;
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_animations/simple_animations/controlled_animation.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'index.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'index.dart';
import '../providers/index.dart';
import '../utils/index.dart';
import '../widgets/index.dart';
import '../models/index.dart';

class RoomScreen extends StatefulWidget {
  final int id;
  RoomScreen({this.id});
  @override
  _RoomScreenState createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  Timer timer;
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
    setState(() {});
    List<dynamic> devices = [];
    List<DeviceModel> allDevices = [];
    RoomModel room = RoomModel();
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return FutureBuilder<RoomModel>(
        future: DatabaseProvider.db.fetchRoom(widget.id),
        builder: (BuildContext context, AsyncSnapshot<RoomModel> snapshot1) {
          if (snapshot1.hasData) {
            devices = snapshot1.data.devices;
            room = snapshot1.data;
          }
          return FutureBuilder<List<DeviceModel>>(
              future: DatabaseProvider.db.fetchDevices(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<DeviceModel>> snapshot2) {
                if (snapshot2.hasData) {
                  allDevices = snapshot2.data;
                }
                return Scaffold(
                  appBar: AppBar(
                    centerTitle: true,
                    actions: [
                      PopupMenuButton(
                        icon: Icon(
                          Icons.more_vert,
                        ),
                        offset: Offset(0.0, 10.0),
                        elevation: 1,
                        onSelected: (i) async {
                          switch (i) {
                            case 1:
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    String newName = room.name;
                                    return CustomDialog(
                                        icon: Icons.edit,
                                        widget: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25),
                                          child: TextFormField(
                                            initialValue: room.name,
                                            onChanged: (value) {
                                              newName = value;
                                            },
                                            keyboardType: TextInputType.text,
                                            style:
                                                TextStyle(color: Colors.black),
                                            cursorColor: Colors.black,
                                            decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black),
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black),
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                              ),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black),
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                              ),
                                              hintText: 'Enter Name',
                                              hintStyle: TextStyle(
                                                  color: Colors.black),
                                              //labelText: label,
                                            ),
                                            maxLines: 1,
                                          ),
                                        ),
                                        buttonlabel: 'Proceed',
                                        buttonPressed: () async {
                                          if (newName != room.name) {
                                            await DatabaseProvider.db
                                                .changeRoomTitle(
                                                    room.id, newName);
                                            Navigator.of(context).pop();
                                          } else {
                                            Navigator.of(context).pop();
                                          }
                                          await SetStateProvider.setStateProvider.sendSetState();
                                        });
                                  });
                              break;
                            default:
                              break;
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 1,
                            child: PopupMenuOption(Icons.edit, 'Edit Name'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.centerFloat,
                  body: isLoading
                      ? Center(child: loaderSpin(context))
                      : SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 0),
                                  child: Center(
                                    child: Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      height: 150,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        // color: Colors.blue.withOpacity(1.0),
                                        color: Color(0xFF262AAA),
                                        //color: Color(0xFF3b5998),
                                        /*gradient: LinearGradient(
                                  colors: [
                                    Color(0xff2b5876).withOpacity(0.7),
                                    Color(0xff4e4376).withOpacity(0.7),
                                    //Color(0xff2C3E50),
                                    //Color(0xff000000),
                                    //Color(0xff414141),
                                    //Color(0xff000000),
                                  ],
                                  begin: Alignment
                                      .topLeft, //begin of the gradient color
                                  end: Alignment
                                      .bottomRight, //end of the gradient color
                                  stops: [0.2, 0.8] //stops for individual color
                                  //set the stops number equal to numbers of color
                                  ),*/
                                        borderRadius: BorderRadius.circular(
                                            10), //border corner radius
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Image.asset(
                                            room.image,
                                            height: 100,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 15),
                                            child: VerticalDivider(
                                              color: Colors.white60,
                                              width: 1,
                                              thickness: 2,
                                            ),
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                room.name,
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.breeSerif(
                                                  textStyle: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                room.devices.length.toString() +
                                                    " Devices",
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.breeSerif(
                                                  textStyle: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      for (var i = 0;
                                          i < allDevices.length;
                                          i++) ...[
                                        if (devices.contains(
                                            allDevices[i].deviceId)) ...[
                                          RoomScreenGridItems(
                                            onTap: !dataProvider.online
                                                ? () {
                                                    messageDialog(context,
                                                        'Connection is Offline');
                                                  }
                                                : dataProvider.waitingDevice !=
                                                        ''
                                                    ? () {}
                                                    : () {
                                                        if ((allDevices[i]
                                                                        .parameters
                                                                        .length >
                                                                    0 ||
                                                                allDevices[i]
                                                                        .timer ==
                                                                    1) &&
                                                            allDevices[i]
                                                                    .data[0] ==
                                                                "1") {
                                                          showControls(
                                                              allDevices[i],
                                                              () async {
                                                            await dataProvider
                                                                .waitingDeviceStatus(
                                                                    context,
                                                                    allDevices[
                                                                            i]
                                                                        .deviceId,
                                                                    DateTime
                                                                        .now());
                                                          });
                                                        }
                                                      },
                                            device: allDevices[i],
                                            text1: allDevices[i].name,
                                            text2: allDevices[i]
                                                        .parameters
                                                        .length >
                                                    0
                                                ? allDevices[i].parameters[0]
                                                        [0] +
                                                    ' ' +
                                                    allDevices[i].data[1]
                                                : '',
                                            img: allDevices[i].image,
                                            on: allDevices[i].data[0] == "1",
                                            deviceOnLoad:
                                                allDevices[i].deviceId ==
                                                    dataProvider.waitingDevice,
                                            onClick: !dataProvider.online
                                                ? () {
                                                    messageDialog(context,
                                                        'Connection is Offline');
                                                  }
                                                : dataProvider.waitingDevice !=
                                                        ''
                                                    ? () {}
                                                    : () async {
                                                        String newStatus =
                                                            allDevices[i].data[
                                                                        0] ==
                                                                    "1"
                                                                ? '0'
                                                                : '1';
                                                        SharedPreferences
                                                            prefs =
                                                            await SharedPreferences
                                                                .getInstance();
                                                        String homeId =
                                                            (prefs.getString(
                                                                    'homeId') ??
                                                                '');
                                                        await MQTTConnection
                                                            .mqtt
                                                            .onPublishMessageToTopic(
                                                                homeId, [
                                                          allDevices[i]
                                                              .deviceId
                                                              .toString(),
                                                          ",$newStatus",
                                                          ',' +
                                                              allDevices[i]
                                                                  .data[1],
                                                          newStatus == '0'
                                                              ? ',0'
                                                              : (',' +
                                                                  allDevices[i]
                                                                      .data[allDevices[
                                                                              i]
                                                                          .data
                                                                          .length -
                                                                      1])
                                                        ]);
                                                        await dataProvider
                                                            .waitingDeviceStatus(
                                                                context,
                                                                allDevices[i]
                                                                    .deviceId,
                                                                DateTime.now());
                                                      },
                                          ),
                                        ]
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                );
              });
        });
  }

  showControls(DeviceModel device, Function onApply) async {
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
                    height: 10,
                  ),
                  for (var x = 0; x < device.parameters.length; x++) ...[
                    ListTile(
                      title: Text(
                        device.parameters[x][0],
                        style: GoogleFonts.breeSerif(
                          textStyle: TextStyle(
                            //color: Color(0xFF121212),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      subtitle: SfSlider(
                        min: double.parse(device.parameters[x][1]),
                        max: double.parse(device.parameters[x][2]),
                        value: device.data[x + 1] == "0"
                            ? double.parse(device.parameters[x][1])
                            : double.parse(device.data[x + 1]),
                        interval: double.parse(device.parameters[x][3]),
                        stepSize: double.parse(device.parameters[x][3]),
                        showTicks: true,
                        showLabels: true,
                        minorTicksPerInterval: 1,
                        onChanged: (value) {
                          setState(() {
                            device.data[x + 1] = value.toString();
                          });
                        },
                      ),
                    ),
                  ],
                  Container(
                    height: 1,
                    width: 1000,
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  if (device.timer == 1) ...[
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
                              device.deviceId.toString(),
                              ',' + device.data[0],
                              ',' + device.data[1],
                              ',' + _duration.inMinutes.toString()
                            ]).then((value) {
                              onApply();
                            });
                            await dataProvider.waitingDeviceStatus(
                                context, device.deviceId, DateTime.now());
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

class RoomScreenGridItems extends StatelessWidget {
  final DeviceModel device;
  final String text1;
  final String text2;
  final bool on;
  final bool deviceOnLoad;
  final String img;
  final Function onTap;
  final Function onClick;

  const RoomScreenGridItems(
      {this.device,
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
                      if (device.timerTime != '' &&
                          device.timerTime != null) ...[
                        if (DateTime.parse(device.timerTime)
                            .isAfter(DateTime.now())) ...[
                          SizedBox(
                            height: 2,
                          ),
                          LaunchCountdown(DateTime.parse(device.timerTime)),
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
