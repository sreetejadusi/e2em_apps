import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State;
import 'package:provider/provider.dart';

import '../../index_files.dart';

class AllMaintenance extends StatefulWidget {
  const AllMaintenance({super.key});

  @override
  State<AllMaintenance> createState() => _AllMaintenanceState();
}

class _AllMaintenanceState extends State<AllMaintenance>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  bool l = false;
  List<MaintenanceModel> maintenanceList = [];
  load() async {
    setState(() {
      l = true;
    });
    await loadAllMaintenance();
    setState(() {
      l = false;
    });
  }

  Future<void> loadAllMaintenance() async {
    AuthenticationProvider ap = context.read<AuthenticationProvider>();
    try {
      await mongoDB.maintainMongoDBConnection(context);
      DbCollection maintenance = mongoDB.db.collection('maintenance');
      await maintenance.find().toList().then((res) async {
        setState(() {
          maintenanceList = [
            for (final item in res.reversed.toList())
              MaintenanceModel.fromMap(item)
          ];
        });
      });

      print("T Wallet loaded");
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    load();
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    AuthenticationProvider ap = context.watch<AuthenticationProvider>();
    HubManager hubManager = context.watch<HubManager>();
    WalletProvider wp = context.watch<WalletProvider>();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
/*
        title: const Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Text(
            "Approve Wallet",
            style: TextStyle(color: Colors.white),
          ),
        ),
        centerTitle: true,
        actions: [],*/
        flexibleSpace: TabBar(
          labelColor: Colors.black,
          indicatorColor: accentColor1,
          indicatorSize: TabBarIndicatorSize.label,
          isScrollable: false,
          controller: tabController,
          onTap: (int index) {},
          tabs: const [
            Tab(
              text: "Pending",
            ),
            Tab(
              text: "Complete",
            ),
          ],
        ),
      ),
      body: l
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                ///PENDING
                Padding(
                  padding: const EdgeInsets.only(
                      left: 18, right: 18, top: 18, bottom: 8),
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: largeRadius),
                          child: Scrollbar(
                            thumbVisibility: true,
                            child: ListView(
                              physics: const BouncingScrollPhysics(),
                              children: [
                                for (var i = 0;
                                    i < maintenanceList.length;
                                    i++) ...[
                                  if (maintenanceList[i].status ==
                                      "pending") ...[
                                    maintenaanceItem(
                                      maintenanceData: maintenanceList[i],
                                    ),
                                  ],
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                ///APPROVED
                Padding(
                  padding: const EdgeInsets.only(
                      left: 18, right: 18, top: 18, bottom: 8),
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: largeRadius),
                          child: Scrollbar(
                            thumbVisibility: true,
                            child: ListView(
                              physics: const BouncingScrollPhysics(),
                              children: [
                                for (var i = 0;
                                    i < maintenanceList.length;
                                    i++) ...[
                                  if (maintenanceList[i].status ==
                                      "complete") ...[
                                    maintenaanceItem(
                                      maintenanceData: maintenanceList[i],
                                    ),
                                  ],
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget maintenaanceItem({
    required MaintenanceModel maintenanceData,
  }) {
    WalletProvider wp = context.read<WalletProvider>();
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: accentColor1),
          color: accentColor1.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Id: " + maintenanceData.maintenanceId,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Issue: " + maintenanceData.issue,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Description: " + maintenanceData.description,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Hub ID: " + maintenanceData.hubId,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Vehicle ID: " + maintenanceData.vehicleId.toUpperCase(),
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Date: " + dateFromString(maintenanceData.datetime),
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (maintenanceData.status == "pending") ...[
                  FloatingActionButton.small(
                    foregroundColor: accentColor1,
                    elevation: 5,
                    onPressed: () async {
                      try {
                        await mongoDB.maintainMongoDBConnection(context);
                        DbCollection maintenance =
                            mongoDB.db.collection('maintenance');
                        await maintenance.updateMany(
                            {'maintenanceId': maintenanceData.maintenanceId},
                            modify.set('status', "complete"));
                        messageDialog(
                            context, "Maintenance moved to complete", true);
                        load();
                      } catch (e) {
                        print(e);
                      }
                    },
                    backgroundColor: Colors.white,
                    child: const Icon(
                      Icons.touch_app_rounded,
                    ),
                  ),
                ] else ...[
                  Icon(
                    Icons.verified,
                    color: Colors.green,
                    size: 40,
                  )
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }
}
