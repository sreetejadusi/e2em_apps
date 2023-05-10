import 'package:flutter/services.dart';
import 'package:mqtt_client/mqtt_client.dart';
import '../providers/mongoDBConnection.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State;
import '../widgets/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'index.dart';
import 'package:provider/provider.dart';
import '../providers/index.dart';
import '../utils/index.dart';
import '../models/index.dart';

class Scan extends StatefulWidget {
  const Scan({Key? key}) : super(key: key);

  @override
  _ScanState createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  String vid ="";
  String sendTopic = "ROVE000";
  String receiveTopic = "@ROVE000";
  bool pinged = false;
  bool screenLoading = false;
  bool loading = false;
  late QRViewController controller;
  load() async {
    setState(() {
      screenLoading = true;
    });
    try {
      await mqtt.init();
    } catch (e) {
      fullScreenMessageDialog(
          context: context,
          color: Colors.redAccent,
          icon: Icons.error,
          title: 'Connection Error',
          subtitle: 'Unable to connect to vehicle',
          onBack: () {
            Navigator.pop(context);
            Navigator.pop(context);
            /*Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Scan()),
                        );*/
          });
      print(e);
    }
    if (MQTTConnection.mqtt.client.connectionStatus!.returnCode ==
        MqttConnectReturnCode.connectionAccepted) {
      setState(() {
        screenLoading = false;
      });
    } else {}
  }

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    setState(() {
      loading = false;
    });
    load();
    mqtt.addListener(onMessage);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  String result = "";
  String tempResult = "";
  bool completed = false;

  final GlobalKey qrKey = GlobalKey();
  TextStyle ts1 = GoogleFonts.breeSerif(
      textStyle: TextStyle(fontSize: 25.0, fontWeight: FontWeight.normal));
  TextStyle ts = GoogleFonts.breeSerif(
      textStyle: TextStyle(fontSize: 19.0, fontWeight: FontWeight.normal));

