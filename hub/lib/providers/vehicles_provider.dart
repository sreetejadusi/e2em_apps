import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../index_files.dart';

class VehiclesProvider with ChangeNotifier {
  List<VehicleModel> get vehicles => _vehicles.reversed.toList();
  List<VehicleModel> _vehicles = [];
  Future<void> load(BuildContext context) async {
    try {
      await mongoDB.maintainMongoDBConnection(context);
      _vehicles = [];
      DbCollection vehicles = mongoDB.db.collection('vehicles');
      await vehicles
          .find()
          .toList()
          .then((t) async {
            _vehicles = [for (final item in t) VehicleModel.fromMap(item)];
          });
      notifyListeners();
      print("Vehicles loaded");
    } catch (e) {
      print(e);
    }
  }

  Future<void> reset() async {
    _vehicles = [];
  }
}
