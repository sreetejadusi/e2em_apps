import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../providers/index.dart';
import '../utils/colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SettingsScreenState();
  }
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  load() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();

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
    DataProvider dp = context.watch<DataProvider>();
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 24),
        child: Column(
          children: [
            ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              tileColor: tileColor,
              selectedTileColor: Colors.transparent,
              onTap: () {
                dp.changeAutoConnectWaiting(!dp.autoConnect);
              },
              title: const Text(
                'Auto Scan & Connect',
                style: TextStyle(color: Colors.white),
              ),
              trailing: Icon(dp.autoConnect
                  ? Icons.check_box_outlined
                  : Icons.check_box_outline_blank),
            ),
            /* CheckboxListTile(
              tileColor: tileColor,
              s
              title: const Text('Auto Connect',style: TextStyle(color: Colors.white),),
              autofocus: false,
              selected: dp.autoConnect,
              value: dp.autoConnect,
              onChanged: (bool? value) {
                dp.changeAutoConnectWaiting(value!);
              },
            ), //Chec*/
          ],
        ),
      ),
    );
  }
}
