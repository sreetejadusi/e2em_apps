import 'package:big_tip/big_tip.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void fullScreenInfoDialog(
    {required BuildContext context,
    required Color color,
    IconData? icon,
    String? title,
    String? subtitle,
    String? buttonTitle,
    required Function() onBack,
    required Function() onClick}) {
  showDialog<dynamic>(
      context: context,
      builder: (BuildContext context) => WillPopScope(
            onWillPop: () async {
              onBack();
              return true;
            },
            child: Scaffold(
              body: BigTip(
                title: Text(
                  title!,
                  style: GoogleFonts.breeSerif(
                      textStyle: TextStyle(fontSize: 30, color: color)),
                ),
                subtitle: Text(
                  subtitle!,
                  style:
                      GoogleFonts.breeSerif(textStyle: TextStyle(fontSize: 20)),
                ),
                action: Container(
                  height: 50,
                  child: Ink(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      constraints: BoxConstraints(
                          minHeight: 75,
                          maxWidth: MediaQuery.of(context).size.width * 0.50),
                      child: Text(
                        buttonTitle!,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                // actionCallback: onClick,
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      size: 60,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ),
              ),
            ),
          ));
}

void fullScreenYesOrNoDialog(
    {required BuildContext context,
    required Color color,
    IconData? icon,
    String? title,
    String? subtitle,
    required Function() onYes}) {
  showDialog<dynamic>(
      context: context,
      builder: (BuildContext context) => WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Scaffold(
              body: BigTip(
                title: Text(
                  title!,
                  style: GoogleFonts.breeSerif(
                      textStyle: TextStyle(fontSize: 30, color: color)),
                ),
                subtitle: Text(
                  subtitle!,
                  style:
                      GoogleFonts.breeSerif(textStyle: TextStyle(fontSize: 20)),
                ),
                action: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Ink(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            constraints: BoxConstraints(
                                minHeight: 75,
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.20),
                            child: Text(
                              "No",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: onYes,
                        child: Ink(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            constraints: BoxConstraints(
                                minHeight: 75,
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.20),
                            child: Text(
                              "Yes",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      size: 60,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ),
              ),
            ),
          ));
}

void fullScreenMessageDialog(
    {required BuildContext context,
    required Color color,
    IconData? icon,
    String? title,
    String? subtitle,
    Function()? onBack}) {
  showDialog<dynamic>(
      context: context,
      builder: (BuildContext context) => WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Scaffold(
              body: BigTip(
                title: Text(
                  title!,
                  style: GoogleFonts.breeSerif(
                      textStyle: TextStyle(fontSize: 30, color: color)),
                ),
                subtitle: Text(
                  subtitle!,
                  style:
                      GoogleFonts.breeSerif(textStyle: TextStyle(fontSize: 20)),
                ),
                action: Container(
                  height: 50,
                  child: Ink(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      constraints: BoxConstraints(
                          minHeight: 75,
                          maxWidth: MediaQuery.of(context).size.width * 0.50),
                      child: Text(
                        "Back",
                        style: GoogleFonts.breeSerif(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                // actionCallback: onBack,
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      size: 60,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ),
              ),
            ),
          ));
}
