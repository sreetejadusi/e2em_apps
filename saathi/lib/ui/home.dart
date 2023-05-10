import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State, Switch;
import 'package:provider/provider.dart';
import '../providers/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/index.dart';
import '../utils/index.dart';
import '../models/index.dart';
import 'index.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  bool isLoading = false;
  Timer? timer;
  bool reConnecting = false;
  String sendPingMessage = "Hare krishna";
  int tryCounter = 0;
  //String temp = "el:1:12:30:1:14:";
  load() async {
    DevicesProvider dep = context.read<DevicesProvider>();
    setState(() {
      isLoading = true;
    });
    await dep.init(context);
    sendPing();
    messageWaiting();
    setState(() {
      isLoading = false;
    });
    timer = Timer.periodic(const Duration(seconds: 20), (Timer t) {
      sendPing();
    });
  }

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    mqtt.addListener(onMessage);
    load();
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    timer?.cancel();
    mqtt.removeListener(onMessage);
    super.dispose();
  }

  String addLeadingZeros(int num) => num.toString().padLeft(2, '0');

  onMessage(MQTTMessageModel mqttMessage) async {
    DataProvider dp = context.read<DataProvider>();
    print("Topic : " + mqttMessage.topic!);
    print("Message : " + mqttMessage.message!);
    dp.parseMessage(context, mqttMessage.message!, true);
  }

  messageWaiting() async {
    DataProvider dp = context.read<DataProvider>();
    dp.waitingForMessageStatus(true);
    Future.delayed(const Duration(seconds: 7), () {
      if (dp.waitingForMessage) {
        dp.waitingForMessageStatus(false);
      } else {}
    });
  }

  setTimer(int min) async {
    DataProvider dp = context.read<DataProvider>();
    DevicesProvider dep = context.read<DevicesProvider>();
    String mes = "el:" +
        (dp.on ? 1 : 0).toString() +
        ":" +
        min.toString() +
        ":" +
        dp.inOperate.toString() +
        ":14:";
    try {
      await MQTTConnection.mqtt
          .onPublishMessageToTopic(dep.sendTopic!, [mes]).then((value) {});
      //messageWaiting();
    } catch (e) {
      print(e.toString());
    }
  }

  sendPing() async {
    DevicesProvider dep = context.read<DevicesProvider>();
    try {
      await MQTTConnection.mqtt.onPublishMessageToTopic(
          dep.sendTopic!, [sendPingMessage]).then((value) {});
    } catch (e) {
      print(e.toString());
    }
  }

  sendOnOff(int onOff) async {
    DataProvider dp = context.read<DataProvider>();
    DevicesProvider dep = context.read<DevicesProvider>();
    String mes =
        "el:" + onOff.toString() + ":0:" + dp.inOperate.toString() + ":14:";
    try {
      await MQTTConnection.mqtt
          .onPublishMessageToTopic(dep.sendTopic!, [mes]).then((value) {});
      //messageWaiting();
    } catch (e) {
      print(e.toString());
    }
  }

  tryOnOffCall(int onOff, bool first) {
    DataProvider dp = context.read<DataProvider>();
    DevicesProvider dep = context.read<DevicesProvider>();
    if (first) {
      setState(() {
        tryCounter = 3;
      });
      dp.waitingForMessageStatus(true);
    } else {}
    sendOnOff(onOff);
    setState(() {
      tryCounter = tryCounter - 1;
    });
    if (tryCounter == 0) {
      Future.delayed(const Duration(seconds: 6), () {
        dp.waitingForMessageStatus(false);
      });
    } else if (dp.waitingForMessage) {
      Future.delayed(const Duration(seconds: 6), () {
        if (dp.waitingForMessage) {
          tryOnOffCall(onOff, false);
        } else {}
      });
    } else {}
  }

  tryTimerCall(int min, bool first) {
    DataProvider dp = context.read<DataProvider>();
    DevicesProvider dep = context.read<DevicesProvider>();
    if (first) {
      setState(() {
        tryCounter = 3;
      });
      dp.waitingForMessageStatus(true);
    } else {}
    setTimer(min);
    setState(() {
      tryCounter = tryCounter - 1;
    });
    if (tryCounter == 0) {
      Future.delayed(const Duration(seconds: 6), () {
        dp.waitingForMessageStatus(false);
      });
    } else if (dp.waitingForMessage) {
      Future.delayed(const Duration(seconds: 6), () {
        if (dp.waitingForMessage) {
          tryTimerCall(min, false);
        } else {}
      });
    } else {}
  }

  bool switchClicked = false;
  @override
  Widget build(BuildContext context) {
    DataProvider dp = context.watch<DataProvider>();
    DevicesProvider dep = context.watch<DevicesProvider>();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      color: bgColor,
      child: Stack(
        children: [
          /* Container(
            decoration: const BoxDecoration(color: Colors.white),
            height: double.infinity,
            width: double.infinity,
          ),*/
          Container(
            decoration: const BoxDecoration(color: Colors.white
                //color: Color(0XFFF2A6A6)
                // color: Color(0XFFA3C7F5)

                ),
            height: double.infinity,
            width: double.infinity,
          ),
          /* ClipPath(
            clipper: DrawClip2(),
            child: Container(
              width: width,
              height: height*0.25,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xffa58fd2), Color(0xffddc3fc)],
                    begin: Alignment.bottomCenter,
                    end: Alignment.bottomRight),
              ),
            ),
          ),
          ClipPath(
            clipper: DrawClip(),
            child: Container(
              width: width,
              height: height * 0.38,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xffddc3fc), Color(0xff91c5fc)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
              ),
            ),
          ),*/
          /* AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget? child) {
              return ClipPath(
                clipper: DrawClip(_controller.value),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: [Color(0xFFE0647B), Color(0xFFFCDD89)]),
                  ),
                ),
              );
            },
          ),*/
          /* BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 7,
              sigmaY: 7,
            ),
            child: Container(
              decoration: const BoxDecoration(
                  //color: Color(0XFFF2A6A6)
                  color: Color(0XFFA3C7F5)

              ),
              height: double.infinity,
              width: double.infinity,
            ),
          ),*/
          upperCurvedContainer(),
          /* CustomPaint(
            child: Container(
              height: 300.0,
            ),
            painter: CurvePainter(),
          ),*/
          Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                //leading:
                title: Padding(
                  padding: const EdgeInsets.only(left: 20, top: 10),
                  child: Text(
                    'Saathi',
                    style: GoogleFonts.breeSerif(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 10),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Devices()),
                        );
                      },
                      icon: Icon(
                        CupertinoIcons.square_grid_2x2,
                        size: 30,
                        color:
                            dep.primaryDevice == 0 ? Colors.red : Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                ],
              ),
              body: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Stack(
                      fit: StackFit.passthrough,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: width * 0.25, right: width * 0.25, top: 10),
                          child: Opacity(
                            opacity: dp.waitingForMessage ? 1 : 0,
                            child: const LinearProgressIndicator(
                              backgroundColor: Colors.transparent,
                              color: Colors.green,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            time(),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                //  const SizedBox(height: 40),
                                Opacity(
                                  opacity: dp.online ? 1 : 0.7,
                                  child: durationPicker(
                                      context: context,
                                      val: dp.sliderValue,
                                      timerTime: dp.timerTimeString,
                                      onTap: dp.online && !dp.waitingForMessage
                                          ? (int min) {
                                              int mi = 0;
                                              if (dp.timerOn) {
                                                mi = 0;
                                              } else {
                                                mi = min;
                                              }
                                              tryTimerCall(mi, true);
                                              // setTimer(m);
                                            }
                                          : (int min) {}),
                                ),
                                /* GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      on = !on;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(shape: BoxShape.circle,color: tileColor),
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Icon(Icons.power_settings_new,
                                          size: 65,
                                          color: on ? Colors.green : Colors.red),
                                    ),
                                  ),
                                ),*/
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      //color: switchSplash,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Opacity(
                                          opacity: dep.devices.isNotEmpty &&
                                                  dp.online
                                              ? 1
                                              : 0.7,
                                          child: Transform.scale(
                                            scale: 2.0,
                                            child: Switch.adaptive(
                                              value: dp.on,
                                              thumbColor: switchClicked
                                                  ? MaterialStateProperty.all(
                                                      Colors.blue.shade700)
                                                  : null,
                                              activeColor: Colors.green,
                                              hoverColor: Colors.blue,
                                              splashRadius: 25,
                                              inactiveTrackColor:
                                                  Colors.red.withOpacity(0.7),
                                              inactiveThumbColor: Colors.red,
                                              onChanged: dep
                                                          .devices.isNotEmpty &&
                                                      dp.online &&
                                                      !dp.waitingForMessage
                                                  ? (value) {
                                                      if (!dp
                                                          .waitingForMessage) {
                                                        setState(() {
                                                          switchClicked = true;
                                                        });
                                                        Future.delayed(
                                                            const Duration(
                                                                milliseconds:
                                                                    500), () {
                                                          setState(() {
                                                            switchClicked =
                                                                false;
                                                          });
                                                        });
                                                      } else {}
                                                      tryOnOffCall(
                                                          dp.on ? 0 : 1, true);
                                                      //sendOnOff(dp.on ? 0 : 1);
                                                    }
                                                  : (value) async {},
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                /* Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        //gradient: curveGradient,
                                        border: Border.all(
                                            color: on ? Colors.green : Colors.red),
                                        borderRadius: BorderRadius.circular(50.0),
                                      ),
                                      child: Center(
                                        child: Transform.scale(
                                          scale: 1.0,
                                          child: CustomSwitch(
                                            //gradient: on ? gr : redGradient,
                                            size: 40.0,
                                            value: on,
                                            onChanged: (value) {
                                              setState(() {
                                                on = value;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),*/
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 35),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  ListTile(
                                    shape: tileShape,
                                    tileColor: tileColor,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 3, horizontal: 25),
                                    title: Text(
                                      dp.online
                                          ? ' Connected'
                                          : " Not Connected",
                                      style: GoogleFonts.breeSerif(
                                        textStyle: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Text(
                                        dep.getPrimaryDeviceName(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    leading: Icon(
                                      Icons.cloud_done_outlined,
                                      size: 30,
                                      color:
                                          dp.online ? Colors.green : Colors.red,
                                    ),
                                    horizontalTitleGap: 5,
                                    trailing: !dp.online
                                        ? reConnecting
                                            ? AnimatedBuilder(
                                                animation: animationController,
                                                builder: (_, child) {
                                                  return Transform.rotate(
                                                    angle: animationController
                                                            .value *
                                                        2 *
                                                        pi,
                                                    child: child,
                                                  );
                                                },
                                                child: IconButton(
                                                  onPressed: null,
                                                  icon: Icon(
                                                    Icons.refresh,
                                                    size: 32,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              )
                                            : IconButton(
                                                icon: const Icon(
                                                  Icons.refresh,
                                                  size: 30,
                                                  color: Colors.black,
                                                ),
                                                onPressed: () {
                                                  if (!dp.waitingForMessage) {
                                                    setState(() {
                                                      reConnecting = true;
                                                    });
                                                    sendPing();
                                                    messageWaiting();
                                                    Future.delayed(
                                                        const Duration(
                                                            seconds: 8), () {
                                                      setState(() {
                                                        reConnecting = false;
                                                      });
                                                      /* dataProvider.onlineStatus(
                                                        context, true);
                                                    Future.delayed(
                                                        const Duration(seconds: 5),
                                                        () {
                                                      dataProvider.onlineStatus(
                                                          context, false);
                                                    });*/
                                                    });
                                                  }
                                                },
                                              )
                                        : null,
                                  ),
                                  /* Divider(
                              thickness: 2,
                              color: Colors.blue.withOpacity(0.6),
                              indent: 50,
                              endIndent: 50,
                            ),*/
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Opacity(
                                    opacity: dp.online ? 1 : 0.7,
                                    child: ListTile(
                                      shape: tileShape,
                                      tileColor: tileColor,
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 25),
                                      title: Text(
                                        dp.fault ? "Fault" : "No Fault",
                                        style: GoogleFonts.breeSerif(
                                          textStyle: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      leading: Icon(
                                          dp.fault
                                              ? Icons.info
                                              : Icons.electrical_services,
                                          size: 30,
                                          color: dp.fault
                                              ? Colors.red
                                              : Colors.blue),
                                      horizontalTitleGap: 5,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
        ],
      ),
    );
  }

  Widget upperCurvedContainer() {
    double width = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return ClipPath(
      clipper: MyCustomClipper(),
      child: Container(
        height: h * 0.42,
        // height: 50,
        width: width,
        decoration: BoxDecoration(
          gradient: curveGradient,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[],
              ),
            ),
            // _topRow(),
            //Text('Satelite VPN', style: vpnStyle),
            //_bottomRow(),
          ],
        ),
      ),
    );
  }

  /*Widget connectionWidget(width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: width * 0.49,
          width: width * 0.49,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: online ? greenGradient : redGradient,
              boxShadow: [
                BoxShadow(
                  color: online
                      ? greenGradient.colors[0].withOpacity(.2)
                      : redGradient.colors[0].withOpacity(.2),
                  spreadRadius: 15,
                  blurRadius: 15,
                ),
              ]
              // color: bgColor,
              ),
          child: Center(
            child: Container(
              height: width * 0.48,
              width: width * 0.48,
              decoration: BoxDecoration(
                shape: BoxShape.circle, gradient: curveGradient,
                // gradient: curveGradient,
                // color: Colors.red,
              ),
              child: Center(
                child: Container(
                  height: width * 0.4,
                  width: width * 0.4,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, gradient: curveGradient),
                  child: Center(
                    child: Container(
                      height: width * 0.37,
                      width: width * 0.37,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: online ? greenGradient : redGradient,
                          boxShadow: [
                            BoxShadow(
                              color: online
                                  ? greenGradient.colors[0].withOpacity(.2)
                                  : redGradient.colors[0].withOpacity(.2),
                              spreadRadius: 15,
                              blurRadius: 15,
                            ),
                          ]),
                      child: Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            online
                                ? Icon(Icons.signal_wifi_4_bar,
                                    color: Colors.white, size: 70)
                                : reConnecting
                                    ? AnimatedBuilder(
                                        animation: animationController,
                                        builder: (_, child) {
                                          return Transform.rotate(
                                            angle: animationController.value *
                                                2 *
                                                pi,
                                            child: child,
                                          );
                                        },
                                        child: Icon(Icons.refresh,
                                            color: Colors.white, size: 70),
                                      )
                                    : Icon(Icons.refresh,
                                        color: Colors.white, size: 70),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }*/

  /*Widget connectedStatusText() {
    return Align(
      alignment: Alignment.center,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(text: 'Status :', style: connectedStyle, children: [
          TextSpan(
            text: online ? ' Connected\n' : " Not Connected\n",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: online ? greenGradient.colors[0] : redGradient.colors[0],
            ),
          ),
        ]),
      ),
    );
  }*/
}

/*
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  bool reConnecting = false;
  bool status = false;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text(
          'Controller',
          // s
        ),
        actions: [
          1 > 2
              ? Icon(
                  Icons.circle,
                  color: Colors.green,
                )
              : ActionChip(
                  label: Icon(
                    Icons.circle,
                    color: Colors.red,
                  ),
                  avatar: reConnecting
                      ? AnimatedBuilder(
                          animation: animationController,
                          builder: (_, child) {
                            return Transform.rotate(
                              angle: animationController.value * 2 * pi,
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
                      reConnecting = true;
                    });
                    Future.delayed(const Duration(seconds: 3), () {
                      setState(() {
                        reConnecting = false;
                      });
                    });
                  },
                ),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Transform.scale(
                  scale: 1.0,
                  child: CustomSwitch(
                    activeColor: Colors.green,
                    size: 60.0,
                    value: status,
                    onChanged: (value) {
                      setState(() {
                        status = value;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
         Center(
            child: InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                    border: Border.all(
                        width: 1.2, color: status ? Colors.green : Colors.red)),
                child: Padding(
                  padding: const EdgeInsets.all(2.5),
                  child: Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      color: status ? Colors.green : Colors.red,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(50.0)),
                    ),
                    child: Center(
                      child: AutoSizeText(
                        status ? 'ON' : 'OFF',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 23,
                            color: Colors.white,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.timer,
                  size: 65,
                )),
          ),
        ],
      ),
    );
  }
}
*/
