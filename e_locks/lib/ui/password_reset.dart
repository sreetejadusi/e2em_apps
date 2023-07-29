import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:math';
import 'package:e_locks/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State hide Center;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../providers/index.dart';
import '../utils/colors.dart';
import '../widgets/index.dart';
import 'package:http/http.dart' as http;

class PasswordReset extends StatefulWidget {
  final String id;

  const PasswordReset({Key? key, required this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PasswordResetState();
  }
}

class _PasswordResetState extends State<PasswordReset> {
  TextEditingController newPassword = TextEditingController();
  TextEditingController otpEnter = TextEditingController();
  bool isLoading = false;
  bool otpSent = false;
  bool otpVerified = false;
  bool resendEnable = false;
  String? otp;
  String? email;
  sendOTP() async {
    int min = 100000; //min and max values act as your 6 digit range
    int max = 999999;
    var randomizer = Random();
    var rNum = min + randomizer.nextInt(max - min);
    print(rNum);
    bool con = await checkInternetConnectivity();
    if (con) {
      final response =
          await http.post(Uri.parse('https://api.sendinblue.com/v3/smtp/email'),
              headers: {
                HttpHeaders.acceptHeader: "application/json",
                HttpHeaders.contentTypeHeader: 'application/json',
                "api-key":
                    "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",
              },
              body: jsonEncode({
                "sender": {
                  "name": "E-LOCKS",
                  "email": "pankaj.yadav@iic.ac.in"
                },
                "to": [
                  {"email": email, "name": "E-LOCK User"}
                ],
                "subject": "Password Reset",
                "htmlContent":
                    "<html><head></head><body><div style='font-family: Helvetica,Arial,sans-serif;min-width:1000px;overflow:auto;line-height:2'><div style='margin:50px auto;width:70%;padding:20px 0'><div style='border-bottom:1px solid #eee'><p style='font-size:1.4em;color: #00466a;text-decoration:none;font-weight:600'>E-LOCKS</p></div><p style='font-size:1.1em'>Hi,</p><p>Use below OTP to reset your password. OTP is valid for 5 minutes</p><h2 style='background: #00466a;margin: 0 auto;width: max-content;padding: 0 10px;color: #fff;border-radius: 4px;'>$rNum</h2><p style='font-size:0.9em;'>Regards,<br />E-LOCKS</p><hr style='border:none;border-top:1px solid #eee' /><div style='float:right;padding:8px 0;color:#aaa;font-size:0.8em;line-height:1;font-weight:300'><p>E-LOCKS</p><p>India</p></div></div></div></body></html>"
              }));
      print(response.statusCode);
      if (response.statusCode == 201) {
        setState(() {
          resendEnable = false;
          otpSent = true;
          otp = rNum.toString();
        });
        message_dialog(context, "OTP sent to " + email!);
      }
      print(response.body);
    } else {
      message_dialog(context, "No Internet");
    }
  }

  load() async {
    setState(() {
      isLoading = true;
    });
    bool con = await checkInternetConnectivity();
    if (con) {
      await MongoDBConnection.mongoDB.checkMongoDBConnection();
      DbCollection dc = mongoDB.db.collection('l_devices');
      await dc.find({'id': widget.id}).toList().then((value) async {
            if (value.isNotEmpty) {
              String em = value.first["email"];
              print(em);
              setState(() {
                email = em;
              });
            } else {
              message_dialog(context, "No Device");
            }
          });
    } else {
      message_dialog(context, "No Internet");
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    load();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DataProvider dp = context.watch<DataProvider>();
    return Container(
      color: Colors.black,
      child: imgBackground(
        Scaffold(
          appBar: AppBar(
            backgroundColor: appBarColor,
            //centerTitle: true,
            title: Text(
              'Password Reset',
            ),
            actions: [],
          ),
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (isLoading) ...[
                  Center(
                    child: Container(
                      height: 50,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ] else ...[
                  if (!otpSent) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Click below to receive otp to ${email!}",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: InkWell(
                        onTap: () {
                          sendOTP();
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          height: 40,
                          width: 132,
                          child: const Center(
                            child: Text(
                              "Send OTP",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ] else if (otpSent) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Click below to resend otp to ${email!}",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Opacity(
                        opacity: resendEnable ? 1 : 0.5,
                        child: InkWell(
                          onTap: resendEnable
                              ? () {
                                  sendOTP();
                                }
                              : null,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            height: 40,
                            width: 132,
                            child: const Center(
                              child: Text(
                                "Resend OTP",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    CountDownTimer(
                      secondsRemaining: 60,
                      whenTimeExpires: () {
                        setState(() {
                          resendEnable = true;
                        });
                      },
                      countDownTimerStyle: TextStyle(
                        color: Color(0XFFf5a623),
                        fontSize: 17.0,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: otpEnter,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "OTP cannot be empty";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {});
                      },
                      autofocus: false,
                      style: TextStyle(fontSize: 17),
                      decoration: InputDecoration(
                        border: linedBorder,
                        enabledBorder: linedBorder,
                        errorBorder: linedErrorBorder,
                        focusedBorder: linedFocusedBorder,
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        labelText: 'OTP',
                        labelStyle: linedLabelStyle,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: newPassword,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "New Password cannot be empty";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {});
                      },
                      autofocus: false,
                      style: TextStyle(fontSize: 17),
                      decoration: InputDecoration(
                        border: linedBorder,
                        enabledBorder: linedBorder,
                        errorBorder: linedErrorBorder,
                        focusedBorder: linedFocusedBorder,
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        labelText: 'New Password',
                        labelStyle: linedLabelStyle,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: InkWell(
                        onTap: () async {
                          if (otpEnter.text == otp) {
                            bool con = await checkInternetConnectivity();
                            if (con) {
                              await MongoDBConnection.mongoDB
                                  .checkMongoDBConnection();
                              DbCollection dc =
                                  mongoDB.db.collection('l_devices');
                              await dc.update(where.eq('id', widget.id),
                                  modify.set('password', newPassword.text));
                              Navigator.pop(context);
                              message_dialog(
                                  context, "Password Reset Successful");
                            } else {
                              message_dialog(context, "No Internet");
                            }
                          } else {
                            message_dialog(context, "Invalid OTP");
                          }
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          height: 40,
                          width: 132,
                          child: const Center(
                            child: Text(
                              "Submit",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
