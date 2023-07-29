import 'package:flutter/material.dart';
import 'package:hub/widgets/appbar.dart';
import 'package:provider/provider.dart';

import '../../index_files.dart';

class HubDetail extends StatefulWidget {
  final String hubId;
  final Function() pop;
  const HubDetail({super.key, required this.hubId, required this.pop});

  @override
  State<HubDetail> createState() => _HubDetailState();
}

class _HubDetailState extends State<HubDetail>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  load() async {
    setState(() {});

    AdminManager am = context.read<AdminManager>();
    am.initHub(context, widget.hubId);
  }

  @override
  void initState() {
    load();
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    AdminManager am = context.watch<AdminManager>();
    return Scaffold(
      appBar:
          GradientAppBar(title: widget.hubId, automaticallyImplyLeading: true),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TabBar(
            indicatorColor: accentColor1,
            isScrollable: true,
            controller: tabController,
            indicatorPadding: const EdgeInsets.symmetric(horizontal: 20),
            indicatorWeight: 2.5,
            tabs: const [
              Tab(
                child: Text(
                  "VEHICLE INFO",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Tab(
                child: Text(
                  "BATTERY INFO",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Tab(
                child: Text(
                  "DRIVERS",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Tab(
                child: Text(
                  "WALLET",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
          Expanded(
            child: (am.vehiclesLoading ||
                    am.driversLoading ||
                    am.batteriesLoading)
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                    controller: tabController,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 5),
                            child: addItem(
                                title: "Add Vehicle",
                                add: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddVehicle(
                                            vehicleModel: null,
                                            hubId: widget.hubId,
                                            added: () {
                                              Navigator.of(context);
                                              am.loadHubs(context);
                                            })),
                                  );
                                }),
                          ),
                          Expanded(
                            child: GridView(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 5),
                              physics: const BouncingScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                              ),
                              children: [
                                cardItem(
                                    num: am.vehicles.length,
                                    title: "Total Vehicles",
                                    icon: Icons.bike_scooter,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const AdminVehiclesList(
                                                  title: 'Total Vehicles',
                                                  filter: VehicleStatus.values,
                                                )),
                                      );
                                    }),
                                cardItem(
                                    num: am.vehicles
                                        .where((element) =>
                                            element.getVS() ==
                                            VehicleStatus.maintenance)
                                        .toList()
                                        .length,
                                    title: "Maintenance",
                                    icon: Icons.home_repair_service,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const AdminVehiclesList(
                                                  title: 'Maintenance',
                                                  filter: [
                                                    VehicleStatus.maintenance
                                                  ],
                                                )),
                                      );
                                    }),
                                cardItem(
                                    num: am.vehicles
                                        .where((element) =>
                                            element.getVS() ==
                                            VehicleStatus.assigned)
                                        .toList()
                                        .length,
                                    title: "Total Assigned",
                                    icon: Icons.person_add,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const AdminVehiclesList(
                                                  title: 'Total Assigned',
                                                  filter: [
                                                    VehicleStatus.assigned
                                                  ],
                                                )),
                                      );
                                    }),
                                cardItem(
                                    num: am.vehicles
                                        .where((element) =>
                                            element.getVS() ==
                                            VehicleStatus.parking)
                                        .toList()
                                        .length,
                                    title: "Vehicles Parking",
                                    icon: Icons.local_parking,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const AdminVehiclesList(
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
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 5),
                            child: addItem(
                                title: "Add Battery",
                                add: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddBattery(
                                            batteryModel: null,
                                            hubId: widget.hubId,
                                            added: () {
                                              Navigator.of(context);
                                              am.loadHubs(context);
                                            })),
                                  );
                                }),
                          ),
                          Expanded(
                            child: GridView(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 5),
                              physics: const BouncingScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                              ),
                              children: [
                                cardItem(
                                    num: am.batteries.length,
                                    title: "Total Batteries",
                                    icon: Icons.earbuds_battery,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const AdminBatteriesList(
                                                  title: "Total Batteries",
                                                  filter: BatteryStatus.values,
                                                )),
                                      );
                                    }),
                                cardItem(
                                    num: am.batteries
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
                                                const AdminBatteriesList(
                                                  title: "Maintenance",
                                                  filter: [
                                                    BatteryStatus.maintenance
                                                  ],
                                                )),
                                      );
                                    }),
                                cardItem(
                                    num: am.batteries
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
                                                const AdminBatteriesList(
                                                  title: "Assigned Batteries",
                                                  filter: [
                                                    BatteryStatus.assigned
                                                  ],
                                                )),
                                      );
                                    }),
                                cardItem(
                                    num: am.batteries
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
                                                const AdminBatteriesList(
                                                  title: "Ideal Batteries",
                                                  filter: [BatteryStatus.ideal],
                                                )),
                                      );
                                    }),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 5),
                            child: addItem(
                                title: "Add Driver",
                                add: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddDriver(
                                            driverModel: null,
                                            hubId: widget.hubId,
                                            added: () {
                                              Navigator.of(context);
                                              am.loadHubs(context);
                                            })),
                                  );
                                }),
                          ),
                          Expanded(
                            child: GridView(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 5),
                              physics: const BouncingScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                              ),
                              children: [
                                cardItem(
                                    num: am.drivers.length,
                                    title: "Total Drivers",
                                    icon: Icons.person,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const AdminDriversList(
                                            title: "Total Drivers",
                                          ),
                                        ),
                                      );
                                    }),
                              ],
                            ),
                          ),
                        ],
                      ),
                      HubWallet(hubId: widget.hubId),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget addItem({required title, required Function() add}) {
    return InkWell(
      onTap: () {
        add();
      },
      child: Container(
        decoration: BoxDecoration(
            color: accentColor1, borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: ListTile(
            title: Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.add_box,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
          ),
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
      child: Container(
        decoration: BoxDecoration(
            color: accentColor1, borderRadius: BorderRadius.circular(24)),
        child: InkWell(
          onTap: onTap,
          radius: largeRadius,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
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
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.w600),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 10),
                    child: Text(
                      title,
                      style: TextStyle(fontSize: 15),
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
