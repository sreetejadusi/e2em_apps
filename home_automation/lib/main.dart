import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'sgView.dart';
import 'package:provider/provider.dart';
import 'providers/index.dart';
import 'colors.dart';
import 'screens/index.dart';
import 'sidebar/index.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
  ));
  //await Firebase.initializeApp();
  //await FirebaseMessaging.instance.getInitialMessage();
  Provider.debugCheckInvalidValueType = null;
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with TickerProviderStateMixin {
  //class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData th = ThemeData(
      brightness: Brightness.light,
      //brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundColor,
      // scaffoldBackgroundColor: Color.fromRGBO(3, 9, 23, 1.0),
      primaryColor: primaryColor,
      accentColor: accentColor,
      cardColor: cardColor,
      //canvasColor: canvasColor,
      //dividerColor: dividerColor,
      dialogBackgroundColor: cardColor,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: AppBarTheme(
          color: backgroundColor,
          elevation: 0,
          iconTheme: Theme.of(context).iconTheme),
      popupMenuTheme: PopupMenuThemeData(
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RoomsAndDevicesProvider()),
        ChangeNotifierProvider(create: (_) => DataProvider()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Home Automation',
          theme: th,
          home: Welcome()
          // home: SGView(),
          ),
    );
  }
}
