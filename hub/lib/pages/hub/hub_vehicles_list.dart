import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hub/ble_unlock/devices_screen.dart';
import 'package:hub/widgets/appbar.dart';
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
    print(widget.filter);
    HubManager hubManager = context.watch<HubManager>();
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: GradientAppBar(
            title: widget.title, automaticallyImplyLeading: true),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: (widget.filter.length == 1 &&
                widget.filter.contains(VehicleStatus.assigned))
            ? FloatingActionButton.extended(
                backgroundColor: accentColor1,
                onPressed: () {
                  List<String> dl = [];
                  for (var i = 0; i < hubManager.vehicles.length; i++) {
                    if (widget.filter
                            .contains(hubManager.vehicles[i].getVS()) &&
                        !hubManager.vehicles[i].unlocked) {
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
                label: const Text(
                  "Unlock Vehicles",
                  style: TextStyle(color: Colors.black),
                ),
                icon: const Icon(
                  Icons.lock_open,
                  color: Colors.black,
                ),
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
              ));
  }

  Widget tile({required VehicleModel vehicle}) {
    HubManager hubManager = context.read<HubManager>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Color(0xFF9a9a9a).withOpacity(0.25),
                offset: Offset(1, 2),
                blurRadius: 12,
                spreadRadius: 0)
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //       builder: (context) => HubVehicleDetail(
            //             vehicle: vehicle,
            //           )),
            // );
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
                  vehicle.getVS() == VehicleStatus.parking
                      ? FontAwesomeIcons.squareParking
                      : vehicle.getVS() == VehicleStatus.assigned
                          ? FontAwesomeIcons.clipboardCheck
                          : FontAwesomeIcons.screwdriverWrench,
                  color: Colors.black,
                ),
              )),
          title: Text(
            vehicle.vehicleId.toUpperCase(),
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          // subtitle: Text(vehicleStatusMap(vehicle.getVS())),
          trailing: Text(vehicleStatusMap(vehicle.getVS())),
        ),
      ),
    );
  }
}
