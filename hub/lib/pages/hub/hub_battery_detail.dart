import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State;
import 'package:provider/provider.dart';

import '../../index_files.dart';

class HubBatteryDetail extends StatefulWidget {
  final BatteryModel battery;

  const HubBatteryDetail({super.key, required this.battery});

  @override
  State<HubBatteryDetail> createState() => _HubBatteryDetailState();
}

class _HubBatteryDetailState extends State<HubBatteryDetail> {
  bool l = false;
  @override
  Widget build(BuildContext context) {
    HubManager hubManager = context.watch<HubManager>();
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: accentColor1,
        title: Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Text(
            widget.battery.batteryId,
            style: TextStyle(color: Colors.white),
          ),
        ),
        //iconTheme:
        centerTitle: true,
        actions: [],
      ),
      body: l
          ? loading(context)
          : Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  CustomContainer(
                    context: context,
                    widget: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(
                          widget.battery.batteryId,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        leading: Icon(
                          Icons.battery_charging_full,
                          size: 35,
                          color: Colors.black,
                        ),
                        trailing: Text(
                          batteryStatusMap(widget.battery.getBS()),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        CustomContainer(
                          context: context,
                          widget: Padding(
                            padding:
                                EdgeInsets.symmetric(vertical: largeRadius),
                            child: Scrollbar(
                              thumbVisibility: true,
                              child: ListView(
                                shrinkWrap: true,
                                children: [
                                  if (widget.battery.getBS() ==
                                      BatteryStatus.ideal) ...[
                                    batteryAction(
                                        title: "Move to maintenance",
                                        onTap: () {
                                          maintenance();
                                        }),
                                  ],
                                  if (widget.battery.getBS() ==
                                      BatteryStatus.maintenance) ...[
                                    batteryAction(
                                        title: "Move to ideal",
                                        onTap: () {
                                          ideal();
                                        }),
                                  ]
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
            ),
    );
  }

  assign(String batteryId) {}

  maintenance() async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    setState(() {
      l = true;
    });
    HubManager hubManager = context.read<HubManager>();
    await mongoDB.maintainMongoDBConnection(context);
    DbCollection batteries = mongoDB.db.collection('batteries');
    await batteries
        .update(where.eq("batteryId", widget.battery.batteryId),
            modify.set("batteryStatus", "maintenance"))
        .then((value) {
      print("Battery Moved to maintenance");
    });
    await hubManager.init(context);
    setState(() {
      l = false;
    });
    Navigator.pop(context);
    messageDialog(context, "Battery moved to maintenance",true);
  }

  ideal() async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    setState(() {
      l = true;
    });
    HubManager hubManager = context.read<HubManager>();
    await mongoDB.maintainMongoDBConnection(context);
    DbCollection batteries = mongoDB.db.collection('batteries');
    await batteries
        .update(where.eq("batteryId", widget.battery.batteryId),
            modify.set("batteryStatus", "ideal"))
        .then((value) {
      print("Battery Moved to ideal");
    });
    await hubManager.init(context);
    setState(() {
      l = false;
    });
    Navigator.pop(context);
    messageDialog(context, "Battery moved to ideal", true);
  }

  Widget divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Container(
        color: Colors.black,
        width: double.infinity,
        height: 0.7,
      ),
    );
  }

  Widget batteryAction({
    required String title,
    required Function() onTap,
  }) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: ListTile(
        onTap: onTap,
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(largeRadius),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Icon(
            Icons.call_to_action_outlined,
            color: Colors.black,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 20,
          color: Colors.black,
        ),
      ),
    );
  }
}
