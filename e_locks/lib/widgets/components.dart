import 'dart:ui';

import 'package:flutter/material.dart';

InputBorder linedBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(8),
  borderSide: BorderSide(color: Colors.white, width: 1),
);
InputBorder linedEnabledBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(8),
  borderSide: BorderSide(color: Colors.white, width: 1),
);
InputBorder linedFocusedBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(8),
  borderSide: BorderSide(color: Colors.white, width: 1),
);
InputBorder linedErrorBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(8),
  borderSide: BorderSide(color: Colors.red, width: 1),
);
TextStyle linedLabelStyle =
TextStyle(color: Colors.white, fontWeight: FontWeight.w300);
///
InputBorder border = OutlineInputBorder(
  borderRadius: BorderRadius.circular(8),
  borderSide: BorderSide(color: Colors.transparent, width: 1),
);
InputBorder enabledBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(8),
  borderSide: BorderSide(color: Colors.transparent, width: 1),
);
InputBorder focusedBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(8),
  borderSide: BorderSide(color: Colors.transparent, width: 1),
);
InputBorder errorBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(8),
  borderSide: BorderSide(color: Colors.transparent, width: 1),
);
TextStyle labelStyle =
    TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w300);
