import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State;
import 'package:provider/provider.dart';

import '../../index_files.dart';

class WalletAddMoney extends StatefulWidget {
  const WalletAddMoney({super.key});

  @override
  State<WalletAddMoney> createState() => _WalletAddMoneyState();
}

class _WalletAddMoneyState extends State<WalletAddMoney> {
  final _formKey = GlobalKey<FormState>();
  var senderNameController = TextEditingController();
  var transactionIdController = TextEditingController();
  var amountController = TextEditingController();
  List<String> paymentGateways = [
    "PhonePe",
    "Google pay",
    "Patym",
    "UPI",
    "IMPS",
    "NEFT"
  ];
  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    AuthenticationProvider ap = context.watch<AuthenticationProvider>();
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: accentColor1,
        title: const Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Text(
            "Add Money",
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
                    senderNameController.clear();
                    amountController.clear();
                    transactionIdController.clear();
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
                  AuthenticationProvider ap =
                      context.read<AuthenticationProvider>();
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                    HubManager hubManager = context.read<HubManager>();
                    await mongoDB.maintainMongoDBConnection(context);
                    DbCollection twallet = mongoDB.db.collection('twallet');
                    await twallet.insertOne(TWalletModel(
                      userId: ap.loginId,
                      amount: int.parse(amountController.text),
                      utr: transactionIdController.text,
                      status: 'pending',
                      timestamp: DateTime.now().toString(),
                    ).toMap());
                    Navigator.pop(context);
                    Navigator.pop(context);
                    messageDialog(context, "Wallet money add requested", true);
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
      body: Padding(
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
                labelText: 'Payment Gateway',
                controller: senderNameController,
                items: paymentGateways,
                hintText: 'Select Payment Gateway',
                type: TextFieldType.dropdown,
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return "Payment Gateway cannot be empty";
                  }
                  return null;
                },
                onChanged: (String value) {
                  setState(() {
                    senderNameController = TextEditingController(text: value);
                  });
                },
                suffixIcon: Icons.arrow_drop_down,
              ),
              SizedBox(
                height: h * 0.01,
              ),
              CustomTextField(
                labelText: 'Transaction Id/UTR No',
                controller: transactionIdController,
                items: [],
                hintText: 'Enter Transaction Id/UTR No',
                suffixIcon: Icons.text_snippet,
                type: TextFieldType.normal,
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return "Transaction Id/UTR No cannot be empty";
                  }
                  return null;
                },
                onChanged: (String value) {
                  setState(() {
                    transactionIdController =
                        TextEditingController(text: value);
                  });
                },
              ),
              SizedBox(
                height: h * 0.01,
              ),
              CustomTextField(
                labelText: 'Amount',
                controller: amountController,
                items: const [],
                hintText: 'Enter Amount',
                suffixIcon: Icons.payment,
                keyBoardType: TextInputType.number,
                type: TextFieldType.normal,
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return "Amount cannot be empty";
                  } else if (int.parse(value) < ap.hub!.minRecharge) {
                    return "Minimum recharge is ${ap.hub!.minRecharge}";
                  }
                  return null;
                },
                onChanged: (String value) {
                  setState(() {
                    amountController = TextEditingController(text: value);
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
