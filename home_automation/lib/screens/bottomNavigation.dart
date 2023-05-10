import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_automation/sidebar/bloc.navigation_bloc/navigation_bloc.dart';
import 'package:home_automation/widgets/index.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State;
import 'package:shared_preferences/shared_preferences.dart';
import 'index.dart';
import 'package:provider/provider.dart';
import '../providers/index.dart';
import '../utils/index.dart';
import '../models/index.dart';

class BottomNavigation extends StatefulWidget with NavigationStates {
  @override
  State<StatefulWidget> createState() {
    return _BottomNavigationState();
  }
}

class _BottomNavigationState extends State<BottomNavigation>
    with SingleTickerProviderStateMixin {
  bool hw = false;
  AnimationController animationController;
  int currentIndex = 1;
  bool isLoading = false;
  final List<Widget> _children = [
    Sensors(),
    HomeScreen(),
    Miscellaneous(),
  ];
  load() async {
    DataProvider dataProvider = context.read<DataProvider>();
    setState(() {
      isLoading = true;
    });
    await mqtt.init();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String homeId = (prefs.getString('homeId') ?? '');
    await context.read<RoomsAndDevicesProvider>().load();
    dataProvider.init();
    await MQTTConnection.mqtt
        .onPublishMessageToTopic(homeId, ['hello']).then((value) {});
    Future.delayed(const Duration(seconds: 5), () {
      DataProvider dataProvider = context.read<DataProvider>();
      if (dataProvider.online) {
        setState(() {
          isLoading = false;
        });
      } else {
        dataProvider.onlineStatus(context, false);
        setState(() {
          isLoading = false;
        });
      }
    });
    setState(() {
      //isLoading = false;
    });
  }

  onMessage(MQTTMessageModel data) async {
    DataProvider dataProvider = context.read<DataProvider>();
    if (data.message == 'hello') {
      dataProvider.onlineStatus(context, true);
      dataProvider.lastCheckedConnection(context, DateTime.now());
      dataProvider.checkDeviceConnection();
      setState(() {
        isLoading = false;
        hw = false;
      });
    } else {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String homeId = (prefs.getString('homeId') ?? '');
        DbCollection home = mongoDB.db.collection(homeId);
        List<dynamic> l = data.message.toString().split(',');
        String deviceId = l[0].toString();
        print(deviceId);
        if (dataProvider.deviceIds.contains(deviceId)) {
          await DatabaseProvider.db.changeDeviceData(
              l[0].toString(),
              listToString(
                  one: l[1].toString(),
                  two: l[2].toString(),
                  three: l[3].toString()));
          await dataProvider.waitingDeviceStatus(context, '', null);
          await home.update(
            where.eq('deviceId', l[0].toString()),
            modify.set(
              'data',
              listToString(
                  one: l[1].toString(),
                  two: l[2].toString(),
                  three: l[3].toString()),
            ),
          );
          await DatabaseProvider.db.changeDeviceTimerTime(
              l[0].toString(),
              DateTime.now()
                  .add(Duration(minutes: int.parse(l[3].toString())))
                  .toString());
          await SetStateProvider.setStateProvider.sendSetState();
          await home.update(
              where.eq('deviceId', l[0].toString()),
              modify.set(
                  'timerTime',
                  DateTime.now()
                      .add(Duration(minutes: int.parse(l[3].toString())))
                      .toString()));
          setState(() {});
        } else if (dataProvider.miscellaneousIds.contains(deviceId)) {
          await DatabaseProvider.db.changeMiscellaneousData(
            l[0].toString(),
            listToString(
                one: l[1].toString(),
                two: l[2].toString(),
                three: l[3].toString()),
          );
          await dataProvider.waitingDeviceStatus(context, '', null);
          await home.update(
              where.eq('deviceId', l[0].toString()),
              modify.set(
                  'data',
                  listToString(
                      one: l[1].toString(),
                      two: l[2].toString(),
                      three: l[3].toString())));
          await DatabaseProvider.db.changeMiscellaneousTimerTime(
              l[0].toString(),
              DateTime.now()
                  .add(Duration(minutes: int.parse(l[3].toString())))
                  .toString());
          await SetStateProvider.setStateProvider.sendSetState();
          await home.update(
              where.eq('deviceId', l[0].toString()),
              modify.set(
                  'timerTime',
                  DateTime.now()
                      .add(Duration(minutes: int.parse(l[3].toString())))
                      .toString()));
          setState(() {});
        } else {}
      } catch (e) {
        print(e);
      }
    }
  }

  mqttConn() async {
    mqtt.addListener(onMessage);
  }

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    mqttConn();
    load();
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 900))
          ..repeat();
  }

  @override
  void dispose() {
    mqtt.removeListener(onMessage);
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DataProvider dataProvider = context.watch<DataProvider>();
    RoomsAndDevicesProvider roomsAndDevicesProvider =
        context.watch<RoomsAndDevicesProvider>();
    return roomsAndDevicesProvider.isLoading || isLoading
        ? Center(child: loaderSpin(context))
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: Text(
                'BUCKY',
                style: GoogleFonts.gugi(
                  textStyle: TextStyle(
                      //fontStyle: FontStyle.italic,
                      color: Color(0xFF1f3252),
                      fontWeight: FontWeight.bold),
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.notifications,
                  ),
                  onPressed: () {},
                ),
                dataProvider.online
                    ? Icon(
                        Icons.circle,
                        color: Colors.green,
                      )
                    : ActionChip(
                        label: Icon(
                          Icons.circle,
                          color: Colors.red,
                        ),
                        avatar: hw
                            ? AnimatedBuilder(
                                animation: animationController,
                                builder: (_, child) {
                                  return Transform.rotate(
                                    angle:
                                        animationController.value * 2 * math.pi,
                                    child: child,
                                  );
                                },
                                child: Icon(
                                  Icons.refresh,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                              )
                            : Icon(
                                Icons.refresh,
                                color: Theme.of(context).iconTheme.color,
                              ),
                        /* */
                        onPressed: () async {
                          setState(() {
                            hw = true;
                          });
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          String homeId = (prefs.getString('homeId') ?? '');
                          await MQTTConnection.mqtt.onPublishMessageToTopic(
                              homeId, ['hello']).then((value) {});
                          Future.delayed(const Duration(seconds: 20), () {
                            setState(() {
                              hw = false;
                            });
                          });
                        },
                      ),
                SizedBox(
                  width: 5,
                ),
              ],
            ),
            body: _children[currentIndex],
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                onTabTapped(1);
              },
              tooltip: "Home",
              child: Icon(Icons.home,
                  color: currentIndex == 1 ? Colors.blue : Colors.grey),
              elevation: 4.0,
              backgroundColor: Colors.white,
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomNavigationBar(
                onTap: onTabTapped,
                currentIndex: currentIndex,
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.devices_other), label: "Sensors"),
                  BottomNavigationBarItem(
                      icon: Opacity(opacity: 0, child: Icon(Icons.home)),
                      label: "Home"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.settings_input_component),
                      label: "Miscellaneous"),
                ]),
          );
  }

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }
}
