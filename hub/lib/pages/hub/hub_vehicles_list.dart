import 'package:flutter/material.dart';
import 'package:hub/ble_unlock/devices_screen.dart';
import 'package:provider/provider.dart';

import '../../index_files.dart';

class HubVehiclesList extends StatefulWidget {
  final String title;
  final List<VehicleStatus> filter;

  const HubVehiclesList({super.key, required this.title, required this.filter});

  @override
  State<HubVehiclesList> createState() => _HubVehiclesListState();
}

class _HubVehiclesListState extends State<HubVehiclesList> {
  @override
  Widget build(BuildContext context) {
    HubManager hubManager = context.watch<HubManager>();
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: accentColor1,
        title: Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Text(
            widget.title,
            style: TextStyle(color: Colors.white),
          ),
        ),
        //iconTheme:
        centerTitle: true,
        actions: [],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: (widget.filter.length == 1 &&
              widget.filter.contains(VehicleStatus.assigned))
          ? FloatingActionButton.extended(
              backgroundColor: accentColor1,
              onPressed: () {
                List<String> dl = [];
                for (var i = 0; i < hubManager.vehicles.length; i++) {
                  if (widget.filter.contains(hubManager.vehicles[i].getVS())) {
                    setState(() {
                      dl.add(hubManager.vehicles[i].vehicleId);
                    });
                  }
                }
                print(dl);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DevicesScreen(
                      devicesNames: dl,
                    ),
                  ),
                );
              },
              label: const Text("Unlock Vehicles"),
              icon: const Icon(Icons.lock_open),
            )
          : null,
      body: hubManager.vehiclesLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              children: [
                for (var i = 0; i < hubManager.vehicles.length; i++) ...[
                  if (widget.filter
                      .contains(hubManager.vehicles[i].getVS())) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 15),
                      child: tile(
                        vehicle: hubManager.vehicles[i],
                      ),
                    ),
                  ],
                ],
              ],
            ),
    );
  }

  Widget tile({required VehicleModel vehicle}) {
    HubManager hubManager = context.read<HubManager>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Card(
        elevation: 2,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(largeRadius),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: clg,
            borderRadius: BorderRadius.circular(largeRadius),
          ),
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HubVehicleDetail(
                          vehicle: vehicle,
                        )),
              );
            },
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
                  child: Icon(
                    Icons.sticky_note_2_outlined,
                    color: Colors.black,
                  ),
                )),
            title: Text(
              vehicle.vehicleId,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(vehicleStatusMap(vehicle.getVS())),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
              size: 15,
            ),
          ),
        ),
      ),
    );
  }
}
