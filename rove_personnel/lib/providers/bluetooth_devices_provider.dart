import 'package:flutter/material.dart';
import 'package:flutter_blue_elves/flutter_blue_elves.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/models.dart';
import 'package:provider/provider.dart';

class BluetoothDevicesProvider with ChangeNotifier {
  bool get scanning => _scanning;
  bool _scanning = false;

  bool get openedControl => _openedControl;
  bool _openedControl = false;

  List<ScanResult> get scanResultList => _scanResultList;
  List<ScanResult> _scanResultList = [];

  List<HideConnectedDevice> get hideConnectedList => _hideConnectedList;
  List<HideConnectedDevice> _hideConnectedList = [];

  String get lastDevice => _lastDevice;
  String _lastDevice = "--------";

  Device? get connectedDevice => _connectedDevice;
  Device? _connectedDevice;

  int get tabIndex => _tabIndex;
  int _tabIndex = 0;
  Future<void> changeTabIndex(int i) async {
    _tabIndex = i;
    notifyListeners();
  }

  Future<void> changeLastDevice(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('lastDevice', name);
    lastDeviceInit();
    notifyListeners();
  }

  Future<void> changeConnectedDevice(Device? d) async {
    _connectedDevice = d;
    notifyListeners();
  }

  Future<void> controlOpened(bool b) async {
    _openedControl = b;
    notifyListeners();
  }

  Future<void> lastDeviceInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _lastDevice = (prefs.getString('lastDevice') ?? "--------");
    notifyListeners();
  }

  Future<void> stopScan() async {
    try {
      FlutterBlueElves.instance.stopScan();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> scan(BuildContext context) async {
    _openedControl = false;
    notifyListeners();
    try {
      if (_scanning) {
        FlutterBlueElves.instance.stopScan();
      } else {
        _scanning = true;
        notifyListeners();
        _hideConnectedList = [];
        notifyListeners();
        getHideConnectedDevice();
        notifyListeners();
        _scanResultList = [];
        notifyListeners();
        FlutterBlueElves.instance.startScan(10000).listen((event) {
          _scanResultList.insert(0, event);
          lastDeviceInit();
          String ss = event.name ?? "-----";
          String s = ss.trim();

          if (!_openedControl && s == _lastDevice.trim()) {
            stopScan();
            Device toConnectDevice = event.connect(connectTimeout: 10000);
            changeConnectedDevice(toConnectDevice);
            changeLastDevice(s);
            changeTabIndex(0);
          }
          notifyListeners();
        }).onDone(() {
          _scanning = false;
          notifyListeners();
        });
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future<void> getHideConnectedDevice() async {
    FlutterBlueElves.instance.getHideConnectedDevices().then((values) {
      _hideConnectedList = values;
      notifyListeners();
    });
  }
}
