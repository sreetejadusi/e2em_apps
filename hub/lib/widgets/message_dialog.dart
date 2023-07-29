import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

messageDialog(BuildContext context, String text, bool positive) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Column(
        children: [
          Lottie.network(
            positive
                ? 'https://assets9.lottiefiles.com/packages/lf20_llvpcqsi.json'
                : 'https://assets7.lottiefiles.com/packages/lf20_tl52xzvn.json',
            repeat: false,
            onLoaded: (p0) {
              Timer(Duration(milliseconds: 4500), () {
                Navigator.pop(context);
              });
            },
          ),
          Text(text)
        ],
      ),
    ),
  );
}
