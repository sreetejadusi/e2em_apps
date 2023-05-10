import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/index.dart';
import '../providers/index.dart';
import 'base_provider.dart';
import 'index.dart';
import '../screens/index.dart';
import 'package:provider/provider.dart';
import '../utils/index.dart';
class NotificationsProvider extends BaseProvider {
  List<NotificationModel> get notifications => _notifications.reversed.toList();
  List<NotificationModel> _notifications = [];
  late UserModel _user;

  Future<void> load(UserModel user) async {
    _user = user;
    await init();
  }

  @override
  Future<void> init() async {
    try {
      startLoading();
      await checkMongoDBConnection();
      _notifications = [];
      if (!_user.emailVerified) {
        _notifications.add(NotificationModel(
            id: "-",
            color: Colors.primaries[Random().nextInt(Colors.primaries.length)]
                [Random().nextInt(9) * 100],
            icon: Icons.mark_email_unread_outlined,
            title: "Email Verification",
            subtitle: "Email Verification Incomplete",
            onTap: () {

            },
            onClose: () {}));
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString("userId");
      print('userId');
      print(userId);
      DbCollection notifications = mongoDB.db.collection('notifications');
      await notifications.find({'userId': userId}).toList().then((n) async {
            for (var i = 0; i < n.length; i++) {
              ObjectId _id = n[i]['_id'];
              _notifications.add(NotificationModel(
                  id: _id.$oid.toString(),
                  color: Colors
                          .primaries[Random().nextInt(Colors.primaries.length)]
                      [Random().nextInt(9) * 100],
                  icon: Icons.info_outline,
                  title: n[i]['title'],
                  subtitle: n[i]['subtitle'],
                  onTap: () {},
                  onClose: () {}));
            }
          });
      notifyListeners();
      finishLoading();
      print("Notifications loaded");
    } catch (e) {
      receivedError();
      print(e);
    }
  }

  Future<void> removeNotification(int index) async {
    _notifications.removeAt(index);
    notifyListeners();
  }

  Future<void> reset() async {
    _notifications = [];
  }
}
