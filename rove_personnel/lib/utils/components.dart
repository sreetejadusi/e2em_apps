import 'package:flutter/material.dart';
//282A37
Color cursorColor = Colors.white;
InputBorder border = OutlineInputBorder(
  borderRadius: BorderRadius.circular(7),
);
InputBorder enabledBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(7),
  borderSide: BorderSide(color: Color(0xFF282A37),width: 1.5),
);
InputBorder focusedBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(7),
  borderSide: BorderSide(color: Color(0xFF282A37)),
);
InputBorder errorBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(7),
  borderSide: BorderSide(color: Color(0xFF282A37)),
);
TextStyle labelStyle =
    TextStyle(color: Colors.white,fontSize: 20, fontWeight: FontWeight.w500);
