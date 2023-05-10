import 'dart:async';
import 'package:flutter/cupertino.dart';
import '../widgets/index.dart';

Map<int, String> times = {
  1: "00:00",
  30: "00:30",
  45: "00:45",
  60: "01:00",
  120: "02:00",
  180: "03:00",
  240: "04:00",
  300: "05:00",
  360: "06:00",
  420: "07:00",
  480: "08:00",
};

class DataProvider extends ChangeNotifier {
  //
  bool get waitingForMessage => _waitingForMessage;
  bool _waitingForMessage = false;
  //
  String get timerTimeString => _timerTimeString;
  String _timerTimeString = "00:00";
  //
  bool get on => _on;
  bool _on = false;
  //
  double get sliderValue => _sliderValue;
  double _sliderValue = 1.0;
  //
  int get inOperate => _inOperate;
  int _inOperate = 0;
  //
  bool get fault => _fault;
  bool _fault = false;
  //
  bool get timerOn => _timerOn;
  bool _timerOn = false;
  //
  int get totalTimer => _totalTimer;
  int _totalTimer = 0;
  //
  int get timerMin => _timerMin;
  int _timerMin = 0;
  //
  bool get changing => _changing;
  bool _changing = false;
  //
  DateTime get lastChange => _lastChange;
  DateTime _lastChange = DateTime.now().subtract(const Duration(hours: 1));
  //
  late Timer timer;
  //
  DateTime get lastConnectionCheck => _lastConnectionCheck;
  late DateTime _lastConnectionCheck;
  //
  bool get online => _online;
  bool _online = false;
  //
  Future<void> waitingForMessageStatus(bool w) async {
    _waitingForMessage = w;
    notifyListeners();
  }

  Future<void> onStatus(BuildContext context, bool o) async {
    _on = o;
    notifyListeners();
  }

  Future<void> updateSliderValue(double value) async {
    _sliderValue = value;
    notifyListeners();
  }

  Future<void> updateFault(bool t) async {
    _fault = t;
    notifyListeners();
  }

  Future<void> updateInOperate(int t) async {
    _inOperate = t;
    notifyListeners();
  }

  Future<void> updateTimerOn(bool t) async {
    _timerOn = t;
    notifyListeners();
  }

  Future<void> updateTimerString(String value) async {
    _timerTimeString = value;
    notifyListeners();
  }

  Future<void> updateTimerMin(int t) async {
    _timerMin = t;
    notifyListeners();
  }

  Future<void> updateTotalTimer(int t) async {
    _totalTimer = t;
    notifyListeners();
  }

  Future<void> updateLastChange(DateTime dt) async {
    _lastChange = dt;
    notifyListeners();
  }

  Future<void> updateChanging(bool o) async {
    _changing = o;
    notifyListeners();
  }

  Future<void> onlineStatus(BuildContext context, bool o) async {
    _online = o;
    notifyListeners();
  }

  Future<void> lastCheckedConnection(BuildContext context, DateTime dt) async {
    _lastConnectionCheck = dt;
    notifyListeners();
  }

  Future<void> checkDeviceConnection() async {
    Future.delayed(const Duration(seconds: 30), () {
      print(DateTime.now().difference(_lastConnectionCheck).inSeconds);
      if (DateTime.now().difference(_lastConnectionCheck).inSeconds >= 25) {
        _online = false;
        print('offline');
      } else {
        _online = true;
        print('online');
      }
      notifyListeners();
    });
  }

  parseMessage(BuildContext context, String s, bool ol) async {
    List<String> mes = s.split(':');
    print(mes);
    if (mes.length == 5) {
      if (ol) {
        onlineStatus(context, true);
        lastCheckedConnection(context, DateTime.now());
        checkDeviceConnection();
        waitingForMessageStatus(false);
      } else {}
      String onOff = mes[0].toString();
      int totalDur = double.parse(mes[1].toString().trim()).toInt();
      int dur = double.parse(mes[2].toString().trim()).toInt();
      String fau = mes[3].toString().trim();
      if (onOff == "1") {
        onStatus(context, true);
      } else {
        onStatus(context, false);
      }
      notifyListeners();
      if (fau == "0") {
        updateFault(false);
      } else {
        updateFault(true);
      }
      notifyListeners();
      if (((totalDur > 0 && dur > 0 && totalDur >= dur) || (totalDur == 0)) &&
          (totalDur <= times.keys.last && dur <= times.keys.last)) {
        if (dur > 0.0) {
          updateTimerMin(dur.toInt());
          String tempTS = addLeadingZeros((dur - dur.remainder(60)) ~/ 60) +
              ":" +
              addLeadingZeros(dur.remainder(60));
          updateTimerString(tempTS);
        } else {
          updateTimerMin(0);
          updateTimerString("00:00");
        }
        if (totalDur > 0.0) {
          updateTotalTimer(totalDur);
          updateSliderValue((timerMin / totalTimer) * 100);
          if (!_timerOn) {
            updateChanging(false);
            updateTimerOn(true);
          } else {}
        } else {
          updateTotalTimer(0);
          updateSliderValue(0);
          if (_timerOn) {
            updateTimerOn(false);
          } else {}
        }
      } else {}
      notifyListeners();
    } else {}
    notifyListeners();
  }
}
