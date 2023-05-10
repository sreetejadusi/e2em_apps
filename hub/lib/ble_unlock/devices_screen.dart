import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_elves/flutter_blue_elves.dart';
import 'package:provider/provider.dart';

import 'bluetooth_devices_provider.dart';
import 'bluetooth_provider.dart';
import 'control_screen.dart';
import 'saved_device_model.dart';
import 'saved_devices_provider.dart';
import '../index_files.dart';

class DevicesScreen extends StatefulWidget {
  final List<String> devicesNames;

  const DevicesScreen({Key? key, required this.devicesNames}) : super(key: key);

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  final formKey = GlobalKey<FormState>();
  String expanded = "";
  String editName = "";
  TextEditingController edit_name = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController id = TextEditingController();
  TextEditingController password = TextEditingController();

  load() async {
    BluetoothProvider bp = context.read<BluetoothProvider>();
    Future.delayed(const Duration(seconds: 0), () async {
      await bp.check(context);
    });
    /*Future.delayed(const Duration(milliseconds: 1000), () async {
      if (bp.gpsOn && bp.bluetoothOn && !bdp.scanning) {
        bdp.scan(context);
      }
    });*/
  }

  @override
  void initState() {
    load();
    super.initState();
  }

  @override
  void dispose() {
    BluetoothDevicesProvider bdp = context.read<BluetoothDevicesProvider>();
    try {
      bdp.connectedDevice?.disConnect();
    } catch (e) {
      print(e);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    BluetoothProvider bp = context.watch<BluetoothProvider>();
    BluetoothDevicesProvider bdp = context.watch<BluetoothDevicesProvider>();
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        floatingActionButton: (bp.gpsOn && bp.bluetoothOn)
            ? FloatingActionButton(
                backgroundColor:
                    bdp.scanning ? Colors.deepOrange : accentColor1,
                onPressed: () {
                  bdp.scan(context, widget.devicesNames);
                },
                tooltip: 'scan',
                child: Icon(
                  bdp.scanning ? Icons.stop : Icons.find_replace,
                  color: Colors.white,
                ),
              )
            : null,
        appBar: AppBar(
          backgroundColor: accentColor1,
          elevation: 0,
          title: const Text(
            "Devices",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  if (!bp.bluetoothOn) {
                    FlutterBlueElves.instance
                        .androidOpenBluetoothService((isOk) {
                      debugPrint(isOk
                          ? "The user agrees to turn on the Bluetooth function"
                          : "The user does not agrees to turn on the Bluetooth function");
                    });
                  }
                },
                icon: Icon(
                  Icons.bluetooth,
                  color:
                      bp.bluetoothOn ? Colors.greenAccent : Colors.deepOrange,
                )),
            IconButton(
                onPressed: () {
                  if (!bp.gpsOn) {
                    FlutterBlueElves.instance
                        .androidOpenLocationService((isOk) {
                      debugPrint(isOk
                          ? "The user agrees to turn on the positioning function"
                          : "The user does not agree to enable the positioning function");
                    });
                  }
                },
                icon: Icon(
                  Icons.location_on,
                  color: bp.gpsOn ? Colors.greenAccent : Colors.deepOrange,
                )),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
        body: /*SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              connection(context, () {}, "Connecting....", Colors.white),
              Center(
                  child: SizedBox(
                width: w * 0.4,
                height: w * 0.4,
                child: FloatingActionButton(
                  elevation: 5,
                  backgroundColor: accentColor1.withOpacity(0.7),
                  onPressed: () {
                    // sendUnlock();
                  },
                  tooltip: 'Unlock',
                  child: Icon(
                    Icons.lock_open,
                    size: w * 0.25,
                  ),
                ),
              )),
            ],
          ),
        ),*/
            SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: <Widget>[
                    // if (widget.devicesNames.isNotEmpty) ...[
                    textFieldTitle("Accessible Devices"),
                    // ],
                    Wrap(
                      spacing: 10,
                      alignment: WrapAlignment.center,
                      children: [
                        for (int i = 0;
                            i < widget.devicesNames.length;
                            i++) ...[
                          Chip(
                            label: Text(widget.devicesNames[i]),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    // if (bdp.scanResultList.isNotEmpty) ...[
                    textFieldTitle("Scanned Accessible Devices"),
                    //],
                    for (int i = 0; i < bdp.hideConnectedList.length; i++) ...[
                      if (bdp.hideConnectedList[i].name != null) ...[
                        tileHCD(bdp.hideConnectedList[i]),
                      ],
                    ],
                    for (int i = 0; i < bdp.scanResultList.length; i++) ...[
                      if (bdp.scanResultList[i].name != null) ...[
                        tileSR(bdp.scanResultList[i]),
                      ],
                    ],
                  ],
                ),
              ),
            ],
          ),
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

  Widget tileSR(ScanResult sr) {
    BluetoothDevicesProvider bdp = context.read<BluetoothDevicesProvider>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: CustomContainer(
        context: context,
        widget: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(
              sr.name ?? " ",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                sr.id,
                //up.userDetails[1],
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            trailing: ActionChip(
              onPressed: () async {
                Device toConnectDevice = sr.connect(connectTimeout: 10000);
                bdp.changeConnectedDevice(toConnectDevice);
                String ss = sr.name ?? "-----";
                String s = ss.trim();
                bdp.changeLastDevice(s);
                bdp.changeTabIndex(1);
                if (bdp.connectedDevice != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ControlScreen(device: bdp.connectedDevice!),
                    ),
                  );
                }
              },
              label: const Text("Connect"),
            ),
          ),
        ),
      ),
    );
  }

  Widget tileHCD(HideConnectedDevice hcd) {
    BluetoothDevicesProvider bdp = context.read<BluetoothDevicesProvider>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: CustomContainer(
        context: context,
        widget: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(
              hcd.name ?? " ",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                hcd.id,
                //up.userDetails[1],
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            trailing: ActionChip(
              onPressed: () async {
                Device toConnectDevice = hcd.connect(connectTimeout: 10000);
                bdp.changeConnectedDevice(toConnectDevice);
                String ss = hcd.name ?? "-----";
                String s = ss.trim();
                bdp.changeLastDevice(s);
                bdp.changeTabIndex(1);
                if (bdp.connectedDevice != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ControlScreen(device: bdp.connectedDevice!),
                    ),
                  );
                }
              },
              label: const Text("Connect"),
            ),
          ),
        ),
      ),
    );
  }
}
