import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_blue_elves/flutter_blue_elves.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/weather.dart';
import 'bluetooth_devices_provider.dart';
import 'package:provider/provider.dart';

class DataProvider with ChangeNotifier {
  bool get locked => _locked;
  bool _locked = true;

  double get temp => _temp;
  double _temp = 0;

  double get hum => _hum;
  double _hum = 0;

  late Position currentPosition;

  Future<void> changeLocked(bool b) async {
    _locked = b;
    notifyListeners();
  }

  Future<void> init() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
      }
    }
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
