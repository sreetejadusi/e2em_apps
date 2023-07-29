// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import '../screens/index.dart';

Future<bool> checkInternet(BuildContext context) async {
  bool internet = false;
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    internet = true;
  } else if (connectivityResult == ConnectivityResult.none) {
    internet = false;
    return false;
  } else {
    internet = false;
  }
  return internet;
}
