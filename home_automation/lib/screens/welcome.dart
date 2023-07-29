import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State ,Center;
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/index.dart';
import '../utils/index.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'index.dart';
import 'package:provider/provider.dart';
import '../widgets/index.dart';
import '../sidebar/index.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _scaleController;
  late AnimationController _scale2Controller;
  late AnimationController _widthController;
  late AnimationController _positionController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _scale2Animation;
  late Animation<double> _widthAnimation;
  late Animation<double> _positionAnimation;
  bool isLoading = false;
  bool hideIcon = false;
  late Timer internetCheckTimer;
  /*Future<void> checkConnectivity() async {
    setState(() {
      isLoading = true;
    });
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      await load();
      print("internet  available");
    } else if (connectivityResult == ConnectivityResult.none) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NetworkError()),
      );
      print("Error in connection");
      return false;
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NetworkError()),
      );
      print("Error in connection");
      return false;
    }
  }*/

  Future<void> load() async {
    internetCheckTimer = Timer.periodic(Duration(seconds: 1), (Timer t) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool internetError = prefs.getBool('internetError') ?? true;
      var connectivityResult = await (Connectivity().checkConnectivity());
      bool i = connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi;
      if (!i && !internetError) {
        prefs.setBool("internetError", true);
        fullScreenDialog(context: context, widget: NetworkError());
      } else if (i && internetError) {
        prefs.setBool("internetError", false);
        internetCheckTimer.cancel();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Welcome()),
        );
      } else {}
    });
    setState(() {
      isLoading = true;
    });
    try {
      await mongoDB.init();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool loggedIn = (prefs.getBool('loggedIn') ?? false);
      if (loggedIn) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SideBarLayout()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    WidgetsBinding.instance.addObserver(this);
    load();
    firebase();
    super.initState();

    _scaleController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 0.8).animate(_scaleController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _widthController.forward();
            }
          });

    _widthController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));

    _widthAnimation =
        Tween<double>(begin: 80.0, end: 300.0).animate(_widthController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _positionController.forward();
            }
          });

    _positionController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));

    _positionAnimation =
        Tween<double>(begin: 0.0, end: 215.0).animate(_positionController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              setState(() {
                hideIcon = true;
              });
              _scale2Controller.forward();
            }
          });

    _scale2Controller =
        AnimationController(vsync: this, duration: Duration(microseconds: 100));

    _scale2Animation = Tween<double>(begin: 1.0, end: 32.0).animate(
        _scale2Controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Navigator.push(context,
              PageTransition(type: PageTransitionType.fade, child: Login()));
        }
      });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  firebase() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      //print(message.notification.title);
      //print(message.notification.body);
      alertDialog(
          context, message.notification!.title!, message.notification!.body!, "Ok");
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      //print(message.notification.title);
      //print(message.notification.body);
      alertDialog(
          context, message.notification!.title!, message.notification!.body!, "Ok");
    });
    /* final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    FirebaseMessaging.instance.configure(
      onMessage: (Map<String, dynamic> message) async {
        alertDialog(context, "Message", message.toString(), "Ok");
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );*/
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 45),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            /* Image.asset(
              'assets/welcomeScreenLogo.png',
              alignment: Alignment.centerLeft,
              height: MediaQuery.of(context).size.width * 0.17,
              width: MediaQuery.of(context).size.width * 0.17,
            ),*/
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  /* FadeAnimation(
                      1,
                      Text(
                        "BUCKY",
                        style: GoogleFonts.gugi(
                          textStyle: TextStyle(
                              // color: Colors.white,
                              fontSize: 50),
                        ),
                      )),*/
                  FadeAnimation(
                    1.3,
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Image.asset(
                          //"https://i.postimg.cc/C5fTZyVc/smart-house-1.png",
                          'assets/logo.png',
                          alignment: Alignment.centerLeft,
                          height: MediaQuery.of(context).size.width * 0.25,
                          width: MediaQuery.of(context).size.width * 0.25,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Center(
                    child: FadeAnimation(
                        1.3,
                        Text(
                          "BUCKY",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.gugi(
                            textStyle: TextStyle(
                                color: Colors.white,
                                //color: Colors.white.withOpacity(1),
                                fontSize: 33),
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Center(
                    child: FadeAnimation(
                        1.3,
                        Text(
                          "Chores are done hassle-free",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.breeSerif(
                            textStyle: TextStyle(
                                color: Colors.white,
                                //color: Colors.white.withOpacity(1),
                                height: 1.4,
                                fontSize: 18),
                          ),
                        )),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 70,
            ),
            Stack(
              children: [
                Opacity(
                  opacity: isLoading ? 1 : 0,
                  child: FadeAnimation(
                    1,
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Center(
                            child: LoaderCircular(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Opacity(
                  opacity: isLoading ? 0 : 1,
                  child: FadeAnimation(
                      1.6,
                      AnimatedBuilder(
                        animation: _scaleController,
                        builder: (context, child) => Transform.scale(
                            scale: _scaleAnimation.value,
                            child: Center(
                              child: AnimatedBuilder(
                                animation: _widthController,
                                builder: (context, child) => Container(
                                  width: _widthAnimation.value,
                                  height: 80,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.blue.withOpacity(.4)),
                                  child: InkWell(
                                    onTap: !isLoading
                                        ? () {
                                            _scaleController.forward();
                                          }
                                        : () {},
                                    child: Stack(children: <Widget>[
                                      AnimatedBuilder(
                                        animation: _positionController,
                                        builder: (context, child) => Positioned(
                                          left: _positionAnimation.value,
                                          child: AnimatedBuilder(
                                            animation: _scale2Controller,
                                            builder: (context, child) =>
                                                Transform.scale(
                                                    scale:
                                                        _scale2Animation.value,
                                                    child: Container(
                                                      width: 60,
                                                      height: 60,
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors.blue),
                                                      child: hideIcon == false
                                                          ? Icon(
                                                              Icons
                                                                  .arrow_forward,
                                                              color:
                                                                  Colors.white,
                                                            )
                                                          : Container(),
                                                    )),
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ),
                                ),
                              ),
                            )),
                      )),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
