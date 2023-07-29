import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../index_files.dart';

class DriverPreBook extends StatefulWidget {
  const DriverPreBook({super.key});

  @override
  State<DriverPreBook> createState() => _DriverPreBookState();
}

class _DriverPreBookState extends State<DriverPreBook> {
  var stationNameController = TextEditingController();
  var addressController = TextEditingController();
  var paymentModeController = TextEditingController();
  var timeController = TextEditingController();
  var batteryNoController = TextEditingController();

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final date = DateTime.now();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: accentColor1,
        title: const Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Text(
            "Pre Book",
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
                    stationNameController.clear();
                    addressController.clear();
                    batteryNoController.clear();
                    paymentModeController.clear();
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
                      "Book",
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
        child: ListView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          children: [
            textFieldTitle("Select Date"),
            Wrap(
              spacing: 10,
              alignment: WrapAlignment.center,
              children: [
                for (int i = 0; i < 7; i++) ...[
                  ActionChip(
                    label: Text(DateFormat('MMM dd yyyy')
                        .format(date.add(Duration(days: i)))
                        .toString()),
                    onPressed: () {},
                  ),
                ],
              ],
            ),
            SizedBox(
              height: h * 0.01,
            ),
            CustomTextField(
              labelText: 'Time',
              controller: timeController,
              items: const [],
              hintText: 'Select Time',
              suffixIcon: Icons.access_time,
              type: TextFieldType.time,
              validator: (String? value) {
                if (value!.isEmpty) {
                  return "Time cannot be empty";
                }
                return null;
              },
              onChanged: (String value) {
                setState(() {
                  timeController = TextEditingController(text: value);
                });
              },
            ),
            SizedBox(
              height: h * 0.01,
            ),
            CustomTextField(
              labelText: 'Amount',
              //controller: d,
              items: [],
              hintText: '200',
              type: TextFieldType.normal,
              validator: (String? value) {
                if (value!.isEmpty) {
                  return "Amount cannot be empty";
                }
                return null;
              },
              onChanged: (String value) {}, suffixIcon: Icons.payment,
            ),
            SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
    );
  }
}
