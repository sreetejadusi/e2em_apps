import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

extension ContextExtension on BuildContext {
  Brightness get brightness => Theme.of(this).brightness;
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
  double get paddingTop => MediaQuery.of(this).padding.top;
}

Future showLoadingDialog(BuildContext context, String text) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return LoadingDialog(
          context: context,
          text: text,
        );
      });
}

class LoadingDialog extends StatelessWidget {
  final String text;
  final BuildContext context;
  const LoadingDialog({
    required this.context,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      children: <Widget>[
        SizedBox(
          height: 15,
        ),
        Center(child: CircularProgressIndicator()),
        SizedBox(
          height: 15,
        ),
        Center(
            child: Text(
          text,
          style: GoogleFonts.breeSerif(
              textStyle: TextStyle(fontWeight: FontWeight.normal)),
          textAlign: TextAlign.center,
        )),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }
}

class CustomDialog extends StatelessWidget {
  final IconData? icon;
  final String? text;
  final Widget? widget;
  final String? buttonlabel;
  final Function() buttonPressed;

  const CustomDialog({
    this.icon,
    this.text,
    this.widget,
    this.buttonlabel,
    required this.buttonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      backgroundColor: Theme.of(context).cardColor,
      // backgroundColor: Color(0xFFBB86FC),
      title: null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Icon(
              icon,
              color: Colors.white,
              //  color: Colors.black,
              size: 80,
            ),
          ),
        ),
        if (text != null) ...[
          Center(
            child: Text(
              text!,
              textAlign: TextAlign.center,
              style: GoogleFonts.breeSerif(
                textStyle: TextStyle(
                  //color: ,
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
            ),
          )
        ],
        if (widget != null) ...[widget!],
        SizedBox(
          height: 15,
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Transform.scale(
              scale: 1.2,
              child: ActionChip(
                  backgroundColor: Theme.of(context).accentColor,
                  //backgroundColor: Color(0xFF121212),
                  label: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: Text(
                      buttonlabel!,
                      style: GoogleFonts.breeSerif(
                        textStyle: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
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

/*class YesNoDialog extends StatelessWidget {
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
      backgroundColor: Color(0xFFBB86FC),
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
                color: Color(0xFF121212),
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
                  backgroundColor: Color(0xFF121212),
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
                  backgroundColor: Color(0xFF121212),
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
}*/

Future<void> alertDialog(
    BuildContext context, String title, String content, String b) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: Text(
          title,
          style: GoogleFonts.breeSerif(
            textStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.normal,
            ),
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          content,
          style: GoogleFonts.breeSerif(
            textStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.normal,
            ),
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          Transform.scale(
            scale: 1.2,
            child: ActionChip(
                backgroundColor: Color(0xFF121212),
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
  final Widget title;
  final List<Widget> children;

  const RoundDialog({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      backgroundColor: Theme.of(context).cardColor,
      title: title == null ? null : title,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      children: children,
    );
  }
}
