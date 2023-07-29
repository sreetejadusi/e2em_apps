import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State, Center;
import '../../widgets/index.dart';
import '../../utils/index.dart';
import 'index.dart';
import '../providers/index.dart';

class TermsAndConditions extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  bool isLoading = false;
  String data = '';
  load() async {
    setState(() {
      isLoading = true;
    });
    DbCollection other = mongoDB.db.collection('other');
    try {
      await other
          .find({'type': 'termsAndConditions'})
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
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : MdDecode(
        title: 'Terms And Conditions',
        data: data,
      ),
    );
  }
}
