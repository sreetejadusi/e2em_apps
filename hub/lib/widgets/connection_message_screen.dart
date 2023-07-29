import 'package:flutter/material.dart';

import '../index_files.dart';
import 'package:big_tip/big_tip.dart';

import '../main.dart';

class ConnectionMessageScreen extends StatefulWidget {
  const ConnectionMessageScreen({super.key});

  @override
  State<ConnectionMessageScreen> createState() =>
      _ConnectionMessageScreenState();
}

class _ConnectionMessageScreenState extends State<ConnectionMessageScreen> {
  bool l = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: BigTip(
          title: Text(
            "Connection Issue",
            style: TextStyle(color: Colors.black),
          ),
          subtitle: Text(
            "Click on retry button to refresh connection",
            style: TextStyle(color: Colors.black),
          ),
          action: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: accentColor1, // Background color
            ),
            onPressed: () async {
              setState(() {
                l = true;
              });
              await mongoDB.maintainMongoDBConnection(context);
              setState(() {
                l = false;
              });
              RestartWidget.restartApp(context);
              // main();
            },
            child: const Text(
              "Retry",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          child: l
              ? Center(
                  child: LinearProgressIndicator(
                  color: accentColor1,
                ))
              : Container(
                  height: 130,
                  width: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.wifi,
                      // size: 160,
                      color: accentColor1,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
