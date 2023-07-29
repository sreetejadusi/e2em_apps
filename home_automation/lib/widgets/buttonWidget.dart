
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget button(
    {required BuildContext context ,required String text,
      required bool filled,
      required Color color,
      required Function onTap}) {
  return Transform.scale(
    scale: 1.7,
    child: Container(
      decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: const BorderRadius.all(Radius.circular(50.0)),
          border: Border.all(width: 1.2, color: color)),
      margin: EdgeInsets.symmetric(horizontal: 100.0, vertical: 50.0),
      child: Padding(
        padding: const EdgeInsets.all(1.5),
        child: FloatingActionButton(
          heroTag: 'rhaeheah',
          backgroundColor:
          filled ? color : Theme.of(context).scaffoldBackgroundColor,
          onPressed: onTap(),
          child: Transform.scale(
              scale: 0.8,
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                    color: filled
                        ? Theme.of(context).scaffoldBackgroundColor
                        : color,
                    fontWeight: FontWeight.w700),
              )),
        ),
      ),
    ),
  );
}