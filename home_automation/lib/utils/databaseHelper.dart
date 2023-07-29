import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:home_automation/providers/dataProvider.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sql.dart';

import '../models/index.dart';

class DatabaseProvider {
  // DatabaseProvider(this._database);
  DatabaseProvider();

  static final DatabaseProvider db = DatabaseProvider();
  late Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await getDatabaseInstance();
    return _database;
  }

  Future<Database> getDatabaseInstance() async {
    _database = await database;
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "database.db");
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Rooms ("
          "id integer primary key AUTOINCREMENT,"
          "code TEXT,"
          "name TEXT,"
          "image TEXT,"
          "devices TEXT"
          ")");
      await db.execute("CREATE TABLE Devices ("
          "id integer primary key AUTOINCREMENT,"
          "name TEXT,"
          "image TEXT,"
          "code TEXT,"
          "deviceId TEXT,"
          "timerTime TEXT,"
          "data TEXT,"
          "category TEXT,"
          "timer INTEGER,"
          "parameters TEXT"
          ")");
      await db.execute("CREATE TABLE Sensors ("
          "id integer primary key AUTOINCREMENT,"
          "code TEXT,"
          "data TEXT,"
          "deviceId TEXT,"
          "name TEXT,"
          "image TEXT"
          ")");
      await db.execute("CREATE TABLE Miscellaneous ("
          "id integer primary key AUTOINCREMENT,"
          "deviceId TEXT,"
          "data TEXT,"
          "code TEXT,"
          "timer INTEGER,"
          "timerTime TEXT,"
          "hasControl TEXT,"
          "name TEXT,"
          "image TEXT"
          ")");
    });
  }

  Future<void> clearSensors() async {
    final db = await database;
    await db.rawDelete("DELETE FROM Sensors");
    print('Sensors Cleared');
    print(await fetchSensors());
  }

  Future<void> clearMiscellaneous() async {
    final db = await database;
    await db.rawDelete("DELETE FROM Miscellaneous");
    print('Miscellaneous Cleared');
    print(await fetchMiscellaneous());
  }

  Future<void> clearRooms() async {
    final db = await database;
    await db.rawDelete("DELETE FROM Rooms");
    print('Rooms Cleared');
    print(await fetchRooms());
  }

  Future<void> clearDevices() async {
    final db = await database;
    await db.rawDelete("DELETE FROM Devices");
    print('Devices Cleared');
    print(await fetchRooms());
  }

  Future<void> clearCategories() async {
    final db = await database;
    await db.rawDelete("DELETE FROM Categories");
    print('Categories Cleared');
    print(await fetchRooms());
  }

  Future<int> addSensor(SensorModel data) async {
    final db = await database;
    var raw = await db.insert(
      "Sensors",
      <String, dynamic>{
        "image": data.image,
        "code": data.code,
        "name": data.name,
        "data": data.data[0].toString() +
            ',' +
            data.data[1].toString() +
            ',' +
            data.data[2].toString(),
        "deviceId": data.deviceId,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;
  }

  Future<int> addMiscellaneous(MiscellaneousModel data) async {
    final db = await database;
    var raw = await db.insert(
      "Miscellaneous",
      <String, dynamic>{
        "image": data.image,
        "code": data.code,
        "name": data.name,
        "deviceId": data.deviceId,
        "hasControl": data.hasControl,
        "data": data.data[0].toString() +
            ',' +
            data.data[1].toString() +
            ',' +
            data.data[2].toString(),
        "timer": data.timer ?? 0,
        "timerTime": data.timerTime ?? '',
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;
  }

  Future<int> addRoom(RoomModel data) async {
    final db = await database;
    var raw = await db.insert(
      "Rooms",
      <String, dynamic>{
        "image": data.image,
        "code": data.code,
        "name": data.name,
        "devices": jsonEncode(data.devices),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;
  }

  Future<int> addDevice(DeviceModel data) async {
    final db = await database;
    var raw = await db.insert(
      "Devices",
      <String, dynamic>{
        "name": data.name,
        "image": data.image,
        "code": data.code,
        "timer": data.timer,
        "timerTime": data.timerTime,
        "data": data.data[0].toString() +
            ',' +
            data.data[1].toString() +
            ',' +
            data.data[2].toString(),
        "deviceId": data.deviceId,
        "category": data.category,
        "parameters": jsonEncode(data.parameters),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;
  }

  Future<List<SensorModel>> fetchSensors() async {
    final db = await database;
    var response = await db.query("Sensors");
    List<SensorModel> list =
        response.map((c) => SensorModel.fromDatabase(c)).toList();
    return list;
  }

  Future<List<MiscellaneousModel>> fetchMiscellaneous() async {
    final db = await database;
    var response = await db.query("Miscellaneous");
    List<MiscellaneousModel> list =
        response.map((c) => MiscellaneousModel.fromDatabase(c)).toList();
    return list;
  }

  Future<List<RoomModel>> fetchRooms() async {
    final db = await database;
    var response = await db.query("Rooms");
    List<RoomModel> list =
        response.map((c) => RoomModel.fromDatabase(c)).toList();
    return list;
  }

  Future<List<DeviceModel>> fetchDevices() async {
    final db = await database;
    var response = await db.query("Devices");
    List<DeviceModel> list =
        response.map((c) => DeviceModel.fromDatabase(c)).toList();
    return list;
  }

  Future<dynamic> fetchCategories() async {
    final db = await database;
    var response = await db.query("Categories");
    return response;
  }

  Future<int> changeDeviceParameters(int id, String parameters) async {
    final db = await database;
    var response = await db.rawUpdate(
        'UPDATE Devices SET parameters = ? WHERE id = ?', [parameters, id]);
    return response;
  }

  Future<int> changeDeviceTimerTime(String deviceId, String timerTime) async {
    final db = await database;
    var response = await db.rawUpdate(
        'UPDATE Devices SET timerTime = ? WHERE deviceId = ?',
        [timerTime, deviceId]);
    return response;
  }

  Future<int> changeMiscellaneousTimerTime(
      String deviceId, String timerTime) async {
    final db = await database;
    var response = await db.rawUpdate(
        'UPDATE Miscellaneous SET timerTime = ? WHERE deviceId = ?',
        [timerTime, deviceId]);
    return response;
  }

  Future<int> changeRoomTitle(int id, String title) async {
    final db = await database;
    var response = await db
        .rawUpdate('UPDATE Rooms SET name = ? WHERE id = ?', [title, id]);
    return response;
  }

  Future<int> changeDeviceData(String deviceId, String data) async {
    final db = await database;
    var response = await db.rawUpdate(
        'UPDATE Devices SET data = ? WHERE deviceId = ?', [data, deviceId]);
    return response;
  }

  Future<int> changeMiscellaneousData(String deviceId, String data) async {
    final db = await database;
    var response = await db.rawUpdate(
        'UPDATE Miscellaneous SET data = ? WHERE deviceId = ?',
        [data, deviceId]);
    return response;
  }

  Future<RoomModel> fetchRoom(int id) async {
    final db = await database;
    var response = await db.query("Rooms", where: "id = ?", whereArgs: [id]);
    return Future.value(RoomModel.fromDatabase(response.first));
  }

  deleteNote(int id) async {
    final db = await database;
    return db.delete("Notes", where: "id = ?", whereArgs: [id]);
  }
}
