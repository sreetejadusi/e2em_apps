import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

import 'connectivity.dart';

Future<void> openUrl(String url) async {
  final Uri _url = Uri.parse(url);
  if (!await launchUrl(_url)) {
    throw 'Could not launch $url';
  }
}

noInternet(BuildContext context) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('No Internet Connection'),
        //content: Text('GeeksforGeeks'),
        actions: [
          ActionChip(
            onPressed: () {
              Navigator.pop(context);
            }, // function used to perform after pressing the button
            label: const Text('Ok'),
          ),
        ],
      );
    },
  );
}
