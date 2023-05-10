import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/index.dart';
import 'package:row_collection/row_collection.dart';

class ProfileListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  const ProfileListTile(this.title, this.subtitle, this.icon);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue.withOpacity(0.8),
        ),
        child: Center(
          child: Icon(icon, size: 25, color: Colors.white),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: GoogleFonts.breeSerif(
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          Separator.spacer(space: 4),
        ],
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.breeSerif(
          textStyle: TextStyle(
            fontSize: 18,
            color: Theme.of(context).textTheme.caption.color,
          ),
        ),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 16,
      ),
    );
  }
}
