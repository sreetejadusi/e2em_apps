import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'index_files.dart';

class AdminStart extends StatefulWidget {
  const AdminStart({Key? key}) : super(key: key);

  @override
  State<AdminStart> createState() => _AdminStartState();
}

class _AdminStartState extends State<AdminStart>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  int currentTab = 0;

  load() async {
    setState(() {
      isLoading = true;
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    //DataProvider dp = context.read<DataProvider>();
    //dp.updateCurrentTab(0);
    load();
    super.initState();
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
      const AdminHome(),
      const AllMaintenance(),
      const ApproveTWallet(),
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
            "EV2GO ADMIN",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          actions: [
            Row(
              children: [
                IconButton(
                    onPressed: () async {},
                    tooltip: "Server Connection",
                    icon: Icon(
                      Icons.compass_calibration_outlined,
                      color: up.serverConnection
                          ? Colors.greenAccent
                          : Colors.deepOrange,
                    )),
                IconButton(
                    onPressed: () async {
                      await mongoDB.init();
                    },
                    tooltip: "Refresh",
                    icon: Icon(
                      Icons.refresh,
                      color: Colors.greenAccent,
                    )),
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
            navItem(icon: Icons.home_repair_service, label: "Maintenance"),
            navItem(icon: Icons.wallet, label: "Wallet"),
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
