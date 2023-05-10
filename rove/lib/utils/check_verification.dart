import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/index.dart';
import '../widgets/index.dart';
import '../screens/index.dart';

Future<void> checkVerification(BuildContext context) async {
  print('I check');
  UserProvider userProvider = context.read<UserProvider>();
  UserCredential credential = await FirebaseAuth.instance
      .signInWithEmailAndPassword(
          email: userProvider.user.email!.trim(),
          password: userProvider.user.password!.trim());
  print(credential.user!.emailVerified);
  if (userProvider.user.emailVerified &&
      userProvider.user.phoneNumberVerified) {
  } /* else if (!userProvider.user.emailVerified) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EmailVerification()),
    );
  } */
  else if (!userProvider.user.phoneNumberVerified) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PhoneNumberVerification()),
    );
  }
}
