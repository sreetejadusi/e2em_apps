import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';

extension ContextExtension on BuildContext {
  Brightness get brightness => Theme.of(this).brightness;
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
  double get paddingTop => MediaQuery.of(this).padding.top;
}

flutterToast(BuildContext context, String msg, int time, ToastGravity gravity) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_LONG,
    gravity: gravity,
    timeInSecForIosWeb: time,
  );
}

class CustomDialog extends StatelessWidget {
  final IconData icon;
  final String text;
  final Widget widget;
  final String buttonlabel;
  final Function() buttonPressed;

  const CustomDialog({
    this.icon,
    this.text,
    this.widget,
    this.buttonlabel,
    this.buttonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      //backgroundColor: Color(0xFFBB86FC),
      title: null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Icon(
              icon,
              color: Colors.black,
              size: 80,
            ),
          ),
        ),
        if (text != null) ...[
          Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: GoogleFonts.breeSerif(
                textStyle: TextStyle(
                  color: Color(0xFF121212),
                  fontSize: 25,
                ),
              ),
            ),
          )
        ],
        if (widget != null) ...[widget],
        SizedBox(
          height: 15,
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Transform.scale(
              scale: 1.2,
              child: ActionChip(
                  //backgroundColor: Color(0xFF121212),
                  label: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: Text(buttonlabel),
                  ),
                  onPressed: () async {
                    buttonPressed();
                  }),
            ),
          ),
        ),
      ],
    );
  }
}

class YesNoDialog extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function() yesPressed;
  final Function() noPressed;
  const YesNoDialog({
    @required this.icon,
    @required this.text,
    @required this.yesPressed,
    @required this.noPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
    //  backgroundColor: Color(0xFFBB86FC),
      title: null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Icon(
              icon,
              color: Colors.black,
              size: 80,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            text,
            style: GoogleFonts.breeSerif(
              textStyle: TextStyle(
                fontSize: 23,
                //color: Color(0xFF121212),
                fontWeight: FontWeight.normal,
              ),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 45,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Transform.scale(
              scale: 1.2,
              child: ActionChip(
                 // backgroundColor: Color(0xFF121212),
                  label: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: Text("No"),
                  ),
                  onPressed: () {
                    noPressed();
                  }),
            ),
            Transform.scale(
              scale: 1.2,
              child: ActionChip(
                  //backgroundColor: Color(0xFF121212),
                  label: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: Text("Yes"),
                  ),
                  onPressed: () {
                    yesPressed();
                  }),
            ),
          ],
        )
      ],
    );
  }
}

Future messageDialog(BuildContext context, String content) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Icon(Icons.wifi_off,size: 50,),
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

Future<void> alertDialog(
    BuildContext context, String title, String content, String b) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        // backgroundColor: Color(0xFFBB86FC),
        title: Text(
          title,
          style: GoogleFonts.breeSerif(
            textStyle: TextStyle(
              //color: Color(0xFF121212),
              fontWeight: FontWeight.normal,
            ),
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          content,
          style: GoogleFonts.breeSerif(
            textStyle: TextStyle(
              //color: Color(0xFF121212),
              fontWeight: FontWeight.normal,
            ),
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          Transform.scale(
            scale: 1.2,
            child: ActionChip(
                // backgroundColor: Color(0xFF121212),
                label: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 13),
                  child: Text(b),
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
        ],
      );
    },
  );
}

class RoundDialog extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const RoundDialog({
    this.title,
    @required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      backgroundColor: Color(0xFFBB86FC),
      title: title == null
          ? null
          : Text(
              title.toUpperCase(),
              style: GoogleFonts.breeSerif(
                textStyle: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF121212),
                  fontWeight: FontWeight.bold,
                ),
              ),
              textAlign: TextAlign.center,
            ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      children: children,
    );
  }
}
