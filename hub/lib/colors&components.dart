import 'dart:ui';

import 'package:flutter/material.dart';

Color accentColor1 = const Color(0XFF64E3C8);
Color accentColor2 = Color(0xFF7AE49D);

Color accentDark = Color(0xFF64E3C8);
Color accentLight = Color(0xFF7AE49D);
Color cardColor = const Color(0XFFe4e4e4);
//Color backgroundColor  = const Color(0XFFf6fbff);
Color backgroundColor = Colors.white;
//Color backgroundColor = const Color(0XFFe6e8f6);

LinearGradient lg = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  transform: GradientRotation(274.12),
  colors: [
    //accentColor2,
    accentColor1,
    accentColor2,
    //accentColor1
    //Color(0XFFD7E1EC),
    //Color(0XFFFFFFFF)
  ],
);
LinearGradient clg = const LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
  colors: [
    Color(0XFFFFFFFF),
    Color(0XFFD7E1EC),
  ],
);
double smallRadius = 6;
double largeRadius = 16;

Color cursorColor = Colors.black45;
InputBorder border = InputBorder.none;
InputBorder enabledBorder = InputBorder.none;
InputBorder focusedBorder = InputBorder.none;
InputBorder errorBorder = InputBorder.none;
BoxDecoration formDecoration = BoxDecoration(boxShadow: [
  BoxShadow(
    color: Colors.grey.withOpacity(0.5),
    spreadRadius: 0,
    blurRadius: 2,
    offset: Offset(0, 3), // changes position of shadow
  ),
], color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(12)));
TextStyle hintStyle = const TextStyle(fontSize: 2);
TextStyle labelStyle =
    const TextStyle(color: Colors.black, fontWeight: FontWeight.w600);
