import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State;
import 'package:provider/provider.dart';

import '../../index_files.dart';

class Maintenance extends StatefulWidget {
  final String? vehicleId;
  final String hubId;

  const Maintenance({super.key, required this.vehicleId,required this.hubId});

  @override
  State<Maintenance> createState() => _MaintenanceState();
}

class _MaintenanceState extends State<Maintenance> {
  final _formKey = GlobalKey<FormState>();
  var vehicleNoController = TextEditingController();
  var issueController = TextEditingController();
  var descriptionController = TextEditingController();

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    setState(() {
      if (widget.vehicleId != null) {
        vehicleNoController.text = widget.vehicleId!;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    VehiclesProvider vp = context.watch<VehiclesProvider>();
    HubManager hubManager = context.watch<HubManager>();
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: accentColor1,
        title: const Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Text(
            "Maintenance",
            style: TextStyle(color: Colors.white),
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
                    vehicleNoController.clear();
                    issueController.clear();
                    descriptionController.clear();
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
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                    HubManager hubManager = context.read<HubManager>();
                    hubManager.vehicleAddingMaintenanceState(true);
                    await mongoDB.maintainMongoDBConnection(context);
                    DbCollection maintenance =
                        mongoDB.db.collection('maintenance');
                    DbCollection vehicles = mongoDB.db.collection('vehicles');
                    List<String> ml = [];
                    String? newMaintenanceId;
                    await maintenance.find().toList().then((res) async {
                      if (res.isNotEmpty) {
                        ml = [for (final item in res) item['maintenanceId']];
                        ml.sort();
                        int newMID = int.parse(ml.last.replaceAll("M", "")) + 1;
                        newMaintenanceId = "M$newMID";
                      } else {
                        newMaintenanceId = "M101";
                      }
                    });
                    if (newMaintenanceId != null) {
                      await maintenance.insertOne(MaintenanceModel(
                              maintenanceId: newMaintenanceId!,
                              hubId: widget.hubId,
                              vehicleId: widget.vehicleId!,
                              issue: issueController.text,
                              description: descriptionController.text,
                              status: "pending",
                              datetime: DateTime.now().toString())
                          .toMap());
                      await vehicles.update(
                          where.eq("vehicleId", widget.vehicleId!),
                          modify.set('vehicleStatus', "maintenance"));
                      await vehicles.update(
                          where.eq("vehicleId", widget.vehicleId!),
                          modify.set('driverId', null));
                      await vehicles
                          .update(where.eq("vehicleId", widget.vehicleId!),
                              modify.set("maintenanceId", newMaintenanceId))
                          .then((value) {
                        print("Vehicle Moved to maintenance");
                      });
                      //clear();
                      await hubManager.init(context);
                      hubManager.vehicleAddingMaintenanceState(false);
                      messageDialog(context, "Vehicle Moved to maintenance",true);
                      if (widget.vehicleId != null) {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }
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
                      "Add",
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
          : hubManager.vehicleAddingMaintenance
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
                          labelText: 'Vehicle No',
                          controller: vehicleNoController,
                          items: [
                            for (final item in hubManager.vehicles)
                              if (item.getVS() == VehicleStatus.parking ||
                                  item.getVS() == VehicleStatus.assigned) ...[
                                item.vehicleId
                              ]
                          ],
                          hintText: 'Select Vehicle No',
                          suffixIcon: Icons.arrow_drop_down,
                          type: TextFieldType.dropdown,
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
                          },
                        ),
                        SizedBox(
                          height: h * 0.01,
                        ),
                        CustomTextField(
                          labelText: 'Issue',
                          controller: issueController,
                          items: const ["Not Starting", "Low Performance"],
                          hintText: 'Select Issue',
                          suffixIcon: Icons.arrow_drop_down,
                          type: TextFieldType.dropdown,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return "Issue cannot be empty";
                            }
                            return null;
                          },
                          onChanged: (String value) {
                            setState(() {
                              issueController =
                                  TextEditingController(text: value);
                            });
                          },
                        ),
                        SizedBox(
                          height: h * 0.01,
                        ),
                        CustomTextField(
                          labelText: 'Description',
                          controller: descriptionController,
                          items: const [],
                          hintText: 'Enter Description',
                          suffixIcon: Icons.short_text_outlined,
                          type: TextFieldType.textarea,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return "Description cannot be empty";
                            }
                            return null;
                          },
                          onChanged: (String value) {
                            setState(() {
                              descriptionController =
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
