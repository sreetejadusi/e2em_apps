import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../index_files.dart';

class DriverAssistance extends StatefulWidget {
  const DriverAssistance({super.key});

  @override
  State<DriverAssistance> createState() => _DriverAssistanceState();
}

class _DriverAssistanceState extends State<DriverAssistance> {
  var descriptionController = TextEditingController();
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
        backgroundColor: accentColor1,
        title: const Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Text(
            "Assistance",
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
                      "Assist",
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
                  descriptionController = TextEditingController(text: value);
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
