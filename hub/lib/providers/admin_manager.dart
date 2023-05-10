import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:provider/provider.dart';
import '../index_files.dart';

class AdminManager with ChangeNotifier {
  List<HubModel> get hubs => _hubs.reversed.toList();
  List<HubModel> _hubs = [];

  List<VehicleModel> get vehicles => _vehicles.reversed.toList();
  List<VehicleModel> _vehicles = [];

  List<DriverModel> get drivers => _drivers.reversed.toList();
  List<DriverModel> _drivers = [];

  List<BatteryModel> get batteries => _batteries.reversed.toList();
  List<BatteryModel> _batteries = [];

  bool get vehiclesLoading => _vehiclesLoading;
  bool _vehiclesLoading = false;

  bool get driversLoading => _driversLoading;
  bool _driversLoading = false;

  bool get batteriesLoading => _batteriesLoading;
  bool _batteriesLoading = false;

  bool get hubsLoading => _hubsLoading;
  bool _hubsLoading = false;

  Future<void> initHub(BuildContext context, String hubId) async {
    print("Admin Manager Init Hub");
    await loadVehicles(context, hubId);
    await loadBatteries(context, hubId);
    await loadDrivers(context, hubId);
    notifyListeners();
    print("Admin Manager Hub Initialized");
  }

  Future<void> loadHubs(BuildContext context) async {
    try {
      await mongoDB.maintainMongoDBConnection(context);
      _hubs = [];
      _hubsLoading = true;
      notifyListeners();
      DbCollection hubs = mongoDB.db.collection('hubs');
      await hubs.find().toList().then((t) async {
        _hubs = [for (final item in t) HubModel.fromMap(item)];
      });
      notifyListeners();
      _hubsLoading = false;
      notifyListeners();
      print("Hubs loaded");
    } catch (e) {
      print(e);
    }
  }

  Future<void> loadDrivers(BuildContext context, String hubId) async {
    try {
      await mongoDB.maintainMongoDBConnection(context);
      _drivers = [];
      _driversLoading = true;
      notifyListeners();
      DbCollection drivers = mongoDB.db.collection('drivers');
      await drivers.find({"hubId": hubId}).toList().then((t) async {
            _drivers = [for (final item in t) DriverModel.fromMap(item)];
          });
      notifyListeners();
      _driversLoading = false;
      notifyListeners();
      print("Drivers loaded");
    } catch (e) {
      print(e);
    }
  }

  Future<void> loadBatteries(BuildContext context, String hubId) async {
    try {
      await mongoDB.maintainMongoDBConnection(context);
      _batteries = [];
      _batteriesLoading = true;
      notifyListeners();
      DbCollection batteries = mongoDB.db.collection('batteries');
      await batteries.find({"hubId": hubId}).toList().then((t) async {
            _batteries = [for (final item in t) BatteryModel.fromMap(item)];
          });
      notifyListeners();
      _batteriesLoading = false;
      notifyListeners();
      print("Batteries loaded");
    } catch (e) {
      print(e);
    }
  }

  DriverModel? getDriver(String driverId) {
    DriverModel? dm;
    for (var i = 0; i < _drivers.length; i++) {
      if (driverId == _drivers[i].driverId) {
        dm = _drivers[i];
      }
    }
    return dm;
  }

  Future<void> loadVehicles(BuildContext context, String hubId) async {
    try {
      await mongoDB.maintainMongoDBConnection(context);
      _vehicles = [];
      _vehiclesLoading = true;
      notifyListeners();
      DbCollection vehicles = mongoDB.db.collection('vehicles');
      await vehicles.find({"hubId": hubId}).toList().then((t) async {
            _vehicles = [for (final item in t) VehicleModel.fromMap(item)];
          });
      notifyListeners();
      _vehiclesLoading = false;
      notifyListeners();
      print("Vehicles loaded");
    } catch (e) {
      print(e);
    }
  }
}
