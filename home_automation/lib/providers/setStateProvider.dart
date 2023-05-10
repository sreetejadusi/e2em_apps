import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/index.dart';

SetStateProvider setStateProvider = SetStateProvider();

class SetStateProvider {
  static final SetStateProvider setStateProvider = SetStateProvider._internal();
  factory SetStateProvider() {
    return setStateProvider;
  }

  SetStateProvider._internal();
  ObserverList<Function> _listeners = new ObserverList<Function>();
  addListener(Function callback) {
    _listeners.add(callback);
  }

  removeListener(Function callback) {
    _listeners.remove(callback);
  }

  Future<void> sendSetState() async {
    _listeners.forEach((Function callback) {
      callback();
    });
  }
}
