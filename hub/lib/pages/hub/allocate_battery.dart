import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State;
import 'package:provider/provider.dart';

import '../../index_files.dart';

class AllocateBattery extends StatefulWidget {
  final String? batteryId;
  final Function(int) tabChange;

  const AllocateBattery(
      {super.key, required this.batteryId, required this.tabChange});

  @override
  State<AllocateBattery> createState() => _AllocateBatteryState();
}

class _AllocateBatteryState extends State<AllocateBattery>
    with SingleTickerProviderStateMixin {
  bool previousAllocationLoading = false;
  List<String> previousAllocationDetail = [];
  String? allocatedBattery;

  //List<List<BatteryModel>> batteriesPairs = [];
  List<BatteryModel> availableBatteries = [];
  List<VehicleModel> availableVehicles = [];
  int selectedPair = -1;
  final _formKey = GlobalKey<FormState>();
  var driverNameController = TextEditingController();
  var vehicleNoController = TextEditingController();
  var batteryNo1Controller = TextEditingController();
  var batteryNo2Controller = TextEditingController();
  // var paymentAmountController = TextEditingController();
  var dateTimeController = TextEditingController();
  AnimationController? bsController;

  @override
  void initState() {
    bsController = AnimationController(vsync: this);
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    setState(() {
      if (widget.batteryId != null) {
        vehicleNoController.text = widget.batteryId!;
      } else {}
    });
    // Timer.periodic(Duration(seconds: 2), (timer) {
    load();
    // });
    super.initState();
  }

  load() {
    HubManager hubManager = context.read<HubManager>();
    setState(() {
      availableVehicles.addAll(hubManager.vehicles.where((element) =>
          element.batteryId != null && element.vehicleStatus == 'assigned'));
    });
  }

  loadBatteryPairs() {
    HubManager hubManager = context.read<HubManager>();
    availableBatteries = [];
    //batteriesPairs = [];
    for (int i = 0; i < hubManager.batteries.length; i++) {
      if (hubManager.batteries[i].getBS() == BatteryStatus.ideal &&
          (allocatedBattery != hubManager.batteries[i].batteryId)) {
        setState(() {
          availableBatteries.add(hubManager.batteries[i]);
        });
      }
    }
    print(availableBatteries);
    /*while (availableBatteries.length >= 2) {
      BatteryModel bm1 = availableBatteries[0];
      BatteryModel bm2 = availableBatteries[1];
      setState(() {
        availableBatteries.removeAt(1);
        availableBatteries.removeAt(0);
      });
      setState(() {
        //batteriesPairs.add([bm1, bm2]);
      });
    }*/
    //print(batteriesPairs);
  }

  loadAllocatedBatteries() {
    HubManager hubManager = context.read<HubManager>();
    setState(() {
      allocatedBattery = null;
    });
    if (vehicleNoController.text.isNotEmpty &&
        hubManager.vehicles
                .singleWhere(
                    (element) => element.vehicleId == vehicleNoController.text)
                .batteryId !=
            null) {
      setState(() {
        allocatedBattery = hubManager.vehicles
            .singleWhere(
                (element) => element.vehicleId == vehicleNoController.text)
            .batteryId;
      });
    }
  }

  clear() {
    setState(() {
      driverNameController.clear();
      vehicleNoController.clear();
      // paymentAmountController.clear();
      dateTimeController.clear();
      batteryNo1Controller.clear();
      batteryNo2Controller.clear();
      allocatedBattery = null;
      previousAllocationDetail.clear();
      availableBatteries.clear();
      //batteriesPairs.clear();
      selectedPair = -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    VehiclesProvider vp = context.watch<VehiclesProvider>();
    DataProvider dp = context.watch<DataProvider>();
    HubManager hubManager = context.watch<HubManager>();
    WalletProvider wp = context.watch<WalletProvider>();
    AuthenticationProvider ap = context.watch<AuthenticationProvider>();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: backgroundColor,
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor:
      //       widget.batteryId == null ? Colors.transparent : accentColor1,
      //   title: Padding(
      //     padding: const EdgeInsets.symmetric(vertical: 15),
      //     child: Text(
      //       "Swap Battery",
      //       style: TextStyle(
      //           color: widget.batteryId == null ? Colors.black : Colors.white),
      //     ),
      //   ),
      //   centerTitle: true,
      //   actions: [],
      // ),
      // persistentFooterButtons: [
      //   Padding(
      //     padding: const EdgeInsets.symmetric(vertical: 10),
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //       children: [
      //         InkWell(
      //           onTap: () {
      //             clear();
      //           },
      //           child: Container(
      //             decoration: BoxDecoration(
      //               //color: Color(0xFF0079E9),
      //               border: Border.all(width: 1, color: Colors.black),
      //               borderRadius: const BorderRadius.all(Radius.circular(8)),
      //             ),
      //             height: 40,
      //             width: w * 0.35,
      //             child: Center(
      //               child: Text(
      //                 "Clear",
      //                 style: TextStyle(
      //                     fontSize: 16,
      //                     color: Colors.black,
      //                     fontWeight: FontWeight.bold),
      //               ),
      //             ),
      //           ),
      //         ),
      //         if (selectedPair != -1 &&
      //             vehicleNoController.text.isNotEmpty) ...[
      //           InkWell(
      //             onTap: selectedPair == -1
      //                 ? null
      //                 : () async {
      //                     if (_formKey.currentState!.validate()) {
      //                       _formKey.currentState!.save();
      //                       SystemChannels.textInput
      //                           .invokeMethod('TextInput.hide');
      //                       hubManager.batterySwappingState(true);
      //                       bool success = await wp.updateWalletAmount(
      //                           context: context,
      //                           loginType: LoginType.hub,
      //                           loginId:
      //                               ap.loginId.split("-").toList().first.trim(),
      //                           amount: ap.hub!.batterySwapCost,
      //                           credit: false);
      //                       if (success) {
      //                         await mongoDB.maintainMongoDBConnection(context);
      //                         DbCollection batteries =
      //                             mongoDB.db.collection('batteries');
      //                         DbCollection vehicles =
      //                             mongoDB.db.collection('vehicles');
      //                         DbCollection wallet =
      //                             mongoDB.db.collection('wallet');
      //                         await wallet.insertOne({
      //                           'userId': ap.loginId,
      //                           'amount': ap.hub!.batterySwapCost,
      //                           'description': "Battery Swap",
      //                           'timestamp': DateTime.now().toString(),
      //                           'type': 'debit'
      //                         });
      //                         await batteries.update(
      //                             where.eq(
      //                                 "batteryId",
      //                                 availableBatteries[selectedPair]
      //                                     .batteryId),
      //                             modify.set('batteryStatus', "assigned"));
      //                         await batteries.update(
      //                             where.eq("batteryId", allocatedBattery),
      //                             modify.set('batteryStatus', "ideal"));
      //                         await vehicles.update(
      //                             where.eq("batteryId", allocatedBattery),
      //                             modify.set(
      //                                 'batteryId',
      //                                 availableBatteries[selectedPair]
      //                                     .batteryId));
      //                         clear();
      //                         await hubManager.init(context);
      //                         hubManager.batterySwappingState(false);
      //                         //await dp.updateCurrentTab(0);
      //                         widget.tabChange(0);
      //                         messageDialog(context, "Battery Swap Done");
      //                         if (widget.batteryId != null) {
      //                           Navigator.pop(context);
      //                           Navigator.pop(context);
      //                         }
      //                       } else {
      //                         hubManager.batterySwappingState(false);
      //                         messageDialog(context,
      //                             "Error in battery allocation, Insufficient Balance");
      //                       }
      //                     }
      //                   },
      //             child: Container(
      //               decoration: BoxDecoration(
      //                 color: accentColor1,
      //                 borderRadius: const BorderRadius.all(Radius.circular(8)),
      //               ),
      //               height: 40,
      //               width: w * 0.35,
      //               child: Center(
      //                 child: Text(
      //                   "Swap",
      //                   style: TextStyle(
      //                       fontSize: 16,
      //                       color: Colors.white,
      //                       fontWeight: FontWeight.bold),
      //                 ),
      //               ),
      //             ),
      //           ),
      //         ]
      //       ],
      //     ),
      //   ),
      // ],
      /*bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25),
        child:
      ),*/
      body:
          (hubManager.vehiclesLoading ||
                  hubManager.driversLoading ||
                  hubManager.batteriesLoading)
              ? const Center(child: CircularProgressIndicator())
              : hubManager.batterySwapping
                  ? loading(context)
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 18),
                      child: Form(
                        key: _formKey,
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          children: [
                            if (previousAllocationLoading) ...[
                              const Center(child: CircularProgressIndicator()),
                            ] else ...[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12.0),
                                child: Text(
                                  "*Battery Swap Cost-${ap.hub!.batterySwapCost}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18),
                                ),
                              ),
                              SizedBox(
                                height: h * 0.01,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Text('Select vehicle no'),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    // border: Border.all(color: Colors.black),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Color(0xFF7d7d7d)
                                              .withOpacity(0.25),
                                          blurRadius: 10)
                                    ],
                                    color: Colors.white),
                                child: DropdownMenu(
                                  inputDecorationTheme: InputDecorationTheme(
                                      border: InputBorder.none),
                                  width: w * 0.9,
                                  controller: vehicleNoController,
                                  dropdownMenuEntries: [
                                    for (final item in availableVehicles)
                                      // if (item.vehicleStatus == VehicleStatus.parking) ...[
                                      DropdownMenuEntry(
                                          value: item.vehicleId,
                                          label: item.vehicleId.toUpperCase())
                                    //]
                                  ],
                                  hintText: 'Choose here',
                                  // suffixIcon: Icons.arrow_drop_down,
                                  // validator: (String? value) {
                                  //   if (value!.isEmpty) {
                                  //     return "Vehicle No cannot be empty";
                                  //   }
                                  //   return null;
                                  // },
                                  onSelected: (value) {
                                    setState(() {
                                      vehicleNoController =
                                          TextEditingController(text: value);
                                    });
                                    showModalBottomSheet(
                                      elevation: 0,
                                      isScrollControlled: false,
                                      context: context,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(24.0),
                                        ),
                                      ),
                                      builder: (modalBottomSheetContext) {
                                        return StatefulBuilder(builder:
                                            (builderContext, itemState) {
                                          return Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: BottomSheet(
                                                elevation: 00,
                                                animationController:
                                                    bsController,
                                                // showDragHandle: true,
                                                onClosing: () {},
                                                shadowColor: Colors.black,
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                    top: Radius.circular(24.0),
                                                  ),
                                                ),
                                                builder: (sheetContext) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        if (allocatedBattery !=
                                                            null) ...[
                                                          textFieldTitle(
                                                              "Out Battery"),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        5),
                                                            child: Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Chip(
                                                                side: BorderSide(
                                                                    color:
                                                                        accentColor1),
                                                                backgroundColor:
                                                                    accentColor1,
                                                                label: Text(
                                                                  allocatedBattery!
                                                                      .toUpperCase(),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                        SizedBox(
                                                          height: 18,
                                                        ),
                                                        if (vehicleNoController
                                                            .text
                                                            .isNotEmpty) ...[
                                                          textFieldTitle(
                                                              "Available Batteries"),
                                                          Wrap(
                                                            spacing: 10,
                                                            alignment:
                                                                WrapAlignment
                                                                    .start,
                                                            children: [
                                                              for (int i = 0;
                                                                  i <
                                                                      availableBatteries
                                                                          .length;
                                                                  i++) ...[
                                                                InputChip(
                                                                  selectedColor:
                                                                      accentColor1,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  side: BorderSide(
                                                                      color:
                                                                          accentColor1),
                                                                  selected:
                                                                      selectedPair ==
                                                                          i,
                                                                  label: Text(
                                                                      "${availableBatteries[i].batteryId}"
                                                                          .toUpperCase()),
                                                                  onPressed:
                                                                      () {
                                                                    itemState(
                                                                        () {
                                                                      selectedPair =
                                                                          i;
                                                                    });
                                                                    itemState(
                                                                        () {
                                                                      //paymentAmountController.text = "100";
                                                                    });
                                                                  },
                                                                ),
                                                              ],
                                                            ],
                                                          ),
                                                        ],
                                                        SizedBox(
                                                          height: 18,
                                                        ),
                                                        if (vehicleNoController
                                                            .text
                                                            .isNotEmpty) ...[
                                                          textFieldTitle(
                                                              "In Battery"),
                                                          Wrap(
                                                            spacing: 10,
                                                            alignment:
                                                                WrapAlignment
                                                                    .start,
                                                            children: [
                                                              for (int i = 0;
                                                                  i <
                                                                      availableBatteries
                                                                          .length;
                                                                  i++) ...[
                                                                if (selectedPair ==
                                                                    i) ...[
                                                                  Chip(
                                                                    side: BorderSide(
                                                                        color:
                                                                            accentColor1),
                                                                    backgroundColor:
                                                                        accentColor1,
                                                                    label: Text(
                                                                      "${availableBatteries[i].batteryId}"
                                                                          .toUpperCase(),
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ],
                                                            ],
                                                          ),
                                                        ],
                                                        Spacer(),
                                                        Center(
                                                          child: Visibility(
                                                            visible: selectedPair !=
                                                                    -1 &&
                                                                vehicleNoController
                                                                    .text
                                                                    .isNotEmpty,
                                                            child: InkWell(
                                                              onTap:
                                                                  selectedPair ==
                                                                          -1
                                                                      ? null
                                                                      : () async {
                                                                          if (_formKey
                                                                              .currentState!
                                                                              .validate()) {
                                                                            _formKey.currentState!.save();
                                                                            SystemChannels.textInput.invokeMethod('TextInput.hide');
                                                                            Navigator.of(sheetContext).pop();
                                                                            hubManager.batterySwappingState(true);
                                                                            bool success = await wp.updateWalletAmount(
                                                                                context: context,
                                                                                loginType: LoginType.hub,
                                                                                loginId: ap.loginId.split("-").toList().first.trim(),
                                                                                amount: ap.hub!.batterySwapCost,
                                                                                credit: false);

                                                                            if (success) {
                                                                              await mongoDB.maintainMongoDBConnection(context);
                                                                              DbCollection batteries = mongoDB.db.collection('batteries');
                                                                              DbCollection vehicles = mongoDB.db.collection('vehicles');
                                                                              DbCollection wallet = mongoDB.db.collection('wallet');
                                                                              await wallet.insertOne({
                                                                                'userId': ap.loginId,
                                                                                'amount': ap.hub!.batterySwapCost,
                                                                                'description': "Battery Swap",
                                                                                'timestamp': DateTime.now().toString(),
                                                                                'type': 'debit',
                                                                                'metadata': vehicleNoController.text
                                                                              });
                                                                              await batteries.update(where.eq("batteryId", availableBatteries[selectedPair].batteryId), modify.set('batteryStatus', "assigned"));
                                                                              await batteries.update(where.eq("batteryId", allocatedBattery), modify.set('batteryStatus', "ideal"));
                                                                              await vehicles.update(where.eq("batteryId", allocatedBattery), modify.set('batteryId', availableBatteries[selectedPair].batteryId));
                                                                              await vehicles.update(where.eq("batteryId", availableBatteries[selectedPair].batteryId), modify.set('unlocked', false));
                                                                              clear();
                                                                              await hubManager.init(context);
                                                                              hubManager.batterySwappingState(false);
                                                                              //await dp.updateCurrentTab(0);
                                                                              widget.tabChange(0);
                                                                              messageDialog(context, "Battery Swap Done", true);
                                                                              if (widget.batteryId != null) {
                                                                                Navigator.pop(context);
                                                                                Navigator.pop(context);
                                                                              }
                                                                            } else {
                                                                              hubManager.batterySwappingState(false);
                                                                              messageDialog(context, "Error in battery allocation, Insufficient Balance", false);
                                                                            }
                                                                          }
                                                                        },
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color:
                                                                      accentColor1,
                                                                  borderRadius:
                                                                      const BorderRadius
                                                                          .all(
                                                                          Radius.circular(
                                                                              8)),
                                                                ),
                                                                height: 40,
                                                                width: w * 0.35,
                                                                child: Center(
                                                                  child: Text(
                                                                    "Swap",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }),
                                          );
                                        });
                                      },
                                    );
                                    loadAllocatedBatteries();
                                    loadBatteryPairs();
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              ElevatedButton(
                                  style: ButtonStyle(
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.symmetric(vertical: 18)),
                                      side: MaterialStateProperty.all(
                                          BorderSide(
                                              color: accentColor1, width: 1)),
                                      shadowColor: MaterialStateProperty.all(
                                          Colors.transparent),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white),
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              accentColor1)),
                                  onPressed: clear,
                                  child: Text('CLEAR')),
                            ],
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
