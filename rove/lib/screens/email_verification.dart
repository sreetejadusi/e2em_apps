import 'dart:convert';
import 'dart:core';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/index.dart';
import 'package:provider/provider.dart';
import '../providers/index.dart';
import 'index.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State;
import '../utils/index.dart';
class EmailVerification extends StatefulWidget {

  @override
  _EmailVerificationState createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
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
    UserProvider userProvider = context.read<UserProvider>();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: Theme.of(context).iconTheme,
        elevation: 0,
        title: Text(
          "Email Verification",
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: Text(
                    "Your Email ${userProvider.user.email} is not verified",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    "Please verify your email to continue,verification link has been sent to your mail",
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                  ),
                ),
                TextButton.icon(
                  onPressed: () async {
                    await FirebaseAuth.instance.currentUser!
                        .sendEmailVerification()
                        .then((value) {
                      alertDialog(
                          context,
                          "Email Verification",
                          "Verification link sent to ${userProvider.user.email}",
                          'Ok');
                    });
                  },
                  icon: Icon(Icons.mail_outline),
                  label: Text('Send Verification Link'),
                ),
                SizedBox(
                  height: 30,
                ),
                TextButton.icon(
                  onPressed: () async {
                    await checkMongoDBConnection();
                    UserCredential credential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: userProvider.user.email!.trim(),
                            password: userProvider.user.password!.trim());
                    if (credential.user!.emailVerified) {
                      DbCollection users = mongoDB.db.collection('users');
                      await users.update(
                          where.eq('email', userProvider.user.email),
                          modify.set('emailVerified', true));
                      await context.read<UserProvider>().init();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                      alertDialog(context, "Email Verification",
                          "Email Verified", 'Ok');
                    } else {
                      alertDialog(context, "Email Verification",
                          "Email Not Verified", 'Ok');
                    }
                  },
                  icon: Icon(Icons.refresh),
                  label: Text('Refresh'),
                )
              ]),
        ),
      ),
    );
  }
}
