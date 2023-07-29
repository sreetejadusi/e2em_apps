import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State hide Center;
import 'package:shared_preferences/shared_preferences.dart';
import 'index.dart';
import 'package:provider/provider.dart';
import '../providers/index.dart';
import '../widgets/index.dart';
import '../utils/index.dart';
class PhoneNumberVerification extends StatefulWidget {
  const PhoneNumberVerification({Key? key}) : super(key: key);

  @override
  PhoneNumberVerificationState createState() => PhoneNumberVerificationState();
}

class PhoneNumberVerificationState extends State<PhoneNumberVerification>
    with TickerProviderStateMixin {
  bool isLoading = false;
  late String verificationId;
  bool otpSent = false;
  TextEditingController otp = new TextEditingController(text: '');

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
    UserProvider userProvider = context.read<UserProvider>();
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      print('phoneAuthCredential.smsCode');
      print(phoneAuthCredential.smsCode);
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
                text: 'OTP sent to ' + userProvider.user.phoneNumber!,
                buttonlabel: 'Ok',
                buttonPressed: () async {
                  Navigator.pop(context);
                });
          });
      //alertDialog(
      //  context, "OTP", 'OTP sent to ' + userProvider.user.phoneNumber, 'Ok');
      print('verificationId');
      print(verificationId);
    } as PhoneCodeSent;

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {};
    loadingTrue();
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: userProvider.user.phoneNumber!,
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
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.watch<UserProvider>();
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          iconTheme: Theme.of(context).iconTheme,
          elevation: 4,
          title: Text(
            "Phone Number Verification",
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
                                  userProvider.user.phoneNumber!,
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
                                      await checkMongoDBConnection();
                                      try {
                                        PhoneAuthCredential credential =
                                            PhoneAuthProvider.credential(
                                                verificationId: verificationId,
                                                smsCode:
                                                    otp.text.toString().trim());
                                        await FirebaseAuth.instance
                                            .signInWithCredential(credential)
                                            .then((value) async {
                                          DbCollection users =
                                              mongoDB.db.collection('users');
                                          await users.update(
                                              where.eq(
                                                  'phoneNumber',
                                                  userProvider
                                                      .user.phoneNumber),
                                              modify.set(
                                                  'phoneNumberVerified', true));
                                          await context
                                              .read<UserProvider>()
                                              .init();
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HomeScreen()),
                                          );
                                          alertDialog(
                                              context,
                                              "Phone Number Verification",
                                              "Phone Number Verified",
                                              'Ok');
                                        });

                                        ///////////////////////////********************************************/////////////////////////
                                      } catch (e) {
                                        alertDialog(
                                            context,
                                            "Phone Number Verification",
                                            'Invalid OTP',
                                            'Ok');
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
