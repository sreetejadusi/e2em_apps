import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_elves/flutter_blue_elves.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bluetooth_devices_provider.dart';
import '../index_files.dart';

class ControlScreen extends StatefulWidget {
  // final String macAddress;
  //final String name;
  final Device device;

  const ControlScreen(
      {Key? key,
      // required this.name,
      // required this.macAddress,
      required this.device})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ControlScreenState();
  }
}

class _ControlScreenState extends State<ControlScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  //////////////////////////////
  List<BleService> services = [];
  List<String> readUUIDS = [];
  List<String> writeUUIDS = [];
  DeviceState deviceState = DeviceState.disconnected;
  late StreamSubscription<BleService> _serviceDiscoveryStream;
  late StreamSubscription<DeviceState> _stateStream;
  late StreamSubscription<DeviceSignalResult> _deviceSignalResultStream;
  bool isLoading = false;

  //bool unLockWaiting = false;
  load() async {
    //DataProvider dp = context.read<DataProvider>();
    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    //dp.changeUnlockWaiting(false);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    BluetoothDevicesProvider bdp = context.read<BluetoothDevicesProvider>();
    load();
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 900))
          ..repeat();
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
      Future.delayed(const Duration(milliseconds: 300), () {
        try {
          send("ev2go2023");
        } catch (e) {
          print(e);
        }
      });

      ///
    });
    deviceState = widget.device.state;
    if (deviceState == DeviceState.connected) {
      if (!widget.device.isWatchingRssi) widget.device.startWatchRssi();
      widget.device.discoveryService();
    }
    _stateStream = widget.device.stateStream.listen((event) {
      if (event == DeviceState.connected) {
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

  sendUnlock() async {
    String mes = "el:1:";
    send(mes.toString().trim());
    /* Future.delayed(const Duration(seconds: 5), () {
      if (dp.unlockWaiting) {
        dp.changeUnlockWaiting(false);
      }
    });*/
  }

  onMessage(String mes) {
    List<String> m = mes.toString().trim().split(':');
    String unLock = m[1].toString();
    try {
      if (unLock == "1") {
        messageDialog(context, "Unlocked");
      } else {}
    } catch (e) {
      messageDialog(context, "Error in Unlocking");
      print(e);
    }
  }

  send(String mes) {
    widget.device
        .writeData(writeUUIDS[0], writeUUIDS[1], true, alpha_to_unit8list(mes));
  }

  Uint8List alpha_to_unit8list(String asciiString) {
    String as = asciiString;
    List<int> codes = as.codeUnits;
    Uint8List data = Uint8List(codes.length);
    for (int i = 0; i < codes.length; i++) {
      data[i] = codes[i];
    }
    return data;
  }

  @override
  void dispose() {
    animationController.dispose();
    _serviceDiscoveryStream.cancel();
    _stateStream.cancel();
    _deviceSignalResultStream.cancel();
    if (widget.device.state == DeviceState.connected) {
      widget.device.disConnect();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BluetoothDevicesProvider bdp = context.watch<BluetoothDevicesProvider>();
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    //DataProvider dp = context.watch<DataProvider>();
    bool connected = deviceState == DeviceState.connected;
    bool connecting = deviceState == DeviceState.connecting;
    bool disconnected = deviceState == DeviceState.disconnected;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: accentColor1,
        title: Text(
          bdp.lastDevice,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        /*  actions: [
          IconButton(
              onPressed: () {
                sendUnlock();
              },
              icon: Icon(
                Icons.lock_open,
                color: Colors.green,
              )),
          SizedBox(
            width: 10,
          ),
        ],*/
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            connecting
                ? connection(context, () {}, "Connecting....", Colors.white)
                : connection(context, () {
                    if (connected) {
                      widget.device.disConnect();
                    } else {
                      try {
                        widget.device.connect(connectTimeout: 10000);
                      } catch (e) {
                        print(e);
                      }
                    }
                  }, connected ? "Disconnect" : "Connect", Colors.white),
            Center(
                child: SizedBox(
              width: w * 0.6,
              height: w * 0.6,
              child: FloatingActionButton(
                elevation: 5,
                backgroundColor: accentColor1.withOpacity(0.7),
                onPressed: () {
                  sendUnlock();
                },
                tooltip: 'Unlock',
                child: Icon(
                  Icons.lock_open,
                  size: w * 0.4,
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget connection(
      BuildContext context, Function() tap, String text, Color color) {
    DataProvider dp = context.read<DataProvider>();
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return MaterialButton(
        onPressed: tap,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ));
  }
}
