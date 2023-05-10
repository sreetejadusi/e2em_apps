/*import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import '../utils/index.dart';
import '../widgets/index.dart';
import '../providers/index.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State;
import 'package:provider/provider.dart';
import '../sidebar/index.dart';
class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String phoneNumber, password;
  bool _secureText = true;
  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  Future<void> signIn() async {
    setState(() {
      isLoading = true;
    });
    DbCollection users = mongoDB.db.collection('users');
    try {
      await users
          .find({'phoneNumber': '+91' + phoneNumber})
          .toList()
          .then((value1) async {
            if (value1.length == 0) {
              setState(() {
                isLoading = false;
              });
              alertDialog(
                  context, "Login", 'Phone Number Not Registered', 'Ok');
            } else {
              await users
                  .find({
                    'phoneNumber': '+91' + phoneNumber,
                    'password': password
                  })
                  .toList()
                  .then((value2) async {
                    if (value2.length == 0) {
                      setState(() {
                        isLoading = false;
                      });
                      alertDialog(context, "Login", 'Invalid Password', 'Ok');
                    } else {
                      print(value2.first);
                      ObjectId _id = value2.first['_id'];
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString("userId", _id.$oid.toString());
                      prefs.setBool("loggedIn", true);
                      setState(() {
                        isLoading = false;
                      });
                      await context.read<UserProvider>().init();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    }
                  });
            }
          });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      alertDialog(
          context, "Login", 'Something went wrong please try again', 'Ok');
      print(e);
    }
  }

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Welcome()),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(''),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Welcome()),
              );
            },
          ),
        //  backgroundColor: Color.fromRGBO(3, 9, 23, 1.0),
          //elevation: 0,
        ),
      //  backgroundColor: Color.fromRGBO(3, 9, 23, 1),
        body: isLoading
            ? Center(child: LoaderCircular())
            : SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: SafeArea(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          FadeAnimation(
                            0.5,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Welcome,",
                                  style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  "Sign in to continue!",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.grey.shade700),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Column(
                            children: <Widget>[
                              FadeAnimation(
                                0.5,
                                TextFormField(
                                  keyboardType: TextInputType.phone,
                                  onSaved: (value) => phoneNumber = value,
                                  onChanged: (value) {},
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Phone Number field cannot be empty";
                                    } else if (value.toString().length != 10) {
                                      return "Phone Number should be 10 digit number";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    prefix: Text(
                                      '+91',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 16.0),
                                    ),
                                    border: border,
                                    labelStyle: labelStyle,
                                    errorBorder: errorBorder,
                                    enabledBorder: enabledBorder,
                                    focusedBorder: focusedBorder,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.auto,
                                    labelText: "Phone Number",
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              FadeAnimation(
                                0.5,
                                TextFormField(
                                  onSaved: (value) => password = value,
                                  onChanged: (value) {},
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Password field cannot be empty";
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.text,
                                  obscureText: _secureText,
                                  decoration: InputDecoration(
                                    labelText: "Password",
                                    suffixIcon: IconButton(
                                      alignment: Alignment.center,
                                      onPressed: showHide,
                                      icon: Icon(
                                          _secureText
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Theme.of(context)
                                              .textTheme
                                              .caption
                                              .color),
                                    ),
                                    border: border,
                                    labelStyle: labelStyle,
                                    errorBorder: errorBorder,
                                    enabledBorder: enabledBorder,
                                    focusedBorder: focusedBorder,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.auto,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              FadeAnimation(
                                0.5,
                                Align(
                                  alignment: Alignment.topRight,
                                  child: TextButton(
                                    child: Text(
                                      "Forgot Password ?",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EnterPhoneNumber()),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              FadeAnimation(
                                1.2,
                                Container(
                                  height: 50,
                                  child: FlatButton(
                                    onPressed: () async {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) =>  SideBarLayout()
                                           // HomeScreen()
                                        ),
                                      );
                                   /*   if (_formKey.currentState.validate()) {
                                        _formKey.currentState.save();
                                        SystemChannels.textInput
                                            .invokeMethod('TextInput.hide');
                                        await signIn();
                                      }*/
                                    },
                                    padding: EdgeInsets.all(0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            Colors.blue,
                                            Colors.greenAccent,
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Container(
                                        alignment: Alignment.center,
                                        constraints: BoxConstraints(
                                            minHeight: 50,
                                            maxWidth: double.infinity),
                                        child: Text(
                                          "Login",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                          FadeAnimation(
                            0.5,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "I'm a new user.",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignUp()),
                                    );
                                  },
                                  child: Text(
                                    "Sign up",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

      ),
    );
  }
}*/
