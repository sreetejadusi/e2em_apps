import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_blue_elves/flutter_blue_elves.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bluetooth_devices_provider.dart';
import 'package:provider/provider.dart';

class DataProvider with ChangeNotifier {
  bool get locked => _locked;
  bool _locked = true;


  Future<void> changeLocked(bool b) async {
    _locked =b;
    notifyListeners();
  }
}
