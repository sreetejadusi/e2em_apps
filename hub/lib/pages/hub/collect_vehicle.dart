import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State;
import 'package:provider/provider.dart';

import '../../index_files.dart';

class CollectVehicle extends StatefulWidget {
  final String? vehicleId;
  final Function(int) tabChange;

  const CollectVehicle(
      {super.key, required this.vehicleId, required this.tabChange});

  @override
  State<CollectVehicle> createState() => _CollectVehicleState();
}

class _CollectVehicleState extends State<CollectVehicle> {
  final _formKey = GlobalKey<FormState>();
  var driverNameController = TextEditingController();
  var vehicleNoController = TextEditingController();

//  var dateTimeController = TextEditingController();
  //int selectedAllocationDate = -1;
  //List<DateTime> collectiondates = [];
  // int collectAllocation = -1;
  // List<dynamic> collectAllocationsDriver = [];
  //List<dynamic> vehicleAllocations = [];
  List<String> selectedVehiclesForCollection = [];

  //List<DriverModel?> vehicleAllocationDrivers = [];
  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    final date = DateTime.now();
    setState(() {
      if (widget.vehicleId != null) {
        vehicleNoController.text = widget.vehicleId!;
      } else {}
    });
    /* setState(() {
      collectiondates = [
        for (int i = 1; i < 7; i++) (date.subtract(Duration(days: i))),
        for (int i = 0; i < 7; i++) (date.add(Duration(days: i)))
      ];
      collectiondates.sort();
    });*/
    super.initState();
  }

  /*loadVehicleAllocations(String vid) async {
    HubManager hubManager = context.read<HubManager>();
    DbCollection vehicles = mongoDB.db.collection('vehicles');
    DbCollection drivers = mongoDB.db.collection('drivers');

    setState(() {
     // collectAllocation = -1;
      //vehicleAllocations = [];
    });

    await vehicles.findOne({"vehicleId": vid}).then((t) async {
      if (t != null) {
        List<dynamic> l = t['allocations'] ?? [];
        for (var item in l) {
          setState(() {
            vehicleAllocations.addAll(hubManager.allocations
                .where((element) => element.allocationId == item));
          });
        }
      }
    });
    setState(() {
      vehicleAllocationDrivers = [];
    });

    for (int i = 0; i < vehicleAllocations.length; i++) {
      List<DriverModel> dm = [];
      for (var item in hubManager.drivers) {
        if (item.allocations.contains(vehicleAllocations[i].allocationId)) {
          setState(() {
            dm.add(item);
          });
          break;
        }
      }
      if (dm.isNotEmpty) {
        setState(() {
          vehicleAllocationDrivers.add(dm[0]);
        });
      } else {
        setState(() {
          vehicleAllocationDrivers.add(null);
        });
      }
    }
  }*/

  clear() {
    setState(() {
      driverNameController.clear();
      vehicleNoController.clear();
      selectedVehiclesForCollection = [];
      //dateTimeController.clear();
      // selectedAllocationDate = -1;
      // vehicleAllocations.clear();
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    VehiclesProvider vp = context.watch<VehiclesProvider>();
    HubManager hubManager = context.watch<HubManager>();
    DataProvider dp = context.watch<DataProvider>();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor:
            widget.vehicleId == null ? Colors.transparent : accentColor1,
        title: Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Text(
            "Collect Vehicle",
            style: TextStyle(
                color: widget.vehicleId == null ? Colors.black : Colors.white),
          ),
        ),
        centerTitle: true,
        actions: [],
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
              if (selectedVehiclesForCollection.isNotEmpty) ...[
                InkWell(
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                      hubManager.vehicleCollectingState(true);
                      await mongoDB.maintainMongoDBConnection(context);
                      DbCollection vehicles = mongoDB.db.collection('vehicles');
                      DbCollection drivers = mongoDB.db.collection('drivers');

                      /* List<dynamic> val = [];
                      List<dynamic> dal = [];
                      await vehicles.findOne({
                        "vehicleId": vehicleNoController.text
                      }).then((t) async {
                        if (t != null) {
                          setState(() {
                            val = t['allocations'] ?? [];
                          });
                          setState(() {
                            val.removeWhere((element) =>
                                element ==
                                vehicleAllocations[collectAllocation]
                                    .allocationId);
                          });
                        }
                      });
                      await drivers.findOne({
                        "driverId": vehicleAllocationDrivers[collectAllocation]!
                            .driverId
                      }).then((t) async {
                        if (t != null) {
                          setState(() {
                            dal = t['allocations'] ?? [];
                          });
                          setState(() {
                            dal.removeWhere((element) =>
                                element ==
                                vehicleAllocations[collectAllocation]
                                    .allocationId);
                          });
                        }
                      });*/

                      for (int i = 0;
                          i < selectedVehiclesForCollection.length;
                          i++) {
                        await vehicles.update(
                            where.eq(
                                "vehicleId", selectedVehiclesForCollection[i]),
                            modify.set('driverId', null));
                        await vehicles.update(
                            where.eq(
                                "vehicleId", selectedVehiclesForCollection[i]),
                            modify.set('vehicleStatus', "parking"));
                      }
                      clear();
                      await hubManager.init(context);
                      hubManager.vehicleCollectingState(false);
                      widget.tabChange(0);
                     // await dp.updateCurrentTab(0);
                      messageDialog(context, "Vehicle Collected");
                      if (widget.vehicleId != null) {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }
                    }
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
                        "Collect",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
      /*bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25),
        child:
      ),*/
      body: (hubManager.vehiclesLoading ||
              hubManager.driversLoading ||
              hubManager.batteriesLoading)
          ? const Center(child: CircularProgressIndicator())
          : hubManager.vehicleCollecting
              ? loading(context)
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      children: [
                        SizedBox(
                          height: h * 0.01,
                        ),
                        /* textFieldTitle("Select Allocated Date"),
                        Wrap(
                          spacing: 10,
                          alignment: WrapAlignment.center,
                          children: [
                            for (int i = 0;
                                i < collectiondates.length;
                                i++) ...[
                              InputChip(
                                selected: (selectedAllocationDate == i),
                                label: Text(DateFormat('MMM dd yyyy')
                                    .format(collectiondates[i])
                                    .toString()),
                                onPressed: () {
                                  setState(() {
                                    selectedAllocationDate = i;
                                  });
                                },
                              ),
                            ],
                          ],
                        ),*/
                        /* if (selectedAllocationDate != -1) ...[
                          CustomTextField(
                            labelText: 'Vehicle No',
                            controller: vehicleNoController,
                            type: TextFieldType.dropdown,
                            items: [
                              for (final item in hubManager.vehicles)
                                if (item.vehicleStatus ==
                                    VehicleStatus.parking) ...[item.vehicleId]
                            ],
                            hintText: 'Select Vehicle No',
                            suffixIcon: Icons.arrow_drop_down,
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return "Vehicle No cannot be empty";
                              }
                              return null;
                            },
                            onChanged: (String value) {
                              setState(() {
                                vehicleNoController =
                                    TextEditingController(text: value);
                              });
                              if (vehicleNoController.text.isNotEmpty) {
                                loadVehicleAllocations(
                                    vehicleNoController.text);
                              }
                            },
                          ),
                        ],*/
                        textFieldTitle("Select Collection"),
                        Wrap(
                          spacing: 10,
                          alignment: WrapAlignment.center,
                          children: [
                            for (int i = 0;
                                i < hubManager.vehicles.length;
                                i++) ...[
                              if (hubManager.vehicles[i].getVS() ==
                                  VehicleStatus.assigned) ...[
                                InputChip(
                                  selected:
                                      selectedVehiclesForCollection.contains(
                                          hubManager.vehicles[i].vehicleId),
                                  label: Text(hubManager.vehicles[i].vehicleId +
                                      " - " +
                                      hubManager.vehicles[i].driverId!),
                                  onPressed: () {
                                    String vid =
                                        hubManager.vehicles[i].vehicleId;
                                    if (selectedVehiclesForCollection
                                        .contains(vid)) {
                                      setState(() {
                                        selectedVehiclesForCollection
                                            .remove(vid);
                                      });
                                    } else {
                                      setState(() {
                                        selectedVehiclesForCollection.add(vid);
                                      });
                                    }
                                  },
                                ),
                              ],
                            ],
                          ],
                        ),
                        SizedBox(
                          height: 25,
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
