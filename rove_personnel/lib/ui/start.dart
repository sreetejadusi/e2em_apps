import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_elves/flutter_blue_elves.dart';
import 'package:rove_personnel/ui/index.dart';
import 'package:rove_personnel/ui/settings_screen.dart';
import '../utils/index.dart';
import '../widgets/index.dart';
import '../providers/index.dart';
import 'package:provider/provider.dart';

class Start extends StatefulWidget {
  const Start({Key? key}) : super(key: key);

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  bool isLoading = false;

  load() async {
    setState(() {
      isLoading = true;
    });
    BluetoothDevicesProvider bdp = context.read<BluetoothDevicesProvider>();
    BluetoothProvider bp = context.read<BluetoothProvider>();
    await bdp.lastDeviceInit();
    Future.delayed(const Duration(seconds: 0), () async {
      await bp.check(context);
    });

    Future.delayed(const Duration(milliseconds: 1500), () async {
      if (bp.gpsOn && bp.bluetoothOn) {
        bdp.scan(context);
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    load();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BluetoothProvider bp = context.watch<BluetoothProvider>();
    BluetoothDevicesProvider bdp = context.watch<BluetoothDevicesProvider>();
    List<Widget> tabs = [
      bdp.connectedDevice != null
          ? ControlScreen(device: bdp.connectedDevice!)
          : NoDeviceControlScreen(),
      Devices(),
      SettingsScreen(),
      Container()
    ];
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Image.asset(
            "assets/vh_logo.png",
            //fit: BoxFit.,
            height: 48,
          ),
          actions: [
            if (bdp.tabIndex == 0) ...[
              IconButton(
                icon: Icon(
                  Icons.notifications_none_outlined,
                  size: 30,
                  color: greenAccentColor,
                ),
                onPressed: () {
                  bdp.changeTabIndex(0);
                },
              ),
            ],
            if (bdp.tabIndex == 1) ...[
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
                    color: bp.bluetoothOn ? Colors.green : Colors.red,
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
                    color: bp.gpsOn ? Colors.green : Colors.red,
                  )),
            ],
            SizedBox(
              width: 10,
            ),
          ],
          //Text("Control"),
        ),
        backgroundColor: Colors.transparent,
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : tabs[bdp.tabIndex],
        bottomNavigationBar: FABBottomAppBar(
          centerItemText: '',
          color: Colors.white,
          selectedColor: Color(0xFF70CFA3),
          notchedShape: CircularNotchedRectangle(),
          onTabSelected: (int index) {
            BluetoothDevicesProvider bdp =
                context.read<BluetoothDevicesProvider>();
            // if (index == 0) {
            //   // bdp.changeConnectedDevice(null);
            // } else {}
            bdp.changeTabIndex(index);
          },
          items: [
            FABBottomAppBarItem(
              iconData: Icons.home_rounded,
            ),
            FABBottomAppBarItem(
              iconData: Icons.bluetooth,
            ),
            FABBottomAppBarItem(iconData: Icons.dashboard_rounded),
            FABBottomAppBarItem(iconData: Icons.person),
          ],
          backgroundColor: accentColor,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: _buildFab(
            context), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  Widget _buildFab(BuildContext context) {
    BluetoothProvider bp = context.read<BluetoothProvider>();
    DataProvider dp = context.read<DataProvider>();
    BluetoothDevicesProvider bdp = context.read<BluetoothDevicesProvider>();
    return AnchoredOverlay(
      showOverlay: true,
      overlayBuilder: (context, offset) {
        return const SizedBox.shrink();
        /* CenterAbout(
          position: Offset(offset.dx, offset.dy - 4 * 35.0),
        );*/
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: bdp.connectedDevice == null && bdp.tabIndex == 0
            ? FloatingActionButton(
                backgroundColor: Color(0xFF70CFA3),
                onPressed: () {
                  bdp.changeTabIndex(1);
                },
                tooltip: 'device',
                child: Icon(Icons.add),
              )
            : bdp.tabIndex == 0
                ? FloatingActionButton(
                    backgroundColor: Color(0xFF70CFA3),
                    onPressed: () {
                      LockUnlock.lu.lockUnlock();
                    },
                    tooltip: 'lock',
                    child: Icon(dp.locked ? Icons.lock_open : Icons.lock),
                  )
                : (bp.gpsOn && bp.bluetoothOn)
                    ? FloatingActionButton(
                        backgroundColor:
                            bdp.scanning ? Colors.red : Color(0xFF70CFA3),
                        onPressed: () {
                          bdp.scan(context);
                        },
                        tooltip: 'scan',
                        child: Icon(
                            bdp.scanning ? Icons.stop : Icons.find_replace),
                      )
                    : null,
        /* FloatingActionButton(
          onPressed: () {},
          tooltip: 'Increment',
          child: Icon(bdp.tabIndex == 0 ? Icons.lock : Icons.search),
        ),*/
      ),
    );
  }
}
