import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'index.dart';
import '../providers/index.dart';
import '../widgets/index.dart';
import '../utils/index.dart';
import '../models/index.dart';

class RideScreen extends StatefulWidget {
  final String vid;
  const RideScreen({Key? key, required this.vid}) : super(key: key);
  @override
  _RideScreenState createState() => _RideScreenState();
}

class _RideScreenState extends State<RideScreen> {
  Timer? timer;
  String pingMessage = "";
  String sendTopic = "";
  String receiveTopic = "";
  String lockMessage = "";
  String unlockMessage = "";
  bool isLoading = false;
  String SOC = "0";
  String SOH = "0";
  String KM = "0";
  bool locked = true;
  bool durationWaiting = false;
  // For velocity Tracking
  /// Geolocator is used to find velocity
  GeolocatorPlatform locator = GeolocatorPlatform.instance;

  /// Current Velocity in m/s
  double _velocity = 0;
  durationTrue() async {
    setState(() {
      durationWaiting = true;
    });
  }

  addDuration(int seconds) async {
    String l = locked ? "Unable to unlock vehicle" : "Unable to lock vehicle";
    Future.delayed(const Duration(seconds: 5), () {
      if (durationWaiting) {
        setState(() {
          durationWaiting = false;
        });
        showDialog(
            context: context,
            builder: (context) {
              return CustomDialog(
                  icon: Icons.error,
                  text: l,
                  buttonlabel: 'Ok',
                  buttonPressed: () async {
                    Navigator.pop(context);
                  });
            });
      }
    });
  }

