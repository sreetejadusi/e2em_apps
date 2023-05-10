import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: accentColor1,
        title: const Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Text(
            "Documents View",
            style: TextStyle(color: Colors.white),
          ),
        ),
        //iconTheme:
        centerTitle: true,
        actions: [],
      ),
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
            if (vehicleNoController.text.isNotEmpty) ...[
              SizedBox(
                height: h * 0.01,
              ),
              textFieldTitle("Documents"),
              tile(title: "Aadhaar Card", icon: Icons.picture_as_pdf),
              tile(title: "RC", icon: Icons.picture_as_pdf),
              tile(title: "Insurance", icon: Icons.picture_as_pdf),
              tile(title: "Fitness", icon: Icons.picture_as_pdf),
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
      child: CustomContainer(
        context: context,
        widget: ListTile(
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
