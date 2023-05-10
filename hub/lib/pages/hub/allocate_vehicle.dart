import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State;
import 'package:provider/provider.dart';

import '../../index_files.dart';

class AllocateVehicle extends StatefulWidget {
  final String? vehicleId;
  final Function(int) tabChange;

  const AllocateVehicle(
      {super.key, required this.vehicleId, required this.tabChange});

  @override
  State<AllocateVehicle> createState() => _AllocateVehicleState();
}

class _AllocateVehicleState extends State<AllocateVehicle> {
  final _formKey = GlobalKey<FormState>();
  var batteryIdController = TextEditingController();
  var driverNameController = TextEditingController();
  var vehicleNoController = TextEditingController();

  // var paymentAmountController = TextEditingController();
  var bulkAllocationController = TextEditingController();
  bool bulkAllocation = false;
  int selectedAllocationDate = 0;
  String? allocatedBattery;
  List<List<String>> bulkAllocationList = [];
  List<String> vl = [];

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    load();

    super.initState();
  }

  load() {
    HubManager hubManager = context.read<HubManager>();
    WalletProvider wp = context.read<WalletProvider>();
    final date = DateTime.now();

    if (widget.vehicleId != null) {
      vl = [
        for (final item in hubManager.vehicles)
          if (item.getVS() == VehicleStatus.parking) ...[item.vehicleId]
      ];
      vehicleChanged(widget.vehicleId!);
    } else {
      vl = [
        for (final item in hubManager.vehicles)
          if (item.getVS() == VehicleStatus.parking) ...[item.vehicleId]
      ];
    }
  }

  clear() {
    setState(() {
      driverNameController.clear();
      vehicleNoController.clear();
      // paymentAmountController.clear();
      batteryIdController.clear();
    });
    setState(() {
      bulkAllocationList.clear();
    });
  }

  vehicleChanged(String value) {
    HubManager hubManager = context.read<HubManager>();
    setState(() {
      vehicleNoController = TextEditingController(text: value);
    });
    setState(() {
      allocatedBattery = hubManager.vehicles
          .singleWhere(
              (element) => vehicleNoController.text == element.vehicleId)
          .batteryId;
    });
    setState(() {
      batteryIdController = TextEditingController(text: allocatedBattery);
    });
  }

  driverChanged(String value) {
    HubManager hubManager = context.read<HubManager>();
    setState(() {
      driverNameController =
          TextEditingController(text: value.split("-").toList()[0].trim());
      // paymentAmountController.text = "300";
    });
    setState(() {
      vl = [];
    });
    List<dynamic> al = hubManager.drivers
        .singleWhere((element) => driverNameController.text == element.driverId)
        .vehicleFrequency;
    al = al..sort((a, b) => b[1].compareTo(a[1]));
    for (var v in al) {
      setState(() {
        vl.add(v[0]);
      });
    }
    for (var v in hubManager.vehicles) {
      if (!vl.contains(v.vehicleId)) {
        setState(() {
          vl.add(v.vehicleId);
        });
      }
    }
    setState(() {
      vl.removeWhere((vli) =>
          hubManager.vehicles
              .singleWhere((element) => element.vehicleId == vli)
              .getVS() !=
          VehicleStatus.parking);
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final date = DateTime.now();
    VehiclesProvider vp = context.watch<VehiclesProvider>();
    HubManager hubManager = context.watch<HubManager>();
    WalletProvider wp = context.watch<WalletProvider>();
    DataProvider dp = context.watch<DataProvider>();
    AuthenticationProvider ap = context.watch<AuthenticationProvider>();
    int totalCost = bulkAllocation
        ? ((ap.hub!.allocationCost * bulkAllocationList.length) +
            (ap.hub!.batterySwapCost * bulkAllocationList.length))
        : (ap.hub!.allocationCost + ap.hub!.batterySwapCost);
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
            "Allocate Vehicle",
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
              InkWell(
                onTap: () async {
                  AuthenticationProvider ap =
                      context.read<AuthenticationProvider>();
                  WalletProvider wp = context.read<WalletProvider>();
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                    hubManager.vehicleAllocatingState(true);
                    bool success = await wp.updateWalletAmount(
                        context: context,
                        loginType: LoginType.hub,
                        loginId: ap.loginId,
                        amount: totalCost,
                        credit: false);
                    if (success) {
                      HubManager hubManager = context.read<HubManager>();
                      await mongoDB.maintainMongoDBConnection(context);
                      DbCollection vehicles = mongoDB.db.collection('vehicles');
                      DbCollection drivers = mongoDB.db.collection('drivers');
                      DbCollection batteries =
                          mongoDB.db.collection('batteries');
                      DbCollection wallet = mongoDB.db.collection('wallet');
                      await wallet.insertOne({
                        'userId': ap.loginId,
                        'amount': totalCost,
                        'description': "Vehicle & Battery Allocation",
                        'timestamp': DateTime.now().toString(),
                        'type': 'debit'
                      });
                      if (!bulkAllocation) {
                        await vehicles.update(
                            where.eq("vehicleId", vehicleNoController.text),
                            modify.set('vehicleStatus', "assigned"));
                        await vehicles.update(
                            where.eq("vehicleId", vehicleNoController.text),
                            modify.set('driverId', driverNameController.text));
                        await batteries.update(
                            where.eq("batteryId", batteryIdController.text),
                            modify.set('batteryStatus', "assigned"));
                        await batteries.update(
                            where.eq("batteryId", allocatedBattery),
                            modify.set('batteryStatus', "ideal"));
                        await vehicles.update(
                            where.eq("vehicleId", vehicleNoController.text),
                            modify.set('batteryId', batteryIdController.text));

                        ///Frequency Update
                        await drivers
                            .find({"driverId": driverNameController.text})
                            .toList()
                            .then((res) async {
                              if (res.isNotEmpty) {
                                List<dynamic> al = res[0]['vehicleFrequency'];
                                List<List<dynamic>> all = [];
                                for (var item in al) {
                                  all.add([item[0], item[1]]);
                                }
                                bool exist = false;
                                for (var item in all) {
                                  if (item[0] == vehicleNoController.text) {
                                    int nf = item[1] + 1;
                                    item[1] = nf;
                                    exist = true;
                                    break;
                                  }
                                }
                                if (!exist) {
                                  all.add([vehicleNoController.text, 1]);
                                }
                                print(all);
                                await drivers.update(
                                    where.eq(
                                        "driverId", driverNameController.text),
                                    modify.set('vehicleFrequency', all));
                              }
                            });

                        ///
                        clear();
                        await hubManager.init(context);
                        hubManager.vehicleAllocatingState(false);
                        widget.tabChange(0);
                        messageDialog(context, "Vehicle allocated");
                        if (widget.vehicleId != null) {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }
                      } else {}
                      if (bulkAllocation) {
                        for (int i = 0; i < bulkAllocationList.length; i++) {
                          List<String> l = bulkAllocationList[i];
                          await vehicles.update(where.eq("vehicleId", l[1]),
                              modify.set('vehicleStatus', "assigned"));
                          await vehicles.update(where.eq("vehicleId", l[1]),
                              modify.set('driverId', l[0]));
                          await batteries.update(where.eq("batteryId", l[2]),
                              modify.set('batteryStatus', "assigned"));
                          await vehicles.update(where.eq("vehicleId", l[1]),
                              modify.set('batteryId', l[2]));

                          ///Frequency Update
                          await drivers
                              .find({"driverId": l[0]})
                              .toList()
                              .then((res) async {
                                if (res.isNotEmpty) {
                                  List<dynamic> al =
                                      res[0]['vehicleFrequency'] ?? [];
                                  List<List<dynamic>> all = [];
                                  for (var item in al) {
                                    all.add([item[0], item[1]]);
                                  }
                                  bool exist = false;
                                  for (var item in all) {
                                    if (item[0] == l[1]) {
                                      int nf = item[1] + 1;
                                      item[1] = nf;
                                      exist = true;
                                      break;
                                    }
                                  }
                                  if (!exist) {
                                    all.add([l[1], 1]);
                                  }
                                  print("-----------all-----------");
                                  print(all);
                                  await drivers.update(
                                      where.eq("driverId", l[0]),
                                      modify.set('vehicleFrequency', all));
                                }
                              });

                          ///
                        }
                        clear();
                        await hubManager.init(context);
                        hubManager.vehicleAllocatingState(false);
                        widget.tabChange(0);
                        messageDialog(context, "Vehicle allocated");
                        if (widget.vehicleId != null) {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }
                      } else {}
                    } else {
                      hubManager.vehicleAllocatingState(false);
                      messageDialog(context,
                          "Error in vehicle allocation(Check Wallet Balance)");
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
                      "Allocate",
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
      /*bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25),
        child:
      ),*/
      body: (hubManager.vehiclesLoading ||
              hubManager.driversLoading ||
              hubManager.batteriesLoading)
          ? const Center(child: CircularProgressIndicator())
          : hubManager.vehicleAllocating
              ? loading(context)
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      children: [
                        ListTile(
                          title: Text("Usable Balance"),
                          trailing: Text(
                            wp.walletBalance.toString(),
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                        textFieldTitle("Allocation Type"),
                        Padding(
                          padding: EdgeInsets.all(0.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: InputChip(
                                  label: Text("Single Allocation"),
                                  selected: !bulkAllocation,
                                  onPressed: () {
                                    clear();
                                    setState(() {
                                      bulkAllocation = !bulkAllocation;
                                      bulkAllocationList.clear();
                                      //paymentAmountController.clear();
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: InputChip(
                                  label: Text("Bulk Allocation"),
                                  selected: bulkAllocation,
                                  onPressed: () {
                                    clear();
                                    setState(() {
                                      bulkAllocation = !bulkAllocation;
                                      bulkAllocationList.clear();
                                      // paymentAmountController.clear();
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        /* textFieldTitle("Select Date"),
                        Wrap(
                          spacing: 10,
                          alignment: WrapAlignment.center,
                          children: [
                            for (int i = 0;
                                i < hubManager.allocationDates.length;
                                i++) ...[
                              InputChip(
                                selected: (selectedAllocationDate == i),
                                label: Text(DateFormat('MMM dd yyyy')
                                    .format(hubManager.allocationDates[i])
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
                        Row(
                          children: [
                            Expanded(
                              child: ListTile(
                                title: Text(
                                    "Vehicle Cost-${ap.hub!.allocationCost}"),
                              ),
                            ),
                            Expanded(
                              child: ListTile(
                                title: Text(
                                    "Battery Cost-${ap.hub!.batterySwapCost}"),
                              ),
                            ),
                          ],
                        ),
                        ListTile(
                          title: Text("Total Cost- $totalCost"),
                        ),
                        if (!bulkAllocation) ...[
                          CustomTextField(
                            labelText: 'Driver Id',
                            controller: driverNameController,
                            items: [
                              for (final item in hubManager.drivers)
                                if (!([
                                  for (var v in hubManager.vehicles)
                                    v.driverId ?? " "
                                ].contains(item.driverId)))
                                  ("${item.driverId}")
                            ],
                            type: TextFieldType.dropdown,
                            hintText: 'Select Driver Id',
                            suffixIcon: Icons.arrow_drop_down,
                            onChanged: (String value) {
                              driverChanged(value);
                            },
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return "Driver Id cannot be empty";
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: h * 0.01,
                          ),
                          CustomTextField(
                            labelText: 'Vehicle No',
                            controller: vehicleNoController,
                            type: TextFieldType.dropdown,
                            items: vl,
                            hintText: 'Select Vehicle No',
                            suffixIcon: Icons.arrow_drop_down,
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return "Vehicle No cannot be empty";
                              }
                              return null;
                            },
                            onChanged: (String value) {
                              vehicleChanged(value);
                            },
                          ),
                          if (vehicleNoController.text.isNotEmpty) ...[
                            SizedBox(
                              height: h * 0.01,
                            ),
                            CustomTextField(
                              labelText: 'Battery Id',
                              controller: batteryIdController,
                              items: [
                                    for (var item in hubManager.batteries
                                        .where((element) =>
                                            element.getBS() ==
                                            BatteryStatus.ideal)
                                        .toList())
                                      item.batteryId
                                  ] +
                                  [
                                    if (allocatedBattery != null) ...[
                                      allocatedBattery!
                                    ]
                                  ],
                              hintText: 'Select Battery Id',
                              suffixIcon: Icons.arrow_drop_down,
                              type: TextFieldType.dropdown,
                              validator: (String? value) {
                                /*if (value!.isEmpty) {
                              return "Battery Id cannot be empty";
                            }*/
                                return null;
                              },
                              readOnly: true,
                              onChanged: (String value) {
                                setState(() {
                                  batteryIdController =
                                      TextEditingController(text: value);
                                });
                              },
                            ),
                          ],
                        ],
                        if (bulkAllocation) ...[
                          textFieldTitle("Bulk Allocate"),
                          SizedBox(
                            height: h * 0.01,
                          ),
                          ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BulkAllocation(
                                    bulkAllocation:
                                        (Map<DriverModel, VehicleModel> ba,
                                            List<String> abl) {
                                      setState(() {
                                        bulkAllocationList.clear();
                                      });
                                      if (ba.length == abl.length) {
                                        for (int j = 0; j < ba.length; j++) {
                                          setState(() {
                                            bulkAllocationList.add([
                                              ba.keys.toList()[j].driverId,
                                              ba.values.toList()[j].vehicleId,
                                              abl[j]
                                            ]);
                                          });
                                        }
                                        /*  setState(() {
                                          paymentAmountController.text =
                                              (300 * bulkAllocationList.length)
                                                  .toString();
                                        });*/
                                      }
                                    },
                                  ),
                                ),
                              );
                            },
                            title: Text("Choose Bulk Allocation"),
                            trailing: Icon(Icons.arrow_forward),
                          ),
                          Wrap(
                            spacing: 10,
                            alignment: WrapAlignment.center,
                            children: [
                              for (int i = 0;
                                  i < bulkAllocationList.length;
                                  i++) ...[
                                Chip(
                                  label: Text(bulkAllocationList[i].join("-")),
                                ),
                              ],
                            ],
                          ),
                        ],
                        /* if (driverNameController.text.isNotEmpty ||
                            bulkAllocationList.isNotEmpty) ...[
                          SizedBox(
                            height: h * 0.01,
                          ),
                          CustomTextField(
                            labelText: 'Payment Amount',
                            controller: paymentAmountController,
                            items: const [],
                            hintText: 'Enter Payment Amount',
                            suffixIcon: Icons.payment,
                            type: TextFieldType.normal,
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return "Payment Amount cannot be empty";
                              }
                              return null;
                            },
                            readOnly: true,
                            onChanged: (String value) {
                              setState(() {
                                paymentAmountController =
                                    TextEditingController(text: value);
                              });
                            },
                          ),
                        ],*/
                        /*SizedBox(
                      height: h * 0.01,
                    ),
                    textFieldTitle("Payment Mode"),
                    TextFormField(
                      controller: paymentModeController,
                      onTap: () {
                        showDropdownNormalDialog(
                            context: context,
                            items: paymentModes,
                            onChanged: (String value) {
                              setState(() {
                                paymentModeController =
                                    TextEditingController(text: value);
                              });
                            });
                      },
                      readOnly: true,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Payment Mode cannot be empty";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        suffixIcon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black45,
                        ),
                        border: border,
                        enabledBorder: border,
                        errorBorder: errorBorder,
                        focusedBorder: focusedBorder,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelText: 'Payment Mode',
                        hintText: "Select Payment Mode",
                      ),
                    ),*/
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