  onMessage(MQTTMessageModel mqttMessage) async {
    pingMessage = "HELLO" + widget.vid;
    sendTopic = "ROVE" + widget.vid;
    receiveTopic = "@ROVE" + widget.vid;
    lockMessage = "LOCK" + widget.vid;
    unlockMessage = "UNLOCK" + widget.vid;
    DataProvider dataProvider = context.read<DataProvider>();
    //print('MQTTMessage');
    //print(mqttMessage.topic);
    //print(mqttMessage.message);
    if (mqttMessage.message == pingMessage) {
      dataProvider.onlineStatus(context, true);
      dataProvider.lastCheckedConnection(context, DateTime.now());
      dataProvider.checkDeviceConnection();
      setState(() {
        isLoading = false;
      });
    } else if (mqttMessage.message == lockMessage) {
      print("LOCK CAME");
      setState(() {
        durationWaiting = false;
      });
      setState(() {
        locked = true;
      });
      showDialog(
          context: context,
          builder: (context) {
            return CustomDialog(
                icon: Icons.lock_outlined,
                text: "Vehicle Locked",
                buttonlabel: 'Ok',
                buttonPressed: () async {
                  Navigator.pop(context);
                });
          });
    } else if (mqttMessage.message == unlockMessage) {
      print("UnLOCK CAME");
      setState(() {
        durationWaiting = false;
      });
      setState(() {
        locked = false;
      });
      showDialog(
          context: context,
          builder: (context) {
            return CustomDialog(
                icon: Icons.lock_open_outlined,
                text: "Vehicle Unlocked",
                buttonlabel: 'Ok',
                buttonPressed: () async {
                  Navigator.pop(context);
                });
          });
    } else {
      try {
        List<String> result = mqttMessage.message!.split(',');
        if (result.length == 3) {
          setState(() {
            SOC = result[0].toString();
            SOH = result[1].toString();
            KM = result[2].toString();
          });
        }
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> back() async {
    endRide();
  }

  load() async {
    UserProvider userProvider = context.read<UserProvider>();
    setState(() {
      isLoading = true;
    });
    DbCollection users = mongoDB.db.collection('users');
    await users.update(
        where.eq('_id', ObjectId.fromHexString(userProvider.user.id!)),
        modify.set('pendingRide', widget.vid));
    await checkMQTTConnection();
    await MQTTConnection.mqtt.onPublishMessageToTopic(
        sendTopic, ["HELLO" + widget.vid]).then((value) {});
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
  }

  @override
  void initState() {
    print("Vehicle Id");
    print(widget.vid);
    setState(() {
      pingMessage = "HELLO" + widget.vid;
      sendTopic = "ROVE" + widget.vid;
      receiveTopic = "@ROVE" + widget.vid;
      lockMessage = "LOCK" + widget.vid;
      unlockMessage = "UNLOCK" + widget.vid;
    });
    mqtt.addListener(onMessage);
    load();
    super.initState();
    try {
      timer = Timer.periodic(const Duration(seconds: 15), (Timer t) {
        MQTTConnection.mqtt.onPublishMessageToTopic(
            sendTopic, ["HELLO" + widget.vid]).then((value) {});
      });
    } catch (e) {
      print(e.toString());
    }
    /* try {
      setState(() {
        isLoading = true;
      });
      locator
          .getPositionStream(
        desiredAccuracy: LocationAccuracy.high,
      )
          .listen(
        (Position position) {
          locator
              .getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          )
              .then(
            (Position updatedPosition) {
              double v = ((position.speed + updatedPosition.speed) / 2) * 3.6;
              if (v < 26 && !locked) {
                setState(() {
                  _velocity = v;
                });
              }
              //print('velocity : ' + _velocity.toString());
            },
          );
        },
      );
    } catch (e) {
      print(e);
    }*/
  }

  @override
  void dispose() {
    timer?.cancel();
    mqtt.removeListener(onMessage);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.watch<UserProvider>();
    WalletProvider walletProvider = context.watch<WalletProvider>();
    TransactionsProvider transactionsProvider =
        context.watch<TransactionsProvider>();
    ImagesUrlProvider imagesUrlProvider = context.watch<ImagesUrlProvider>();
    DataProvider dataProvider = context.watch<DataProvider>();
    return WillPopScope(
      onWillPop: () async {
        await back();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(3, 9, 23, 1.0),
          elevation: 0,
          automaticallyImplyLeading: true,
          title: Text(
            "LET'S ROVE",
            style: GoogleFonts.gugi(
              textStyle: TextStyle(),
            ),
          ),
          actions: [
            dataProvider.online
                ? TextButton.icon(
                    onPressed: () {},
                    icon: Icon(
                      Icons.wifi_tethering,
                      color: Colors.green,
                    ),
                    label: Text(
                      'Online',
                      style: TextStyle(color: Colors.green),
                    ),
                  )
                : TextButton.icon(
                    icon: Icon(
                      Icons.refresh,
                      color: Colors.red,
                    ),
                    label: Text(
                      'Offline',
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      await MQTTConnection.mqtt.onPublishMessageToTopic(
                          sendTopic, ["HELLO" + widget.vid]).then((value) {});
                      Future.delayed(const Duration(seconds: 20), () {
                        setState(() {
                          isLoading = false;
                        });
                      });
                    },
                  ),
          ],
        ),
        floatingActionButton: !isLoading
            ?
            //dataProvider.online?
            Transform.scale(
                scale: 1.0,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                      border: Border.all(width: 1.5, color: Colors.blue
                          //color:Color(0xFFA8EE90),
                          )),
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: FloatingActionButton.extended(
                      heroTag: 'rideScreen',
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      onPressed: () {
                        endRide();
                      },
                      elevation: 5,
                      label: Text(
                        'End Ride',
                        style: GoogleFonts.breeSerif(
                          textStyle:
                              TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                      icon: Icon(
                        Icons.legend_toggle_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: isLoading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: loaderSpin(context)),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Connecting to Vehicle...",
                    style: GoogleFonts.breeSerif(
                        textStyle: TextStyle(
                            fontSize: 21.0, fontWeight: FontWeight.normal)),
                  ),
                ],
              )
            : SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      /*TextButton.icon(
                        onPressed: () async {
                          await MQTTConnection.mqtt.onPublishMessageToTopic(
                              receiveTopic, ['hello']).then((value) {});
                        },
                        icon: Icon(
                          Icons.send,
                          color: Colors.green,
                        ),
                        label: Text(
                          'MQTT(Online)',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),*/
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 0,
                        ),
                        child: CarouselSlider(
                            options: CarouselOptions(
                              enlargeCenterPage: true,
                              autoPlay: true,
                              viewportFraction: 1,
                              autoPlayInterval: Duration(milliseconds: 2000),
                            ),
                            items: [
                              for (var i = 0;
                                  i < imagesUrlProvider.rideScreenImages.length;
                                  i++) ...[
                                Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.memory(
                                      imagesUrlProvider.rideScreenImages[i],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ]
                            ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 5,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 10),
                                  child: Text(
                                    "Vehicle ID - " + widget.vid,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.breeSerif(
                                      textStyle: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(50.0)),
                                    border: Border.all(
                                        width: 1.5, color: Colors.blue)),
                                child: Padding(
                                  padding: const EdgeInsets.all(7),
                                  child: IconButton(
                                    onPressed: () async {
                                      if (dataProvider.online) {
                                        await checkMQTTConnection();
                                        await MQTTConnection.mqtt
                                            .onPublishMessageToTopic(
                                                sendTopic, [
                                          locked ? unlockMessage : lockMessage
                                        ]);
                                        setState(() {
                                          durationWaiting = true;
                                        });
                                        addDuration(5);
                                      } else {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return CustomDialog(
                                                  icon: Icons.wifi_off,
                                                  text: "Vehicle is offline",
                                                  buttonlabel: 'Ok',
                                                  buttonPressed: () async {
                                                    Navigator.pop(context);
                                                  });
                                            });
                                      }
                                    },
                                    icon: Icon(
                                      locked
                                          ? Icons.lock_outlined
                                          : Icons.lock_open_outlined,
                                      size: 35,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color(0xFF151B20),
                                  border: Border.all(
                                      color: Colors.blue.withOpacity(0.6),
                                      width: 0.1),
                                  borderRadius: BorderRadius.circular(500)),
                              child: Padding(
                                padding: const EdgeInsets.all(13.0),
                                child: SpeedMeter(
                                  speed: _velocity,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 5,
                            left: 7.0,
                            right: 0.0,
                            child: Center(
                              child: Transform.scale(
                                scale: 0.7,
                                child: FloatingActionButton.extended(
                                  backgroundColor: Colors.redAccent,
                                  onPressed: () {},
                                  elevation: 5,
                                  label: Text(
                                    'Speed',
                                    style: GoogleFonts.breeSerif(
                                      textStyle: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                  ),
                                  icon: null,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      /*OutlinedButton(
                          onPressed: () async {
                            await checkMQTTConnection();
                            await MQTTConnection.mqtt.onPublishMessageToTopic(
                                '@' + 'HOPP202101', [
                              "${79.toString()},${90.toString()},${5.toString()}"
                            ]);
                          },
                          child: Text("MQTT(params)")),*/
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            border: Border.all(
                                color: Colors.blue.withOpacity(0.6), width: 2),
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              CardStatus2(
                                iconName: LineIcons.heart,
                                colorCard: Colors.red,
                                totalCases: SOH,
                                status: "SOH(%)",
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              CardStatus2(
                                iconName: LineIcons.batteryFull,
                                colorCard: Colors.greenAccent,
                                //colorCard: Colors.red,
                                totalCases: SOC,
                                status: "SOC(%)",
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              CardStatus2(
                                iconName: Icons.delivery_dining,
                                colorCard: Colors.orangeAccent,
                                //colorCard: Theme.of(context).accentColor,
                                totalCases: KM,
                                status: "KM",
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 70,
                      ),
                      /* button(
                            context: context,
                            text: onOffProvider.on ? 'ON' : 'OFF',
                            filled: onOffProvider.on ? true : false,
                            color: Theme.of(context).accentColor,
                            onTap: () async {
                              await onOffProvider.onPressed();
                              await MQTTConnection.mqtt
                                  .onSubscribeToTopic('mqttconn');
                              await MQTTConnection.mqtt.onPublishMessageToTopic(
                                  'mqttconn', [onOffProvider.on ? 'ON' : 'OFF']);
                            }),*/
                      /*
                        if (_currentPosition != null)
                          Center(
                            child: Text(
                                "LAT: ${_currentPosition.latitude}, LNG: ${_currentPosition.longitude}"),
                          ),*/
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  endRide() async {
    UserProvider userProvider = context.read<UserProvider>();
    TransactionsProvider transactionsProvider =
        context.read<TransactionsProvider>();
    WalletProvider walletProvider = context.read<WalletProvider>();
    fullScreenYesOrNoDialog(
        context: context,
        color: Theme.of(context).accentColor,
        icon: Icons.legend_toggle,
        title: 'End Ride',
        subtitle: 'Are you sure you want to end ride',
        onYes: () async {
          setState(() {
            isLoading = true;
          });
          await checkMongoDBConnection();
          await MQTTConnection.mqtt
              .onPublishMessageToTopic(sendTopic, [lockMessage]);
          DbCollection transactions = mongoDB.db.collection('transactions');
          TransactionModel transaction = TransactionModel();
          transaction.userId = userProvider.user.id;
          transaction.amount = 200.toString();
          transaction.from = "pending";
          transaction.to = "ride";
          transaction.timestamp = DateTime.now().toString();
          transaction.paymentId = "";
          await transactions.insertOne(transaction.toMap());
          DbCollection users = mongoDB.db.collection('users');
          await users.update(
              where.eq('_id', ObjectId.fromHexString(userProvider.user.id!)),
              modify.set('pendingRide', null));
          timer?.cancel();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
          fullScreenMessageDialog(
              context: context,
              color: Theme.of(context).accentColor,
              icon: Icons.verified,
              title: 'Congrats',
              subtitle: 'Ride Successful',
              onBack: () {
                Navigator.pop(context);
              });
          setState(() {
            isLoading = false;
          });
          ////////////////////
        });
  }
}

class CardStatus2 extends StatelessWidget {
  final IconData? iconName;
  final Color? colorCard;
  final String? totalCases;
  final String? status;
  const CardStatus2({
    this.iconName,
    this.colorCard,
    this.totalCases,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.transparent,
            //border: Border.all(
            //  width: 1.2,
            //color: Theme.of(context).accentColor.withOpacity(0.2)
            // ),
            borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: <Widget>[
              Icon(
                iconName,
                size: 43,
                color: colorCard,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "$totalCases",
                style: TextStyle(
                    color: colorCard,
                    //color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "$status",
                style: TextStyle(
                    color: colorCard,
                    //color: Colors.white,
                    fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
