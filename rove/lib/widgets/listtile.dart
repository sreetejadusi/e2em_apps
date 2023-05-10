import 'package:flutter/material.dart';
//import 'package:row_collection/row_collection.dart';

class ListCell extends StatelessWidget {
  final Widget? leading, trailing;
  final String? title, subtitle;
  final VoidCallback? onTap;
  final EdgeInsets contentPadding;

  const ListCell({
    this.leading,
    this.trailing,
    required this.title,
    this.subtitle,
    this.onTap,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 17,
    ),
  });

  factory ListCell.icon({
    required IconData icon,
    Widget? trailing,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return ListCell(
      leading: Icon(icon,size: 30,),
      trailing: trailing,
      title: title,
      subtitle: subtitle,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title!,
          ),
        //  if (subtitle != null) Separator.spacer(space: 4),
        ],
      ),
      subtitle: subtitle == null
          ? null
          : Text(
        subtitle!,
      ),
      trailing: trailing,
      contentPadding: contentPadding,
      onTap: onTap,
    );
  }
}
