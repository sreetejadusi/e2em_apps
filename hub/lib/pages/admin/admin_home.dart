import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State;
import 'package:provider/provider.dart';

import '../../index_files.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  bool l = false;

  List<HubModel> hubsList = [];
  load() async {
    AdminManager am = context.read<AdminManager>();
    await am.loadHubs(context);
  }

  /*Future<void> loadAllHubs() async {
    AuthenticationProvider ap = context.read<AuthenticationProvider>();
    try {
      await mongoDB.maintainMongoDBConnection(context);
      DbCollection hubs = mongoDB.db.collection('hubs');
      await hubs.find().toList().then((res) async {
        setState(() {
          hubsList = [for (final item in res) HubModel.fromMap(item)];
        });
      });

      print("Hubs loaded");
    } catch (e) {
      print(e);
    }
  }*/

  @override
  void initState() {
    load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AdminManager am = context.watch<AdminManager>();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: FloatingActionButton(
          backgroundColor: accentColor1,
          foregroundColor: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddHub(
                      hubModel: null,
                      added: () {
                        am.loadHubs(context);
                      })),
            );
          },
          child: const Icon(Icons.add),
        ),
        body: am.hubsLoading || l
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Hubs',
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .fontSize),
                        )),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  ListView(
                    shrinkWrap: true,
                    children: [
                      for (var i = 0; i < am.hubs.length; i++) ...[
                        hubItem(
                          hubModel: am.hubs[i],
                        ),
                      ],
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  deleteHubConfirmation({required HubModel hubModel}) {
    AdminManager am = context.read<AdminManager>();
    Widget okButton = ElevatedButton(
      child: Text("OK"),
      onPressed: () async {
        Navigator.of(context).pop();
        try {
          setState(() {
            l = true;
          });
          await mongoDB.maintainMongoDBConnection(context);
          DbCollection hubs = mongoDB.db.collection('hubs');
          DbCollection drivers = mongoDB.db.collection('drivers');
          DbCollection vehicles = mongoDB.db.collection('vehicles');
          DbCollection batteries = mongoDB.db.collection('batteries');
          DbCollection wallet = mongoDB.db.collection('wallet');
          DbCollection maintenance = mongoDB.db.collection('maintenance');
          DbCollection twallet = mongoDB.db.collection('twallet');

          await hubs.deleteMany({"hubId": hubModel.hubId});
          await vehicles.deleteMany({"hubId": hubModel.hubId});
          await batteries.deleteMany({"hubId": hubModel.hubId});
          await drivers.deleteMany({"hubId": hubModel.hubId});
          await wallet.deleteMany({"userId": hubModel.hubId});
          await twallet.deleteMany({"userId": hubModel.hubId});
          await maintenance.deleteMany({"hubId": hubModel.hubId});

          await am.loadHubs(context);
          setState(() {
            l = false;
          });
          messageDialog(context, "Hub Deleted", true);
          print("Hub Deleted");
        } catch (e) {
          print(e);
        }
      },
    );
    Widget cancelButton = ElevatedButton(
      child: const Text("Cancel"),
      onPressed: () async {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(hubModel.hubId),
      content: Text("Are you sure you want to delete hub- ${hubModel.hubId}"),
      actions: [
        cancelButton,
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget hubItem({required HubModel hubModel}) {
    AdminManager am = context.read<AdminManager>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
            color: accentColor1,
            boxShadow: [
              BoxShadow(
                blurRadius: 5,
                spreadRadius: 1,
                color: Colors.black12,
              ),
            ],
            borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HubDetail(
                        hubId: hubModel.hubId,
                        pop: () {},
                      )),
            );
          },
          title: Text(
            capitalize(hubModel.name),
            style: TextStyle(fontSize: 20),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              hubModel.hubId,
              //up.userDetails[1],
              style: TextStyle(fontSize: 15),
            ),
          ),
          leading: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Icon(
              FontAwesomeIcons.shop,
              size: 24,
              color: Colors.black,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.black,
                  ),
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddHub(
                              hubModel: hubModel,
                              added: () {
                                am.loadHubs(context);
                              })),
                    );
                  }),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.black,
                ),
                onPressed: () async {
                  deleteHubConfirmation(hubModel: hubModel);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
