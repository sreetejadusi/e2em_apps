import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../index_files.dart';

class BulkAllocation extends StatefulWidget {
  final Function(Map<DriverModel, VehicleModel>, List<String>) bulkAllocation;

  const BulkAllocation({super.key, required this.bulkAllocation});

  @override
  State<BulkAllocation> createState() => _BulkAllocationState();
}

class _BulkAllocationState extends State<BulkAllocation> {
  final _formKey = GlobalKey<FormState>();
  List<VehicleModel> vl = [];
  List<DriverModel> dl = [];
  List<BatteryModel> bl = [];
  List<DriverModel> sd = [];
  Map<DriverModel, VehicleModel> allocationList = {};
  List<String> allocatedBatteries = [];
  List<Map<String, List<List<dynamic>>>> allFrequency = [];

  load() async {
    HubManager hubManager = context.read<HubManager>();
    hubManager.init(context);
    setState(() {
      sd = [];
      allocationList = {};
    });
    vl = [];
    dl = [];
    List<VehicleModel> vll = hubManager.vehicles.toList();
    for (int i = 0; i < vll.length; i++) {
      if (vll[i].getVS() == VehicleStatus.parking) {
        setState(() {
          vl.add(vll[i]);
        });
      }
    }
    setState(() {
      // vl.removeLast();
      //vl.removeLast();
      //vl.removeLast();
    });
    setState(() {
      dl = [
        for (final item in hubManager.drivers)
          if (!([for (var v in hubManager.vehicles) v.driverId ?? " "]
              .contains(item.driverId)))
            item
      ];
    });
    await loadFrequency();
  }

  ///VEHICLE FREQUENTLY USED ALLOCATION
  allocate() async {
    HubManager hubManager = context.read<HubManager>();
    List<List<List<dynamic>>> fl = [];
    setState(() {
      allocationList = {};
    });
    List<String> dln = [for (var item in sd) item.driverId];
    dln = dln..sort();
    await loadFrequency();
    setState(() {
      allFrequency
          .removeWhere((element) => !dln.contains(element.keys.toList()[0]));
      allFrequency = allFrequency
        ..sort((a, b) => a.keys.toList()[0].compareTo(b.keys.toList()[0]));
    });

    for (int i = 0; i < allFrequency.length; i++) {
      List<List<dynamic>> dm = allFrequency[i].values.toList()[0];
      dm.removeWhere((element) =>
          !([for (var item in vl) item.vehicleId].contains(element[0])));
      for (var item in vl) {
        if ([for (var item in dm) item[0]].contains(item.vehicleId)) {
        } else {
          setState(() {
            dm.add([item.vehicleId, 0]);
          });
        }
      }
      setState(() {
        dm = dm..sort((a, b) => a[0].compareTo(b[0]));
      });
      setState(() {
        fl.add(dm);
      });
    }
    int g = -1;
    int ii = 0;
    int jj = 0;
    List<String> exclude = [];
    for (int x = 0; x < dln.length; x++) {
      try {
        for (int i = 0; i < fl.length; i++) {
          for (int j = 0; j < fl[i].length; j++) {
            if (!exclude.contains("$i-$j")) {
              if (fl[i][j][1] > g) {
                setState(() {
                  g = fl[i][j][1];
                  ii = i;
                  jj = j;
                });
              }
            }
          }
        }
        setState(() {
          allocationList.addAll({
            sd.singleWhere((element) => element.driverId == dln[ii]):
                vl.singleWhere((element) => element.vehicleId == fl[ii][jj][0])
          });
          exclude.add("$ii-$jj");
          for (int j = 0; j < fl[ii].length; j++) {
            exclude.add("$ii-$j");
          }
          for (int i = 0; i < fl.length; i++) {
            exclude.add("$i-$jj");
          }
          exclude = exclude.toSet().toList();
          g = -1;
        });
      } catch (e) {
        print(e);
      }
    }
    setState(() {
      allocatedBatteries.clear();
    });
    setState(() {
      bl = [
        for (final item in hubManager.batteries)
          if (item.getBS() == BatteryStatus.ideal) item
      ];
    });
    for (var item in allocationList.values.toList()) {
      String? bid = item.batteryId;
      if (bid != null) {
        setState(() {
          allocatedBatteries.add(bid);
        });
      } else {
        setState(() {
          allocatedBatteries.add(bl[0].batteryId);
          bl.removeAt(0);
        });
      }
    }
    print(allocatedBatteries);
  }

  Future<void> loadFrequency() async {
    HubManager hubManager = context.read<HubManager>();
    setState(() {
      allFrequency = [];
    });

    for (var item in hubManager.drivers.toList()) {
      setState(() {
        allFrequency.add(<String, List<List<dynamic>>>{
          item.driverId.toString(): [
            for (var item in item.vehicleFrequency) item
          ],
        });
      });
    }

    print(allFrequency.toString());
    /* setState(() {
      allFrequency.addAll([
        <String, List<List<dynamic>>>{
          "D103": [
            ["V105", 2],
            ["V101", 1],
          ],
        },
        <String, List<List<dynamic>>>{
          "D104": [
            ["V102", 2],
            ["V105", 1],
          ],
        },
        <String, List<List<dynamic>>>{
          "D101": [
            ["V101", 0],
            ["V102", 2],
            ["V105", 1],
          ],
        },
        <String, List<List<dynamic>>>{
          "D102": [
            ["V103", 2],
            ["V101", 4],
          ],
        },
      ]);
    });*/
  }

