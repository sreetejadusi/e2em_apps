import 'dart:math';

import '../utils/index.dart';
import '../widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State;
import 'package:provider/provider.dart';
import '../providers/index.dart';
import '../models/index.dart';

class Devices extends StatefulWidget {
  const Devices({Key? key}) : super(key: key);

  @override
  _DevicesState createState() => _DevicesState();
}

class _DevicesState extends State<Devices> {
  final formKey = GlobalKey<FormState>();
  String expanded = "";
  String editName = "";
  TextEditingController edit_name = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController id = TextEditingController();
  TextEditingController password = TextEditingController();

  bool addDevice = false;
  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget editDeviceName(DeviceModel d) {
    DevicesProvider dp = context.read<DevicesProvider>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
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
              decoration: InputDecoration(
                border: border,
                enabledBorder: border,
                errorBorder: errorBorder,
                focusedBorder: focusedBorder,
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                labelText: 'Name',
                labelStyle: buttonTextStyle,
              ),
            ),
          ),
          Opacity(
            opacity: edit_name.text.isNotEmpty ? 1 : 0,
            child: IconButton(
              onPressed: edit_name.text.isNotEmpty
                  ? () {
                      dp.editDeviceName(context,d.id, edit_name.text);
                      setState(() {
                        editName = "";
                        edit_name.clear();
                      });
                    }
                  : () {},
              icon: Icon(
                Icons.save,
                size: 30,
                color: Colors.blueGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget tile(DeviceModel d) {
    DevicesProvider dp = context.read<DevicesProvider>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.5, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          color: tileColor,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
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
              contentPadding: EdgeInsets.symmetric(vertical: 3, horizontal: 25),
              title: Text(
                d.name,
                style: GoogleFonts.breeSerif(
                  textStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              horizontalTitleGap: 5,
              trailing: d.id == dp.primaryDevice
                  ? null
                  : IconButton(
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
            if (expanded == d.id || d.id == dp.primaryDevice) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InputChip(
                      backgroundColor:
                          d.id == dp.primaryDevice ? Colors.green : Colors.grey,
                      avatar: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Icon(d.id == dp.primaryDevice
                            ? Icons.check_box
                            : Icons.check_box_outline_blank),
                      ),
                      label: Text(
                        'Primary',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      onSelected: (bool value) {
                        setState(() {
                          dp.updatePrimaryDevice(context,d.id);
                        });
                      },
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (d.id == editName) {
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

                            //dp.editDeviceName(d.id, " ");
                          },
                          icon: Icon(
                            Icons.edit,
                            size: 30,
                            color: editName == d.id
                                ? Colors.green
                                : Colors.blueGrey,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            dp.removeDevice(context,d.id);
                          },
                          icon: const Icon(
                            Icons.delete_outline,
                            size: 30,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
            SizedBox(
              height: 10,
            ),
            if (d.id == editName) ...[
              editDeviceName(d),
              SizedBox(
                height: 20,
              ),
            ]
          ],
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

  @override
  Widget build(BuildContext context) {
    DevicesProvider dep = context.watch<DevicesProvider>();
    return WillPopScope(
      onWillPop: () async {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Devices'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            FloatingActionButton(
              heroTag: "toggle",
              mini: true,
              backgroundColor: Colors.blue,
              onPressed: () {
                setState(() {
                  addDevice = !addDevice;
                });
              },
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 30,
            ),
          ],
        ),
        backgroundColor: bgColor,
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        //floatingActionButton:
        body: ListView(
          children: <Widget>[
            if (addDevice) ...[
              Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.5, vertical: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: tileColor,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 10,
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
                              border: border,
                              enabledBorder: border,
                              errorBorder: errorBorder,
                              focusedBorder: focusedBorder,
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              labelText: 'Name',
                              labelStyle: buttonTextStyle,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: id,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "ID cannot be empty";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: border,
                              enabledBorder: border,
                              errorBorder: errorBorder,
                              focusedBorder: focusedBorder,
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              labelText: 'ID',
                              labelStyle: buttonTextStyle,
                            ),
                          ),
                          SizedBox(
                            height: 15,
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
                              border: border,
                              enabledBorder: border,
                              errorBorder: errorBorder,
                              focusedBorder: focusedBorder,
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              labelText: 'Password',
                              labelStyle: buttonTextStyle,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Transform.scale(
                                scale: 0.9,
                                child: FloatingActionButton.extended(
                                  heroTag: "add",
                                  backgroundColor: Colors.green,
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      await MongoDBConnection.mongoDB.checkMongoDBConnection();
                                      DbCollection dc =
                                          mongoDB.db.collection('mycollection');
                                      await dc
                                          .find({
                                            'topic': id.text,
                                            'password': password.text
                                          })
                                          .toList()
                                          .then((value) async {
                                            if (value.isNotEmpty) {
                                              if(dep.devices.where((element) => element.id ==id.text).toList().isEmpty){
                                                dep.addDevice(context,DeviceModel(
                                                    id: id.text,
                                                    name: name.text));
                                                clearAddDevice();
                                                setState(() {
                                                  addDevice = false;
                                                });
                                              }else{
                                                messageDialog(context,
                                                    "Device Already Added");
                                              }

                                            } else {
                                              messageDialog(context,
                                                  "Invalid Credentials");
                                            }
                                          });
                                    }
                                  },
                                  label: Text(
                                    "Add",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              Transform.scale(
                                scale: 0.9,
                                child: FloatingActionButton.extended(
                                  heroTag: "clear",
                                  backgroundColor: Colors.red,
                                  onPressed: () {
                                    clearAddDevice();
                                  },
                                  label: Text(
                                    "Clear",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
            for (var i = 0; i < dep.devices.length; i++) ...[
              tile(dep.devices[i]),
            ],
          ],
        ),
      ),
    );
  }
}
