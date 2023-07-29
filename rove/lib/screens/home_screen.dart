import 'dart:async';
import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State hide Center;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:rove/screens/ride_instructions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/index.dart';
import '../utils/index.dart';
import '../widgets/index.dart';
import 'index.dart';
import 'my_wallet.dart';

const bgColor = Color(0xFF1d263b);
const primary = Color(0xFFFF4B63);
const warning = Color(0xFFFCC666);
const success = Color(0xFF77FF89);
const textWhite = Color(0xFFFFFFFF);
const textBlack = Color(0xFF000000);

const appTitle = TextStyle(
    fontSize: 28, fontWeight: FontWeight.bold, height: 1.5, color: textWhite);
const appSubTitle = TextStyle(
    fontSize: 20, fontWeight: FontWeight.bold, height: 1.5, color: textWhite);
const contentWhite = TextStyle(fontSize: 15, height: 1.5, color: textWhite);
const contentBlack = TextStyle(fontSize: 15, height: 1.5, color: textBlack);

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Timer timer;
  late Position _currentPosition;
  bool isLoading = false;
  bool pendingRide = false;

  load() async {
    UserProvider userProvider = context.read<UserProvider>();
    setState(() {
      isLoading = true;
    });
    DbCollection users = mongoDB.db.collection('users');
    await users
        .find({'_id': ObjectId.fromHexString(userProvider.user.id!)})
        .first
        .then((user) async {
          setState(() {
            pendingRide = user["pendingRide"] != null;
          });
        });
    /*
    //await checkVerification(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      pendingRide = (prefs.getBool('pendingRide') ?? false);
    });*/
    await context.read<TransactionsProvider>().init();
    print(pendingRide);
    setState(() {
      isLoading = false;
    });
    await Permission.location.request();
    context.read<ImagesUrlProvider>().init();
    await context.read<NotificationsProvider>().load(userProvider.user);
    await context.read<WalletProvider>().init();
  }

  onMessage(String data) async {}

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    load();
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TransactionsProvider transactionsProvider =
        context.watch<TransactionsProvider>();
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    UserProvider userProvider = context.watch<UserProvider>();
    NotificationsProvider notificationsProvider =
        context.watch<NotificationsProvider>();
    ImagesUrlProvider imagesUrlProvider = context.watch<ImagesUrlProvider>();
    return WillPopScope(
      onWillPop: () async {
        fullScreenYesOrNoDialog(
            context: context,
            color: Theme.of(context).colorScheme.secondary,
            icon: Icons.fullscreen_exit,
            title: 'Exit App',
            subtitle: 'Sure you want to exit the app',
            onYes: () {
              print('yes');
              exit(0);
            });
        /* showDialog(
            context: context,
            builder: (context) {
              return YesNoDialog(
                icon: Icons.fullscreen_exit,
                text: "Sure you want to exit the app    ",
                noPressed: () {
                  Navigator.pop(context);
                },
                yesPressed: () {
                  exit(0);
                  //print("yes");
                },
              );
            });*/
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        // backgroundColor: Color.fromRGBO(3, 9, 23, 1.0),
        appBar: AppBar(
          backgroundColor: Colors.black,
          //  backgroundColor: Color.fromRGBO(3, 9, 23, 1.0),
          elevation: 0,
          title: Text(
            "LET'S ROVE",
            style: GoogleFonts.gugi(
              textStyle: TextStyle(),
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Notifications()),
                );
              },
              child: IconBadge(
                icon: Icon(
                  Icons.notifications,
                ),
                itemCount: notificationsProvider.notifications.length,
                badgeColor: Colors.blueGrey.withOpacity(0.7),
                maxCount: 500,
              ),
            ),
          ],
        ),
        floatingActionButton: isLoading
            ? null
            : Container(
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    bool lse = await Geolocator.isLocationServiceEnabled();
                    print('isLocationServiceEnabled : ' + lse.toString());
                    if (!lse) {
                      print('no');
                      await Geolocator.openLocationSettings();
                    } else {
                      print('yes');
                      // if (transactionsProvider.transactions[0].from ==
                      //     "pending") {
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => const TransactionHistory(),
                      //     ),
                      //   );
                      // } else if (pendingRide) {
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(builder: (context) => Scan()),
                      //   );
                      // } else {
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(builder: (context) => Scan()),
                      //   );
                      // }
                    }
                  },
                  // padding: EdgeInsets.all(0),
                  // shape: RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.circular(6),
                  // ),
                  child: Ink(
                    decoration: BoxDecoration(
                      color: Color(0xFF26352e),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      constraints: BoxConstraints(
                          minHeight: 75,
                          maxWidth: MediaQuery.of(context).size.width * 0.50),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            LineIcons.qrcode,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            transactionsProvider.transactions.isNotEmpty &&
                                    transactionsProvider.transactions[0].from ==
                                        "pending"
                                ? "Pending Payment"
                                : pendingRide
                                    ? 'Continue Ride'
                                    : 'Scan to Ride',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
        /*Transform.scale(
                scale: 1.0,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(50.0)),
                      border: Border.all(width: 1.5, color: accentColor
                          //color:Color(0xFFA8EE90),
                          )),
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: FloatingActionButton.extended(
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      onPressed: () async {
                        bool lse = await Geolocator.isLocationServiceEnabled();
                        print('isLocationServiceEnabled : ' + lse.toString());
                        if (!lse) {
                          print('no');
                          await Geolocator.openLocationSettings();
                        } else {
                          print('yes');
                          if (pendingRide) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RideScreen()),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Scan()),
                            );
                          }
                        }
                      },
                      elevation: 5,
                      label: Text(
                        pendingRide ? 'Continue Ride' : 'Scan to Ride',
                        style: GoogleFonts.breeSerif(
                          textStyle:
                              TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                      icon: Icon(
                        pendingRide ? Icons.arrow_forward : LineIcons.qrcode,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),*/
        drawer: MenuDrawer(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: isLoading
            ? Center(child: loaderSpin(context))
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
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
                                  i < imagesUrlProvider.homeScreenImages.length;
                                  i++) ...[
                                Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.memory(
                                      imagesUrlProvider.homeScreenImages[i],
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ]
                            ]),
                      ),
                      if (!userProvider.isLoading) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  DefaultTextStyle(
                                    style: GoogleFonts.breeSerif(
                                      textStyle: TextStyle(fontSize: 18),
                                    ),
                                    child: AnimatedTextKit(
                                        totalRepeatCount: 2,
                                        animatedTexts: [
                                          TyperAnimatedText('Hi,'),
                                        ]),
                                  ),
                                  DefaultTextStyle(
                                    style: GoogleFonts.breeSerif(
                                        textStyle: TextStyle(fontSize: 25)),
                                    child: AnimatedTextKit(
                                        totalRepeatCount: 2,
                                        animatedTexts: [
                                          TyperAnimatedText(
                                              userProvider.user.name!),
                                        ]),
                                  ),
                                ],
                              ),
                              Spacer(),
                              IconButton(
                                onPressed: () {},
                                splashRadius: 25,
                                icon: Icon(
                                  LineIcons.instagram,
                                  size: 35,
                                  color: Colors.white,
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                splashRadius: 25,
                                icon: Icon(
                                  LineIcons.facebook,
                                  size: 35,
                                  color: Colors.white,
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                splashRadius: 25,
                                icon: Icon(
                                  LineIcons.youtube,
                                  size: 35,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Options(
                              onTap: () async {
                                bool lse =
                                    await Geolocator.isLocationServiceEnabled();
                                print('isLocationServiceEnabled : ' +
                                    lse.toString());
                                if (!lse) {
                                  print('no');
                                  await Geolocator.openLocationSettings();
                                } else {
                                  print('yes');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LocateHOPP()),
                                  );
                                }
                              },
                              icon: Icons.location_on,
                              color: Colors.orangeAccent,
                              text: "Locate\nHOPP",
                              index: 1,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Options(
                              index: 2,
                              onTap: () {
                                //"http://maps.google.com/maps".launchUrl;
                                "https://www.google.com/maps".launchUrl;
                              },
                              icon: Icons.near_me,
                              color: Colors.red,
                              text: "Nearby\nAttractions",
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Options(
                              index: 3,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const AboutVehicle()),
                                );
                              },
                              icon: LineIcons.bicycle,
                              color: Colors.greenAccent,
                              text: "Vehicle\nInfo",
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            child: Text(
                              "Featured",
                              style: GoogleFonts.breeSerif(
                                textStyle: appSubTitle,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                            child: Card(
                              //color: Color(0xFF15202b),
                              color: Color(0xFF252525),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        RowItem1(
                                          ontap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MyWallet()),
                                            );
                                          },
                                          iconName: Icons
                                              .account_balance_wallet_outlined,
                                          colorCard: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          text: "My\nWallet",
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        RowItem1(
                                          ontap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      TransactionHistory()),
                                            );
                                          },
                                          iconName: Icons.monetization_on,
                                          colorCard: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          text: "My\nPayments",
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        RowItem1(
                                          ontap: () {},
                                          iconName:
                                              Icons.monetization_on_outlined,
                                          colorCard: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          text: "Refer \n& Earn",
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        RowItem1(
                                          ontap: () {},
                                          iconName: Icons.history,
                                          colorCard: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          text: "Your\nHistory",
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        RowItem1(
                                          ontap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      RideInstructions()),
                                            );
                                          },
                                          iconName: Icons.delivery_dining,
                                          colorCard: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          text: "Riding\nInstructions",
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        RowItem1(
                                          ontap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      TermsAndConditions()),
                                            );
                                          },
                                          iconName: Icons.info,
                                          colorCard: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          text: "T & C\n for User",
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 70,
                          ),
                        ],
                      )
                      /* button(
                            context: context,
                            text: onOffProvider.on ? 'ON' : 'OFF',
                            filled: onOffProvider.on ? true : false,
                            color: Theme.of(context).colorScheme.secondary,
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
}

class Options extends StatelessWidget {
  final int index;
  final IconData icon;
  final Color color;
  final String text;
  final Function() onTap;

  const Options({
    required this.index,
    required this.icon,
    required this.color,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.blue.withOpacity(0.6), width: 2),
          borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        borderRadius: BorderRadius.circular(17),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    //color: Colors.blue
                    //color: colorCard.withOpacity(0.5),
                    // border: Border.all(color: colorCard, width: 2),
                    //borderRadius: BorderRadius.circular(40 / 2)
                    ),
                child: Icon(
                  icon,
                  size: 40,
                  color: color,
                  //color: Colors.white,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.breeSerif(
                    textStyle: TextStyle(
                        color: color,
                        //color: Colors.white,
                        fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

class RowItem1 extends StatelessWidget {
  final IconData? iconName;
  final Color? colorCard;
  final String? text;
  final Function() ontap;

  const RowItem1({
    this.iconName,
    this.colorCard,
    this.text,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: InkWell(
      onTap: ontap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: Icon(
                iconName,
                size: 45,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                text!,
                textAlign: TextAlign.center,
                style: GoogleFonts.breeSerif(
                  textStyle: TextStyle(
                      // color: colorCard,
                      color: Colors.white,
                      fontSize: 13),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
