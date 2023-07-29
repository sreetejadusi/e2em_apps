import 'package:flutter/material.dart';
import '../utils/index.dart';

class EnterPhoneNumber extends StatefulWidget {
  const EnterPhoneNumber({Key? key}) : super(key: key);

  @override
  State<EnterPhoneNumber> createState() => _EnterPhoneNumberState();
}

class _EnterPhoneNumberState extends State<EnterPhoneNumber> {
  String? phoneNumber;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: h * 0.05,
              ),
              Text(
                "Reset Password",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: h * 0.02,
              ),
              Text(
                "Please enter your phone number",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: h * 0.05,
              ),
              TextFormField(
                keyboardType: TextInputType.phone,
                onSaved: (value) => phoneNumber = value,
                cursorColor: cursorColor,
                onChanged: (value) {},
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Phone Number field cannot be empty";
                  } else if (value.toString().length != 10) {
                    return "Phone Number should be 10 digit number";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  /*  prefixIcon: Icon(
                    Icons.phone,
                    color: Theme.of(context).accentColor,
                  ),*/
                    border: border,
                    labelStyle: labelStyle,
                    errorBorder: errorBorder,
                    enabledBorder: enabledBorder,
                    focusedBorder: focusedBorder,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: "Enter Phone Number",
                    labelText: "Phone Number"),
              ),
              SizedBox(
                height: h * 0.04,
              ),
              Container(
                  height: 48,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: blueAccentColor,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Center(
                    child: Text(
                      "Continue",
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
