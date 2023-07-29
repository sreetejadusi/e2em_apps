import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, AsyncSnapshot<SharedPreferences> prefs) {
          return Container(
            decoration: BoxDecoration(color: Colors.transparent),
            child: SwitchListTile(
                title: Text('Auto Connect'),
                subtitle: Text('Auto connect to the last device.'),
                value: prefs.data!.getBool('autoConnect') ?? false,
                onChanged: (autoConnect) {
                  prefs.data!.setBool('autoConnect', autoConnect);
                  setState(() {});
                }),
          );
        });
  }
}
