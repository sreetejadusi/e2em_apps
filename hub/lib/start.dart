import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hub/widgets/appbar.dart';
import 'package:intl/intl.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'index_files.dart';

class Start extends StatefulWidget {
  const Start({
    Key? key,
    this.tab = 0,
  }) : super(key: key);
  final int tab;
  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> with SingleTickerProviderStateMixin {
  bool isLoading = false;
  late int currentTab;

  Future<void> load() async {
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
    vehicleParkingCheck();
  }

  Future<void> vehicleParkingCheck() async {
    // await load();
    AuthenticationProvider ap = context.read<AuthenticationProvider>();
    HubManager hubManager = context.read<HubManager>();
    DbCollection hubs = mongoDB.db.collection("hubs");
    var date = ap.dateOperative;
    print(date);
    if (date != null && date != DateTime.now().day) {
      hubs.updateOne(where.eq('hubId', ap.hub!.hubId),
          modify.set('dateOperative', DateTime.now().day));
      hubManager.vehicleCollectingState(true);
      await mongoDB.maintainMongoDBConnection(context);
      DbCollection vehicles = mongoDB.db.collection('vehicles');
      print(hubManager.vehicles);
      for (var element in hubManager.vehicles) {
        // print(element.vehicleId);

        await vehicles.update(where.eq("vehicleId", element.vehicleId),
            modify.set('driverId', null));
        await vehicles.update(where.eq("vehicleId", element.vehicleId),
            modify.set('vehicleStatus', "parking"));
        await vehicles.update(where.eq("vehicleId", element.vehicleId),
            modify.set('unlocked', false));
      }
      await hubManager.init(context);
      hubManager.vehicleCollectingState(false);
    }
  }

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    //DataProvider dp = context.read<DataProvider>();
    currentTab = widget.tab;
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
    List titles = ['EV2GO HUB', 'Documents', 'Vehicles', 'Swap Battery'];
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
        appBar: GradientAppBar(
          title: titles[currentTab],
          automaticallyImplyLeading: false,
        ),
        body: up.serverConnection
            ? isLoading
                ? const Center(child: CircularProgressIndicator())
                : tabs[currentTab]
            : const ConnectionMessageScreen(),
        // drawer: const MenuDrawer(),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(gradient: lg),
          child: NavigationBar(
            backgroundColor: Colors.transparent,
            // type: BottomNavigationBarType.fixed,
            // selectedItemColor: Colors.black,
            // unselectedItemColor: Colors.black,
            // currentIndex: currentTab,
            // onDestinationSelected: (int index) {
            //   print(index);
            //   setState(() {
            //     currentTab = index;
            //   });
            // },
            selectedIndex: currentTab,
            elevation: 0,
            destinations: <Container>[
              navItem(icon: Icons.home_rounded, label: "Home", tab: 0),
              navItem(icon: Icons.grid_view, label: "Documents", tab: 1),
              navItem(icon: FontAwesomeIcons.car, label: "Vehicles", tab: 2),
              navItem(
                  icon: Icons.battery_charging_full,
                  label: "Batteries",
                  tab: 3),
            ],
          ),
        ),
      ),
    );
  }

  Container navItem(
      {required IconData icon, required String label, required int tab}) {
    bool active = currentTab == tab;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
          color: active ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8)),
      child: IconButton(
        onPressed: () {
          setState(() {
            currentTab = tab;
          });
        },
        icon: Container(
          child: FittedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon),
                active
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                          label,
                          style: TextStyle(color: accentColor1),
                        ),
                      )
                    : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
