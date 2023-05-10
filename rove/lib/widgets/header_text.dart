import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/index.dart';
//import 'package:row_collection/row_collection.dart';

class HeaderText extends StatelessWidget {
  final String? text;
  const HeaderText({this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text!,
          style: GoogleFonts.breeSerif(
            textStyle: TextStyle(fontSize: 25),
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
