import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hub/widgets/appbar.dart';

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
      appBar: GradientAppBar(title: 'Alarms', automaticallyImplyLeading: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
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
                subtitle: "Issues in vehicle performance",
                iconColor: Colors.black,
                icon: FontAwesomeIcons.circleExclamation),
            tile(
                title: "Wallet Approved",
                subtitle: "Add amount to wallet approved",
                iconColor: Colors.black,
                icon: FontAwesomeIcons.thumbsUp),
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
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: accentColor1,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 28,
                )),
            SizedBox(
              width: 16,
            ),
            FittedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  Text(subtitle),
                ],
              ),
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
              size: 15,
            )
          ],
        ),
      ),
    );
  }
}
