import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

Widget loading(BuildContext context) {
  final w = MediaQuery.of(context).size.width;
  final h = MediaQuery.of(context).size.height;
  return Center(
    child: Column(
      children: [
        Lottie.network(
            'https://assets10.lottiefiles.com/packages/lf20_b88nh30c.json'),
        Text('Processing Request')
      ],
    ),
  );
}
