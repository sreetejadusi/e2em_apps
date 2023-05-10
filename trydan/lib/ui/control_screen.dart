import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_elves/flutter_blue_elves.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../new_ui/new_control_screen.dart';
import 'index.dart';
import '../providers/index.dart';
import 'package:provider/provider.dart';
import '../utils/index.dart';

class ControlScreen extends StatefulWidget {
  final Device device;
  final Function(String key) rebuild;
  const ControlScreen({Key? key, required this.rebuild, required this.device})
      : super(key: key);

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen>
    with TickerProviderStateMixin {
  String temp = "----";

  ///PARAMETERS
  //int speed = 0;
  int battery = 0;
  int mode = 1;
  int rangeLeft = 0;
  String cycleId = "000";


  ///
  //////////////////////////////
  List<BleService> services = [];
  List<String> readUUIDS = [];
  List<String> writeUUIDS = [];
  DeviceState deviceState = DeviceState.disconnected;
  late StreamSubscription<BleService> _serviceDiscoveryStream;
  late StreamSubscription<DeviceState> _stateStream;
  late StreamSubscription<DeviceSignalResult> _deviceSignalResultStream;
  bool isLoading = false;
  String name = "------";

  double velocity = 0;
  GeolocatorPlatform locator = GeolocatorPlatform.instance;
  Future<void> locationAccess() async {
    bool lse = await Geolocator.isLocationServiceEnabled();
    print('isLocationServiceEnabled : ' + lse.toString());
    if (!lse) {
      print('no');
      await Geolocator.openLocationSettings();
    } else {
      print('yes');
    }
  }
  load() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = (prefs.getString('name') ?? "------");
    });
    await Geolocator.requestPermission();
    // await Permission.location.request();
    await locationAccess();
    setState(() {
      isLoading = false;
    });
  }

  String parseCycleId(
     String name) {
    String temp = name;
    String res = "000";
    try {
      if (temp.contains("Trydan")) {
        res = temp.replaceAll("Trydan", "").trim();
      }
    } catch (e) {
      print(e);
    }
    return res;
  }

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    BluetoothDevicesProvider bdp = context.read<BluetoothDevicesProvider>();
    load();
    setState(() {
      cycleId =parseCycleId(bdp.connectedDeviceName ?? "000");
    });
    super.initState();
    ///SPEEDOMETER
    try {
      locator
          .getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      )
          .listen(
            (Position position) {
          print('position--------------------------------------------------------------------------------');
          print('position');
          print(position.latitude.toString() +
              '   ' +
              position.longitude.toString());
          locator
              .getCurrentPosition(
            locationSettings: LocationSettings(
              accuracy: LocationAccuracy.high,
            ),
          )
              .then(
                (Position updatedPosition) {
              print(updatedPosition.latitude.toString() +
                  '   ' +
                  updatedPosition.longitude.toString());
              if (!isLoading) {
                setState(() {
                  velocity =
                      ((position.speed + updatedPosition.speed) / 2) * 3.6;
                });
              }
              print('velocity : ' + velocity.toString());
            },
          );
        },
      );
    } catch (e) {
      print(e);
    }
    _serviceDiscoveryStream =
        widget.device.serviceDiscoveryStream.listen((event) {
      setState(() {
        services.add(event);
      });

      ///----------------------Handling Services----------------------
      List<BleService> customServices = services
          .where((element) =>
              element.serviceUuid.substring(4, 8) != "1800" &&
              element.serviceUuid.substring(4, 8) != "1801")
          .toList();
      if (customServices.length >= 2) {
        setState(() {
          readUUIDS.clear();
          writeUUIDS.clear();
        });

        ///------Write Service-------
        setState(() {
          writeUUIDS.add(customServices[0].serviceUuid);
        });
        BleCharacteristic writeBleCharacteristic =
            customServices[0].characteristics[0];
        setState(() {
          writeUUIDS.add(writeBleCharacteristic.uuid);
        });

        ///--------Read Service--------
        setState(() {
          readUUIDS.add(customServices[1].serviceUuid);
        });
        BleCharacteristic readBleCharacteristic =
            customServices[1].characteristics[0];
        setState(() {
          readUUIDS.add(readBleCharacteristic.uuid);
        });
        if (readBleCharacteristic.properties
                .contains(CharacteristicProperties.notify) ||
            readBleCharacteristic.properties
                .contains(CharacteristicProperties.indicate)) {
          widget.device
              .setNotify(customServices[1].serviceUuid,
                  readBleCharacteristic.uuid, true)
              .then((value) {});
        }
      } else {}

      ///
    });
    deviceState = widget.device.state;
    if (deviceState == DeviceState.connected) {
      ///RSSI
      if (!widget.device.isWatchingRssi) widget.device.startWatchRssi();
      widget.device.discoveryService();
    }
    _stateStream = widget.device.stateStream.listen((event) {
      if (event == DeviceState.connected) {
        ///RSSI
        if (!widget.device.isWatchingRssi) widget.device.startWatchRssi();
        setState(() {
          services.clear();
        });
        widget.device.discoveryService();
      }
      setState(() {
        deviceState = event;
      });
    });

    _deviceSignalResultStream =
        widget.device.deviceSignalResultStream.listen((event) {
      String data = "";
      if (event.data != null && event.data!.isNotEmpty) {
        for (int i = 0; i < event.data!.length; i++) {
          data = data + String.fromCharCode(event.data![i]);
        }
      }
      onMessage(data);
    });


  }

  onMessage(String mes) {
    List<String> m = mes.toString().trim().split(',');
    setState(() {
      temp = mes;
    });
    if (m.length >= 3) {
      try {
        //String _cycleId = m[0].toString();
        int _mode = double.parse(m[1].toString()).toInt();
        int _battery = double.parse(m[2].toString()).toInt();
        /*setState(() {
          cycleId = _cycleId;
        });*/
        if (_battery >= 0 && _battery <= 100) {
          setState(() {
            battery = _battery;
          });
        } else {
          setState(() {
            battery = 0;
          });
        }
        if (_mode == 1 ||
            _mode == 2 ||
            _mode == 3 ||
            _mode == 4 ||
            _mode == 5) {
          setState(() {
            mode = _mode;
          });
        } else {
          setState(() {
            mode = 1;
          });
        }
      } catch (e) {
        print(e);
      }
    }
  }

  send(String mes) {
    widget.device
        .writeData(writeUUIDS[0], writeUUIDS[1], true, alpha_to_unit8list(mes));
  }

  @override
  void dispose() {
    if (widget.device.state == DeviceState.connected) {
      widget.device.disConnect();
    }
    _deviceSignalResultStream.cancel();
    _serviceDiscoveryStream.cancel();
    _stateStream.cancel();

    super.dispose();
  }

  static Random random = Random();
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    BluetoothDevicesProvider bdp = context.watch<BluetoothDevicesProvider>();
    return NewControlScreen(
      hasDevice: true,
      deviceName: bdp.connectedDeviceName ?? "",
      connecting: deviceState == DeviceState.connecting,
      connected: deviceState == DeviceState.connected,
      connect: () {
        setState(() {});
        try {
          widget.device.connect(connectTimeout: 10000);
        } catch (e) {
          print(e);
        }
      },
      disconnect: () {
        widget.device.disConnect();
        setState(() {});
      },
      mode: mode,
      battery: battery,
      speed: velocity.toInt(),
      rangeLeft: rangeLeft,
      modeChange: (int modeNum) {
        String mn = modeNum.toString();
        setState(() {
          mode = modeNum;
        });
        send("$cycleId,$mn");
      },
    );
  }
}
