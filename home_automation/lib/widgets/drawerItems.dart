import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DrawerItem extends StatelessWidget {
  final String text1;
  final IconData icon;
  final Function onTap;
  const DrawerItem(this.icon, this.text1, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: ListTile(
        onTap: onTap(),
        title: Text(
          text1,
          style: GoogleFonts.breeSerif(
            textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        leading: Icon(icon, size: 26),
      ),
    );
    /* InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 45.0,
            margin: EdgeInsetsDirectional.only(start: 15.0, end: 5),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsetsDirectional.only(end: 13.0),
                  child: Container(
                    child: Icon(icon, size: 26),
                    margin:
                    EdgeInsets.only(top: 3, left: 5, bottom: 3, right: 10),
                  ),
                ),
                AutoSizeText(
                  text1,
                  minFontSize: 10,
                  style: TextStyle(
                      fontFamily: "NunitoSans",
                      fontWeight: FontWeight.w600,
                      fontSize: 15),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
          SizedBox(height: 2),
        ],
      ),
    );
    */
  }
}
