import 'package:dio/dio.dart';
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

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String name, username, password;
  bool _secureText = true;
  List<dynamic> val;
  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  Future<void> login() async {
    setState(() {
      isLoading = true;
    });
    await checkMongoDBConnection();
    setState(() {
      val = [];
    });
    DbCollection rootUsers = mongoDB.db.collection('rootUsers');
    DbCollection users = mongoDB.db.collection('normalUsers');
    try {
      await rootUsers
          .find({'name': name, 'username': username, 'password': password})
          .toList()
          .then((value1) async {
            if (value1.length > 0) {
              setState(() {
                val.add(value1.first);
              });
            }
          });
      await users
          .find({'name': name, 'username': username, 'password': password})
          .toList()
          .then((value2) async {
            if (value2.length > 0) {
              setState(() {
                val.add(value2.first);
              });
            }
          });
      if (val.length > 0) {
        print(val.first);
        ObjectId _id = val.first['_id'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool("loggedIn", true);
        prefs.setString("userId", _id.$oid.toString() ?? '');
        prefs.setString("name", val.first['name'] ?? '');
        prefs.setString("username", val.first['username'] ?? '');
        prefs.setString("type", val.first['type'] ?? '');
        prefs.setString("homeId", val.first['homeId'] ?? '');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SideBarLayout()),
        );
      } else {
        setState(() {
          isLoading = false;
        });
        alertDialog(context, "Login", 'Invalid Credentials', 'Ok');
      }
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
                                  "Login to continue!",
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
                                  keyboardType: TextInputType.text,
                                  onSaved: (value) => name = value,
                                  onChanged: (value) {},
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Name field cannot be empty";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    border: border,
                                    labelStyle: labelStyle,
                                    errorBorder: errorBorder,
                                    enabledBorder: enabledBorder,
                                    focusedBorder: focusedBorder,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.auto,
                                    labelText: "Name",
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              FadeAnimation(
                                0.5,
                                TextFormField(
                                  keyboardType: TextInputType.text,
                                  onSaved: (value) => username = value,
                                  onChanged: (value) {},
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Username field cannot be empty";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    border: border,
                                    labelStyle: labelStyle,
                                    errorBorder: errorBorder,
                                    enabledBorder: enabledBorder,
                                    focusedBorder: focusedBorder,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.auto,
                                    labelText: "Username",
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
                                height: 40,
                              ),
                              FadeAnimation(
                                1.2,
                                Container(
                                  height: 50,
                                  child: FlatButton(
                                    onPressed: () async {
                                      if (_formKey.currentState.validate()) {
                                        _formKey.currentState.save();
                                        SystemChannels.textInput
                                            .invokeMethod('TextInput.hide');
                                        await login();
                                      }
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
