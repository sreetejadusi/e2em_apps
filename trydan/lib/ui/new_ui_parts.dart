import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget trydanLogo(BuildContext context,Widget widget) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          "assets/appbar_logo.png",
          //fit: BoxFit.,
          height: 70,
        ),
        Spacer(),
        widget
      ],
    ),
  );
}
