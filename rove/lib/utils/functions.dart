import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';

import '../providers/index.dart';
import 'package:flutter/cupertino.dart';


Future<void> checkMongoDBConnection() async {
  print('mongoDB.db.isConnected : ' + mongoDB.db.isConnected.toString());
  if (mongoDB.db.isConnected) {
  } else {
    await mongoDB.init();
  }
}

Future<void> checkMQTTConnection() async {
  print('MQTTConnection.mqtt.client.connectionStatus : ' +
      (MQTTConnection.mqtt.client.connectionStatus!.returnCode ==
          MqttConnectReturnCode.connectionAccepted)
          .toString());
  if (MQTTConnection.mqtt.client.connectionStatus!.returnCode ==
      MqttConnectReturnCode.connectionAccepted) {
  } else {
    await mqtt.init();
  }
}
void showDropdownDialog(
    {required BuildContext context,required String title, required List<String> items, required Function(String) onChanged}) {
  showDialog<dynamic>(
      context: context,
      builder: (BuildContext context) => AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: Duration(milliseconds: 100),
        curve: Curves.bounceIn,
        child: SimpleDialog(
          title: Text(title),
          children: [
            for (var i = 0; i < items.length; i++) ...[
              DropdownMenuItem(
                  child: ListTile(
                    onTap: () async {
                      onChanged(items[i].toString());
                      Navigator.of(context).pop();
                    },
                    title: Text(items[i].toString()),
                  ))
            ],
          ],
        ),
      ));
}

Future<DateTime?> datePicker(BuildContext context) async {
  try {
    final date = await showDatePicker(
        context: context,
        firstDate: DateTime(1500),
        initialDate: DateTime.now(),
        lastDate: DateTime(2500));
    return DateTime(date!.year, date.month, date.day, 0, 0);
  } catch (e) {
    print(e);
  }
  return null;
}