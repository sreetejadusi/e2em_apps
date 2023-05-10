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
import 'base_provider.dart';
import 'index.dart';
import '../screens/index.dart';
import 'package:provider/provider.dart';
import '../utils/index.dart';

class ImagesUrlProvider extends BaseProvider {
  List<Uint8List> get homeScreenImages => _homeScreenImages.reversed.toList();
  List<Uint8List> _homeScreenImages = [];
  List<Uint8List> get rideScreenImages => _rideScreenImages.reversed.toList();
  List<Uint8List> _rideScreenImages = [];

  @override
  Future<void> init() async {
    try {
      startLoading();
      _homeScreenImages = [];
      _rideScreenImages = [];
      Uint8List hbi1 =
          (await rootBundle.load('assets/hbi1.png')).buffer.asUint8List();
      Uint8List rbi1 =
          (await rootBundle.load('assets/hbi1.png')).buffer.asUint8List();
      _homeScreenImages.add(hbi1);
      _rideScreenImages.add(rbi1);
      notifyListeners();
      List<dynamic> fetched1 = [];
      List<dynamic> fetched2 = [];
      await checkMongoDBConnection();
      DbCollection other = mongoDB.db.collection('other');
      await other
          .find({'type': 'homeScreenImagesURL'})
          .toList()
          .then((value) async {
            if (value.length != 0) {
              fetched1 = value.first['data'];
            }
          });
      for (var i = 0; i < fetched1.length; i++) {
        final ByteData imageData =
            await NetworkAssetBundle(Uri.parse(fetched1[i])).load("");
        final Uint8List bytes = imageData.buffer.asUint8List();
        _homeScreenImages.add(bytes);
        notifyListeners();
      }
      await other
          .find({'type': 'rideScreenImagesURL'})
          .toList()
          .then((value) async {
            if (value.length != 0) {
              fetched2 = value.first['data'];
            }
          });
      for (var i = 0; i < fetched2.length; i++) {
        final ByteData imageData =
            await NetworkAssetBundle(Uri.parse(fetched2[i])).load("");
        final Uint8List bytes = imageData.buffer.asUint8List();
        _rideScreenImages.add(bytes);
        notifyListeners();
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
