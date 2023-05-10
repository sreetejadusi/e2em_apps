import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/index.dart';
import '../providers/index.dart';
import 'baseProvider.dart';
import 'index.dart';
import '../screens/index.dart';
import 'package:provider/provider.dart';

class ImagesUrlProvider extends BaseProvider {
  List<Uint8List> get homeScreenImages => _homeScreenImages.reversed.toList();
  List<Uint8List> _homeScreenImages = [];
  List<Uint8List> get rideScreenImages => _rideScreenImages.reversed.toList();
  List<Uint8List> _rideScreenImages = [];
  UserModel _user = UserModel();

  @override
  Future<void> init() async {
    try {
      startLoading();
      _homeScreenImages = [];
      List<dynamic> fetched1 = [];
      List<dynamic> fetched2 = [];
      DbCollection other = mongoDB.db.collection('other');
      await other.find({'type': 'homeScreenImagesURL'}).toList().then((value) async {
            if (value.length != 0) {
              fetched1 = value.first['data'];
            }
          });
      for (var i = 0; i < fetched1.length; i++) {
        final ByteData imageData =
            await NetworkAssetBundle(Uri.parse(fetched1[i])).load("");
        final Uint8List bytes = imageData.buffer.asUint8List();
        _homeScreenImages.add(bytes);
      }
      await other.find({'type': 'rideScreenImagesURL'}).toList().then((value) async {
        if (value.length != 0) {
          fetched2 = value.first['data'];
        }
      });
      for (var i = 0; i < fetched2.length; i++) {
        final ByteData imageData =
        await NetworkAssetBundle(Uri.parse(fetched2[i])).load("");
        final Uint8List bytes = imageData.buffer.asUint8List();
        _rideScreenImages.add(bytes);
      }
      notifyListeners();
      finishLoading();
      print("Images loaded");
    } catch (e) {
      receivedError();
      print(e);
    }
  }
}
