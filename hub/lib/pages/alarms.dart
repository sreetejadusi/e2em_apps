import 'package:flutter/material.dart';

import '../index_files.dart';

class Alarms extends StatefulWidget {
  const Alarms({super.key});

  @override
  State<Alarms> createState() => _AlarmsState();
}

class _AlarmsState extends State<Alarms> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: accentColor1,
        title: const Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Text(
            "Alarms",
            style: TextStyle(color: Colors.white),
          ),
        ),
        //iconTheme:
        centerTitle: true,
        actions: [],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18,vertical: 18),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          children: [
            tile(
                title: "Battery Issue",
                subtitle: "Issue in battery while charging",
                iconColor: Colors.black,
                icon: Icons.battery_unknown),
            tile(
                title: "Low Balance",
                subtitle: "Low balance in wallet",
                iconColor: Colors.black,
                icon: Icons.account_balance_wallet),
            tile(
                title: "Performance Issue",
                subtitle: "Issue detected in vehicle performance",
                iconColor: Colors.black,
                icon: Icons.electric_rickshaw),
            tile(
                title: "Wallet Approved",
                subtitle: "Add amount to wallet approved",
                iconColor: Colors.black,
                icon: Icons.approval),
          ],
        ),
      ),
    );
  }

  Widget tile(
      {required String title,
      required String subtitle,
      required Color iconColor,
      required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(largeRadius),
        ),
        child:Container(
          decoration: BoxDecoration(
            gradient: clg,
            borderRadius: BorderRadius.circular(largeRadius),
          ),
          child:   ListTile(
          tileColor: Colors.white,
          isThreeLine: true,
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
                child: Icon(icon, color: iconColor),
              )),
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(subtitle),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Colors.black,
            size: 15,
          ),
        ),),
      ),
    );
  }
}
