import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import '../providers/index.dart';

bool checkIfListContains(List<dynamic> l, dynamic s) {
  bool b = false;
  for (var m = 0; m < l.length; m++) {
    if (l[m].contains(s)) {
      b = true;
    }
  }
  return b;
}

List<double> parameterItems(List<dynamic> l, dynamic s) {
  bool b = false;
  List<double> p = [];
  for (var m = 0; m < l.length; m++) {
    if (l[m].contains(s)) {
      p.add(double.parse(l[m][1]));
      p.add(double.parse(l[m][2]));
      p.add(double.parse(l[m][3]));
    }
  }
  return p;
}

Future<void> checkMongoDBConnection() async {
  print('mongoDB.db.isConnected : ' + mongoDB.db.isConnected.toString());
  if (mongoDB.db.isConnected) {
  } else {
    await mongoDB.init();
  }
}

/*Future<void> checkMQTTConnection() async {
  print('MQTTConnection.mqtt.client.connectionStatus : ' +
      (MQTTConnection.mqtt.client.connectionStatus.returnCode ==
              MqttConnectReturnCode.connectionAccepted)
          .toString());
  if (MQTTConnection.mqtt.client.connectionStatus.returnCode ==
      MqttConnectReturnCode.connectionAccepted) {
  } else {
    await mqtt.init();
  }
}*/
