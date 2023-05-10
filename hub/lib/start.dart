import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State;
import 'package:provider/provider.dart';

import 'index_files.dart';

class Start extends StatefulWidget {
  const Start({Key? key}) : super(key: key);

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> with SingleTickerProviderStateMixin {
  bool isLoading = false;
  int currentTab = 0;

  load() async {
    WalletProvider wp = context.read<WalletProvider>();
    HubManager hubManager = context.read<HubManager>();
    AuthenticationProvider ap = context.read<AuthenticationProvider>();

    setState(() {
      isLoading = true;
    });
    DbCollection hubs = mongoDB.db.collection("hubs");
    try {
      await hubs.find({'hubId': ap.loginId}).toList().then((value) async {
            await ap.updateHub(HubModel.fromMap(value.first));
          });
      print("HUB Model Loaded");
    } catch (e) {
      print("HUB Model Load Error");
    }
    await hubManager.init(context);
    wp.init(context: context);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    //DataProvider dp = context.read<DataProvider>();

    super.initState();
    load();
    //dp.updateCurrentTab(0);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    UserProvider up = context.watch<UserProvider>();
    DataProvider dp = context.watch<DataProvider>();
    AuthenticationProvider ap = context.watch<AuthenticationProvider>();
    HubManager hubManager = context.watch<HubManager>();

    List<Widget> tabs = [
      const Home(),
      const Dashboard(),
      AllocateCollectTab(
        tabChange: (int index) {
          setState(() {
            currentTab = index;
          });
        },
      ),
      AllocateBattery(
        batteryId: null,
        tabChange: (int index) {
          setState(() {
            currentTab = index;
          });
        },
      ),
    ];

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: accentColor1,
          elevation: 0,
          title: const Text(
            "EV2GO HUB",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          actions: [
            Row(
              children: [
                Icon(
                  Icons.compass_calibration_outlined,
                  color: up.serverConnection
                      ? Colors.greenAccent
                      : Colors.deepOrange,
                ),
                /* SizedBox(width: 10,),
                Icon(
                  Icons.network_cell,
                  color: up.internetConnection
                      ? Colors.greenAccent
                      : Colors.deepOrange,
                ),*/
                SizedBox(
                  width: 15,
                ),
                /*IconButton(
                    onPressed: () async {
                      await mongoDB.maintainMongoDBConnection(context);
                    },
                    tooltip: "Refresh",
                    icon: Icon(
                      Icons.refresh,
                      color: Colors.greenAccent,
                    )),*/
              ],
            ),
          ],
        ),
        body: up.serverConnection
            ? isLoading
                ? const Center(child: CircularProgressIndicator())
                : tabs[currentTab]
            : const ConnectionMessageScreen(),
        drawer: const MenuDrawer(),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: accentColor1,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.greenAccent,
          unselectedItemColor: Colors.white,
          currentIndex: currentTab,
          onTap: (int index) {
            setState(() {
              currentTab = index;
            });
          },
          elevation: 0,
          items: <BottomNavigationBarItem>[
            navItem(icon: Icons.home, label: "Home"),
            navItem(icon: Icons.dashboard, label: "Miscellaneous"),
            navItem(icon: Icons.electric_rickshaw, label: "Vehicles"),
            navItem(icon: Icons.battery_saver, label: "Batteries"),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem navItem(
      {required IconData icon, required String label}) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      label: label,
    );
  }
}
