import 'package:firebase_auth/firebase_auth.dart';
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

class ResetPassword extends StatefulWidget {
  final String? phoneNumber, email, password;
  ResetPassword({this.phoneNumber, this.email, this.password});
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String? password, confirmPassword;
  String? pass;
  bool _secureText1 = true;
  bool _secureText2 = true;

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

  Future<void> reset() async {
    setState(() {
      isLoading = true;
    });
    await checkMongoDBConnection();
    UserCredential credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: widget.email!.trim(), password: widget.password!.trim());
    await credential.user!.updatePassword(password!);
    DbCollection users = mongoDB.db.collection('users');
    await users.update(where.eq('phoneNumber', widget.phoneNumber),
        modify.set('password', password));
    setState(() {
      isLoading = false;
    });
    Navigator.push(context, MaterialPageRoute(builder: (context) => Welcome()));
    alertDialog(
        context, "Reset Password", 'Password Reset Done Successfully', 'Ok');
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
        backgroundColor: Color.fromRGBO(3, 9, 23, 1.0),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FadeAnimation(
                    0.5,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Reset Password,",
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          "Continue with your new password!",
                          style: TextStyle(
                              fontSize: 20, color: Colors.grey.shade400),
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
                          onSaved: (value) => password = value,
                          onChanged: (value) {
                            setState(() {
                              pass = value;
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
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
                                      .caption!
                                      .color!),
                            ),
                            border: border,
                            labelStyle: labelStyle,
                            errorBorder: errorBorder,
                            enabledBorder: enabledBorder,
                            focusedBorder: focusedBorder,
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
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
                                      .caption!
                                      .color!),
                            ),
                            border: border,
                            labelStyle: labelStyle,
                            errorBorder: errorBorder,
                            enabledBorder: enabledBorder,
                            focusedBorder: focusedBorder,
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      FadeAnimation(
                        1.2,
                        isLoading
                            ? const CircularProgressIndicator()
                            : Container(
                                height: 50,
                                child: FlatButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      SystemChannels.textInput
                                          .invokeMethod('TextInput.hide');
                                      await reset();
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
                                        "Reset",
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
    );
  }
}
