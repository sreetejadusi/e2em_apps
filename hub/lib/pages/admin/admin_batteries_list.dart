import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State;
import 'package:provider/provider.dart';

import '../../index_files.dart';

class AdminBatteriesList extends StatefulWidget {
  final String title;
  final List<BatteryStatus> filter;

  const AdminBatteriesList(
      {super.key, required this.title, required this.filter});

  @override
  State<AdminBatteriesList> createState() => _AdminBatteriesListState();
}

class _AdminBatteriesListState extends State<AdminBatteriesList> {
  @override
  Widget build(BuildContext context) {
    AdminManager am = context.watch<AdminManager>();
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
      body: am.batteriesLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              children: [
                for (var i = 0; i < am.batteries.length; i++) ...[
                  if (widget.filter.contains(am.batteries[i].getBS())) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 15),
                      child: tile(
                        battery: am.batteries[i],
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
              /*  Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HubBatteryDetail(
                          battery: battery,
                        )),
              );*/
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
            subtitle: Text(batteryStatusMap(battery.getBS())),
            trailing: IconButton(
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.black,
              ),
              onPressed: () async {
                DbCollection batteries = mongoDB.db.collection('batteries');
                await batteries.deleteMany({"batteryId": battery.batteryId});
                Navigator.pop(context);
                Navigator.pop(context);
                messageDialog(context, "Battery Deleted");
              },
            ),
          ),
        ),
      ),
    );
  }
}
