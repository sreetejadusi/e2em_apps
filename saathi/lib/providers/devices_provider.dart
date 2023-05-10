import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../models/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'index.dart';
import 'package:provider/provider.dart';

class DevicesProvider extends ChangeNotifier {
  String? get sendTopic => _sendTopic;
  String _sendTopic = "@z";
  String? get receiveTopic => _receiveTopic;
  String _receiveTopic = "z";
  String get primaryDevice => _primaryDevice;
  String _primaryDevice = " ";
  List<DeviceModel> get devices => _devices;
  List<DeviceModel> _devices = [];
  Future<void> updatePrimaryDevice(BuildContext context, String id) async {
    DataProvider dp = context.read<DataProvider>();
    await dp.onlineStatus(context, false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('primaryDevice', id);
    _primaryDevice = id;
    _sendTopic = "@" + id;
    _receiveTopic = id;
    notifyListeners();
    try {
      await MQTTConnection.mqtt.checkMQTTConnection();
      await MQTTConnection.mqtt.onUnSubscribeToTopic("#");
      await MQTTConnection.mqtt.onSubscribeToTopic(id);
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  String getPrimaryDeviceName() {
    String name = "No Devices Added";
    for (var y = 0; y < _devices.length; y++) {
      if (_devices[y].id == _primaryDevice) {
        name = _devices[y].name;
      }
    }
    return name;
  }

  Future<void> save(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> devicesData = [
      for (final item in _devices) item.toMap()
    ];
    prefs.setString('devicesData', jsonEncode(devicesData));
    notifyListeners();
    init(context);
  }

  Future<void> addDevice(BuildContext context, DeviceModel d) async {
    _devices.add(d);
    if (_devices.length == 1) {
      await updatePrimaryDevice(context, d.id);
    } else {}
    notifyListeners();
    await save(context);
  }

  Future<void> removeDevice(BuildContext context, String id) async {
    for (var y = 0; y < _devices.length; y++) {
      if (_devices[y].id == id) {
        _devices.removeAt(y);
      }
    }
    notifyListeners();
    if (_devices.isNotEmpty) {
      await updatePrimaryDevice(context, _devices[0].id);
    } else {
      await updatePrimaryDevice(context, " ");
    }
    notifyListeners();
    await save(context);
  }

  Future<void> editDeviceName(
      BuildContext context, String id, String name) async {
    for (var y = 0; y < _devices.length; y++) {
      if (_devices[y].id == id) {
        _devices[y].name = name;
      }
    }
    notifyListeners();
    await save(context);
  }

  Future<void> init(BuildContext context) async {
    DataProvider dp = context.read<DataProvider>();
    _devices = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String devicesData = (prefs.getString('devicesData') ?? jsonEncode([]));
    List<dynamic> ld = jsonDecode(devicesData);
    List<Map<String, dynamic>> parsedDevicesData = [];
    for (var y = 0; y < ld.length; y++) {
      Map<String, dynamic> m = ld[y];
      parsedDevicesData.add(m);
    }
    _devices = [
      for (final item in parsedDevicesData) DeviceModel.fromDocument(item)
    ];
    notifyListeners();

    ///
    String pDevice = (prefs.getString('primaryDevice')) ?? " ";

    if (_devices.isNotEmpty && pDevice.length > 2) {
      _primaryDevice = pDevice;
      _sendTopic = "@" + pDevice;
      _receiveTopic = pDevice;
      notifyListeners();
      try {
        await MQTTConnection.mqtt.checkMQTTConnection();
        await MQTTConnection.mqtt.onUnSubscribeToTopic("#");
        await MQTTConnection.mqtt.onSubscribeToTopic(pDevice);
      } catch (e) {
        print(e);
      }
    } else {}
    notifyListeners();
    try {
      if (_primaryDevice.length > 2) {
        await MongoDBConnection.mongoDB.checkMongoDBConnection();
        DbCollection dc = mongoDB.db.collection('mycollection');
        await dc
            .find({
              'topic': _primaryDevice,
            })
            .toList()
            .then((value) async {
              if (value.isNotEmpty) {
                String data = value.first['data'] ?? " ";
                dp.parseMessage(context, data,false);
              }
            });
      } else {}
    } catch (e) {
      print(e);
    }
  }
}
