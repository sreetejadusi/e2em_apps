import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget dropdownOptionTile(
    {required BuildContext context,
    required String text,
    required Function() onChanged}) {
  return ListTile(
    title: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Text(
        text.toString(),
        maxLines: 1,
        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
      ),
    ),
    onTap: () {
      onChanged();
    },
  );
}

Widget textFieldTitle(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
    child: Text(
      text,
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
  );
}
