import 'package:flutter/material.dart';
import 'package:flutter_blue_elves/flutter_blue_elves.dart';
import 'package:rove_personnel/utils/index.dart';
import 'package:provider/provider.dart';
import 'package:rove_personnel/widgets/bottom_fab.dart';
import '../providers/index.dart';

class Devices extends StatefulWidget {
  const Devices({Key? key}) : super(key: key);

  @override
  State<Devices> createState() => _DevicesState();
}

class _DevicesState extends State<Devices> {
  load() async {
    BluetoothDevicesProvider bdp = context.read<BluetoothDevicesProvider>();
    BluetoothProvider bp = context.read<BluetoothProvider>();
    Future.delayed(const Duration(milliseconds: 1000), () async {
      if (bp.gpsOn && bp.bluetoothOn && !bdp.scanning) {
        bdp.scan(context);
      }
    });
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

  connecedDevice({required String name, required String mac}) {
    BluetoothDevicesProvider bdp = context.read<BluetoothDevicesProvider>();
    bdp.changeTabIndex(0);
  }

  @override
  Widget build(BuildContext context) {
    BluetoothProvider bp = context.watch<BluetoothProvider>();
    BluetoothDevicesProvider bdp = context.watch<BluetoothDevicesProvider>();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            children: <Widget>[
              // ListTile(
              //   title: Text(
              //     "Connected Device: ",
              //     style: TextStyle(
              //       fontSize: 16,
              //       fontWeight: FontWeight.w500,
              //       color: Color(0xFFA8ADB7),
              //     ),
              //   ),
              // ),
              ListTile(
                title: Text(
                  "Available Devices",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFA8ADB7),
                  ),
                ),
              ),
              for (int i = 0; i < bdp.hideConnectedList.length; i++) ...[
                //if (bdp.hideConnectedList[i].uuids.isNotEmpty) ...[
                tileHCD(bdp.hideConnectedList[i]),
                //],
              ],
              for (int i = 0; i < bdp.scanResultList.length; i++) ...[
                //if (bdp.scanResultList[i].uuids.isNotEmpty) ...[
                tileSR(bdp.scanResultList[i]),
                //],
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget tileHCD(HideConnectedDevice hcd) {
    BluetoothDevicesProvider bdp = context.read<BluetoothDevicesProvider>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: ListTile(
        leading: Icon(Icons.bluetooth),
        trailing: ActionChip(
          backgroundColor: accentColor,
          onPressed: () async {
            Device toConnectDevice = hcd.connect(connectTimeout: 10000);
            bdp.changeConnectedDevice(toConnectDevice);
            String ss = hcd.name ?? "-----";
            String s = ss.trim();
            bdp.changeLastDevice(s);
            bdp.changeTabIndex(0);
            FABBottomAppBarState().updateIndex(0);
          },
          label: const Text("Connect"),
        ),
        title: Text(
          hcd.name ?? "Unnamed Device",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget tileSR(ScanResult sr) {
    BluetoothDevicesProvider bdp = context.read<BluetoothDevicesProvider>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: ListTile(
        leading: Icon(Icons.bluetooth),
        trailing: ActionChip(
          onPressed: () async {
            Device toConnectDevice = sr.connect(connectTimeout: 10000);
            bdp.changeConnectedDevice(toConnectDevice);
            String ss = sr.name ?? "-----";
            String s = ss.trim();
            bdp.changeLastDevice(s);
            bdp.changeTabIndex(0);
            FABBottomAppBarState().updateIndex(0);
          },
          backgroundColor: accentColor,
          label: const Text("Connect"),
        ),
        title: Text(
          sr.name ?? "Unnamed Device",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
