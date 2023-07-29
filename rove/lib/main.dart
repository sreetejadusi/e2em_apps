import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/index.dart';
import 'colors.dart';
import 'screens/index.dart';

//import 'doorLock/index.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
  ));
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.getInitialMessage();
  Provider.debugCheckInvalidValueType = null;
  runApp(App());
}

class App extends StatelessWidget {
  @override
  /*Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OnOffProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Lock',
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Color.fromRGBO(3, 9, 23, 1.0),
          primaryColor: primaryColor,
          accentColor: accentColor,
          cardColor: cardColor,
          canvasColor: canvasColor,
          dividerColor: dividerColor,
          dialogBackgroundColor: cardColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: AppBarTheme(color: backgroundColor,elevation: 0),
          popupMenuTheme: PopupMenuThemeData(
            color: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
        home: Welcome(),
      ),
    );
  }*/
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => TransactionsProvider()),
        ChangeNotifierProvider(create: (_) => WalletProvider()),
        ChangeNotifierProvider(create: (_) => NotificationsProvider()),
        ChangeNotifierProvider(create: (_) => DataProvider()),
        ChangeNotifierProvider(create: (_) => ImagesUrlProvider()),
        //ChangeNotifierProvider(create: (_) => ApplicationBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'HOPP',
        theme: ThemeData(
          brightness: Brightness.dark,
          // scaffoldBackgroundColor: Color.fromRGBO(3, 9, 23, 1.0),
          scaffoldBackgroundColor: Colors.black,
          primaryColor: primaryColor,
          // accentColor: accentColor,
          cardColor: cardColor,
          canvasColor: canvasColor,
          dividerColor: dividerColor,
          dialogBackgroundColor: cardColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: const AppBarTheme(color: Colors.black, elevation: 0),
          popupMenuTheme: PopupMenuThemeData(
            color: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
        //  home: FlutterBlueApp(),
        home: Welcome(),
      ),
    );
  }
}
