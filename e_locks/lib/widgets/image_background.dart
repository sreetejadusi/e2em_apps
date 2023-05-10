import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
Widget imgBackground(Widget w){
  return Stack(
    fit: StackFit.passthrough,
    children: [
      FittedBox(
        fit: BoxFit.fill,
        child: Opacity(
            opacity: 0.6,
            child: Image.asset(
              "assets/bg.png",
            )),
      ),
      w
    ],
  );
}