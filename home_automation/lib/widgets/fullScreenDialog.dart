import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void fullScreenDialog({required BuildContext context, required Widget widget}) {
  showDialog<dynamic>(
      context: context,
      builder: (BuildContext context) => WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: widget,
          ));
}
