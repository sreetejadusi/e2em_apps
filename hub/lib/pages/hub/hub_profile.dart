import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State;
import 'package:provider/provider.dart';

import '../../index_files.dart';

class HubProfile extends StatefulWidget {
  final bool appBar;
  const HubProfile({super.key, required this.appBar});

  @override
  State<HubProfile> createState() => _HubProfileState();
}

class _HubProfileState extends State<HubProfile> {
  bool l = false;
  Map<String, dynamic> profile = {};

  @override
  void initState() {
    load();
    super.initState();
  }

  load() async {
    setState(() {
      l = true;
    });
    AuthenticationProvider ap = context.read<AuthenticationProvider>();
    try {
      await mongoDB.maintainMongoDBConnection(context);
      if (ap.loginType == LoginType.hub) {
        DbCollection hubs = mongoDB.db.collection('hubs');
        await hubs.find({"hubId": ap.loginId}).toList().then((res) async {
              if (res.isNotEmpty) {
                setState(() {
                  profile = res[0];
                });
              }
            });
      }
      setState(() {
        l = false;
      });
      print("Hub profile loaded");
    } catch (e) {
      setState(() {
        l = false;
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: widget.appBar
          ? AppBar(
              elevation: 0,
              backgroundColor: accentColor1,
              title: const Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  "Profile",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              //iconTheme:
              centerTitle: true,
              actions: [],
            )
          : null,
      body: l
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
              child: CustomContainer(
                context: context,
                widget: Padding(
                  padding: EdgeInsets.symmetric(vertical: largeRadius),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18),
                        child: ListTile(
                          title: Text(
                            "Hub Info",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: Icon(
                            Icons.person,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      hubDetailItem(
                          title: "HUB ID",
                          icon: Icons.numbers,
                          subtitle: profile["hubId"] ?? " "),
                      hubDetailItem(
                          title: "Name",
                          icon: Icons.notes,
                          subtitle: profile["name"] ?? " "),
                      hubDetailItem(
                          title: "Address",
                          icon: Icons.location_on,
                          subtitle: profile["address"] ?? " "),
                      hubDetailItem(
                          title: "Wallet Balance",
                          icon: Icons.wallet,
                          subtitle: profile["wallet"].toString() ?? " "),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget hubDetailItem({
    required String title,
    required IconData icon,
    required String subtitle,
  }) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: ListTile(
        tileColor: Colors.white,
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
              child: Icon(icon, color: Colors.black),
            )),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Text(subtitle),
        ),
      ),
    );
  }
}
