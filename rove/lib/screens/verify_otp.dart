import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:provider/provider.dart';
import '../providers/index.dart';
import '../widgets/index.dart';

class VerifyOTP extends StatefulWidget {
  final String? phoneNumber;
  final Function(bool)? val;
  VerifyOTP({this.phoneNumber, this.val});
  @override
  VerifyOTPState createState() => VerifyOTPState();
}

class VerifyOTPState extends State<VerifyOTP> with TickerProviderStateMixin {
  bool isLoading = false;
  late String verificationId;
  bool otpSent = false;
  TextEditingController otp = new TextEditingController(text: '');
  String OTP = '';
  void loadingTrue() {
    setState(() {
      isLoading = true;
    });
  }

  void loadingFalse() {
    setState(() {
      isLoading = false;
    });
  }

  Future<void> verifyPhoneNumber(BuildContext context) async {
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      print('phoneAuthCredential.smsCode');
      print(phoneAuthCredential.smsCode);
      setState(() {
        OTP = phoneAuthCredential.smsCode.toString();
      });
    };

    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      print(authException);
    };

    PhoneCodeSent codeSent =
        (String verificationId1, [int? forceResendingToken]) async {
      setState(() {
        verificationId = verificationId1;
        otpSent = true;
      });
      loadingFalse();
      showDialog(
          context: context,
          builder: (context) {
            return CustomDialog(
                icon: Icons.confirmation_number_outlined,
                text: 'OTP sent to ' + widget.phoneNumber!,
                buttonlabel: 'Ok',
                buttonPressed: () async {
                  Navigator.pop(context);
                });
          });
      //alertDialog(context, "OTP", 'OTP sent to ' + widget.phoneNumber, 'Ok');
      print('verificationId');
      print(verificationId);
    } as PhoneCodeSent;

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {};
    loadingTrue();
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: widget.phoneNumber!,
          timeout: const Duration(seconds: 30),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    verifyPhoneNumber(context);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          iconTheme: Theme.of(context).iconTheme,
          elevation: 4,
          title: Text(
            "OTP Verification",
            style: TextStyle(
                color: Theme.of(context).textTheme.caption!.color!,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Container(
                child: Column(
                  children: <Widget>[
                    Flexible(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  "Verify your Phone Number",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0, top: 4.0, right: 16.0),
                                child: Text(
                                  "Please type the OTP sent to your phone number",
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.normal),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 30.0, top: 2.0, right: 30.0),
                                child: Text(
                                  widget.phoneNumber!,
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            onTap: () async {
                              if (!otpSent) {
                                verifyPhoneNumber(context);
                                setState(() {});
                              }
                            },
                            child: Container(
                              height: 40.0,
                              width: 250.0,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Theme.of(context)
                                        .textTheme
                                        .caption!
                                        .color!,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Center(
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(Icons.send, size: 25),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      otpSent ? "Re-send OTP" : 'Send OTP',
                                      style: TextStyle(fontSize: 19.0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Click here to Re-send OTP to Phone Number",
                            style: TextStyle(fontSize: 15.0),
                          ),
                        ],
                      ),
                      flex: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Center(
                        child: TextFormField(
                          autofocus: true,
                          enabled: false,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.caption!.color!,
                          ),
                          controller: otp,
                          cursorColor:
                              Theme.of(context).textTheme.caption!.color!,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(), hintText: "OTP"),
                          maxLines: 1,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Container(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 5.0,
                                  top: 10.0,
                                  right: 5.0,
                                  bottom: 0.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  MaterialButton(
                                    onPressed: () {
                                      inputTextToField("1");
                                    },
                                    child: Text("1",
                                        style: TextStyle(
                                            fontSize: 37.0,
                                            fontWeight: FontWeight.w400),
                                        textAlign: TextAlign.center),
                                  ),
                                  MaterialButton(
                                    onPressed: () {
                                      inputTextToField("2");
                                    },
                                    child: Text("2",
                                        style: TextStyle(
                                            fontSize: 37.0,
                                            fontWeight: FontWeight.w400),
                                        textAlign: TextAlign.center),
                                  ),
                                  MaterialButton(
                                    onPressed: () {
                                      inputTextToField("3");
                                    },
                                    child: Text("3",
                                        style: TextStyle(
                                            fontSize: 37.0,
                                            fontWeight: FontWeight.w400),
                                        textAlign: TextAlign.center),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          new Container(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 5.0, top: 7.0, right: 5.0, bottom: 0.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  MaterialButton(
                                    onPressed: () {
                                      inputTextToField("4");
                                    },
                                    child: Text("4",
                                        style: TextStyle(
                                            fontSize: 37.0,
                                            fontWeight: FontWeight.w400),
                                        textAlign: TextAlign.center),
                                  ),
                                  MaterialButton(
                                    onPressed: () {
                                      inputTextToField("5");
                                    },
                                    child: Text("5",
                                        style: TextStyle(
                                            fontSize: 37.0,
                                            fontWeight: FontWeight.w400),
                                        textAlign: TextAlign.center),
                                  ),
                                  MaterialButton(
                                    onPressed: () {
                                      inputTextToField("6");
                                    },
                                    child: Text("6",
                                        style: TextStyle(
                                            fontSize: 37.0,
                                            fontWeight: FontWeight.w400),
                                        textAlign: TextAlign.center),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          new Container(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 5.0, top: 7.0, right: 5.0, bottom: 0.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  MaterialButton(
                                    onPressed: () {
                                      inputTextToField("7");
                                    },
                                    child: Text("7",
                                        style: TextStyle(
                                            fontSize: 37.0,
                                            fontWeight: FontWeight.w400),
                                        textAlign: TextAlign.center),
                                  ),
                                  MaterialButton(
                                    onPressed: () {
                                      inputTextToField("8");
                                    },
                                    child: Text("8",
                                        style: TextStyle(
                                            fontSize: 37.0,
                                            fontWeight: FontWeight.w400),
                                        textAlign: TextAlign.center),
                                  ),
                                  MaterialButton(
                                    onPressed: () {
                                      inputTextToField("9");
                                    },
                                    child: Text("9",
                                        style: TextStyle(
                                            fontSize: 37.0,
                                            fontWeight: FontWeight.w400),
                                        textAlign: TextAlign.center),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          new Container(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 5.0, top: 7.0, right: 5.0, bottom: 0.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  MaterialButton(
                                    onPressed: () {
                                      deleteText();
                                    },
                                    child: Icon(
                                      Icons.arrow_back,
                                      size: 35,
                                    ),
                                  ),
                                  MaterialButton(
                                    onPressed: () {
                                      inputTextToField("0");
                                    },
                                    child: Text("0",
                                        style: TextStyle(
                                            fontSize: 37.0,
                                            fontWeight: FontWeight.w400),
                                        textAlign: TextAlign.center),
                                  ),
                                  MaterialButton(
                                    onPressed: () async {
                                      PhoneAuthCredential credential =
                                          PhoneAuthProvider.credential(
                                              verificationId: verificationId,
                                              smsCode:
                                                  otp.text.toString().trim());
                                      try {
                                        await FirebaseAuth.instance
                                            .signInWithCredential(credential);
                                        widget.val!(true);
                                      } catch (e) {
                                        alertDialog(context, "OTP Verification",
                                            'Invalid OTP', 'Ok');
                                        print(e);
                                      }
                                    },
                                    child: Icon(
                                      Icons.check_circle_outline,
                                      size: 35,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      flex: 90,
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  void inputTextToField(String str) {
    if (otp.text.length != 6) {
      setState(() {
        otp = new TextEditingController(text: otp.text + str);
      });
    }
  }

  void deleteText() {
    if (otp.text.length != 0) {
      setState(() {
        otp = new TextEditingController(
            text: otp.text.substring(0, otp.text.length - 1));
      });
    }
  }
}
