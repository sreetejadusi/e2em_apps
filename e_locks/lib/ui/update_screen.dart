import 'dart:async';
import 'dart:math' as math;
import 'package:e_locks/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../providers/index.dart';
import '../utils/colors.dart';

class UpdateScreen extends StatefulWidget {
  final bool mandatory;

  const UpdateScreen(
      {Key? key,
        required this.mandatory})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _UpdateScreenState();
  }
}

class _UpdateScreenState extends State<UpdateScreen> {
  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DataProvider dp = context.watch<DataProvider>();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
                child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color:
                              Colors.black.withOpacity(0.9), //color of shadow
                          spreadRadius: 7, //spread radius
                          blurRadius: 7, // blur radius
                          offset: Offset(0, 2), // changes position of shadow
                          //first paramerter of offset is left-right
                          //second parameter is top to down
                        ),
                        //you can set more BoxShadow() here
                      ],
                    ),
                    child: Image.asset(
                      "assets/logo_256.png",
                      width: 200,
                    ))),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Center(
                    child: Text(
                  "WHAT'S NEW",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25),
                )),
                SizedBox(
                  height: 20,
                ),
                Center(
                    child: Text("We have improved the overall application",
                        textAlign: TextAlign.center)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if(!widget.mandatory)...[
                  InkWell(
                    onTap: () {
                      dp.changeSkipUpdate(true);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        //color: Color(0xFF0079E9),
                        border: Border.all(width: 1, color: Colors.white),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      height: 40,
                      child: Center(
                        child: Text(
                          "Skip",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  )],
                  InkWell(
                    onTap: () {
                      openUrl("https://play.google.com/store/apps/details?id=com.app.e_locks");
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        //color: Color(0xFF0079E9),
                        border: Border.all(width: 1, color: Colors.white),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      height: 40,
                      child: Center(
                        child: Text(
                          "Update App",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
