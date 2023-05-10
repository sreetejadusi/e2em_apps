import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State;
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/index.dart';
import '../utils/index.dart';
import 'index.dart';
import '../providers/index.dart';
import '../models/index.dart';
import 'package:provider/provider.dart';

class EnterPhoneNumber extends StatefulWidget {
  @override
  _EnterPhoneNumberState createState() => _EnterPhoneNumberState();
}

class _EnterPhoneNumberState extends State<EnterPhoneNumber> {
  final _formKey = GlobalKey<FormState>();
  late String phoneNumber;
  Future<void> getOTP() async {
    await checkMongoDBConnection();
    DbCollection users = mongoDB.db.collection('users');
    try {
      await users
          .find({'phoneNumber': '+91' + phoneNumber})
          .toList()
          .then((user) async {
            if (user.length == 0) {
              alertDialog(
                  context, "Login", 'Phone Number Not Registered', 'Ok');
            } else {
              print(user.first);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => VerifyOTP(
                          phoneNumber: '+91' + phoneNumber,
                          val: (bool value) {
                            if (value) {
                              print(value);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ResetPassword(
                                          phoneNumber:
                                              user.first['phoneNumber'],
                                          email: user.first['email'],
                                          password: user.first['password'],
                                        )),
                              );
                            }
                          },
                        )),
              );
            }
          });
    } catch (e) {
      print(e);
    }
    /**/
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
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/rove.png',
                    alignment: Alignment.centerLeft,
                    height: MediaQuery.of(context).size.width * 0.22,
                    width: MediaQuery.of(context).size.width * 0.22,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FadeAnimation(
                      1,
                      Text(
                        "ROVE",
                        style: GoogleFonts.gugi(
                          textStyle: TextStyle(color: Colors.white, fontSize: 27),
                        ),
                      )),
                  FadeAnimation(
                      1.3,
                      Text(
                        "Let's ride the future",
                        // "A Promise of The Most Fuss-Free And Refreshing Ride Ever With Us",
                        textAlign: TextAlign.justify,
                        style: GoogleFonts.breeSerif(
                          textStyle: TextStyle(
                              color: Colors.white.withOpacity(1), fontSize: 17),
                        ),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: <Widget>[
                      FadeAnimation(
                        0.5,
                        TextFieldOuter(
                          child: TextFormField(
                            onSaved: (value) => phoneNumber = value!,
                            onChanged: (value) {},
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Phone Number field cannot be empty";
                              } else if (value.toString().length != 10) {
                                return "Phone Number should be 10 digit number";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.phone,color: Theme.of(context).accentColor,),
                             /* prefix: Text(
                                '+91',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 16.0),
                              ),*/
                              border: border,
                              labelStyle: labelStyle,
                              errorBorder: errorBorder,
                              enabledBorder: enabledBorder,
                              focusedBorder: focusedBorder,
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              hintText: "Phone Number",
                            ),
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
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                SystemChannels.textInput
                                    .invokeMethod('TextInput.hide');
                                await getOTP();
                              }
                            },
                            padding: EdgeInsets.all(0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                color: Theme.of(context).accentColor,
                                /* gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            Colors.blue,
                                            Colors.greenAccent,
                                          ],
                                        ),*/
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                constraints: BoxConstraints(
                                    minHeight: 75,
                                    maxWidth: MediaQuery.of(context).size.width*0.50),
                                child: Text(
                                  "Continue",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
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
    );
  }
}
