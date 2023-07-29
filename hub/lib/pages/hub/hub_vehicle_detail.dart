import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State;
import 'package:provider/provider.dart';

import '../../index_files.dart';

class HubVehicleDetail extends StatefulWidget {
  final VehicleModel vehicle;

  const HubVehicleDetail({super.key, required this.vehicle});

  @override
  State<HubVehicleDetail> createState() => _HubVehicleDetailState();
}

class _HubVehicleDetailState extends State<HubVehicleDetail> {
  bool l = false;
  @override
  Widget build(BuildContext context) {
    HubManager hubManager = context.watch<HubManager>();
    AuthenticationProvider ap = context.watch<AuthenticationProvider>();
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: accentColor1,
        title: Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Text(
            widget.vehicle.vehicleId,
            style: TextStyle(color: Colors.white),
          ),
        ),
        //iconTheme:
        centerTitle: true,
        actions: [],
      ),
      body: l
          ? loading(context)
          : Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  CustomContainer(
                    context: context,
                    widget: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                              widget.vehicle.vehicleId,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            leading: Icon(
                              Icons.electric_rickshaw,
                              size: 35,
                              color: Colors.black,
                            ),
                            trailing: Text(
                              vehicleStatusMap(widget.vehicle.getVS()),
                            ),
                          ),
                          if (widget.vehicle.getVS() ==
                              VehicleStatus.assigned) ...[
                            ListTile(
                              onTap: () {},
                              tileColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(largeRadius),
                              ),
                              title: Text(
                                (hubManager
                                        .getDriver(widget.vehicle.driverId!)
                                        ?.driverId ??
                                    ""),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                widget.vehicle.batteryId!,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        CustomContainer(
                          context: context,
                          widget: Padding(
                            padding:
                                EdgeInsets.symmetric(vertical: largeRadius),
                            child: Scrollbar(
                              thumbVisibility: true,
                              child: ListView(
                                shrinkWrap: true,
                                children: [
                                  if (widget.vehicle.getVS() ==
                                      VehicleStatus.assigned) ...[
                                    /* vehicleAction(
                                        title: "Collect",
                                        onTap: () {
                                          collect(widget.vehicle.vehicleId);
                                        }),*/
                                  ],
                                  if (widget.vehicle.getVS() ==
                                      VehicleStatus.parking) ...[
                                    vehicleAction(
                                        title: "Move to Maintenance",
                                        onTap: () {
                                          maintenance(widget.vehicle.vehicleId);
                                        }),
                                    /* divider(),
                                    vehicleAction(
                                        title: "Assign to Driver",
                                        onTap: () {
                                          assign(widget.vehicle.vehicleId);
                                        }),*/
                                  ],
                                  if (widget.vehicle.getVS() ==
                                      VehicleStatus.maintenance) ...[
                                    vehicleAction(
                                        title: "Move to Parking",
                                        onTap: () {
                                          parking(widget.vehicle.vehicleId);
                                        }),
                                    /*divider(),
                              vehicleAction(
                                  title: "Assign to Driver",
                                  onTap: () {
                                    assign(widget.vehicle.vehicleId);
                                  }),*/
                                  ]
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  /*assign(String vehicleId) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AllocateVehicle(
                vehicleId: vehicleId,
              )),
    );
  }

  collect(String vehicleId) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CollectVehicle(
                vehicleId: vehicleId,
              )),
    );
  }*/

  maintenance(String vehicleId) async {
    AuthenticationProvider ap = context.read<AuthenticationProvider>();
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Maintenance(
                vehicleId: vehicleId,
                hubId: ap.loginId,
              )),
    );
  }

  parking(String vehicleId) async {
    setState(() {
      l = true;
    });
    HubManager hubManager = context.read<HubManager>();
    await mongoDB.maintainMongoDBConnection(context);
    DbCollection vehicles = mongoDB.db.collection('vehicles');
    DbCollection maintenance = mongoDB.db.collection('maintenance');
    await vehicles.update(where.eq("vehicleId", vehicleId),
        modify.set('vehicleStatus', "parking"));
    await vehicles.update(
        where.eq("vehicleId", vehicleId), modify.set("maintenanceId", null));
    await maintenance.update(
        where.eq("maintenanceId", widget.vehicle.maintenanceId),
        modify.set('status', "complete"));
    await vehicles
        .update(where.eq("vehicleId", vehicleId), modify.set('driverId', null))
        .then((value) {
      print("Vehicle Moved to parking");
    });
    setState(() {
      l = false;
    });
    Navigator.pop(context);
    messageDialog(context, "Vehicle Moved to parking", true);
    hubManager.init(context);
  }

  /*collect(String vehicleId) async {
    HubManager hubManager = context.read<HubManager>();
    await mongoDB.maintainMongoDBConnection(context);
    DbCollection vehicles = mongoDB.db.collection('vehicles');
    AuthenticationProvider ap = context.read<AuthenticationProvider>();
    await vehicles.update(where.eq("vehicleId", vehicleId),
        modify.set('vehicleStatus', "parking"));
    await vehicles
        .update(where.eq("vehicleId", vehicleId), modify.set('driverId', null))
        .then((value) {
      print("Vehicle Collected");
    });
    Navigator.pop(context);
    hubManager.loadVehicles(context);
  }*/

  Widget divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Container(
        color: Colors.black,
        width: double.infinity,
        height: 0.7,
      ),
    );
  }

  Widget vehicleAction({
    required String title,
    required Function() onTap,
  }) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: ListTile(
        onTap: onTap,
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(largeRadius),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Icon(
            Icons.call_to_action_outlined,
            color: Colors.black,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 20,
          color: Colors.black,
        ),
      ),
    );
  }
}
