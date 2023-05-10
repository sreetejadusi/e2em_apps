import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_blue_elves/flutter_blue_elves.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bluetooth_devices_provider.dart';
import 'package:provider/provider.dart';

class DataProvider with ChangeNotifier {
  bool get skipUpdate => _skipUpdate;
  bool _skipUpdate = false;

  String get homeName => _homeName;
  String _homeName = "";

  String get roomName => _roomName;
  String _roomName = "";

  bool get edit => _edit;
  bool _edit = false;

  bool get autoConnect => _autoConnect;
  bool _autoConnect = false;

  bool get unlocked => _unlocked;
  bool _unlocked = false;
  bool get unlockWaiting => _unlockWaiting;
  bool _unlockWaiting = false;
  Future<void> changeSkipUpdate(bool b) async {
    _skipUpdate = b;
    notifyListeners();
  }

  Future<void> autoConnectInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _autoConnect = (prefs.getBool('autoConnect') ?? true);
    notifyListeners();
  }

  Future<void> changeAutoConnectWaiting(bool b) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('autoConnect', b);
    autoConnectInit();
    notifyListeners();
  }

  Future<void> changeUnlockWaiting(bool b) async {
    _unlockWaiting = b;
    notifyListeners();
  }

  Future<void> changeUnlocked(bool b) async {
    _unlocked = b;
    /* Future.delayed(const Duration(seconds: 1), () async {
      _unlocked = false;
    });*/
    notifyListeners();
  }

  Future<void> changeEdit(bool b) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('edit', b);
    editInit();
    notifyListeners();
  }

  Future<void> editInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _edit = (prefs.getBool('edit') ?? false);
    notifyListeners();
  }

  Future<void> homeNameInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _homeName = (prefs.getString('homeName') ?? "");
    if (_homeName.isEmpty) {
      changeHomeName("Bucky Home");
    }
    notifyListeners();
  }

  Future<void> roomNameInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _roomName = (prefs.getString('roomName') ?? "");
    if (_roomName.isEmpty) {
      changeRoomName("Main Door");
    }
    notifyListeners();
  }

  Future<void> changeHomeName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('homeName', name);
    homeNameInit();
    notifyListeners();
  }

  Future<void> changeRoomName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('roomName', name);
    roomNameInit();
    notifyListeners();
  }
}
