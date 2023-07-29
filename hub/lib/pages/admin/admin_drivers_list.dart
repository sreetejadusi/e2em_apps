import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State;
import 'package:provider/provider.dart';

import '../../index_files.dart';

class AdminDriversList extends StatefulWidget {
  final String title;

  const AdminDriversList({super.key, required this.title});

  @override
  State<AdminDriversList> createState() => _AdminDriversListState();
}

class _AdminDriversListState extends State<AdminDriversList> {
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
      body: am.driversLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              children: [
                for (var i = 0; i < am.drivers.length; i++) ...[
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                    child: tile(
                      driver: am.drivers[i],
                    ),
                  ),
                ],
              ],
            ),
    );
  }

  Widget tile({required DriverModel driver}) {
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
              /*Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HubVehicleDetail(
                          vehicle: vehicle,
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
              driver.driverId,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            trailing: IconButton(
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.black,
              ),
              onPressed: () async {
                DbCollection drivers = mongoDB.db.collection('drivers');
                await drivers.deleteMany({"driverId": driver.driverId});
                Navigator.pop(context);
                Navigator.pop(context);
                messageDialog(context, "Driver Deleted", true);
              },
            ),
          ),
        ),
      ),
    );
  }
}
