import 'dart:ui';

import 'package:flutter/material.dart';
InputBorder border = OutlineInputBorder(
  borderRadius: BorderRadius.circular(15),
);
InputBorder enabledBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(15),
  borderSide: BorderSide(color: Colors.black),
);
InputBorder focusedBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(15),
  borderSide: BorderSide(color: Colors.blue),
);
InputBorder errorBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(15),
  borderSide: BorderSide(color: Colors.black),
);
TextStyle labelStyle = TextStyle(
    color: Colors.grey.shade700, fontWeight: FontWeight.w600);
