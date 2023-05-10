
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future messageDialog(BuildContext context, String content) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Icon(Icons.error_outline,size: 50,),
        content: Text(content,textAlign: TextAlign.center,),
        actions: [
          Center(
            child: Transform.scale(
              scale: 1.2,
              child: ActionChip(
                label: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ),
          ),
        ],
      );
    },
  );
}