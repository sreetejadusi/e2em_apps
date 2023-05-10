import 'package:flutter/cupertino.dart';

class NotificationModel {
  String? id;
  Color? color;
  IconData? icon;
  String? title;
  String? subtitle;
  Function? onTap;
  Function? onClose;
  NotificationModel(
      {this.id,
      this.color,
      this.icon,
      this.title,
      this.subtitle,
      this.onTap,
      this.onClose});
}
