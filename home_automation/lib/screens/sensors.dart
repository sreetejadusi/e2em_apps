import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_automation/sidebar/bloc.navigation_bloc/navigation_bloc.dart';
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

class Sensors extends StatefulWidget with NavigationStates {
  @override
  _SensorsState createState() => _SensorsState();
}

class _SensorsState extends State<Sensors> {
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
    List<SensorModel> sensors = [];
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return FutureBuilder<List<SensorModel>>(
        future: DatabaseProvider.db.fetchSensors(),
        builder:
            (BuildContext context, AsyncSnapshot<List<SensorModel>> snapshot) {
          if (snapshot.hasData) {
            sensors = snapshot.data;
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: GridView.count(
                                physics: ClampingScrollPhysics(),
                                shrinkWrap: true,
                                primary: false,
                                childAspectRatio: 0.9,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                crossAxisSpacing: 30,
                                mainAxisSpacing: 30,
                                crossAxisCount: 2,
                                children: [
                                  for (var i = 0; i < sensors.length; i++) ...[
                                    SensorsItems(
                                      text1: sensors[i].name,
                                      img: sensors[i].image,
                                      onTap: () {},
                                    ),
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
}

class SensorsItems extends StatelessWidget {
  final String text1;
  final String img;
  final Function onTap;

  const SensorsItems({this.text1, this.img, this.onTap});

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
                  textAlign: TextAlign.center,
                  maxLines: 2,
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
