import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/index.dart';
import '../providers/index.dart';
import 'base_provider.dart';
import 'index.dart';
import '../utils/index.dart';
import '../screens/index.dart';
import 'package:provider/provider.dart';

class WalletProvider extends BaseProvider {
  WalletModel get wallet => _wallet;
  WalletModel _wallet = WalletModel();
  @override
  Future<void> init() async {
    try {
      startLoading();
      await checkMongoDBConnection();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString("userId");
      print('userId');
      print(userId);
      DbCollection wallet = mongoDB.db.collection('wallets');
      await wallet.find({'userId': userId}).toList().then((w) async {
            if (w.length != 0) {
              _wallet = WalletModel.fromMap(w.first);
            } else {}
          });
      notifyListeners();
      finishLoading();
      print(_wallet.toMap());
      print("Wallet loaded");
    } catch (e) {
      receivedError();
      print(e);
    }
  }

  Future<void> reset() async {
    _wallet = WalletModel();
  }
}
