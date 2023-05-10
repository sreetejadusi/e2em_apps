import 'dart:async';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/index.dart';
import '../providers/index.dart';
import 'baseProvider.dart';
import 'index.dart';
import '../utils/index.dart';
import '../screens/index.dart';
import 'package:provider/provider.dart';

class RoomsAndDevicesProvider extends BaseProvider {
  Future<void> load() async {
    List<RoomModel> rooms = await DatabaseProvider.db.fetchRooms();
    if (rooms.length == 0) {
      await init();
    }
  }

  @override
  Future<void> init() async {
    try {
      startLoading();
      await checkMongoDBConnection();
      await DatabaseProvider.db.clearRooms();
      await DatabaseProvider.db.clearDevices();
      await DatabaseProvider.db.clearSensors();
      await DatabaseProvider.db.clearMiscellaneous();
      List<Map<String, dynamic>> roomsList = [];
      List<Map<String, dynamic>> categoriesList = [];
      List<Map<String, dynamic>> devicesList = [];
      List<Map<String, dynamic>> sensorsList = [];
      List<Map<String, dynamic>> miscellaneousList = [];
      DbCollection rooms = mongoDB.db.collection('rooms');
      await rooms.find().toList().then((items) async {
        for (var i = 0; i < items.length; i++) {
          Map<String, dynamic> item = items[i];
          roomsList.add(item);
        }
      });
      print('Rooms List');
      print(roomsList);
      DbCollection categories = mongoDB.db.collection('Categories');
      await categories.find().toList().then((items) async {
        for (var i = 0; i < items.length; i++) {
          Map<String, dynamic> item = items[i];
          categoriesList.add(item);
        }
      });
      print('Categories List');
      print(categoriesList);
      DbCollection devices = mongoDB.db.collection('devices');
      await devices.find().toList().then((items) async {
        for (var i = 0; i < items.length; i++) {
          Map<String, dynamic> item = items[i];
          devicesList.add(item);
        }
      });
      print('Devices List');
      print(devicesList);
      DbCollection sensors = mongoDB.db.collection('sensors');
      await sensors.find().toList().then((items) async {
        for (var i = 0; i < items.length; i++) {
          Map<String, dynamic> item = items[i];
          sensorsList.add(item);
        }
      });
      print('Sensors List');
      print(sensorsList);
      DbCollection miscellaneous = mongoDB.db.collection('miscellaneous');
      await miscellaneous.find().toList().then((items) async {
        for (var i = 0; i < items.length; i++) {
          Map<String, dynamic> item = items[i];
          miscellaneousList.add(item);
        }
      });
      print('Miscellaneous List');
      print(miscellaneousList);
      ///////////Fetching Home Id///////////////
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String homeId = (prefs.getString('homeId') ?? '');
      DbCollection home = mongoDB.db.collection(homeId);
      await home.find({'type': 'room'}).toList().then((items) async {
            for (var i = 0; i < items.length; i++) {
              for (var j = 0; j < roomsList.length; j++) {
                if (items[i]['code'] == roomsList[j]['code']) {
                  RoomModel roomModel = RoomModel(
                    code: items[i]["code"],
                    name: roomsList[j]["name"],
                    image: roomsList[j]["image"],
                    devices: items[i]["devices"],
                  );
                  await DatabaseProvider.db.addRoom(roomModel);
                }
              }
            }
          });
      await home.find({'type': 'device'}).toList().then((items) async {
            for (var i = 0; i < items.length; i++) {
              for (var j = 0; j < devicesList.length; j++) {
                if (items[i]['code'] == devicesList[j]['code']) {
                  List<dynamic> d = [];
                  d = items[i]["data"].split(',');
                  DeviceModel deviceModel = DeviceModel(
                    name: devicesList[j]["name"],
                    image: devicesList[j]["image"],
                    code: items[i]["code"],
                    timer: items[i]["timer"],
                    timerTime: items[i]["timerTime"] ?? '',
                    deviceId: items[i]["deviceId"],
                    data: d,
                    parameters: "",
                    category: items[i]["category"],
                  );
                  await DatabaseProvider.db.addDevice(deviceModel);
                }
              }
            }
          });

      await home.find({'type': 'sensor'}).toList().then((items) async {
            for (var i = 0; i < items.length; i++) {
              for (var j = 0; j < sensorsList.length; j++) {
                if (items[i]['code'] == sensorsList[j]['code']) {
                  List<dynamic> d = [];
                  d = items[i]["data"].split(',');
                  SensorModel sensorModel = SensorModel(
                    code: items[i]["code"],
                    deviceId: items[i]["deviceId"],
                    data: d,
                    name: sensorsList[j]["name"],
                    image: sensorsList[j]["image"],
                  );
                  await DatabaseProvider.db.addSensor(sensorModel);
                }
              }
            }
          });
      await home.find({'type': 'miscellaneous'}).toList().then((items) async {
            for (var i = 0; i < items.length; i++) {
              for (var j = 0; j < miscellaneousList.length; j++) {
                if (items[i]['code'] == miscellaneousList[j]['code']) {
                  List<dynamic> d = [];
                  d = items[i]["data"].split(',');
                  MiscellaneousModel miscellaneousModel = MiscellaneousModel(
                    code: items[i]["code"],
                    deviceId: items[i]["deviceId"],
                    data: d,
                    timer: items[i]["timer"]??0,
                    timerTime: items[i]["timerTime"] ?? '',
                    hasControl: items[i]["hasControl"],
                    name: miscellaneousList[j]["name"],
                    image: miscellaneousList[j]["image"],
                  );
                  await DatabaseProvider.db
                      .addMiscellaneous(miscellaneousModel);
                }
              }
            }
          });

      List<DeviceModel> allDevices = await DatabaseProvider.db.fetchDevices();
      for (var i = 0; i < allDevices.length; i++) {
        print(allDevices[i].id);
        print(allDevices[i].parameters);
        for (var j = 0; j < categoriesList.length; j++) {
          if (allDevices[i].category == categoriesList[j]['code']) {
            await DatabaseProvider.db.changeDeviceParameters(
                allDevices[i].id, jsonEncode(categoriesList[j]['parameters']));
          }
        }
      }
      List<DeviceModel> devices1 = await DatabaseProvider.db.fetchDevices();
      for (var i = 0; i < devices1.length; i++) {
        print(devices1[i].id);
        print(devices1[i].parameters);
      }
      print('Rooms in Database');
      print(await DatabaseProvider.db.fetchRooms());
      print('Devices in Database');
      print(await DatabaseProvider.db.fetchDevices());
      notifyListeners();
      finishLoading();
      print("Rooms And Devices Loaded");
    } catch (e) {
      receivedError();
      print(e);
    }
  }
}
