import 'dart:async';
import 'package:e_locks/ui/index.dart';

import '../widgets/index.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State;
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_elves/flutter_blue_elves.dart';
import 'dart:io';
import '../models/saved_device_model.dart';
import '../providers/index.dart';
import '../utils/index.dart';
import '../widgets/components.dart';
import '../widgets/snack_bar_message.dart';

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({Key? key}) : super(key: key);
  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  ///
  final formKey = GlobalKey<FormState>();
  String expanded = "";
  String editName = "";
  TextEditingController edit_name = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController id = TextEditingController();
  TextEditingController password = TextEditingController();

  //bool addDevice = false;

  ///
  load() async {
    BluetoothDevicesProvider bdp = context.read<BluetoothDevicesProvider>();
    BluetoothProvider bp = context.read<BluetoothProvider>();
    Future.delayed(const Duration(milliseconds: 1000), () async {
      if (bp.gpsOn && bp.bluetoothOn && !bdp.scanning) {
        bdp.scan(context);
      }
    });
  }

  @override
  void initState() {
    load();
    super.initState();
  }

  @override
  void dispose() {
    BluetoothDevicesProvider bdp = context.read<BluetoothDevicesProvider>();
    try {
      bdp.connectedDevice?.disConnect();
    } catch (e) {
      print(e);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BluetoothProvider bp = context.watch<BluetoothProvider>();
    BluetoothDevicesProvider bdp = context.watch<BluetoothDevicesProvider>();
    SavedDevicesProvider sdp = context.watch<SavedDevicesProvider>();
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        //bottomNavigationBar:
        floatingActionButton: (bp.gpsOn && bp.bluetoothOn)
            ? FloatingActionButton(
                backgroundColor: bdp.scanning ? Colors.red : Colors.blue,
                onPressed: () {
                  bdp.scan(context);
                },
                tooltip: 'scan',
                child: Icon(
                  bdp.scanning ? Icons.stop : Icons.find_replace,
                  color: Colors.white,
                ),
              )
            : null,
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          children: <Widget>[
            SizedBox(
              height: 8,
            ),
            ListTile(
              title: Text(
                "Devices",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              trailing: FloatingActionButton(
                heroTag: "toggle",
                mini: true,
                backgroundColor: Colors.blue,
                onPressed: () async {
                  bool con = await checkInternetConnectivity();
                  print(con);
                  if (con) {
                    showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return SingleChildScrollView(
                              child: Container(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: addNewDevice(),
                          ));
                        });
                  } else {
                    message_dialog(context, "No Internet Connection");
                  }
                  /*setState(() {
                    addDevice = !addDevice;
                  });*/
                },
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
            /* Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: const Text("Added Devices",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
            ),*/
            for (var i = 0; i < sdp.devices.length; i++) ...[
              tile(sdp.devices[i]),
            ],

            ///
            for (int i = 0; i < bdp.hideConnectedList.length; i++) ...[
              //if (bdp.hideConnectedList[i].uuids.isNotEmpty) ...[
              tileHCD(bdp.hideConnectedList[i]),
              //],
            ],
            for (int i = 0; i < bdp.scanResultList.length; i++) ...[
              //if (bdp.scanResultList[i].uuids.isNotEmpty) ...[
              tileSR(bdp.scanResultList[i]),
              //],
            ],
          ],
        ),
      ),
    );
  }

  Widget tileHCD(HideConnectedDevice hcd) {
    BluetoothDevicesProvider bdp = context.read<BluetoothDevicesProvider>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: ListTile(
        tileColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        trailing:
            //hcd.uuids.isNotEmpty
            // ?
            ActionChip(
          onPressed: () async {
            Device toConnectDevice = hcd.connect(connectTimeout: 10000);
            bdp.changeConnectedDevice(toConnectDevice);
            String ss = hcd.name ?? "-----";
            String s = ss.trim();
            bdp.changeLastDevice(s);
            bdp.changeTabIndex(1);
          },
          label: const Text("Connect"),
        ),
        //: const Text("NOT BLE"),
        subtitle: Text(hcd.id),
        title: Text(hcd.name ?? "Unnamed Device"),
      ),
    );
  }

  Widget tileSR(ScanResult sr) {
    BluetoothDevicesProvider bdp = context.read<BluetoothDevicesProvider>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        tileColor: Theme.of(context).cardColor,
        leading: Chip(
          backgroundColor: Colors.transparent,
          label: Text(sr.rssi.toString()),
        ),
        trailing:
            //sr.uuids.isNotEmpty
            // ?
            ActionChip(
          onPressed: () async {
            Device toConnectDevice = sr.connect(connectTimeout: 10000);
            bdp.changeConnectedDevice(toConnectDevice);
            String ss = sr.name ?? "-----";
            String s = ss.trim();
            bdp.changeLastDevice(s);
            bdp.changeTabIndex(1);
          },
          label: const Text("Connect"),
        ),
        //: const Text("NOT BLE"),
        subtitle: Text(sr.id),
        title: Text(sr.name ?? "Unnamed Device"),
      ),
    );
  }

  Widget addNewDevice() {
    SavedDevicesProvider sdp = context.read<SavedDevicesProvider>();
    double w = MediaQuery.of(context).size.width;
    return Form(
      key: formKey,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF222430),
          //border: Border.all(width: 1, color: Colors.grey),

          borderRadius: BorderRadius.only(
              topRight: Radius.circular(16.0), topLeft: Radius.circular(16.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 15,
              ),
              ListTile(
                title: Text(
                  "Add Device",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                ),
                trailing: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                    //size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: name,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Name cannot be empty";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: linedBorder,
                  enabledBorder: linedBorder,
                  errorBorder: linedErrorBorder,
                  focusedBorder: linedFocusedBorder,
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  labelText: 'Name',
                  labelStyle: linedLabelStyle,
                  // labelStyle: buttonTextStyle,
                ),
              ),
              SizedBox(
                height: 24,
              ),
              TextFormField(
                controller: id,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "ID cannot be empty";
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: linedBorder,
                  enabledBorder: linedBorder,
                  errorBorder: linedErrorBorder,
                  focusedBorder: linedFocusedBorder,
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  labelText: 'ID',
                  labelStyle: linedLabelStyle,
                ),
              ),
              SizedBox(
                height: 24,
              ),
              TextFormField(
                controller: password,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Password cannot be empty";
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: linedBorder,
                  enabledBorder: linedBorder,
                  errorBorder: linedErrorBorder,
                  focusedBorder: linedFocusedBorder,
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  labelText: 'Password',
                  labelStyle: linedLabelStyle,
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      clearAddDevice();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        //color: Color(0xFF0079E9),
                        border: Border.all(width: 1, color: Colors.white),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                      ),
                      height: 40,
                      width: w * 0.35,
                      child: Center(
                        child: Text(
                          "Clear",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        await MongoDBConnection.mongoDB
                            .checkMongoDBConnection();
                        DbCollection dc = mongoDB.db.collection('l_devices');
                        await dc
                            .find({'id': id.text, 'password': password.text})
                            .toList()
                            .then((value) async {
                              if (value.isNotEmpty) {
                                if (sdp.devices
                                    .where((element) => element.id == id.text)
                                    .toList()
                                    .isEmpty) {
                                  sdp.addDevice(
                                      context,
                                      SavedDeviceModel(
                                          id: id.text, name: name.text));
                                  clearAddDevice();
                                  Navigator.pop(context);
                                } else {
                                  message_dialog(
                                      context, "Device Already Added");
                                }
                              } else {
                                message_dialog(context, "Invalid Credentials");
                              }
                            });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF0079E9),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                      ),
                      height: 40,
                      width: w * 0.35,
                      child: Center(
                        child: Text(
                          "Add",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
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

  Widget tile(SavedDeviceModel d) {
    SavedDevicesProvider sdp = context.read<SavedDevicesProvider>();
    BluetoothDevicesProvider bdp = context.read<BluetoothDevicesProvider>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: tileColor,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              ListTile(
                onTap: () {
                  if (expanded == d.id) {
                    setState(() {
                      expanded = " ";
                    });
                  } else {
                    setState(() {
                      expanded = d.id;
                    });
                  }
                },
                tileColor: Colors.transparent,
                contentPadding: EdgeInsets.symmetric(vertical: 3),
                title: Text(
                  d.name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                horizontalTitleGap: 5,
                trailing: IconButton(
                  onPressed: () {
                    setState(() {
                      editName = "";
                      edit_name.clear();
                    });
                    if (expanded == d.id) {
                      setState(() {
                        expanded = " ";
                      });
                    } else {
                      setState(() {
                        expanded = d.id;
                      });
                    }
                  },
                  icon: Icon(
                    expanded == d.id
                        ? Icons.keyboard_arrow_up_sharp
                        : Icons.keyboard_arrow_down_sharp,
                    size: 30,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              if (expanded == d.id) ...[
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 30,
                        child: editName == d.id
                            ? TextFormField(
                                controller: edit_name,
                                //initialValue: initial,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Name cannot be empty";
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {});
                                },
                                autofocus: true,
                                style: TextStyle(fontSize: 17),
                                decoration: InputDecoration(
                                  border: border,
                                  enabledBorder: border,
                                  errorBorder: errorBorder,
                                  focusedBorder: focusedBorder,
                                  labelText: 'Name',
                                  //labelStyle: buttonTextStyle,
                                ),
                              )
                            : Text(
                                d.name,
                                style: TextStyle(fontSize: 17),
                              ),
                      ),
                    ),
                    // Spacer(),
                    IconButton(
                      onPressed: () {
                        if (d.id == editName) {
                          sdp.editDeviceName(context, d.id, edit_name.text);
                          setState(() {
                            editName = "";
                            edit_name.clear();
                          });
                        } else {
                          setState(() {
                            editName = d.id;
                            edit_name.text = d.name;
                          });
                        }
                      },
                      icon: Icon(
                        editName == d.id
                            ? Icons.save_outlined
                            : Icons.edit_outlined,
                        // size: 30,
                        color: editName == d.id ? Colors.green : Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        sdp.removeDevice(context, d.id);
                      },
                      icon: const Icon(
                        Icons.delete_outline,
                        //size: 30,
                        color: Color(0xFFFF5353),
                      ),
                    ),
                  ],
                ),
              ],
              if (expanded == d.id) ...[
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Chip(
                      backgroundColor: scaffoldBackgroundColor,
                      label: Text(d.id),
                    ),
                    const Spacer(),
                    if (bdp.checksr(d.id) != null) ...[
                      InkWell(
                        onTap: () {
                          ScanResult sri = bdp.checksr(d.id)!;
                          Device toConnectDevice =
                              sri.connect(connectTimeout: 10000);
                          bdp.changeConnectedDevice(toConnectDevice);
                          String ss = sri.name ?? "-----";
                          String s = ss.trim();
                          bdp.changeLastDevice(s);
                          bdp.changeTabIndex(1);
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFF0079E9),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          height: 40,
                          width: 132,
                          child: const Center(
                            child: Text(
                              "Connect",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ] else ...[
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        height: 40,
                        width: 132,
                        child: Center(
                          child: Text(
                            "Not Detected",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextButton(
                        onPressed: () {
                          /* showDialog(
                              context: context,
                              builder: (context) {
                                return PasswordReset(id: d.id);
                              });*/
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PasswordReset(id: d.id)),
                          );
                        },
                        child: Text('Reset Password')),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
              ],
              /*if (d.id == editName) ...[
                editDeviceName(d),
                SizedBox(
                  height: 20,
                ),
              ]*/
            ],
          ),
        ),
      ),
    );
  }

  clearAddDevice() {
    setState(() {
      name.clear();
      id.clear();
      password.clear();
    });
  }
}
