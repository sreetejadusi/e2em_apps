import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PopupMenuOption extends StatelessWidget {
  final IconData icon;
  final String text;
  const PopupMenuOption(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10),
      child: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
          ),
          Text(text),
        ],
      ),
    );
  }
}
