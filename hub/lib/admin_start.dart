import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hub/widgets/appbar.dart';
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
        appBar: GradientAppBar(
            title: 'EV2GO Admin', automaticallyImplyLeading: false),
        body: up.serverConnection
            ? isLoading
                ? const Center(child: CircularProgressIndicator())
                : tabs[currentTab]
            : const ConnectionMessageScreen(),
        // drawer: const MenuDrawer(),
        bottomNavigationBar: Container(
          child: NavigationBar(
            backgroundColor: accentColor1,
            elevation: 0,
            destinations: <Widget>[
              navItem(icon: Icons.home, label: "Home", tab: 0),
              navItem(
                  icon: Icons.home_repair_service,
                  label: "Maintenance",
                  tab: 1),
              navItem(icon: Icons.wallet, label: "Wallet", tab: 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget navItem(
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
