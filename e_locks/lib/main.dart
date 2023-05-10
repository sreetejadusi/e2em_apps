import 'dart:async';

import 'package:mongo_dart/mongo_dart.dart' hide State;
import 'package:package_info_plus/package_info_plus.dart';
import 'widgets/index.dart';
import 'utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ui/index.dart';
import 'package:provider/provider.dart';
import 'providers/index.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BluetoothProvider()),
        ChangeNotifierProvider(create: (_) => BluetoothDevicesProvider()),
        ChangeNotifierProvider(create: (_) => DataProvider()),
        ChangeNotifierProvider(create: (_) => SavedDevicesProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-LOCKS',
        theme: ThemeData(
          brightness: Brightness.dark,
          appBarTheme: AppBarTheme()
              .copyWith(backgroundColor: Colors.transparent, elevation: 0),
          scaffoldBackgroundColor: Colors.white,
          fontFamily: "NotoSans",
        ),
        home: WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: const Extend()),
      ),
    );
  }
}

class Extend extends StatefulWidget {
  const Extend({Key? key}) : super(key: key);

  @override
  State<Extend> createState() => _ExtendState();
}

class _ExtendState extends State<Extend> {
  bool loggedIn = false;
  bool loading = false;
  //bool connection = true;
  bool updateAvailable = false;
  bool updateMandatory = false;
  late Timer internetCheckTimer;
  load() async {
    BluetoothDevicesProvider bdp = context.read<BluetoothDevicesProvider>();
    SavedDevicesProvider sdp = context.read<SavedDevicesProvider>();
    setState(() {
      loading = true;
    });
   /* try {
      internetCheckTimer =
          Timer.periodic(const Duration(seconds: 2), (Timer t) async {
        bool conn = await checkInternetConnectivity();
        setState(() {
          connection = conn;
        });
        //if
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      print(e);
    }*/
    sdp.init();
    bdp.changeTabIndex(1);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loggedIn = prefs.getBool('loggedIn') ?? false;
    });
    setState(() {
      loading = false;
    });
    try {
      await mongoDB.init();
      await checkUpdate();
    } catch (e) {
      print(e);
    }
  }

  Future<void> checkUpdate() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String currentVersion = packageInfo.version;
    DbCollection apps_versions = mongoDB.db.collection('apps_versions');

    await apps_versions.find({'name': 'e-locks'}).toList().then((value) async {
          String newVersion = value.first["version"];
          bool mandatory = value.first["mandatory"];
          if (currentVersion == newVersion) {
          } else {
            setState(() {
              updateAvailable = true;
            });
          }
          setState(() {
            updateMandatory = mandatory;
          });
          setState(() {
            loading = false;
          });
        });
  }

  @override
  void initState() {
    load();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DataProvider dp = context.watch<DataProvider>();
    if (loading) {
      return imgBackground(
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
              child: CircularProgressIndicator(
            backgroundColor: appBarColor,
          )),
        ),
      );
    }/* else if (!connection) {
      return const NetworkError();
    } */else if (!dp.skipUpdate && updateAvailable) {
      return imgBackground(
        UpdateScreen(
          mandatory: updateMandatory,
        ),
      );
    } /*else if (!loggedIn) {
      return imgBackground(
        const Login(),
      );
    }*/
    else {
      return imgBackground(
        const Start(),
      );
    }
  }
}
