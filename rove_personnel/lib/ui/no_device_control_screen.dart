import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rove_personnel/utils/index.dart';
import '../providers/index.dart';
import 'index.dart';

class NoDeviceControlScreen extends StatefulWidget {
  const NoDeviceControlScreen({Key? key}) : super(key: key);

  @override
  State<NoDeviceControlScreen> createState() => _NoDeviceControlScreenState();
}

class _NoDeviceControlScreenState extends State<NoDeviceControlScreen> {
  ///SPEEDOMETER HEIGHT : H*0.22
  ///STATS HEIGHT : H*0.20
  ///WEATHER : H*0.12
  ///
  onLockUnlock() {
    ///
    print("Lock Unlock Pressed");

    ///
  }

  @override
  void dispose() {
    lu.removeListener(onLockUnlock);
    super.dispose();
  }

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    lu.addListener(onLockUnlock);
    //load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              helloTile(context,false),
              temp(context),
              stats(0, 0, 0),
              sm(context, 0),
              Container(
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: ListTile(
                  title: Text(
                    "No Device Connected",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  tileColor: Colors.transparent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
