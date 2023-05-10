import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../index_files.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  load() async {
    HubManager hubManager = context.read<HubManager>();
    hubManager.init(context);
    setState(() {});
  }

  @override
  void initState() {
    load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    VehiclesProvider vp = context.watch<VehiclesProvider>();
    AuthenticationProvider ap = context.watch<AuthenticationProvider>();
    HubManager hubManager = context.watch<HubManager>();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 18, right: 18, top: 18, bottom: 8),
              child: CustomContainer(
                context: context,
                widget: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    onTap: () {
                      if (ap.loginType == LoginType.hub) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HubProfile(
                                    appBar: true,
                                  )),
                        );
                      }
                    },
                    title: Text(
                      ap.displayName,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        ap.displayId,
                        //up.userDetails[1],
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    leading: Icon(
                      Icons.admin_panel_settings,
                      size: 35,
                      color: Colors.black,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            if (ap.loginType == LoginType.hub) ...[
              TabBar(
                indicatorColor: accentColor1,
                isScrollable: false,
                indicatorPadding: const EdgeInsets.symmetric(horizontal: 20),
                indicatorWeight: 2.5,
                tabs: const [
                  Tab(
                    child: Text(
                      "VEHICLE INFO",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "BATTERY INFO",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    (hubManager.vehiclesLoading ||
                            hubManager.driversLoading ||
                            hubManager.batteriesLoading)
                        ?
                        //Lottie.asset('assets/loading.json')

                        const Center(child: CircularProgressIndicator())
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              /*SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(Icons.arrow_back_ios),
                                onPressed: () {
                                  hubManager
                                      .selectedAllocationDateIndexState("-");
                                },
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: Text(
                                  formatDate(hubManager.allocationDates[
                                      hubManager.selectedAllocationDateIndex]),
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.arrow_forward_ios),
                                onPressed: () {
                                  hubManager
                                      .selectedAllocationDateIndexState("+");
                                },
                              ),
                            ],
                          ),*/
                              Expanded(
                                child: GridView(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 15),
                                  physics: const BouncingScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 12,
                                    crossAxisSpacing: 12,
                                  ),
                                  children: [
                                    cardItem(
                                        num: hubManager.vehicles.length,
                                        title: "Total Vehicles",
                                        icon: Icons.bike_scooter,
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const HubVehiclesList(
                                                      title: 'Total Vehicles',
                                                      filter:
                                                          VehicleStatus.values,
                                                    )),
                                          );
                                        }),
                                    cardItem(
                                        num: hubManager.vehicles
                                            .where((element) =>
                                                element.getVS() ==
                                                VehicleStatus.maintenance)
                                            .toList()
                                            .length,
                                        title: "Maintenance",
                                        icon: Icons.battery_0_bar,
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const HubVehiclesList(
                                                      title: 'Maintenance',
                                                      filter: [
                                                        VehicleStatus
                                                            .maintenance
                                                      ],
                                                    )),
                                          );
                                        }),
                                    cardItem(
                                        num: hubManager.vehicles
                                            .where((element) =>
                                                element.getVS() ==
                                                VehicleStatus.assigned)
                                            .toList()
                                            .length,
                                        title: "Total Assigned",
                                        icon: Icons.featured_play_list_outlined,
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const HubVehiclesList(
                                                      title: 'Total Assigned',
                                                      filter: [
                                                        VehicleStatus.assigned
                                                      ],
                                                    )),
                                          );
                                        }),
                                    cardItem(
                                        num: hubManager.vehicles
                                            .where((element) =>
                                                element.getVS() ==
                                                VehicleStatus.parking)
                                            .toList()
                                            .length,
                                        title: "Vehicles Parking",
                                        icon: Icons.park_outlined,
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const HubVehiclesList(
                                                      title: 'Vehicles Parking',
                                                      filter: [
                                                        VehicleStatus.parking
                                                      ],
                                                    )),
                                          );
                                        }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                    (hubManager.vehiclesLoading ||
                            hubManager.driversLoading ||
                            hubManager.batteriesLoading)
                        ? const Center(child: CircularProgressIndicator())
                        : GridView(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 25),
                            physics: const BouncingScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                            ),
                            children: [
                              cardItem(
                                  num: hubManager.batteries.length,
                                  title: "Total Batteries",
                                  icon: Icons.earbuds_battery,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const HubBatteriesList(
                                                title: "Total Batteries",
                                                filter: BatteryStatus.values,
                                              )),
                                    );
                                  }),
                              cardItem(
                                  num: hubManager.batteries
                                      .where((element) =>
                                          element.getBS() ==
                                          BatteryStatus.maintenance)
                                      .toList()
                                      .length,
                                  title: "Maintenance",
                                  icon: Icons.battery_full,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const HubBatteriesList(
                                                title: "Maintenance",
                                                filter: [
                                                  BatteryStatus.maintenance
                                                ],
                                              )),
                                    );
                                  }),
                              cardItem(
                                  num: hubManager.batteries
                                      .where((element) =>
                                          element.getBS() ==
                                          BatteryStatus.assigned)
                                      .toList()
                                      .length,
                                  title: "Assigned Batteries",
                                  icon: Icons.battery_saver,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const HubBatteriesList(
                                                title: "Assigned Batteries",
                                                filter: [
                                                  BatteryStatus.assigned
                                                ],
                                              )),
                                    );
                                  }),
                              cardItem(
                                  num: hubManager.batteries
                                      .where((element) =>
                                          element.getBS() ==
                                          BatteryStatus.ideal)
                                      .toList()
                                      .length,
                                  title: "Ideal Batteries",
                                  icon: Icons.battery_charging_full,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const HubBatteriesList(
                                                title: "Ideal Batteries",
                                                filter: [BatteryStatus.ideal],
                                              )),
                                    );
                                  }),
                            ],
                          ),
                  ],
                ),
              ),
            ],
            if (ap.loginType == LoginType.driver) ...[
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
                  child: CustomContainer(
                    context: context,
                    widget: Padding(
                      padding: EdgeInsets.symmetric(vertical: largeRadius),
                      child: Scrollbar(
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 18),
                                child: ListTile(
                                  title: Text(
                                    "Driver Info",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  trailing: Icon(
                                    Icons.notifications,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              driverDetailsItem(
                                  title: "Vehicle No",
                                  icon: Icons.electric_rickshaw,
                                  subtitle: "VEH106"),
                              driverDetailsItem(
                                  title: "Battery No",
                                  icon: Icons.battery_charging_full,
                                  subtitle: "BNO106"),
                              driverDetailsItem(
                                  title: "Start KM",
                                  icon: Icons.mode_of_travel,
                                  subtitle: "104"),
                              driverDetailsItem(
                                  title: "Current KM",
                                  icon: Icons.mode_of_travel,
                                  subtitle: "150"),
                              driverDetailsItem(
                                  title: "Balance KM",
                                  icon: Icons.mode_of_travel,
                                  subtitle: "25"),
                              driverDetailsItem(
                                  title: "Wallet Balance",
                                  icon: Icons.wallet,
                                  subtitle: "2000"),
                              driverDetailsItem(
                                  title: "Hub Name",
                                  icon: Icons.admin_panel_settings,
                                  subtitle: "25"),
                              driverDetailsItem(
                                  title: "Battery No",
                                  icon: Icons.battery_charging_full,
                                  subtitle: "BNO106"),
                              driverDetailsItem(
                                  title: "Balance KM",
                                  icon: Icons.mode_of_travel,
                                  subtitle: "25"),
                              driverDetailsItem(
                                  title: "Battery No",
                                  icon: Icons.battery_charging_full,
                                  subtitle: "BNO106"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget driverDetailsItem({
    required String title,
    required IconData icon,
    required String subtitle,
  }) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: ListTile(
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(largeRadius),
        ),
        leading: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(smallRadius),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Icon(icon, color: Colors.black),
            )),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Text(subtitle),
        ),
      ),
    );
  }

  Widget cardItem(
      {required int num,
      required String title,
      required IconData icon,
      required Function() onTap}) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: CustomContainer(
        context: context,
        widget: InkWell(
          onTap: onTap,
          radius: largeRadius,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(smallRadius),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(
                          icon,
                          color: Colors.black,
                        ),
                      )),
                ),
                Center(
                  child: Text(
                    num.toString(),
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 10),
                    child: Text(
                      title,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
