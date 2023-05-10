import 'dart:io';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:permission_handler/permission_handler.dart';
import 'index.dart';

class DataProvider extends ChangeNotifier {
  late Timer timer;
  bool _online = false;
  late DateTime _lastConnectionCheck;
  bool get online => _online;
  DateTime get lastConnectionCheck => _lastConnectionCheck;
  Future<void> onlineStatus(BuildContext context, bool o) async {
    _online = o;
    notifyListeners();
  }

  Future<void> lastCheckedConnection(BuildContext context, DateTime dt) async {
    _lastConnectionCheck = dt;
    notifyListeners();
  }

  Future<void> checkDeviceConnection() async {
    Future.delayed(const Duration(seconds: 30), () {
      print(DateTime.now().difference(_lastConnectionCheck).inSeconds);
      if (DateTime.now().difference(_lastConnectionCheck).inSeconds >= 20) {
        _online = false;
        print('offline');
      } else {
        _online = true;
        print('online');
      }
      notifyListeners();
    });
  }
}
