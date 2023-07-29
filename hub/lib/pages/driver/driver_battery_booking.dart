import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../index_files.dart';

class DriverBatteryBooking extends StatefulWidget {
  const DriverBatteryBooking({super.key});

  @override
  State<DriverBatteryBooking> createState() => _DriverBatteryBookingState();
}

class _DriverBatteryBookingState extends State<DriverBatteryBooking> {
  var stationNameController = TextEditingController();
  var addressController = TextEditingController();
  var paymentModeController = TextEditingController();
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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: accentColor1,
        title: const Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Text(
            "Battery Booking",
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
      /*bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25),
        child:
      ),*/
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
              labelText: 'Hub ID',
              controller: stationNameController,
              items: driverNames,
              type: TextFieldType.dropdown,
              hintText: 'Select Hub ID',
              suffixIcon: Icons.arrow_drop_down,
              onChanged: (String value) {
                setState(() {
                  stationNameController = TextEditingController(text: value);
                });
              },
              validator: (String? value) {
                if (value!.isEmpty) {
                  return "Hub ID cannot be empty";
                }
                return null;
              },
            ),
            SizedBox(
              height: h * 0.01,
            ),
            CustomTextField(
              labelText: 'Address',
              //controller: d,
              items: [],
              hintText: '1-310, Ambe Residency, Banglore',
              type: TextFieldType.textarea,
              validator: (String? value) {
                if (value!.isEmpty) {
                  return "Address cannot be empty";
                }
                return null;
              },
              onChanged: (String value) {}, suffixIcon: Icons.notes,
            ),
            SizedBox(
              height: h * 0.01,
            ),
            CustomTextField(
              labelText: 'No of Batteries',
              controller: batteryNoController,
              type: TextFieldType.dropdown,
              items: ["1", "2", "3", "4"],
              hintText: 'Select No of Batteries',
              suffixIcon: Icons.arrow_drop_down,
              validator: (String? value) {
                if (value!.isEmpty) {
                  return "No of Batteries cannot be empty";
                }
                return null;
              },
              onChanged: (String value) {
                setState(() {
                  batteryNoController = TextEditingController(text: value);
                });
              },
            ),
            SizedBox(
              height: h * 0.01,
            ),
            CustomTextField(
              labelText: 'Distance',
              //controller: d,
              items: [],
              hintText: '20 KM',
              type: TextFieldType.normal,
              validator: (String? value) {
                if (value!.isEmpty) {
                  return "Distance cannot be empty";
                }
                return null;
              },
              onChanged: (String value) {}, suffixIcon: Icons.linear_scale,
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
