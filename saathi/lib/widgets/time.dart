import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';
import 'package:google_fonts/google_fonts.dart';

Widget time() {
  Color textColor = Colors.black;
  return DigitalClock(
    digitAnimationStyle: Curves.decelerate,
    showSecondsDigit: false,
    is24HourTimeFormat: false,
    areaDecoration: const BoxDecoration(
      color: Colors.transparent,
    ),
    /*secondDigitDecoration: const BoxDecoration(
      color: Colors.transparent,
    ),*/
    hourMinuteDigitDecoration: const BoxDecoration(
      color: Colors.transparent,
    ),
    /*secondDigitTextStyle:
        TextStyle(color: Colors.transparent, fontWeight: FontWeight.bold, fontSize: 25),*/
    hourMinuteDigitTextStyle: GoogleFonts.breeSerif(
      textStyle: TextStyle(
        color: textColor,
        fontWeight: FontWeight.bold,
        fontSize: 50,
      ),
    ),
    amPmDigitTextStyle: GoogleFonts.breeSerif(
      textStyle: TextStyle(
          color: textColor, fontWeight: FontWeight.bold, fontSize: 20),
    ),
  );
}
