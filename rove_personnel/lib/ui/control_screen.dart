import 'dart:async';
import 'package:provider/provider.dart';
import '../utils/index.dart';
import '../providers/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_elves/flutter_blue_elves.dart';
import 'package:rove_personnel/utils/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'index.dart';

class ControlScreen extends StatefulWidget {
  //final String macAddress;
  //final String name;
  final Device device;

  const ControlScreen(
      {Key? key,
      //required this.name,
      //required this.macAddress,
      required this.device})
      : super(key: key);
  //const ControlScreen({Key? key}) : super(key: key);

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen>
    with SingleTickerProviderStateMixin {
  String ld = "---";
  Timer? timer;
  bool isLoading = false;
  int SOC = 0;
  int SOH = 0;
  int KM = 0;
  // bool locked = true;
  bool durationWaiting = false;
  durationTrue() async {
    setState(() {
      durationWaiting = true;
    });
  }

  late AnimationController animationController;

  ///SPEEDOMETER HEIGHT : H*0.22
  ///STATS HEIGHT : H*0.20
  ///WEATHER : H*0.12
  List<BleService> services = [];
  List<String> readUUIDS = [];
  List<String> writeUUIDS = [];
  DeviceState deviceState = DeviceState.disconnected;
  late StreamSubscription<BleService> _serviceDiscoveryStream;
  late StreamSubscription<DeviceState> _stateStream;
  late StreamSubscription<DeviceSignalResult> _deviceSignalResultStream;
  load() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    lu.removeListener(onLockUnlock);
    super.dispose();
  }

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    BluetoothDevicesProvider bdp = context.read<BluetoothDevicesProvider>();
    lu.addListener(onLockUnlock);
    //load();
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

  onLockUnlock() {
    BluetoothDevicesProvider bdp = context.read<BluetoothDevicesProvider>();
    DataProvider dp = context.read<DataProvider>();

    ///
    sendLockUnlock(dp.locked ? 1 : 0);

    ///
  }

  sendLockUnlock(int lockUnlock) async {
    ///el:0:10:20:30:14:
    String mes = "el:$lockUnlock:0:0:0:14:";
    send(mes.toString().trim());
  }

  onMessage(String mes) {
    DataProvider dp = context.read<DataProvider>();
    BluetoothProvider bp = context.read<BluetoothProvider>();
    BluetoothDevicesProvider bdp = context.read<BluetoothDevicesProvider>();
    setState(() {
      ld = mes;
    });
    List<String> m = mes.toString().trim().split(',');
    if (m.length == 7) {
      String lockUnlock = mes[1].toString();
      try {
        SOH = double.parse(mes[2].toString()).toInt();
        SOC = double.parse(mes[3].toString()).toInt();
        KM = double.parse(mes[4].toString()).toInt();
      } catch (e) {
        print(e);
      }
      String _SOC = mes[1].toString();
      if (lockUnlock == "1") {
        dp.changeLocked(false);
        /*setState(() {
          locked = false;
        });*/
      } else {
        dp.changeLocked(true);
        /* setState(() {
          locked = true;
        });*/
      }
    }
  }

  send(String mes) {
    widget.device
        .writeData(writeUUIDS[0], writeUUIDS[1], true, alpha_to_unit8list(mes));
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    bool connected = deviceState == DeviceState.connected;
    bool connecting = deviceState == DeviceState.connecting;
    bool disconnected = deviceState == DeviceState.disconnected;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              helloTile(context, true),
              temp(context),
              stats(SOH, SOC, KM),
              sm(context, 200),
              Container(
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: ListTile(
                  title: Text(
                    "Rove",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    deviceState == DeviceState.connected
                        ? "Connected"
                        : deviceState == DeviceState.connecting
                            ? "Connecting"
                            : "Not Connected",
                    style: TextStyle(
                        color: deviceState == DeviceState.connected
                            ? Color(0xFF70CFA3)
                            : deviceState == DeviceState.connecting
                                ? Colors.blue
                                : Colors.red,
                        fontSize: 14),
                  ),
                  trailing: deviceState == DeviceState.connecting
                      ? const CircularProgressIndicator()
                      : FlatButton(
                          child: Text(
                            connected ? "Disconnect" : "Connect",
                            style: TextStyle(fontSize: 16),
                          ),
                          //
                          color:
                              connected ? Color(0xFFEB5353) : Color(0xFF70CFA3),
                          textColor: Colors.white,
                          onPressed: () {
                            if (connected) {
                              widget.device.disConnect();
                            } else {
                              try {
                                widget.device.connect(connectTimeout: 10000);
                              } catch (e) {
                                print(e);
                              }
                            }
                          },
                        ),
                  tileColor: Colors.transparent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
