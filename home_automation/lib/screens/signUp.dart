/*import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State;
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/index.dart';
import '../utils/index.dart';
import 'index.dart';
import '../providers/index.dart';
import '../models/index.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String name,
      email,
      phoneNumber,
      city,
      occupation,
      age,
      password,
      confirmPassword;
  String pass;
  bool _secureText1 = true;
  bool _secureText2 = true;
  TextEditingController occupationController = new TextEditingController();
  showHide1() {
    setState(() {
      _secureText1 = !_secureText1;
    });
  }

  showHide2() {
    setState(() {
      _secureText2 = !_secureText2;
    });
  }

  Future<void> signUp() async {
    setState(() {
      isLoading = true;
    });
    DbCollection users = mongoDB.db.collection('users');
    DbCollection wallets = mongoDB.db.collection('wallets');
    try {
      await users
          .find({'phoneNumber': '+91' + phoneNumber})
          .toList()
          .then((value1) async {
            if (value1.length != 0) {
              alertDialog(
                  context, "Sign up", 'Phone Number Already Registered', 'Ok');
            } else {
              await users.find({'email': email}).toList().then((value2) async {
                    if (value2.length != 0) {
                      alertDialog(
                          context, "Sign up", 'Email Already Registered', 'Ok');
                    } else {
                      UserModel user = UserModel();
                      user.name = name;
                      user.email = email;
                      user.phoneNumber = '+91' + phoneNumber;
                      user.city = city;
                      user.occupation = occupation;
                      user.age = age;
                      user.password = password;
                      user.phoneNumberVerified = false;
                      user.emailVerified = false;
                      var addUser = await users.insertOne(user.toMap());
                      if (addUser.isSuccess) {


                      }
                    }
                  });
            }
          });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
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
                                "Create Account,",
                                style: TextStyle(
                                    fontSize: 26, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Text(
                                "Sign up to get started!",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.grey.shade700),
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
                                onSaved: (value) => name = value,
                                onChanged: (value) {},
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Name field cannot be empty";
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                  labelText: "Name",
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
                              height: 20,
                            ),
                            FadeAnimation(
                              0.5,
                              TextFormField(
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
                                keyboardType: TextInputType.phone,
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
                                onSaved: (value) => email = value,
                                onChanged: (value) {},
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Email field cannot be empty";
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: "Email ID",
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
                              height: 20,
                            ),
                            FadeAnimation(
                              0.5,
                              TextFormField(
                                onSaved: (value) => age = value,
                                onChanged: (value) {},
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Age field cannot be empty";
                                  } else if (value.toString().length != 2) {
                                    return "Age should be 2 digit number";
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: "Age",
                                  border: border,
                                  labelStyle: labelStyle,
                                  errorBorder: errorBorder,
                                  enabledBorder: enabledBorder,
                                  focusedBorder: focusedBorder,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.auto,
                                ),
                              ),
                              /* TextFormField(
                                  onSaved: (value) => birthOfYear = value,
                                  onChanged: (value) {},
                                  readOnly: true,
                                  controller: birthOfYearController,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Birth of Year field cannot be empty";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    labelText: "Birth of Year",
                                    border: border,
                                    labelStyle: labelStyle,
                                    errorBorder: errorBorder,
                                    enabledBorder: enabledBorder,
                                    focusedBorder: focusedBorder,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.auto,
                                  ),
                                  onTap: () {
                                    showDropdownDialog(
                                        context: context,
                                        title: 'Select Birth of Year',
                                        items: [
                                          for (var i = 1900;
                                              i < DateTime.now().year;
                                              i++) ...[i.toString()]
                                        ],
                                        onChanged: (String value) {
                                          setState(() {
                                            birthOfYearController.text = value;
                                          });
                                        });
                                  }),*/
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            FadeAnimation(
                              0.5,
                              TextFormField(
                                  onSaved: (value) => occupation = value,
                                  onChanged: (value) {},
                                  readOnly: true,
                                  controller: occupationController,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Occupation field cannot be empty";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    labelText: "Occupation",
                                    border: border,
                                    labelStyle: labelStyle,
                                    errorBorder: errorBorder,
                                    enabledBorder: enabledBorder,
                                    focusedBorder: focusedBorder,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.auto,
                                  ),
                                  onTap: () {
                                    showDropdownDialog(
                                        context: context,
                                        title: 'Select Occupation',
                                        items: ["Student", "Other"],
                                        onChanged: (String value) {
                                          setState(() {
                                            occupationController.text = value;
                                          });
                                        });
                                  }),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            FadeAnimation(
                              0.5,
                              TextFormField(
                                onSaved: (value) => city = value,
                                onChanged: (value) {},
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "City field cannot be empty";
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  labelText: "City",
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
                              height: 20,
                            ),
                            FadeAnimation(
                              0.5,
                              TextFormField(
                                onSaved: (value) => password = value,
                                onChanged: (value) {
                                  setState(() {
                                    pass = value;
                                  });
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Password field cannot be empty";
                                  } else if (value.toString().length < 8) {
                                    return "Password length should be \natleast 8 characters";
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.text,
                                obscureText: _secureText1,
                                decoration: InputDecoration(
                                  labelText: "Password",
                                  suffixIcon: IconButton(
                                    alignment: Alignment.center,
                                    onPressed: showHide1,
                                    icon: Icon(
                                        _secureText1
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
                              height: 20,
                            ),
                            FadeAnimation(
                              0.5,
                              TextFormField(
                                onSaved: (value) => confirmPassword = value,
                                onChanged: (value) {},
                                validator: (value) {
                                  if (value != pass || pass != value) {
                                    return "password and confirm password should be same";
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.text,
                                obscureText: _secureText2,
                                decoration: InputDecoration(
                                  labelText: "Confirm Password",
                                  suffixIcon: IconButton(
                                    alignment: Alignment.center,
                                    onPressed: showHide2,
                                    icon: Icon(
                                        _secureText2
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
                              height: 30,
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
                                      await signUp();
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
                                        "Sign up",
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
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "I'm already a member.",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignIn()),
                                    );
                                  },
                                  child: Text(
                                    "Sign in",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}*/
