import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/index.dart';
import 'index.dart';
import 'package:provider/provider.dart';
import '../providers/index.dart';

class Start extends StatefulWidget {
  const Start({Key? key}) : super(key: key);

  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  bool connection = true;
  late Timer internetCheckTimer;
  bool isLoading = false;
  load() async {
    DevicesProvider dp = context.read<DevicesProvider>();
    setState(() {
      isLoading = true;
    });
    try {
      internetCheckTimer =
          Timer.periodic(const Duration(seconds: 2), (Timer t) async {
        bool conn = await checkInternetConnectivity();
        setState(() {
          connection = conn;
        });
      });
      await mqtt.init();
      await mongoDB.init();
      setState(() {
        isLoading = false;
      });
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
    load();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DataProvider dataProvider = context.watch<DataProvider>();
    if (!connection) {
      return const NetworkError();
    } else if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    } else {
      return const Home();
    }
  }
}
