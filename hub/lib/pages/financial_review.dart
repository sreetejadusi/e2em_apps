import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../index_files.dart';

class FinancialReview extends StatefulWidget {
  const FinancialReview({super.key});

  @override
  State<FinancialReview> createState() => _FinancialReviewState();
}

class _FinancialReviewState extends State<FinancialReview> {
  var vehicleNoController = TextEditingController();
  var fromDateController = TextEditingController();
  var toDateController = TextEditingController();
  var settlementFormController = TextEditingController();
  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        title: const Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Text(
            "Financial Review",
            style: TextStyle(color: Colors.black),
          ),
        ),
        //iconTheme:
        //centerTitle: true,
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
                    fromDateController.clear();
                    vehicleNoController.clear();
                    toDateController.clear();
                    settlementFormController.clear();
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
                      style: TextStyle(fontSize: 16, color: Colors.black,fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {},
                child: Container(
                  decoration: BoxDecoration(
                    color: accentColor1,
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  height: 40,
                  width: w * 0.35,
                  child: Center(
                    child: Text(
                      "Payment",
                      style: TextStyle(fontSize: 16, color: Colors.white,fontWeight: FontWeight.bold),
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
              items: vehiclesNos,
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
                  vehicleNoController = TextEditingController(text: value);
                });
              },
            ),
            SizedBox(
              height: h * 0.01,
            ),
            CustomTextField(
              labelText: 'From Date',
              controller: fromDateController,
              items: const [],
              hintText: 'Select From Date',
              suffixIcon: Icons.date_range_outlined,
              type: TextFieldType.date,
              validator: (String? value) {
                if (value!.isEmpty) {
                  return "From Date cannot be empty";
                }
                return null;
              },
              onChanged: (String value) {
                setState(() {
                  fromDateController = TextEditingController(text: value);
                });
              },
            ),
            SizedBox(
              height: h * 0.01,
            ),
            CustomTextField(
              labelText: 'To Date',
              controller: toDateController,
              items: const [],
              hintText: 'Select To Date',
              suffixIcon: Icons.date_range_outlined,
              type: TextFieldType.date,
              validator: (String? value) {
                if (value!.isEmpty) {
                  return "To Date cannot be empty";
                }
                return null;
              },
              onChanged: (String value) {
                setState(() {
                  toDateController = TextEditingController(text: value);
                });
              },
            ),
            SizedBox(
              height: h * 0.01,
            ),
            CustomTextField(
              labelText: 'Settlement Form',
              controller: settlementFormController,
              items: const [],
              hintText: 'Enter Settlement Form',
              suffixIcon: Icons.short_text_outlined,
              type: TextFieldType.textarea,
              validator: (String? value) {
                if (value!.isEmpty) {
                  return "Settlement Form cannot be empty";
                }
                return null;
              },
              onChanged: (String value) {
                setState(() {
                  settlementFormController = TextEditingController(text: value);
                });
              },
            ),
            SizedBox(
              height: h * 0.01,
            ),
          ],
        ),
      ),
    );
  }
}
