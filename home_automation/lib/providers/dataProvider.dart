import 'dart:io';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather/weather.dart';
import 'index.dart';
import '../widgets/index.dart';
import '../models/index.dart';
import '../utils/index.dart';

class DataProvider extends ChangeNotifier {
  late Timer timer;
  double _hum = 0;
  double _temp = 0;
  double _aqi = 0;
  List<String> _deviceIds = [];
  List<String> _miscellaneousIds = [];
  late Position currentPosition;
  bool _online = false;
  late DateTime _lastConnectionCheck;
  String _waitingDevice = '';
  List<String> get deviceIds => _deviceIds;
  List<String> get miscellaneousIds => _miscellaneousIds;
  String get waitingDevice => _waitingDevice;
  double get hum => _hum;
  double get temp => _temp;
  double get aqi => _aqi;
  bool get online => _online;
  DateTime get lastConnectionCheck => _lastConnectionCheck;
  late DateTime wdt;
  Future<void> init() async {
    List<DeviceModel> allDevices = await DatabaseProvider.db.fetchDevices();
    List<MiscellaneousModel> allMiscellaneous =
        await DatabaseProvider.db.fetchMiscellaneous();
    for (var i = 0; i < allDevices.length; i++) {
      _deviceIds.add(allDevices[i].deviceId);
    }
    for (var i = 0; i < allMiscellaneous.length; i++) {
      _miscellaneousIds.add(allMiscellaneous[i].deviceId);
    }
    print(deviceIds);
    print(miscellaneousIds);
    notifyListeners();
  }

  Future<void> onlineStatus(BuildContext context, bool o) async {
    _online = o;
    notifyListeners();
  }

  Future<void> waitingDeviceStatus(
      BuildContext context, String di, DateTime dt) async {
    if (di == '') {
      _waitingDevice = '';
      notifyListeners();
    } else if (di != '') {
      if (_waitingDevice == '') {
        wdt = dt;
        _waitingDevice = di;
        notifyListeners();
        try {
          Future.delayed(const Duration(seconds: 5), () {
            if (_waitingDevice != '' && wdt == dt) {
              _waitingDevice = '';
              notifyListeners();
              showDialog(
                  context: context,
                  builder: (context) {
                    return CustomDialog(
                        icon: Icons.error,
                        text: "Unable to connect to device",
                        buttonlabel: 'Ok',
                        buttonPressed: () async {
                          Navigator.pop(context);
                        });
                  });
            }
          });
        } catch (e) {
          print(e);
        }
      } else {}
    } else {}
    notifyListeners();
  }

  Future<void> lastCheckedConnection(BuildContext context, DateTime dt) async {
    _lastConnectionCheck = dt;
    notifyListeners();
  }

  Future<void> checkDeviceConnection() async {
    // _checkStarted = true;
    Future.delayed(Duration(seconds: 16), () {
      print(DateTime.now().difference(_lastConnectionCheck).inSeconds);
      if (DateTime.now().difference(_lastConnectionCheck).inSeconds >= 15) {
        _online = false;
        print('offline');
      } else {
        _online = true;
        print('online');
      }
      notifyListeners();
    });
    // timer = Timer.periodic(Duration(seconds: 16), (Timer t) {

    //});
  }

  Future<void> loadWeather(BuildContext context) async {
    if (_temp == 0) {
      try {
        await Permission.location.request();
        bool lse = await Geolocator.isLocationServiceEnabled();
        print('isLocationServiceEnabled : ' + lse.toString());
        if (!lse) {
          print('no');
          await Geolocator.openLocationSettings();
        } else {
          await Geolocator.getCurrentPosition().then((Position position) async {
            print('LATITUDE :' +
                position.latitude.toString() +
                '\nLONGITUDE :' +
                position.longitude.toString());

            currentPosition = position;
            WeatherFactory wf =
                new WeatherFactory("bb198843a48d2870d85b2b1fb9eb8a26");
            Weather w = await wf.currentWeatherByLocation(
                position.latitude, position.longitude);

            _temp = w.temperature!.celsius!.toDouble();
            _hum = w.humidity!;
            // aqi =w.a;
          });
          //loading = false;
        }
        notifyListeners();
      } catch (e) {
        print('\n\n\n\n\n');
        print(e);
        print('\n\n\n\n\n');
        notifyListeners();
      }
      notifyListeners();
    }
  }
}
