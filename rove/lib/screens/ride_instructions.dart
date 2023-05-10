import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State;

import '../../widgets/index.dart';
import '../../utils/index.dart';
import 'index.dart';
import '../providers/index.dart';

class RideInstructions extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RideInstructionsState();
}

class _RideInstructionsState extends State<RideInstructions> {
  bool isLoading = false;
  String data = '';
  load() async {
    setState(() {
      isLoading = true;
    });
    await checkMongoDBConnection();
    DbCollection other = mongoDB.db.collection('other');
    try {
      await other
          .find({'type': 'rideInstructions'})
          .toList()
          .then((value) async {
            if (value.length != 0) {
              setState(() {
                data =value.first['data'];
              });
            }
          });
      setState(() {
        isLoading = false;
      });
    } catch (e) {
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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : MdDecode(
                title: 'Ride Instructions',
                data: data,
              ),
      ),
    );
  }
}
