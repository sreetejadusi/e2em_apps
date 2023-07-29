import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Padding(
            //   padding: const EdgeInsets.only(
            //       left: 18, right: 18, top: 18, bottom: 8),
            //   child: CustomContainer(
            //     context: context,
            //     widget: Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: ListTile(
            //         onTap: () {
            //           if (ap.loginType == LoginType.hub) {
            //             Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                   builder: (context) => const HubProfile(
            //                         appBar: true,
            //                       )),
            //             );
            //           }
            //         },
            //         title: Text(
            //           ap.displayName,
            //           style:
            //               TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            //         ),
            //         subtitle: Padding(
            //           padding: const EdgeInsets.only(top: 5),
            //           child: Text(
            //             ap.displayId,
            //             //up.userDetails[1],
            //             style: TextStyle(
            //                 fontSize: 15, fontWeight: FontWeight.bold),
            //           ),
            //         ),
            //         leading: Icon(
            //           Icons.admin_panel_settings,
            //           size: 35,
            //           color: Colors.black,
            //         ),
            //         trailing: Icon(
            //           Icons.arrow_forward_ios,
            //           color: Colors.black,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Logged in as',
                    style: TextStyle(color: Color(0xAA8c8c8c), fontSize: 16),
                  ),
                  Text(
                    capitalize(ap.displayName),
                    style: TextStyle(
                        color: accentColor2,
                        fontSize: 26,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
            if (ap.loginType == LoginType.hub) ...[
              TabBar(
                indicatorColor: accentColor1,
                isScrollable: false,
                indicatorPadding: const EdgeInsets.symmetric(horizontal: 20),
                indicatorWeight: 2.5,
                indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(width: 2.0, color: accentColor1),
                    insets: EdgeInsets.symmetric(horizontal: 24.0)),
                tabs: const [
                  Tab(
                    child: Text(
                      "Vehicle Info",
                      style: TextStyle(
                          color: Colors.black,
                          // fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Battery Info",
                      style: TextStyle(
                          color: Colors.black,
                          // fontWeight: FontWeight.bold,
                          fontSize: 18),
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
                                child: ListView(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 15),
                                  physics: const BouncingScrollPhysics(),
                                  // gridDelegate:
                                  //     const SliverGridDelegateWithFixedCrossAxisCount(
                                  //   crossAxisCount: 2,
                                  //   mainAxisSpacing: 12,
                                  //   crossAxisSpacing: 12,
                                  // ),
                                  children: [
                                    cardItem(
                                        context: context,
                                        num: hubManager.vehicles.length,
                                        title: "Total Vehicles",
                                        icon: FontAwesomeIcons.car,
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
                                        context: context,
                                        num: hubManager.vehicles
                                            .where((element) =>
                                                element.getVS() ==
                                                VehicleStatus.maintenance)
                                            .toList()
                                            .length,
                                        title: "Maintenance",
                                        icon:
                                            FontAwesomeIcons.screwdriverWrench,
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
                                        context: context,
                                        num: hubManager.vehicles
                                            .where((element) =>
                                                element.getVS() ==
                                                VehicleStatus.assigned)
                                            .toList()
                                            .length,
                                        title: "Total Assigned",
                                        icon: FontAwesomeIcons.clipboardCheck,
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
                                        context: context,
                                        num: hubManager.vehicles
                                            .where((element) =>
                                                element.getVS() ==
                                                VehicleStatus.parking)
                                            .toList()
                                            .length,
                                        title: "Vehicles Parking",
                                        icon: FontAwesomeIcons.squareParking,
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
                        : ListView(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 25),
                            physics: const BouncingScrollPhysics(),
                            // gridDelegate:
                            //     const SliverGridDelegateWithFixedCrossAxisCount(
                            //   crossAxisCount: 2,
                            //   mainAxisSpacing: 12,
                            //   crossAxisSpacing: 12,
                            // ),
                            children: [
                              cardItem(
                                  context: context,
                                  num: hubManager.batteries.length,
                                  title: "Total Batteries",
                                  icon: FontAwesomeIcons.batteryFull,
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
                                  context: context,
                                  num: hubManager.batteries
                                      .where((element) =>
                                          element.getBS() ==
                                          BatteryStatus.maintenance)
                                      .toList()
                                      .length,
                                  title: "Maintenance",
                                  icon: FontAwesomeIcons.carBattery,
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
                                  context: context,
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
                                  context: context,
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
}
