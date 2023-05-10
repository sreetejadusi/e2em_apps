import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ui/index.dart';
import 'package:provider/provider.dart';
import 'providers/index.dart';

void main() {
  WidgetsFlutterBinding?.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DataProvider()),
        ChangeNotifierProvider(create: (_) => DevicesProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Saathi',
        theme: ThemeData(
          primarySwatch: Colors.grey,
        ),
        home: const Start(),
      ),
    );
  }
}
