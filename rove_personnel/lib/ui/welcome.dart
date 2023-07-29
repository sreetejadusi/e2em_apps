import 'dart:math';

import 'package:flutter/material.dart';
import '../utils/index.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'index.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SlideAction(
                  //height: 48,
                  sliderRotate: false,
                  sliderButtonIcon: Icon(
                    Icons.arrow_forward_ios,
                    color: blueAccentColor,
                  ),
                  //sliderButtonYOffset:-48/5 ,
                  //sliderButtonIconPadding:48/4 ,
                  alignment: Alignment.center,
                  text:"Buy your dream bike",
                  textStyle: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),
                  innerColor: Colors.white,
                  outerColor: blueAccentColor,
                  borderRadius: 8,
                  animationDuration: Duration(seconds: 1),
                  elevation: 5,
                  onSubmit: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Login(),
                      ),
                    );
                  }),
            ],
          ),
          /*Container(
              height: 48,
              width: double.infinity,
              decoration: BoxDecoration(
                color: blueAccentColor,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Center(
                child: Text(
                  "Proceed",
                  style:
                  TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              )),*/
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset("assets/vh.png"),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: h * 0.05,
                    ),
                    Container(
                      color: Colors.white,
                      height: 4,
                      width: 46,
                    ),
                    SizedBox(
                      height: h * 0.02,
                    ),
                    Text(
                      "Welcome to Rove",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: h * 0.02,
                    ),
                    Text(
                      "Let's ride the future",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