  clear() {
    setState(() {
      allocationList.clear();
      sd.clear();
      allFrequency = [];
      allocatedBatteries.clear();
    });
  }

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    VehiclesProvider vp = context.watch<VehiclesProvider>();
    HubManager hubManager = context.watch<HubManager>();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: accentColor1,
        title: Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Text(
            "Choose Bulk Allocation",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                load();
              },
              icon: Icon(Icons.refresh))
        ],
      ),
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  clear();
                },
                child: Container(
                  decoration: BoxDecoration(
                    //color: Color(0xFF0079E9),
                    border: Border.all(width: 1, color: Colors.black),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  height: 40,
                  width: w * 0.35,
                  child: Center(
                    child: Text(
                      "Clear",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  if (allocationList.isNotEmpty &&
                      allocatedBatteries.isNotEmpty) {
                    widget.bulkAllocation(allocationList, allocatedBatteries);
                    Navigator.pop(context);
                  }

                  /* if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                  }*/
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: accentColor1,
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  height: 40,
                  width: w * 0.35,
                  child: Center(
                    child: Text(
                      "Save",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
      body: (hubManager.driversLoading || hubManager.vehiclesLoading)
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Form(
                key: _formKey,
                child: ListView(
                 // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    CustomContainer(
                      context: context,
                      widget: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Container(),
                              ],
                            ),
                            textFieldTitle("Choose Drivers"),
                            Wrap(
                              spacing: 10,
                              alignment: WrapAlignment.center,
                              children: [
                                for (int i = 0; i < dl.length; i++) ...[
                                  InputChip(
                                    label: Text(dl[i].driverId),
                                    selected: (sd.contains(dl[i])),
                                    onPressed: () {
                                      if (sd.contains(dl[i])) {
                                        setState(() {
                                          sd.remove(dl[i]);
                                          allocationList.clear();
                                        });
                                      } else {
                                        if (!(sd.length == vl.length) ||
                                            bl.isNotEmpty) {
                                          setState(() {
                                            sd.add(dl[i]);
                                            allocationList.clear();
                                          });
                                        }
                                      }
                                      allocate();
                                    },
                                  ),
                                ],
                              ],
                            ),
                            textFieldTitle("Available Vehicles"),
                            Wrap(
                              spacing: 10,
                              alignment: WrapAlignment.center,
                              children: [
                                for (int i = 0; i < vl.length; i++) ...[
                                  if (allocationList.values
                                      .toList()
                                      .where((element) =>
                                          element.vehicleId == vl[i].vehicleId)
                                      .toList()
                                      .isEmpty) ...[
                                    Chip(
                                      label: Text(vl[i].vehicleId),
                                    ),
                                  ],
                                ],
                              ],
                            ),
                            textFieldTitle("Available Batteries"),
                            Wrap(
                              spacing: 10,
                              alignment: WrapAlignment.center,
                              children: [
                                for (int i = 0; i < bl.length; i++) ...[
                                  if (allocatedBatteries
                                      .toList()
                                      .where((element) =>
                                          element == bl[i].batteryId)
                                      .toList()
                                      .isEmpty) ...[
                                    Chip(
                                      label: Text(bl[i].batteryId),
                                    ),
                                  ],
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    textFieldTitle("Vehicles Bulk Allocation List"),
                    Column(
                     // physics: const BouncingScrollPhysics(),
                     // scrollDirection: Axis.vertical,
                      children: [
                        for (int i = 0; i < allocationList.length; i++) ...[
                          item(
                              driverId:
                                  allocationList.keys.toList()[i].driverId,
                              batteryId: allocatedBatteries.toList()[i],
                              vehicle: allocationList.values
                                  .toList()[i]
                                  .vehicleId),
                        ],
                        //allocationList
                        //item(driver: "D101", vehicle: "V103"),
                        //item(driver: "D105", vehicle: "V101"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget item(
      {required String driverId,
      required String batteryId,
      required String vehicle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: CustomContainer(
        context: context,
        widget: Padding(
          padding: EdgeInsets.all(0.0),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: ListTile(
                  title: Center(
                    child: Text(
                      driverId,
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: ListTile(
                  title: Center(
                    child: Text(
                      vehicle,
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.normal),
                    ),
                  ),
                  subtitle: Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Center(
                      child: Text(
                        batteryId,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget tile({required String title, required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(largeRadius),
        ),
        child: ListTile(
          tileColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(largeRadius),
          ),
          leading: Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(smallRadius),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Icon(icon),
              )),
          title: Text(
            title,
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 15,
          ),
        ),
      ),
    );
  }
}
