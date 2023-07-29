import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_elves/flutter_blue_elves.dart';
import 'package:hub/widgets/appbar.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State;
import 'package:provider/provider.dart';

import '../../index_files.dart';

class AddHub extends StatefulWidget {
  const AddHub({super.key, required this.hubModel, required this.added});

  final HubModel? hubModel;
  final Function() added;

  @override
  State<AddHub> createState() => _AddHubState();
}

class _AddHubState extends State<AddHub> {
  bool l = false;
  final _formKey = GlobalKey<FormState>();
  var hubIdController = TextEditingController();
  var hubNameController = TextEditingController();
  var hubUsernameController = TextEditingController();
  var passwordController = TextEditingController();
  var addressController = TextEditingController();
  var pinCodeController = TextEditingController();

  var walletController = TextEditingController();

  var minBalanceController = TextEditingController();
  var minRechargeController = TextEditingController();
  var allocationCostController = TextEditingController();
  var batterySwapCostController = TextEditingController();
  var blacklisted = false;
  var dateOperative = 0;

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    if (widget.hubModel != null) {
      setState(() {
        hubIdController.text = widget.hubModel!.hubId;
        hubNameController.text = widget.hubModel!.name;
        hubUsernameController.text = widget.hubModel!.username;
        passwordController.text = widget.hubModel!.password;
        addressController.text = widget.hubModel!.address;
        pinCodeController.text = widget.hubModel!.pinCode;
        walletController.text = widget.hubModel!.wallet.toString();
        minBalanceController.text = widget.hubModel!.minBalance.toString();
        minRechargeController.text = widget.hubModel!.minRecharge.toString();
        allocationCostController.text =
            widget.hubModel!.allocationCost.toString();
        batterySwapCostController.text =
            widget.hubModel!.batterySwapCost.toString();
        blacklisted = widget.hubModel!.blacklisted;
        dateOperative = widget.hubModel!.dateOperative;
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AdminManager am = context.watch<AdminManager>();
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: GradientAppBar(title: 'Add Hub', automaticallyImplyLeading: true),
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    hubNameController.clear();
                    hubUsernameController.clear();
                    passwordController.clear();
                    addressController.clear();

                    pinCodeController.clear();

                    walletController.clear();
                    minBalanceController.clear();
                    minRechargeController.clear();
                    allocationCostController.clear();
                    batterySwapCostController.clear();
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
                onTap: widget.hubModel == null
                    ? () async {
                        if (_formKey.currentState!.validate()) {
                          SystemChannels.textInput
                              .invokeMethod('TextInput.hide');
                          setState(() {
                            l = true;
                          });
                          await mongoDB.maintainMongoDBConnection(context);
                          DbCollection hubs = mongoDB.db.collection('hubs');
                          List<String> hl = [];
                          List<String> ul = [];
                          await hubs.find().toList().then((res) async {
                            if (res.isNotEmpty) {
                              hl = [for (final item in res) item['hubId']];
                              ul = [for (final item in res) item['username']];
                            } else {}
                          });
                          if (hl.contains(hubIdController.text)) {
                            setState(() {
                              l = false;
                            });
                            messageDialog(
                                context, "Hub ID Already Exists", false);
                          } else if (ul.contains(hubUsernameController.text)) {
                            setState(() {
                              l = false;
                            });
                            messageDialog(
                                context, "Hub Username Already Exists", false);
                          } else {
                            await hubs.insertOne(HubModel(
                                    hubId: hubIdController.text,
                                    name: hubNameController.text,
                                    username: hubUsernameController.text,
                                    address: addressController.text,
                                    pinCode: pinCodeController.text,
                                    password: passwordController.text,
                                    wallet: int.parse(
                                        (walletController.text) ?? "0"),
                                    minBalance:
                                        int.parse(minBalanceController.text),
                                    minRecharge:
                                        int.parse(minRechargeController.text),
                                    allocationCost: int.parse(
                                        allocationCostController.text),
                                    batterySwapCost: int.parse(
                                        batterySwapCostController.text),
                                    blacklisted: blacklisted,
                                    dateOperative: DateTime.now().day)
                                .toMap());
                            await am.loadHubs(context);
                            setState(() {
                              l = false;
                            });

                            //widget.added();
                            Navigator.pop(context);
                            messageDialog(context, "Hub Added", true);
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
                          DbCollection hubs = mongoDB.db.collection('hubs');
                          List<String> ul = [];
                          await hubs.find().toList().then((res) async {
                            if (res.isNotEmpty) {
                              ul = [for (final item in res) item['username']];
                            } else {}
                          });
                          if (ul.contains(hubUsernameController.text) &&
                              (widget.hubModel!.username !=
                                  hubUsernameController.text)) {
                            setState(() {
                              l = false;
                            });
                            messageDialog(
                                context, "Hub Username Already Exists", false);
                          } else {
                            await hubs.replaceOne(
                                {"hubId": hubIdController.text},
                                HubModel(
                                        hubId: hubIdController.text,
                                        name: hubNameController.text,
                                        username: hubUsernameController.text,
                                        address: addressController.text,
                                        pinCode: pinCodeController.text,
                                        password: passwordController.text,
                                        wallet: int.parse(
                                            (walletController.text) ?? "0"),
                                        minBalance: int.parse(
                                            minBalanceController.text),
                                        minRecharge: int.parse(
                                            minRechargeController.text),
                                        allocationCost: int.parse(
                                            allocationCostController.text),
                                        batterySwapCost: int.parse(
                                            batterySwapCostController.text),
                                        blacklisted: blacklisted,
                                        dateOperative: dateOperative)
                                    .toMap());
                            await am.loadHubs(context);
                            setState(() {
                              l = false;
                            });
                            widget.added();
                            Navigator.pop(context);
                            messageDialog(context, "Hub Updated", true);
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
                      widget.hubModel == null ? "Add" : "Update",
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
                          labelText: 'Hub Id',
                          controller: hubIdController,
                          items: const [],
                          readOnly: widget.hubModel != null,
                          hintText: 'Enter Hub Id',
                          suffixIcon: Icons.short_text_outlined,
                          type: TextFieldType.normal,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return "Hub Id cannot be empty";
                            }
                            return null;
                          },
                          onChanged: (String value) {
                            setState(() {
                              hubIdController =
                                  TextEditingController(text: value);
                            });
                          },
                        ),
                        SizedBox(
                          height: h * 0.01,
                        ),
                        CustomTextField(
                          labelText: 'Name',
                          controller: hubNameController,
                          items: const [],
                          hintText: 'Enter Name',
                          suffixIcon: Icons.short_text_outlined,
                          type: TextFieldType.normal,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return "Name cannot be empty";
                            }
                            return null;
                          },
                          onChanged: (String value) {
                            setState(() {
                              hubNameController =
                                  TextEditingController(text: value);
                            });
                          },
                        ),
                        SizedBox(
                          height: h * 0.01,
                        ),
                        CustomTextField(
                          labelText: 'Username',
                          controller: hubUsernameController,
                          items: const [],
                          hintText: 'Enter Username',
                          suffixIcon: Icons.short_text_outlined,
                          type: TextFieldType.normal,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return "Username cannot be empty";
                            }
                            return null;
                          },
                          onChanged: (String value) {
                            setState(() {
                              hubUsernameController =
                                  TextEditingController(text: value);
                            });
                          },
                        ),
                        SizedBox(
                          height: h * 0.01,
                        ),
                        CustomTextField(
                          labelText: 'Password',
                          controller: passwordController,
                          items: const [],
                          hintText: 'Enter Password',
                          suffixIcon: Icons.short_text_outlined,
                          type: TextFieldType.normal,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return "Password cannot be empty";
                            }
                            return null;
                          },
                          onChanged: (String value) {
                            setState(() {
                              passwordController =
                                  TextEditingController(text: value);
                            });
                          },
                        ),
                        SizedBox(
                          height: h * 0.01,
                        ),
                        CustomTextField(
                          labelText: 'Wallet Amount',
                          controller: walletController,
                          items: const [],
                          hintText: 'Enter Wallet Amount',
                          suffixIcon: Icons.short_text_outlined,
                          type: TextFieldType.normal,
                          keyBoardType: TextInputType.number,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return "Wallet Amount cannot be empty";
                            }
                            return null;
                          },
                          onChanged: (String value) {
                            setState(() {
                              walletController =
                                  TextEditingController(text: value);
                            });
                          },
                        ),
                        SizedBox(
                          height: h * 0.01,
                        ),
                        CustomTextField(
                          labelText: 'PIN Code',
                          controller: pinCodeController,
                          items: const [],
                          hintText: 'Enter PIN Code',
                          suffixIcon: Icons.short_text_outlined,
                          type: TextFieldType.normal,
                          keyBoardType: TextInputType.number,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return "PIN Code cannot be empty";
                            }
                            return null;
                          },
                          onChanged: (String value) {
                            setState(() {
                              pinCodeController =
                                  TextEditingController(text: value);
                            });
                          },
                        ),
                        SizedBox(
                          height: h * 0.01,
                        ),
                        CustomTextField(
                          labelText: 'Address',
                          controller: addressController,
                          items: const [],
                          hintText: 'Enter Address',
                          suffixIcon: Icons.short_text_outlined,
                          type: TextFieldType.textarea,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return "Address cannot be empty";
                            }
                            return null;
                          },
                          onChanged: (String value) {
                            setState(() {
                              addressController =
                                  TextEditingController(text: value);
                            });
                          },
                        ),
                        SizedBox(
                          height: h * 0.01,
                        ),
                        CustomTextField(
                          labelText: 'Min Balance',
                          controller: minBalanceController,
                          items: const [],
                          hintText: 'Enter Min Balance',
                          suffixIcon: Icons.short_text_outlined,
                          type: TextFieldType.normal,
                          keyBoardType: TextInputType.number,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return "Min Balance cannot be empty";
                            }
                            return null;
                          },
                          onChanged: (String value) {
                            setState(() {
                              minBalanceController =
                                  TextEditingController(text: value);
                            });
                          },
                        ),
                        SizedBox(
                          height: h * 0.01,
                        ),
                        CustomTextField(
                          labelText: 'Min Recharge',
                          controller: minRechargeController,
                          items: const [],
                          hintText: 'Enter Min Recharge',
                          suffixIcon: Icons.short_text_outlined,
                          type: TextFieldType.normal,
                          keyBoardType: TextInputType.number,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return "Min Recharge cannot be empty";
                            }
                            return null;
                          },
                          onChanged: (String value) {
                            setState(() {
                              minRechargeController =
                                  TextEditingController(text: value);
                            });
                          },
                        ),
                        SizedBox(
                          height: h * 0.01,
                        ),
                        CustomTextField(
                          labelText: 'Vehicle Allocation Cost',
                          controller: allocationCostController,
                          items: const [],
                          hintText: 'Enter Vehicle Allocation Cost',
                          suffixIcon: Icons.short_text_outlined,
                          type: TextFieldType.normal,
                          keyBoardType: TextInputType.number,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return "Vehicle Allocation Cost cannot be empty";
                            }
                            return null;
                          },
                          onChanged: (String value) {
                            setState(() {
                              allocationCostController =
                                  TextEditingController(text: value);
                            });
                          },
                        ),
                        SizedBox(
                          height: h * 0.01,
                        ),
                        CustomTextField(
                          labelText: 'Battery Swap Cost',
                          controller: batterySwapCostController,
                          items: const [],
                          hintText: 'Enter Battery Swap Cost',
                          suffixIcon: Icons.short_text_outlined,
                          type: TextFieldType.normal,
                          keyBoardType: TextInputType.number,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return "Battery Swap Cost cannot be empty";
                            }
                            return null;
                          },
                          onChanged: (String value) {
                            setState(() {
                              batterySwapCostController =
                                  TextEditingController(text: value);
                            });
                          },
                        ),
                        SizedBox(
                          height: h * 0.01,
                        ),
                        Row(
                          children: [
                            Checkbox(
                                value: blacklisted,
                                onChanged: (value) {
                                  setState(() {
                                    blacklisted = value!;
                                  });
                                }),
                            Text('Blacklisted')
                          ],
                        )
                      ],
                    ),
                  ),
                ),
    );
  }
}
