import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_elves/flutter_blue_elves.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icon.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../utils/index.dart';
import '../providers/index.dart';
import 'index.dart';

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
    DataProvider dp = context.read<DataProvider>();
    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    dp.changeUnlockWaiting(false);
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
          send("e2em2022");
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
    DataProvider dp = context.read<DataProvider>();
    String mes = "el:0:0:0:14:";
    send(mes.toString().trim());
    dp.changeUnlockWaiting(true);
    Future.delayed(const Duration(seconds: 5), () {
      if (dp.unlockWaiting) {
        dp.changeUnlockWaiting(false);
      }
    });
  }

  onMessage(String mes) {
    DataProvider dp = context.read<DataProvider>();
    List<String> m = mes.toString().trim().split(':');
    if (m.length == 6) {
      String Unlock = mes[1].toString();
      if (Unlock == "0") {
        dp.changeUnlockWaiting(false);
        showDialog(
          context: context,
          builder: (ctx) => WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: const AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              title: Icon(
                Icons.lock_open,
                size: 50,
              ),
              content: Text(
                "Unlocked",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              actions: <Widget>[],
            ),
          ),
        );
        Future.delayed(const Duration(seconds: 1), () async {
          Navigator.pop(context);
        });
      } else {}
    }
  }

  send(String mes) {
    widget.device
        .writeData(writeUUIDS[0], writeUUIDS[1], true, alpha_to_unit8list(mes));
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
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    DataProvider dp = context.watch<DataProvider>();
    bool connected = deviceState == DeviceState.connected;
    bool connecting = deviceState == DeviceState.connecting;
    bool disconnected = deviceState == DeviceState.disconnected;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            SizedBox(
              height: 32,
            ),
            edit(context),
            SizedBox(
              height: 30,
            ),
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
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  waiting(context, dp.unlockWaiting),
                  SwitchButton(
                    enabled: !dp.unlockWaiting,
                    onDown: () {
                      if (connected && !dp.unlockWaiting) {
                        sendUnlock();
                      } else {}
                      print("down");
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      /* Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Spacer(),
                  InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(500)),
                    onTap: () {},
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        connecting
                            ? AnimatedBuilder(
                                animation: animationController,
                                builder: (_, child) {
                                  return Transform.rotate(
                                    angle:
                                        animationController.value * 2 * math.pi,
                                    child: child,
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(500),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: w * 0.25,
                                            height: w * 0.25,
                                            decoration: BoxDecoration(
                                              color: Colors.blue,
                                            ),
                                          ),
                                          Container(
                                            width: w * 0.25,
                                            height: w * 0.25,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: w * 0.25,
                                            height: w * 0.25,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                            ),
                                          ),
                                          Container(
                                            width: w * 0.25,
                                            height: w * 0.25,
                                            decoration: BoxDecoration(
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Container(
                                width: w * 0.5,
                                height: w * 0.5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(500.0),
                                  //00DE54
                                  color: connected
                                      ? Color(0xff00DB58)
                                      : Colors.red,
                                ),
                              ),
                        Container(
                          width: w * 0.35,
                          height: w * 0.35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(500.0),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: FloatingActionButton(
                              backgroundColor: Colors.white,
                              elevation: 5,
                              onPressed: () {
                                if (connected && !unLockWaiting) {
                                  sendUnlock();
                                } else {}
                              },
                              child: Icon(
                                Icons.lock_open,
                                color: Colors.black,
                                size: 50,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                unLockWaiting ? "Unlocking" : "Tap to Unlock",
                style: TextStyle(
                    color: Color(0xff0099FF),
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              )
            ],
          ),*/
    );
  }
}
