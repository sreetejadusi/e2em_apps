import 'dart:async';
import 'dart:math' as math;
import '../utils/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_elves/flutter_blue_elves.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State hide Center;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../utils/colors.dart';
import 'index.dart';
import '../main.dart';
import 'package:provider/provider.dart';
import '../providers/index.dart';

class Start extends StatefulWidget {
  const Start({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _StartState();
  }
}

class _StartState extends State<Start> with SingleTickerProviderStateMixin {
  bool isLoading = false;

  load() async {
    setState(() {
      isLoading = true;
    });
    BluetoothDevicesProvider bdp = context.read<BluetoothDevicesProvider>();
    BluetoothProvider bp = context.read<BluetoothProvider>();
    DataProvider dp = context.read<DataProvider>();
    await bdp.lastDeviceInit();
    Future.delayed(const Duration(seconds: 0), () async {
      await bp.check(context);
    });
    if (dp.autoConnect) {
      Future.delayed(const Duration(milliseconds: 1500), () async {
        if (bp.gpsOn && bp.bluetoothOn) {
          bdp.scan(context);
        }
      });
    } else {}
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    DataProvider dp = context.read<DataProvider>();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    dp.autoConnectInit();
    dp.homeNameInit();
    dp.roomNameInit();
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
    List<Widget> _children = [
      DevicesScreen(),
      if (bdp.connectedDevice != null) ...[
        ControlScreen(device: bdp.connectedDevice!),
      ] else ...[
        NoDeviceControlScreen(),
      ],
      SettingsScreen(),
    ];
    final w = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: appBarColor,
          //centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              'E-LOCKS',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 26),
            ),
          ),
          actions: [
          /*  if (bdp.tabIndex == 2) ...[
              IconButton(
                icon: Icon(
                  Icons.logout,
                ),
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setBool('loggedIn', false);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Extend()),
                  );
                },
              ),
            ],*/
            if (bdp.tabIndex == 1) ...[
              IconButton(
                icon: Icon(
                  Icons.refresh,
                ),
                onPressed: () {
                  //bdp.changeTabIndex(0);
                  bdp.changeTabIndex(1);
                },
              ),
            ],
            if (bdp.tabIndex == 0) ...[
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
            /*  IconButton(
              icon: Icon(
                  Icons.notifications,
              ),
              onPressed: () {},
            ),
            Icon(
              Icons.circle,
              color: Colors.green,
            ),*/
          ],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(child: _children[bdp.tabIndex]),
                ],
              ),
        bottomNavigationBar: Stack(
          children: [
            Opacity(
              opacity: 0,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: BottomNavigationBar(
                  elevation: 0,
                  items: [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.home), label: "Home"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.settings), label: "Settings"),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: appBarColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(500.0),
                  topRight: Radius.circular(200.0),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: BottomNavigationBar(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    onTap: onTabTapped,
                    showSelectedLabels: false,
                    iconSize: 28,
                    selectedItemColor: Colors.white,
                    unselectedItemColor: Colors.white,
                    showUnselectedLabels: false,
                    currentIndex: bdp.tabIndex,
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.dashboard),
                        label: "Devices",
                      ),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.home), label: "Home"),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.settings), label: "Settings"),
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onTabTapped(int index) {
    BluetoothDevicesProvider bdp = context.read<BluetoothDevicesProvider>();
    if (index == 0) {
      bdp.changeConnectedDevice(null);
    } else {}
    bdp.changeTabIndex(index);
  }
}
