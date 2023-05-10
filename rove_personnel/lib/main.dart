import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rove_personnel/ui/enter_phone_number.dart';
import 'utils/index.dart';
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
  Provider.debugCheckInvalidValueType = null;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BluetoothProvider()),
        ChangeNotifierProvider(create: (_) => BluetoothDevicesProvider()),
        ChangeNotifierProvider(create: (_) => DataProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ROVE',
        theme: ThemeData(
            brightness: Brightness.dark,
            //fontFamily: "LexendDeca",
            fontFamily: "SFProDisplay",
            appBarTheme: AppBarTheme().copyWith(backgroundColor: accentColor)),
        home: const Extend(),
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
  PageController controller = PageController(
    initialPage: 0,
  );
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        FittedBox(
          fit: BoxFit.fill,
          child: Image.asset("assets/bg.png"),
        ),
        Start(),
        //Welcome(),
        /*PageView(
          controller: controller,
          children: [

            Start(),
            Welcome(),
            Login(),
            SignUp(),
            EnterPhoneNumber(),
            OTPVerification(),
            ResetPassword(),
          ],
        ),*/
      ],
    );
  }
}
