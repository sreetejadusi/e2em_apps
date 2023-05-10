import 'dart:ui';

import 'package:flutter/material.dart';

Color accentColor1 = const Color(0XFF5176eb);
Color accentColor2 = const Color(0XFF6ca4f9);


Color accentDark = const Color(0XFF3F8DCE);
Color accentLight = const Color(0XFF69B4F8);
Color cardColor = const Color(0XFFe4e4e4);
//Color backgroundColor  = const Color(0XFFf6fbff);
Color backgroundColor = Colors.white;
//Color backgroundColor = const Color(0XFFe6e8f6);

LinearGradient lg = LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
  colors: [
    //accentColor2,
    accentColor1,
    accentColor1,
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
double smallRadius = 5;
double largeRadius = 10;

Color cursorColor = Colors.black45;
InputBorder border = OutlineInputBorder(
  borderRadius: BorderRadius.circular(7),
  borderSide: const BorderSide(color: Colors.black, width: 1.5),
);
InputBorder enabledBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(7),
  borderSide: const BorderSide(color: Colors.black, width: 1.5),
);
InputBorder focusedBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(7),
  borderSide: const BorderSide(color: Colors.black, width: 1.5),
);
InputBorder errorBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(7),
  borderSide: const BorderSide(color: Colors.red, width: 1.5),
);
TextStyle hintStyle =
const TextStyle(color: Colors.black, fontWeight: FontWeight.w500);
TextStyle labelStyle =
    const TextStyle(color: Colors.black, fontWeight: FontWeight.w600);
