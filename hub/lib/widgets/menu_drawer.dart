import 'package:flutter/material.dart';
import 'package:hub/colors&components.dart';
import 'package:provider/provider.dart';

import '../index_files.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    AuthenticationProvider ap = context.watch<AuthenticationProvider>();
    return SizedBox(
      width: w * 0.75,
      child: Drawer(
        backgroundColor: backgroundColor,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(gradient: lg),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ListTile(
                          leading: Container(
                              decoration: BoxDecoration(
                                  color: accentColor1,
                                  border: Border.all(
                                    width: 3,
                                    color: Colors.white,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50))),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 35,
                                ),
                              )),
                          title: Text(
                            ap.displayName,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              ap.displayId,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  //fontSize: 18,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Expanded(
                child: ListView(
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    /*tile(
                      title: "Home",
                      onTap: () {},
                    ),*/
                    /*if (ap.loginType == LoginType.admin) ...[
                      tile(
                        title: "Approve Wallet",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ApproveTWallet()),
                          );
                        },
                      ),
                    ],*/

                    /* if (ap.loginType == LoginType.driver) ...[
                      tile(
                        title: "Documents",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DriverDocuments()),
                          );
                        },
                      ),
                      tile(
                        title: "Assistance",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DriverAssistance()),
                          );
                        },
                      ),
                    ],*/
                    if (ap.loginType == LoginType.hub) ...[
                      tile(
                        title: "Wallet",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Wallet()),
                          );
                        },
                      ),
                      tile(
                        title: "Profile",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HubProfile(
                                      appBar: true,
                                    )),
                          );
                        },
                      ),
                      /* tile(
                        title: "Maintenance",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Maintenance(
                                      vehicleId: null,
                                    )),
                          );
                        },
                      ),
                      tile(
                        title: "Financial Review",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const FinancialReview()),
                          );
                        },
                      ),
                      tile(
                        title: "Alarms",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Alarms()),
                          );
                        },
                      ),*/
                    ],
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                child: Container(
                  width: double.infinity,
                  height: 1.5,
                  color: Colors.black,
                ),
              ),
              tile(
                title: "Settings",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Settings()),
                  );
                },
              ),
              tile(
                title: "Sign out",
                onTap: () {
                  ap.signOut(context);
                },
              ),
              SizedBox(
                height: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget tile({required String title, required Function() onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: ListTile(
        onTap: onTap,
        tileColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(largeRadius),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        trailing: Padding(
          padding: const EdgeInsets.only(right: 0),
          child: const Icon(
            Icons.arrow_forward_ios,
            size: 15,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
