import 'package:flutter/material.dart';

class ListCell extends StatelessWidget {
  final Widget? leading, trailing;
  final String title, subtitle;
  final VoidCallback onTap;
  final EdgeInsets contentPadding;

  const ListCell({
    this.leading,
    this.trailing,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 17,
    ),
  });

  factory ListCell.icon({
    required IconData icon,
    Widget? trailing,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListCell(
      leading: Icon(
        icon,
        size: 30,
      ),
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
            title,
          ),
          if (subtitle != null) SizedBox(height: 8),
        ],
      ),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle,
            ),
      trailing: trailing,
      contentPadding: contentPadding,
      onTap: onTap,
    );
  }
}
