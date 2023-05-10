import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hub/ble_unlock/bluetooth_provider.dart';
import 'package:hub/ble_unlock/saved_device_model.dart';
import 'package:hub/ble_unlock/saved_devices_provider.dart';
import 'package:provider/provider.dart';

import 'ble_unlock/bluetooth_devices_provider.dart';
import 'ble_unlock/devices_screen.dart';
import 'index_files.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: accentColor1,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(
    const RestartWidget(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HubManager()),
        ChangeNotifierProvider(create: (_) => AdminManager()),
        ChangeNotifierProvider(create: (_) => DataProvider()),
        ChangeNotifierProvider(create: (_) => WalletProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => VehiclesProvider()),
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (_) => SavedDevicesProvider()),
        ChangeNotifierProvider(create: (_) => BluetoothDevicesProvider()),
        ChangeNotifierProvider(create: (_) => BluetoothProvider()),
      ],
      child: MaterialApp(
        title: "EV2GO",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          appBarTheme: AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            iconTheme: const IconThemeData().copyWith(color: Colors.white),
          ),
        ),
        //home: const Scaffold(body: DevicesScreen()),
        home: const Extend(),
      ),
    );
  }
}

class RestartWidget extends StatefulWidget {
  const RestartWidget({super.key, this.child});

  final Widget? child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()?.restartApp();
  }

  @override
  State<StatefulWidget> createState() {
    return _RestartWidgetState();
  }
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child ?? Container(),
    );
  }
}

class Extend extends StatefulWidget {
  const Extend({Key? key}) : super(key: key);

  @override
  State<Extend> createState() => _ExtendState();
}

class _ExtendState extends State<Extend> {
  bool loading = false;
  bool dbTriggered = false;
  late Timer internetCheckTimer;

  load() async {
    UserProvider up = context.read<UserProvider>();
    AuthenticationProvider ap = context.read<AuthenticationProvider>();
    setState(() {
      loading = true;
    });

    internetCheckTimer =
        Timer.periodic(const Duration(seconds: 2), (Timer t) async {
      //print("internetCheckTimer");
      //bool iConn = await checkInternetConnectivity();
      //await up.updateInternetConnectionStatus(iConn);
      bool sConn = mongoDB.db.isConnected;
      up.updateServerConnectionStatus(sConn);
      setState(() {
        dbTriggered = false;
      });
    });

    setState(() {
      //loading = false;
    });
    try {
      await mongoDB.init();
      await ap.init(context);
    } catch (e) {
      setState(() {
        loading = false;
      });
      if (kDebugMode) {
        print(e);
      }
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    load();
    super.initState();
  }

  @override
  void dispose() {
    internetCheckTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationProvider ap = context.watch<AuthenticationProvider>();
    if (loading) {
      return Scaffold(
        backgroundColor: backgroundColor,
        body: Center(
            child: CircularProgressIndicator(
          backgroundColor: accentColor1,
        )),
      );
    } else if (ap.loginType == LoginType.none) {
      return const SignIn();
    } else if (ap.loginType == LoginType.admin) {
      return const AdminStart();
    } else if (ap.loginType == LoginType.hub) {
      return const Start();
    } else {
      return Scaffold(
        backgroundColor: backgroundColor,
        body: Center(
            child: CircularProgressIndicator(
          backgroundColor: accentColor1,
        )),
      );
    }
  }
}
