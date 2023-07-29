import 'package:flutter/material.dart';
import '../utils/index.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String? name,phoneNumber, password,confirmPassword;
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
              SizedBox(height: h*0.05,),
              Text(
                "Sign Up",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: h*0.02,),
              Text(
                "Please enter your details",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: h*0.05,),
              TextFormField(
                keyboardType: TextInputType.name,
                onSaved: (value) => name = value,
                cursorColor: cursorColor,
                onChanged: (value) {},
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Name field cannot be empty";
                  } else if (value.toString().length != 10) {
                    return "Name should be 10 digit number";
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
                    hintText: "Enter Name",
                    labelText: "Name"),
              ),
              SizedBox(height: h*0.03,),
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
              SizedBox(height: h*0.03,),
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
              SizedBox(height: h*0.03,),
              TextFormField(
                keyboardType: TextInputType.text,
                onSaved: (value) => confirmPassword = value,
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
              SizedBox(height: h*0.04,),
              Container(
                  height: 48,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: blueAccentColor,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Center(
                    child: Text(
                      "Sign Up",
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  )),
              SizedBox(height: h*0.02,),
              MaterialButton(onPressed: (){
               Navigator.pop(context);
              },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                    Text(
                      "Login",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: blueAccentColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
