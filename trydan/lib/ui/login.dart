import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/index.dart';
import 'index.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  TextEditingController _name = new TextEditingController();
  TextEditingController _phNumber = new TextEditingController();

  String? phoneNumber, password;
  bool isLoading = false;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: scaffoldBackgroundColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: h * 0.15,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Image.asset(
                            "assets/appbar_logo.png",
                            //fit: BoxFit.,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: h * 0.02,
                    ),
                    Text(
                      "Login",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: h * 0.02,
                    ),
                    Text(
                      "Please enter your details",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: h * 0.05,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      onSaved: (value) => password = value,
                      cursorColor: cursorColor,
                      onChanged: (value) {},
                      controller: _name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Name field cannot be empty";
                        } else if (value.toString().length < 4 ||
                            value.toString().length > 15) {
                          return "Name length should be 4 to 15";
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
                    SizedBox(
                      height: h * 0.03,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      onSaved: (value) => phoneNumber = value,
                      cursorColor: cursorColor,
                      onChanged: (value) {},
                      controller: _phNumber,
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
                      height: h * 0.02,
                    ),
                    /*MaterialButton(
                    onPressed: () {},
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: thirdAccentColor),
                    ),
                  ),*/
                    SizedBox(
                      height: h * 0.04,
                    ),
                    InkWell(
                      onTap: () async {
                        SystemChannels.textInput.invokeMethod('TextInput.hide');
                        if (formKey.currentState!.validate()) {
                          ///
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setString('name', _name.text);

                          ///
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Start(),
                            ),
                          );
                        }
                      },
                      child: Container(
                          height: 48,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: thirdAccentColor,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Center(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          )),
                    ),
                    SizedBox(
                      height: h * 0.02,
                    ),
                    /* MaterialButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                        Text(
                          "Sign Up",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: thirdAccentColor),
                        ),
                      ],
                    ),
                  ),*/
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