  onMessage(MQTTMessageModel mqttMessage) async {
    print('MQTTMessage');
    print(mqttMessage.topic);
    print(mqttMessage.message);
    if(mqttMessage.message=="HELLO"+vid){setState(() {
      pinged = true;
    });}
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: MoveBackButton(
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            screenLoading
                ? Expanded(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(child: loaderSpin(context)),
                      SizedBox(
                        height: 5,
                      ),
                     /* Text(
                        "Connecting to Server...",
                        style: GoogleFonts.breeSerif(
                            textStyle: TextStyle(
                                fontSize: 21.0, fontWeight: FontWeight.normal)),
                      ),*/
                    ],
                  ))
                : Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Container(
                                  color: Colors.black,
                                  height:
                                      MediaQuery.of(context).size.width * 0.75,
                                  width:
                                      MediaQuery.of(context).size.width * 0.75,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      _buildQrView(context),
                                      if (loading) ...[
                                        Center(
                                            child: Transform.scale(
                                                scale: 1.5,
                                                child:
                                                    CircularProgressIndicator()))
                                      ],
                                    ],
                                  )),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                  //color: Color(0xFF151B20),
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  //color: colorCard.withOpacity(0.5),
                                  border: Border.all(
                                      color: Colors.white, width: 0.5),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          'Instructions',
                                          style: ts1,
                                        ),
                                        Image.asset(
                                          'assets/rove.png',
                                          alignment: Alignment.centerLeft,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.15,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.15,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "⦿  Scan QR Code Pasted On Vehicle",
                                      style: ts,
                                      textAlign: TextAlign.left,
                                    ),
                                    Text(
                                      "⦿  Please Align Your Scanner With The QR Code",
                                      style: ts,
                                      textAlign: TextAlign.left,
                                    ),
                                    //Expanded(child: SizedBox()),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const RideScreen(vid: "101")),
                                  );
                                },
                                child: Text('Next'),
                              ),
                              TextButton(
                                onPressed: () {
                                  fullScreenMessageDialog(
                                      context: context,
                                      color: Colors.redAccent,
                                      icon: Icons.error,
                                      title: 'Scan Error',
                                      subtitle: 'Please Scan Valid QR Code',
                                      onBack: () {});
                                },
                                child: Text('D'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    UserProvider userProvider = context.read<UserProvider>();
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return QRView(
      key: qrKey,
      cameraFacing: CameraFacing.back,
      onQRViewCreated: (QRViewController controller) {
        this.controller = controller;
        controller.scannedDataStream.listen((scanData) async {
          if (scanData.code != tempResult) {
            setState(() {
              tempResult = scanData.code!;
            });
            try {
              setState(() {
                result = vehicleIdDecrypt(tempResult);
              });
              print(result);
              //await checkMongoDBConnection();
              setState(() {
                loading = true;
                controller.pauseCamera();
              });
              //showLoadingDialog(context, "Connecting to Vehicle...");
              DbCollection vehicles = mongoDB.db.collection('vehicles');
              await vehicles
                  .find({'vehicleId': result})
                  .toList()
                  .then((t) async {
                    if (t.isNotEmpty) {
                      print("Found vehicle in database");
                      setState(() {
                        vid =result;
                        sendTopic = "ROVE" + result;
                        receiveTopic = "@ROVE" + result;
                      });
                      await checkMQTTConnection();
                      await MQTTConnection.mqtt
                          .onUnSubscribeToTopic(receiveTopic);
                      await MQTTConnection.mqtt
                          .onSubscribeToTopic(receiveTopic);
                      await MQTTConnection.mqtt.onPublishMessageToTopic(
                          sendTopic, ["HELLO" + result]).then((value) {});
                      Future.delayed(const Duration(seconds: 5), () {
                        if (pinged) {
                          fullScreenInfoDialog(
                              context: context,
                              color: Colors.greenAccent,
                              icon: Icons.connect_without_contact,
                              title: 'Connection Successful',
                              subtitle: 'Connected to vehicle',
                              buttonTitle: 'Start Ride',
                              onBack: () {},
                              onClick: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RideScreen(
                                            vid: result,
                                          )),
                                );
                              });
                        } else {
                          fullScreenMessageDialog(
                              context: context,
                              color: Colors.redAccent,
                              icon: Icons.error,
                              title: 'Connection Error',
                              subtitle: 'Unable to connect to vehicle',
                              onBack: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                                /*Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Scan()),
                        );*/
                              });
                        }
                      });
                    } else {
                      fullScreenMessageDialog(
                          context: context,
                          color: Colors.redAccent,
                          icon: Icons.error,
                          title: 'Scan Error',
                          subtitle: 'Please Scan Valid QR Code',
                          onBack: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            /*Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Scan()),
                          );*/
                          });
                    }
                  });
            } catch (e) {
              fullScreenMessageDialog(
                  context: context,
                  color: Colors.redAccent,
                  icon: Icons.error,
                  title: 'Scan Error',
                  subtitle: 'Please Scan Valid QR Code',
                  onBack: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  });
              print(e);
            }
          }
        });
        /*
            DbCollection vehicle = mongoDB.db.collection('vehicles');
            DbCollection vehicleScan = mongoDB.db.collection('vehicleScans');
            await vehicle
                .find({'vehicleId': result})
                .toList()
                .then((vehicle) async {
                  if (vehicle.length != 0) {
                    ObjectId _id = vehicle.first['_id'];
                    var addVehicleScan =
                        await vehicleScan.insertOne(<String, dynamic>{
                      'userId': userProvider.user.id,
                      'vehicleId': _id.$oid.toString(),
                      "timestamp": DateTime.now().toString()
                    });
                    if (vehicle.first['enabled']) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RideScreen()),
                      );
                    } else {
                      Navigator.pop(context);
                      showDialog(
                          context: context,
                          builder: (context) {
                            return CustomDialog(
                                icon: Icons.error_outline,
                                text: "Vehicle Not Available",
                                buttonlabel: 'Ok',
                                buttonPressed: () async {
                                  Navigator.pop(context);
                                });
                          });
                    //  alertDialog(context, "Message", "Vehicle Not Available", "Ok");
                    }
                  } else {
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        builder: (context) {
                          return CustomDialog(
                              icon: Icons.error_outline,
                              text: "Invalid QR Code",
                              buttonlabel: 'Ok',
                              buttonPressed: () async {
                                Navigator.pop(context);
                              });
                        });
                    //alertDialog(context, "QR Code Error", "Invalid QR Code", "Ok");
                  }
                });*/
      },
      overlay: QrScannerOverlayShape(
          overlayColor: Theme.of(context).scaffoldBackgroundColor,
          borderColor: Theme.of(context).accentColor,
          borderRadius: 10,
          borderLength: w * 0.05,
          borderWidth: 8,
          cutOutSize: w * 0.75),
    );
  }
}
