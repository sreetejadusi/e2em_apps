
import 'package:flutter/material.dart';

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
