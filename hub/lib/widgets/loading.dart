import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget loading(BuildContext context) {
  final w = MediaQuery.of(context).size.width;
  final h = MediaQuery.of(context).size.height;
  return Center(
    child: Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                width: w * 0.15,
                height: w * 0.15,
                child: const CircularProgressIndicator(
                  strokeWidth: 10,
                )),
            SizedBox(
              height: 35,
            ),
            Text(
              "Processing...",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    ),
  );
}
