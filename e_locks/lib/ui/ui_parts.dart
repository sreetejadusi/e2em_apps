import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/index.dart';
import 'dart:math' as math;
import '../utils/colors.dart';

import 'index.dart';

Widget waiting(BuildContext context, bool visible) {
  final w = MediaQuery.of(context).size.width;
  return Padding(
    padding: const EdgeInsets.only(bottom: 30),
    child: SizedBox(
      width: w * 0.5,
      child: Opacity(
          opacity: visible ? 1 : 0,
          child: LinearProgressIndicator(
            backgroundColor: appBarColor,
          )),
    ),
  );
}

Widget connection(
    BuildContext context, Function() tap, String text, Color color) {
  DataProvider dp = context.read<DataProvider>();
  final w = MediaQuery.of(context).size.width;
  final h = MediaQuery.of(context).size.height;
  return MaterialButton(
      onPressed: tap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ));
}

Widget edit(BuildContext context) {
  DataProvider dp = context.read<DataProvider>();
  final w = MediaQuery.of(context).size.width;
  final h = MediaQuery.of(context).size.height;
  return Column(
    children: [
      ListTile(
        title: dp.edit
            ? Container(
                width: w * 0.5,
                child: TextFormField(
                  textAlign: TextAlign.start,
                  autofocus: true,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                  initialValue: dp.homeName,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    dp.changeHomeName(value);
                  },
                ),
              )
            : Text(
                dp.homeName,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold),
              ),
        trailing: Transform.scale(
          scale: 0.9,
          child: dp.edit
              ? IconButton(
                  icon: Icon(
                    Icons.done,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    dp.changeEdit(false);
                  },
                )
              : IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    dp.changeEdit(true);
                  },
                ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: dp.edit
              ? Container(
                  width: w * 0.5,
                  child: TextFormField(
                    textAlign: TextAlign.start,
                    autofocus: true,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    initialValue: dp.roomName,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      dp.changeRoomName(value);
                    },
                  ),
                )
              : Text(
                  dp.roomName,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
        ),
      ),
      /*ListTile(
        title:
      ),*/
    ],
  );
}
