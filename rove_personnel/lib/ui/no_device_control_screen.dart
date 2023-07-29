import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
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
  double speed = 0;
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
    DataProvider dataProvider = context.read<DataProvider>();
    dataProvider.init();
    Geolocator.getPositionStream().listen((event) {
      setState(() {
        speed = event.speed;
      });
      print(speed);
    });
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
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  helloTile(context),
                  Spacer(),
                  temp(context),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              stats(0, 0, 0),
              Spacer(),
              sm(context, speed),
              SizedBox(
                height: 24,
              ),
              Text(
                "No Device Connected",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              Spacer()
            ],
          ),
        ),
      ),
    );
  }
}
