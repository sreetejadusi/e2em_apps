import 'package:flutter/material.dart';
import '../utils/index.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  String? password, confirmPasssword;
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
                "Please enter your details",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: h * 0.05,
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                onSaved: (value) => password = value,
                cursorColor: cursorColor,
                onChanged: (value) {},
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Password field cannot be empty";
                  } else if (value.toString().length != 10) {
                    return "Password should be 10 digit number";
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
                    hintText: "Enter Password",
                    labelText: "Password"),
              ),
              SizedBox(
                height: h * 0.03,
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                onSaved: (value) => password = value,
                cursorColor: cursorColor,
                onChanged: (value) {},
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Confirm Password field cannot be empty";
                  } else if (value.toString().length != 10) {
                    return "Confirm Password should be 10 digit number";
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
                    hintText: "Re Enter Password",
                    labelText: "Confirm Password"),
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
