import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hub/widgets/appbar.dart';

import '../index_files.dart';

class DocumentsView extends StatefulWidget {
  const DocumentsView({super.key});

  @override
  State<DocumentsView> createState() => _DocumentsViewState();
}

class _DocumentsViewState extends State<DocumentsView> {
  var vehicleNoController = TextEditingController();
  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    // return Scaffold(
    //   backgroundColor: backgroundColor,
    //   appBar: AppBar(
    //     elevation: 0,
    //     backgroundColor: accentColor1,
    //     title: const Padding(
    //       padding: EdgeInsets.symmetric(vertical: 15),
    //       child: Text(
    //         "Documents View",
    //         style: TextStyle(color: Colors.white),
    //       ),
    //     ),
    //     //iconTheme:
    //     centerTitle: true,
    //     actions: [],
    //   ),
    //   body:
    // );
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          children: [
            SizedBox(
              height: h * 0.02,
            ),
            textFieldTitle('Vehicle No'),
            Container(
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  // border: Border.all(color: Colors.black),
                  boxShadow: [
                    BoxShadow(
                        color: Color(0xFF7d7d7d).withOpacity(0.25),
                        blurRadius: 10)
                  ],
                  color: Colors.white),
              child: DropdownMenu(
                inputDecorationTheme:
                    InputDecorationTheme(border: InputBorder.none),
                width: w * 0.9,
                controller: vehicleNoController,
                hintText: 'Select Vehicle No',
                onSelected: (value) {
                  setState(() {
                    vehicleNoController =
                        TextEditingController(text: value.toString());
                  });
                },
                dropdownMenuEntries: vehiclesNos
                    .map((e) => DropdownMenuEntry(value: e, label: e))
                    .toList(),
              ),
            ),
            // CustomTextField(
            //   labelText: 'Vehicle No',
            //   controller: vehicleNoController,
            //   items: vehiclesNos,
            //   hintText: 'Select Vehicle No',
            //   suffixIcon: Icons.arrow_drop_down,
            //   type: TextFieldType.dropdown,
            //   validator: (String? value) {
            //     if (value!.isEmpty) {
            //       return "Vehicle No cannot be empty";
            //     }
            //     return null;
            //   },
            //   onChanged: (String value) {
            //     setState(() {
            //       vehicleNoController = TextEditingController(text: value);
            //     });
            //   },
            // ),
            SizedBox(
              height: h * 0.01,
            ),
            if (vehicleNoController.text.isNotEmpty) ...[
              SizedBox(
                height: h * 0.01,
              ),
              textFieldTitle("Documents"),
              tile(title: "Aadhaar Card", icon: FontAwesomeIcons.file),
              tile(title: "RC", icon: FontAwesomeIcons.file),
              tile(title: "Insurance", icon: FontAwesomeIcons.file),
              tile(title: "Fitness", icon: FontAwesomeIcons.file),
            ],
          ],
        ),
      ),
    );
  }

  Widget tile(
      {required String title,
      //required Color iconColor,
      required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            // border: Border.all(color: Colors.black),
            boxShadow: [
              BoxShadow(
                  color: Color(0xFF7d7d7d).withOpacity(0.25), blurRadius: 7)
            ],
            color: Colors.white),
        child: ListTile(
          tileColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(largeRadius),
          ),
          leading: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(smallRadius),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Icon(icon, color: Colors.black),
              )),
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 15,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
