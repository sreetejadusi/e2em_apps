import 'package:flutter/material.dart';
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
                    builder: (context) => HubBatteryDetail(
                          battery: battery,
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
              battery.batteryId,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
                batteryStatusMap(battery.getBS())),
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
