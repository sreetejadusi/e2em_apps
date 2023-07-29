import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
    AuthenticationProvider ap = context.watch<AuthenticationProvider>();
    WalletProvider wp = context.watch<WalletProvider>();
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: widget.appBar
          ? AppBar(
              // automaticallyImplyLeading: false,
              backgroundColor: accentColor1,
              iconTheme: IconThemeData(color: Colors.black),
              elevation: 0,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Center(
                      child: Text(
                    '@' + (profile["hubId"] ?? " "),
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  )),
                )
              ],
              title: FittedBox(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Profile',
                  style: TextStyle(
                    color: Color(0xFF303030),
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
              ),
              centerTitle: false,
            )
          : null,
      body: l
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Padding(
                //   padding: const EdgeInsets.only(left: 8.0),
                //   child: Align(
                //     alignment: Alignment.centerLeft,
                //     child: IconButton(
                //       icon: Icon(FontAwesomeIcons.chevronLeft),
                //       onPressed: () {
                //         Navigator.of(context).pop();
                //       },
                //     ),
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 48),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 54),
                        padding: EdgeInsets.symmetric(vertical: 48),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(12)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  offset: Offset(-2, -3),
                                  blurRadius: 18)
                            ]),
                        child: Column(
                          children: [
                            Text(
                              capitalize(ap.displayName),
                              style: TextStyle(fontSize: 20),
                            ),
                            Center(
                              child: SizedBox(
                                width: 256,
                                child: Divider(
                                  color: Colors.black,
                                  height: 12,
                                ),
                              ),
                            ),
                            Text(
                              capitalize(profile['address'] ?? ' '),
                              style: TextStyle(fontSize: 14),
                            ),
                            Center(
                              child: SizedBox(
                                width: 256,
                                child: Divider(
                                  color: Colors.black,
                                  height: 12,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            ElevatedButton(
                                style: ButtonStyle(
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.symmetric(horizontal: 12)),
                                    side: MaterialStateProperty.all(BorderSide(
                                        color: accentColor1, width: 1)),
                                    shadowColor: MaterialStateProperty.all(
                                        Colors.transparent),
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                    foregroundColor: MaterialStateProperty.all(
                                        accentColor1)),
                                onPressed: () {},
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 36.0),
                                  child: Text(wp.walletBalance.toString()),
                                )),
                            hubDetailItem(
                                title: 'Documents',
                                icon: FontAwesomeIcons.file,
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Start(
                                          tab: 1,
                                        ),
                                      ));
                                }),
                            hubDetailItem(
                                title: 'Alarms',
                                icon: FontAwesomeIcons.clock,
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Alarms(),
                                      ));
                                }),
                            hubDetailItem(
                                title: 'Wallet',
                                icon: FontAwesomeIcons.wallet,
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Wallet(),
                                      ));
                                }),
                            hubDetailItem(
                                title: 'Settings',
                                icon: FontAwesomeIcons.gear,
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Settings(),
                                      ));
                                }),
                            hubDetailItem(
                                title: 'Sign out',
                                icon: FontAwesomeIcons.arrowRightFromBracket,
                                onTap: () {
                                  ap.signOut(context).then((value) {
                                    Navigator.of(context).pop();
                                  });
                                })
                          ],
                        ),
                      ),
                      Image.asset(
                        'assets/sample_avatar.png',
                      ),
                    ],
                  ),
                )
                // Padding(
                //   padding:
                //       const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
                //   child: CustomContainer(
                //     context: context,
                //     widget: Padding(
                //       padding: EdgeInsets.symmetric(vertical: largeRadius),
                //       child: ListView(
                //         shrinkWrap: true,
                //         children: [
                //           const Padding(
                //             padding: EdgeInsets.symmetric(horizontal: 18),
                //             child: ListTile(
                //               title: Text(
                //                 "Hub Info",
                //                 style: TextStyle(fontWeight: FontWeight.bold),
                //               ),
                //               trailing: Icon(
                //                 Icons.person,
                //                 color: Colors.black,
                //               ),
                //             ),
                //           ),
                //           hubDetailItem(
                //               title: "HUB ID",
                //               icon: Icons.numbers,
                //               subtitle: profile["hubId"] ?? " "),
                //           hubDetailItem(
                //               title: "Name",
                //               icon: Icons.notes,
                //               subtitle: profile["name"] ?? " "),
                //           hubDetailItem(
                //               title: "Address",
                //               icon: Icons.location_on,
                //               subtitle: profile["address"] ?? " "),
                //           hubDetailItem(
                //               title: "Wallet Balance",
                //               icon: Icons.wallet,
                //               subtitle: profile["wallet"].toString() ?? " "),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
    );
  }

  Widget hubDetailItem(
      {required String title,
      required IconData icon,
      required Function() onTap}) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 36.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Row(children: [
                Icon(
                  icon,
                  color: Colors.black,
                  size: 22,
                ),
                SizedBox(
                  width: 12,
                ),
                Text(
                  title,
                  style: TextStyle(fontSize: 18),
                ),
              ]

                  // trailing: Padding(
                  //   padding: const EdgeInsets.only(right: 10),
                  //   child: Text(subtitle),
                  // ),
                  ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 300,
                child: Divider(
                  color: accentColor1,
                  thickness: 1.2,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
