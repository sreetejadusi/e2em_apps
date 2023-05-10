import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State;
import 'package:provider/provider.dart';

import '../../index_files.dart';

class AddDriver extends StatefulWidget {
  const AddDriver(
      {super.key,
      required this.hubId,
      required this.driverModel,
      required this.added});

  final DriverModel? driverModel;
  final String? hubId;
  final Function() added;

  @override
  State<AddDriver> createState() => _AddDriverState();
}

class _AddDriverState extends State<AddDriver> {
  bool l = false;
  final _formKey = GlobalKey<FormState>();
  var driverIdController = TextEditingController();

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    if (widget.driverModel != null) {
      setState(() {
        driverIdController.text = widget.driverModel!.driverId;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AdminManager am = context.watch<AdminManager>();
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    HubManager hubManager = context.watch<HubManager>();
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: accentColor1,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Text(
            widget.driverModel == null ? "Add Driver" : "Edit Driver",
            style: const TextStyle(color: Colors.white),
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
                  setState(() {
                    driverIdController.clear();
                  });
                  setState(() {});
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
                onTap: widget.driverModel == null
                    ? () async {
                        if (_formKey.currentState!.validate()) {
                          SystemChannels.textInput
                              .invokeMethod('TextInput.hide');
                          setState(() {
                            l = true;
                          });
                          await mongoDB.maintainMongoDBConnection(context);
                          DbCollection drivers =
                              mongoDB.db.collection('drivers');
                          List<String> dl = [];
                          await drivers.find().toList().then((res) async {
                            if (res.isNotEmpty) {
                              dl = [for (final item in res) item['driverId']];
                            } else {}
                          });
                          if (dl.contains(driverIdController.text)) {
                            setState(() {
                              l = false;
                            });
                            messageDialog(context, "Driver ID Already Exists");
                          } else {
                            await drivers.insertOne(DriverModel(
                              id: "",
                              hubId: widget.hubId!,
                              vehicleFrequency: [],
                              driverId: driverIdController.text,
                            ).toMap());
                            await am.loadHubs(context);
                            setState(() {
                              l = false;
                            });
                            // widget.added();
                            Navigator.pop(context);
                            Navigator.pop(context);
                            messageDialog(context, "Driver Added");
                          }
                        }
                      }
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          SystemChannels.textInput
                              .invokeMethod('TextInput.hide');
                          setState(() {
                            l = true;
                          });
                          DbCollection drivers =
                              mongoDB.db.collection('drivers');
                          List<String> dl = [];
                          await drivers.find().toList().then((res) async {
                            if (res.isNotEmpty) {
                              dl = [for (final item in res) item['driverId']];
                            } else {}
                          });
                          if (dl.contains(driverIdController.text)) {
                            setState(() {
                              l = false;
                            });
                            messageDialog(context, "Driver ID Already Exists");
                          } else {
                            await drivers.replaceOne(
                                {"driverId": driverIdController.text},
                                DriverModel(
                                  id: "",
                                  hubId: widget.hubId!,
                                  vehicleFrequency: [],
                                  driverId: driverIdController.text,
                                ).toMap());
                            /* DbCollection batteries =
                              mongoDB.db.collection('batteries');
                          List<String> bl = [];
                          await batteries.find().toList().then((res) async {
                            if (res.isNotEmpty) {
                              bl = [for (final item in res) item['batteryId']];
                            } else {}
                          });
                          if (bl.contains(batteryIdController.text)) {
                            setState(() {
                              l = false;
                            });
                            messageDialog(context, "Battery ID Already Exists");
                          } else {
                            await batteries.replaceOne(
                                {"batteryId": batteryIdController.text},
                                BatteryModel(
                                  id: "",
                                  hubId: widget.hubId!,
                                  batteryStatus: "ideal",
                                  batteryId: batteryIdController.text,
                                ).toMap());*/
                            setState(() {
                              l = false;
                            });
                            widget.added();
                            Navigator.pop(context);
                            messageDialog(context, "Driver Updated");
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
                      widget.driverModel == null ? "Add" : "Update",
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
      body: am.hubsLoading
          ? const Center(child: CircularProgressIndicator())
          : l
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
                          height: h * 0.02,
                        ),
                        CustomTextField(
                          labelText: 'Driver Id',
                          controller: driverIdController,
                          items: const [],
                          readOnly: widget.driverModel != null,
                          hintText: 'Enter Driver Id',
                          suffixIcon: Icons.short_text_outlined,
                          type: TextFieldType.normal,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return "Driver Id cannot be empty";
                            }
                            return null;
                          },
                          onChanged: (String value) {
                            setState(() {
                              driverIdController =
                                  TextEditingController(text: value);
                            });
                          },
                        ),
                        SizedBox(
                          height: h * 0.01,
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
