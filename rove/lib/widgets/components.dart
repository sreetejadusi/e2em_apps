import 'dart:ui';

import 'package:flutter/material.dart';
import '../colors.dart';

class TextFieldOuter extends StatelessWidget {
  final Widget child;
  const TextFieldOuter({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF303030),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: child),
      ),
    );
  }
}

Color cursorColor = accentColor;
InputBorder border = InputBorder.none;
/*OutlineInputBorder(
  borderRadius: BorderRadius.circular(15),
);*/
InputBorder enabledBorder = InputBorder.none;
/*OutlineInputBorder(
  borderRadius: BorderRadius.circular(15),
  borderSide: BorderSide(color: Colors.white),
);*/
InputBorder focusedBorder = InputBorder.none;
/*OutlineInputBorder(
  borderRadius: BorderRadius.circular(15),
  borderSide: BorderSide(color: Colors.blue),
);*/
InputBorder errorBorder = InputBorder.none;
/*OutlineInputBorder(
  borderRadius: BorderRadius.circular(15),
  borderSide: BorderSide(color: Colors.white),
);*/
TextStyle labelStyle =
    TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.w600);
