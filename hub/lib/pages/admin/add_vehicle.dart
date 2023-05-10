import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State;
import 'package:provider/provider.dart';

import '../../index_files.dart';

class AddVehicle extends StatefulWidget {
  const AddVehicle(
      {super.key,
      required this.hubId,
      required this.vehicleModel,
      required this.added});

  final VehicleModel? vehicleModel;
  final String? hubId;
  final Function() added;

  @override
  State<AddVehicle> createState() => _AddVehicleState();
}

class _AddVehicleState extends State<AddVehicle> {
  bool l = false;
  final _formKey = GlobalKey<FormState>();
  var vehicleIdController = TextEditingController();

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    if (widget.vehicleModel != null) {
      setState(() {
        vehicleIdController.text = widget.vehicleModel!.vehicleId;
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
            widget.vehicleModel == null ? "Add Vehicle" : "Edit Vehicle",
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
                    vehicleIdController.clear();
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
                onTap: widget.vehicleModel == null
                    ? () async {
                        if (_formKey.currentState!.validate()) {
                          SystemChannels.textInput
                              .invokeMethod('TextInput.hide');
                          setState(() {
                            l = true;
                          });
                          await mongoDB.maintainMongoDBConnection(context);
                          DbCollection vehicles =
                              mongoDB.db.collection('vehicles');
                          List<String> vl = [];
                          await vehicles.find().toList().then((res) async {
                            if (res.isNotEmpty) {
                              vl = [for (final item in res) item['vehicleId']];
                            } else {}
                          });
                          if (vl.contains(vehicleIdController.text)) {
                            setState(() {
                              l = false;
                            });
                            messageDialog(context, "Vehicle ID Already Exists");
                          } else {
                            await vehicles.insertOne(VehicleModel(
                              id: "",
                              hubId: widget.hubId,
                              vehicleId: vehicleIdController.text,
                              driverId: null,
                              batteryId: null,
                              vehicleStatus: "parking",
                              maintenanceId: null,
                            ).toMap());
                            await am.loadHubs(context);
                            setState(() {
                              l = false;
                            });
                            // widget.added();
                            Navigator.pop(context);
                            Navigator.pop(context);
                            messageDialog(context, "Vehicle Added");
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
                          DbCollection vehicles =
                              mongoDB.db.collection('vehicles');
                          List<String> vl = [];
                          await vehicles.find().toList().then((res) async {
                            if (res.isNotEmpty) {
                              vl = [for (final item in res) item['vehicleId']];
                            } else {}
                          });
                          if (vl.contains(vehicleIdController.text)) {
                            setState(() {
                              l = false;
                            });
                            messageDialog(context, "Vehicle ID Already Exists");
                          } else {
                            await vehicles.replaceOne(
                                {"vehicleId": vehicleIdController.text},
                                VehicleModel(
                                  id: "",
                                  hubId: widget.hubId,
                                  vehicleId: vehicleIdController.text,
                                  driverId: null,
                                  batteryId: null,
                                  vehicleStatus: "parking",
                                  maintenanceId: null,
                                ).toMap());
                            setState(() {
                              l = false;
                            });
                            widget.added();
                            Navigator.pop(context);
                            messageDialog(context, "Vehicle Updated");
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
                      widget.vehicleModel == null ? "Add" : "Update",
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
                          labelText: 'Vehicle Id',
                          controller: vehicleIdController,
                          items: const [],
                          readOnly: widget.vehicleModel != null,
                          hintText: 'Enter Vehicle Id',
                          suffixIcon: Icons.short_text_outlined,
                          type: TextFieldType.normal,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return "Vehicle Id cannot be empty";
                            }
                            return null;
                          },
                          onChanged: (String value) {
                            setState(() {
                              vehicleIdController =
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
