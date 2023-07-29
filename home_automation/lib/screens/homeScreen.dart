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

class HomeScreen extends StatefulWidget with NavigationStates {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String name = '';
  bool isLoading = false;
  load() async {
    DataProvider dataProvider = context.read<DataProvider>();
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? '';
    });
    await dataProvider.loadWeather(context);
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
    List<RoomModel> rooms = [];
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return FutureBuilder<List<RoomModel>>(
        future: DatabaseProvider.db.fetchRooms(),
        builder:
            (BuildContext context, AsyncSnapshot<List<RoomModel>> snapshot) {
          if (snapshot.hasData) {
            rooms = snapshot.data!;
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
                      },
                    );
                  });
              return false;
            },
            child: isLoading
                ? Center(child: loaderSpin(context))
                : Scaffold(
                    body: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //LinearProgressIndicator(),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 25, horizontal: 0),
                              child: Center(
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 20),
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
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            LineIcons.home,
                                            size: 75,
                                            color: Colors.white,
                                            // color: Theme.of(context).iconTheme.color.withOpacity(0.6),
                                            //color: Theme.of(context).accentColor,
                                          ),
                                          Text(
                                            '15 Devices',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.breeSerif(
                                              textStyle: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
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
                                      isLoading
                                          ? Center(
                                              child:
                                                  CircularProgressIndicator())
                                          : Column(
                                              mainAxisSize: MainAxisSize.min,
                                              // crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  dataProvider.temp
                                                          .toStringAsFixed(2) +
                                                      ' °C',
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.breeSerif(
                                                    textStyle: TextStyle(
                                                        fontSize: 17,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  'Humidity: ' +
                                                      dataProvider.hum
                                                          .toStringAsFixed(2),
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.breeSerif(
                                                    textStyle: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  'AQI: 2',
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
                            Center(
                              child: TextButton(
                                onPressed: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  String homeId =
                                      (prefs.getString('homeId') ?? '');
                                  await MQTTConnection.mqtt
                                      .onPublishMessageToTopic('@' + homeId,
                                          ['hello']).then((value) {});
                                },
                                child: Text('MQTT'),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              child: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: 'Welcome\n',
                                    style: GoogleFonts.breeSerif(
                                      textStyle: TextStyle(
                                          fontSize: 15,
                                          color: Theme.of(context)
                                              .iconTheme
                                              .color),
                                    ),
                                  ),
                                  TextSpan(
                                    text: name,
                                    style: GoogleFonts.breeSerif(
                                      textStyle: TextStyle(
                                          fontSize: 20,
                                          color: Theme.of(context)
                                              .iconTheme
                                              .color),
                                    ),
                                  ),
                                ]),
                              ),
                              /* Text(
                          'Welcome\nGunasekhar',
                          style:GoogleFonts.breeSerif(
                            textStyle:  TextStyle(fontSize: 20),),
                        ),*/
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: GridView.count(
                                physics: ClampingScrollPhysics(),
                                shrinkWrap: true,
                                primary: false,
                                childAspectRatio: 1.0,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                crossAxisSpacing: 30,
                                mainAxisSpacing: 30,
                                crossAxisCount: 2,
                                children: [
                                  for (var i = 0; i < rooms.length; i++) ...[
                                    HomeScreenGridItems(
                                      text1: rooms[i].name,
                                      text2:
                                          rooms[i].devices.length.toString() +
                                              " Devices",
                                      img: rooms[i].image,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => RoomScreen(
                                                    id: rooms[i].id,
                                                  )),
                                        );
                                      },
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

class HomeScreenGridItems extends StatelessWidget {
  final String text1;
  final String text2;
  final String img;
  final Function onTap;

  const HomeScreenGridItems({required this.text1, required this.text2, required this.img, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      splashColor: Colors.red,
      //splashColor: Colors.transparent,
      //hoverColor: Colors.transparent,
      // highlightColor: Colors.transparent,
      onTap: onTap(),
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
            Text(
              text1,
              style: GoogleFonts.breeSerif(
                  textStyle: TextStyle(
                      //   color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400)),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              text2,
              style: GoogleFonts.breeSerif(
                  textStyle: TextStyle(
                      // color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w400)),
            ),
          ],
        ),
      ),
      /* Container(
        decoration: BoxDecoration(
          boxShadow:[
            BoxShadow(
              color: Colors.grey.withOpacity(0.3), //color of shadow
              spreadRadius: 2, //spread radius
              blurRadius: 2, // blur radius
              offset: Offset(0, 2), // changes position of shadow
              //first paramerter of offset is left-right
              //second parameter is top to down
            ),
            //you can set more BoxShadow() here
          ],
          //color: Colors.grey.withOpacity(0.2),
          //color: Color(0xFFf0f5fb),
          color: Theme.of(context).cardColor,
          //color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          // border: Border.all(width: 0.6, color: Colors.black38)
        ),
        child: Tab(
          icon: Transform.scale(
            scale: 1.5,
            child: Icon(
              icon,
              size: 32,
              color: iconColour,
              // color: Color(0xFFf56a4d),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text1,
                textAlign: TextAlign.center,
                style: GoogleFonts.breeSerif(
                  textStyle: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                text2,
                textAlign: TextAlign.center,
                style: GoogleFonts.breeSerif(
                  textStyle: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF5451d6),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),*/
    );
  }
}
