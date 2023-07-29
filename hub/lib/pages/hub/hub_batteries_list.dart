import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hub/widgets/appbar.dart';
import 'package:provider/provider.dart';

import '../../index_files.dart';

class HubBatteriesList extends StatefulWidget {
  final String title;
  final List<BatteryStatus> filter;

  const HubBatteriesList(
      {super.key, required this.title, required this.filter});

  @override
  State<HubBatteriesList> createState() => _HubBatteriesListState();
}

class _HubBatteriesListState extends State<HubBatteriesList> {
  @override
  Widget build(BuildContext context) {
    HubManager hubManager = context.watch<HubManager>();
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar:
          GradientAppBar(title: widget.title, automaticallyImplyLeading: true),
      body: hubManager.batteriesLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              children: [
                for (var i = 0; i < hubManager.batteries.length; i++) ...[
                  if (widget.filter
                      .contains(hubManager.batteries[i].getBS())) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 15),
                      child: tile(
                        battery: hubManager.batteries[i],
                      ),
                    ),
                  ],
                ],
              ],
            ),
    );
  }

  Widget tile({required BatteryModel battery}) {
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
            //       builder: (context) => HubBatteryDetail(
            //             battery: battery,
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
                  battery.getBS() == BatteryStatus.ideal
                      ? FontAwesomeIcons.squareParking
                      : battery.getBS() == BatteryStatus.assigned
                          ? FontAwesomeIcons.clipboardCheck
                          : FontAwesomeIcons.screwdriverWrench,
                  color: Colors.black,
                ),
              )),
          title: Text(
            battery.batteryId,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          // subtitle: Text(vehicleStatusMap(vehicle.getVS())),
          trailing: Text(batteryStatusMap(battery.getBS())),
        ),
      ),
    );
  }
}
