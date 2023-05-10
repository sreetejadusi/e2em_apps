import 'package:flutter/material.dart';
import 'ui/index.dart';
import 'package:provider/provider.dart';
import 'providers/index.dart';

void main() {
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
        ChangeNotifierProvider(create: (_) => SavedDevicesProvider()),
      ],
      child: MaterialApp(
        title: 'Trydan',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          scaffoldBackgroundColor: const Color(0xFFf8fdff),
          primaryColor: const Color(0xFF6bc6a5),
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(
                secondary: const Color(0xFF0a5688),
                brightness: Brightness.light,
              )
              .copyWith(secondary: Colors.white),
          fontFamily: "SFProDisplay",
        ),
        //home: const Login(),
        home: const Start(),
      ),
    );
  }
}
