import 'dart:async';

import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier {
  bool get internetConnection => _internetConnection;
  bool _internetConnection = false;

  bool get serverConnection => _serverConnection;
  bool _serverConnection = false;

  int get currentTab => _currentTab;
  int _currentTab = 0;

  /*updateCurrentTab(int index) async {
    _currentTab = index;
    notifyListeners();
  }*/

  Future<void> internetConnectionStatus() async {
    notifyListeners();
  }

  Future<void> updateInternetConnectionStatus(bool status) async {
    _internetConnection = status;
    notifyListeners();
  }

  Future<void> updateServerConnectionStatus(bool status) async {
    _serverConnection = status;
    notifyListeners();
  }
}
