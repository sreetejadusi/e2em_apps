import 'dart:async';
import 'dart:math' as math;
import '../utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icon.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../providers/index.dart';
import 'index.dart';

class NoDeviceControlScreen extends StatefulWidget {
  const NoDeviceControlScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _NoDeviceControlScreenState();
  }
}

class _NoDeviceControlScreenState extends State<NoDeviceControlScreen>
    with SingleTickerProviderStateMixin {
  //bool unLockWaiting = false;
  bool isLoading = false;
  load() async {
    DataProvider dp = context.read<DataProvider>();
    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    dp.changeUnlockWaiting(false);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    load();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    DataProvider dp = context.watch<DataProvider>();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            SizedBox(
              height: 32,
            ),
            edit(context),
            SizedBox(
              height: 30,
            ),
            connection(context, () {}, "No Device Connected", Colors.white),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  waiting(context, dp.unlockWaiting),
                  SwitchButton(
                    enabled: false,
                    onDown: () {
                      dp.changeUnlockWaiting(true);
                      Future.delayed(const Duration(seconds: 1), () async {
                        dp.changeUnlockWaiting(false);
                      });
                      print("down");
                    },
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
