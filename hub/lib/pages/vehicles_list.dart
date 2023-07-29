import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../index_files.dart';

class VehiclesList extends StatefulWidget {
  final String title;
  final List<VehicleStatus> filter;

  const VehiclesList({super.key, required this.title, required this.filter});

  @override
  State<VehiclesList> createState() => _VehiclesListState();
}

class _VehiclesListState extends State<VehiclesList> {
  @override
  Widget build(BuildContext context) {
    VehiclesProvider vp = context.watch<VehiclesProvider>();
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
      body: ListView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        children: [
          for (var i = 0; i < vp.vehicles.length; i++) ...[
            if (widget.filter.contains(vp.vehicles[i].getVS())) ...[
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                child: tile(
                    title: vp.vehicles[i].vehicleId,
                    icon: Icons.sticky_note_2_outlined,
                    onTap: () {}),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget tile(
      {required String title,
      required IconData icon,
      required Function() onTap}) {
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
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: ListTile(
              onTap: onTap,
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
                      icon,
                      color: Colors.black,
                    ),
                  )),
              title: Text(
                title,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
                size: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
