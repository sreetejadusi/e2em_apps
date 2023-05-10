import 'package:flutter/material.dart';
import '../index_files.dart';

class CustomContainer extends StatelessWidget {
  final BuildContext context;
  final Widget widget;

  const CustomContainer({
    Key? key,
    required this.context,
    required this.widget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(largeRadius),
      ),
      child: Container(
          decoration: BoxDecoration(
            gradient: clg,
            borderRadius: BorderRadius.circular(largeRadius),
          ),
          child: widget),
    );
  }
}
