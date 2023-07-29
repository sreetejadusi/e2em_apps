import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hub/colors&components.dart';

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
      style: TextStyle(fontWeight: FontWeight.w700),
    ),
  );
}

Widget cardItem(
    {required int num,
    required String title,
    required IconData icon,
    required Function() onTap,
    required BuildContext context}) {
  final w = MediaQuery.of(context).size.width;
  final h = MediaQuery.of(context).size.height;
  return Padding(
    padding: const EdgeInsets.all(0.0),
    child: InkWell(
        onTap: onTap,
        radius: largeRadius,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          margin: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100), color: accentColor1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100)),
                child: Icon(
                  icon,
                ),
              ),
              SizedBox(
                width: 18,
              ),
              Text(
                title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 14),
                child: Text(
                  num.toString(),
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        )
        // child: Column(
        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: <Widget>[
        //     Padding(
        //       padding: const EdgeInsets.only(left: 15),
        //       child: Container(
        //           decoration: BoxDecoration(
        //             color: Colors.white,
        //             borderRadius: BorderRadius.circular(smallRadius),
        //           ),
        //           child: Padding(
        //             padding: const EdgeInsets.all(5.0),
        //             child: Icon(
        //               icon,
        //               color: Colors.black,
        //             ),
        //           )),
        //     ),
        //     Center(
        //       child: Text(
        //         num.toString(),
        //         style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
        //       ),
        //     ),
        //     Center(
        //       child: Padding(
        //         padding: const EdgeInsets.only(bottom: 10, top: 10),
        //         child: Text(
        //           title,
        //           style:
        //               TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        ),
  );
}
