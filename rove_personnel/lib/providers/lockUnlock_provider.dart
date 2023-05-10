import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/index.dart';

LockUnlock lu = LockUnlock();

class LockUnlock {
  static final LockUnlock lu = LockUnlock._internal();
  factory LockUnlock() {
    return lu;
  }

  LockUnlock._internal();
  final ObserverList<Function> _listeners = ObserverList<Function>();
  addListener(Function callback) {
    _listeners.add(callback);
  }

  removeListener(Function callback) {
    _listeners.remove(callback);
  }

  Future<void> reset() async {
    for (var element in _listeners) {
      _listeners.remove(element);
    }
  }

  Future<void> lockUnlock() async {
    for (var callback in _listeners) {
      callback();
    }
  }
}
