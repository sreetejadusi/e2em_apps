import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/index.dart';
//import 'package:row_collection/row_collection.dart';

class MoveBackButton extends StatelessWidget {
  final Function() onTap;
  const MoveBackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Card(
              color: Color(0xFF2F2323),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              // decoration: BoxDecoration(
              //   color: Colors.grey,
              //  borderRadius: const BorderRadius.all(Radius.circular(15.0)),
              //),
              child: IconButton(
                onPressed: onTap,
                icon: Icon(
                  Icons.keyboard_arrow_left_sharp,
                  size: 30,
                  color: Colors.redAccent,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
