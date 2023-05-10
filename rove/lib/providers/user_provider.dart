import 'dart:async';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
class UserProvider extends BaseProvider {
  UserModel get user => _user;
  late UserModel _user;
  @override
  Future<void> init() async {
    try {
      startLoading();
      await checkMongoDBConnection();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      DbCollection users = mongoDB.db.collection('users');
      String? userId = prefs.getString("userId");
      print('userId');
      print(userId);
      FirebaseMessaging.instance.getToken().then((deviceToken) async {
        print('deviceToken');
        print(deviceToken);
        await users.update(
            where.eq('_id', ObjectId.fromHexString(userId!)),
            modify.set('fcmToken', deviceToken));
      });
      await users
          .find({'_id': ObjectId.fromHexString(userId!)})
          .toList()
          .then((user) async {
            if (user.length != 0) {
              _user = UserModel.fromMap(user.first);
            } else {}
          });
      notifyListeners();
      finishLoading();
      print(_user.toMap());
      print("UserDetails loaded");
    } catch (e) {
      receivedError();
      print(e);
    }
  }

}
