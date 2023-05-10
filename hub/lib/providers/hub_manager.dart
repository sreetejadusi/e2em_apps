import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:provider/provider.dart';
import '../index_files.dart';

class HubManager with ChangeNotifier {
  List<VehicleModel> get vehicles => _vehicles.reversed.toList();
  List<VehicleModel> _vehicles = [];

  List<DriverModel> get drivers => _drivers.reversed.toList();
  List<DriverModel> _drivers = [];

  List<BatteryModel> get batteries => _batteries.reversed.toList();
  List<BatteryModel> _batteries = [];

  //List<AllocationModel> get allocations => _allocations.reversed.toList();
  //List<AllocationModel> _allocations = [];

  //List<DateTime> get allocationDates => _allocationDates;
  //List<DateTime> _allocationDates = [];

  // int get selectedAllocationDateIndex => _selectedAllocationDateIndex;
  // int _selectedAllocationDateIndex = 0;

  bool get vehiclesLoading => _vehiclesLoading;
  bool _vehiclesLoading = false;

  bool get driversLoading => _driversLoading;
  bool _driversLoading = false;

  bool get batteriesLoading => _batteriesLoading;
  bool _batteriesLoading = false;

  //bool get allocationsLoading => _allocationsLoading;
  //bool _allocationsLoading = false;

  bool get batterySwapping => _batterySwapping;
  bool _batterySwapping = false;

  bool get vehicleAllocating => _vehicleAllocating;
  bool _vehicleAllocating = false;

  bool get vehicleCollecting => _vehicleCollecting;
  bool _vehicleCollecting = false;

  bool get vehicleAddingMaintenance => _vehicleAddingMaintenance;
  bool _vehicleAddingMaintenance = false;

  /*List<VehicleModel> assignedVehicles() {
    List<VehicleModel> avl = [];
    for (var vehicle in vehicles) {
      List<AllocationModel> aml = [];
      for (var allocation in vehicle.allocations) {
        aml.add(allocations
            .singleWhere((element) => element.allocationId == allocation));
      }
      int l = aml
          .where((element) => checkSameDay(
              d1: element.date,
              d2: _allocationDates[_selectedAllocationDateIndex].toString()))
          .toList()
          .length;
      if (l > 0) {
        avl.add(vehicle);
      }
    }
    return avl;
  }

  List<VehicleModel> parkingVehicles() {
    List<VehicleModel> avl = [];
    for (var vehicle in vehicles) {
      List<AllocationModel> aml = [];
      for (var allocation in vehicle.allocations) {
        aml.add(allocations
            .singleWhere((element) => element.allocationId == allocation));
      }
      int l = aml
          .where((element) => checkSameDay(
          d1: element.date,
          d2: _allocationDates[_selectedAllocationDateIndex].toString()))
          .toList()
          .length;
      if (l == 0) {
        avl.add(vehicle);
      }
    }
    return avl;
  }*/

  // bool hubMangerLoading() {
  //return ;
  //}

  /* Future<void> selectedAllocationDateIndexState(String direction) async {
    switch (direction) {
      case "+":
        if (_selectedAllocationDateIndex != allocationDates.length - 1) {
          _selectedAllocationDateIndex = _selectedAllocationDateIndex + 1;
          notifyListeners();
        }

        break;
      case "-":
        if (_selectedAllocationDateIndex != 0) {
          _selectedAllocationDateIndex = _selectedAllocationDateIndex - 1;
          notifyListeners();
        }
        break;
    }
  }*/

  Future<void> vehicleAddingMaintenanceState(bool status) async {
    _vehicleAddingMaintenance = status;
    notifyListeners();
  }

  Future<void> batterySwappingState(bool status) async {
    _batterySwapping = status;
    notifyListeners();
  }

  Future<void> vehicleAllocatingState(bool status) async {
    _vehicleAllocating = status;
    notifyListeners();
  }

  Future<void> vehicleCollectingState(bool status) async {
    _vehicleCollecting = status;
    notifyListeners();
  }

  Future<void> init(BuildContext context) async {
    print("Hub Manager Init");
    await loadVehicles(context);
    await loadBatteries(context);
    await loadDrivers(context);
    notifyListeners();
    print("Hub Manager Initialized");
  }

  /*Future<void> loadProfile(BuildContext context) async {
    try {
      await mongoDB.maintainMongoDBConnection(context);
      _drivers = [];
      _driversLoading = true;
      notifyListeners();
      DbCollection drivers = mongoDB.db.collection('drivers');
      AuthenticationProvider ap = context.read<AuthenticationProvider>();
      await drivers.find().toList().then((t) async {
        _drivers = [for (final item in t) DriverModel.fromMap(item)];
      });
      notifyListeners();
      _driversLoading = false;
      notifyListeners();
      print("Profile loaded");
    } catch (e) {
      print(e);
    }
  }*/

  /*Future<void> loadAllocations(BuildContext context) async {
    try {
      await mongoDB.maintainMongoDBConnection(context);
      _allocations = [];
      _allocationsLoading = true;
      notifyListeners();
      DbCollection allocations = mongoDB.db.collection('allocations');
      AuthenticationProvider ap = context.read<AuthenticationProvider>();
      await allocations.find().toList().then((t) async {
        _allocations = [for (final item in t) AllocationModel.fromMap(item)];
      });
      notifyListeners();
      _allocationsLoading = false;
      notifyListeners();
      print("Allocations loaded");
    } catch (e) {
      print(e);
    }
  }*/

  Future<void> loadDrivers(BuildContext context) async {
    try {
      await mongoDB.maintainMongoDBConnection(context);
      _drivers = [];
      _driversLoading = true;
      notifyListeners();
      DbCollection drivers = mongoDB.db.collection('drivers');
      AuthenticationProvider ap = context.read<AuthenticationProvider>();
      await drivers.find().toList().then((t) async {
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

  Future<void> loadBatteries(BuildContext context) async {
    try {
      await mongoDB.maintainMongoDBConnection(context);
      _batteries = [];
      _batteriesLoading = true;
      notifyListeners();
      DbCollection batteries = mongoDB.db.collection('batteries');
      await batteries.find().toList().then((t) async {
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

  Future<void> loadVehicles(BuildContext context) async {
    try {
      await mongoDB.maintainMongoDBConnection(context);
      _vehicles = [];
      _vehiclesLoading = true;
      notifyListeners();
      DbCollection vehicles = mongoDB.db.collection('vehicles');
      AuthenticationProvider ap = context.read<AuthenticationProvider>();
      await vehicles.find({"hubId": ap.loginId}).toList().then((t) async {
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

  Future<void> reset() async {
    _vehicles = [];
  }
}
