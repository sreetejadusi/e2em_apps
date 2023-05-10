import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'index.dart';
import '../providers/index.dart';
import '../widgets/index.dart';

class Initialization extends StatefulWidget {
  @override
  _InitializationState createState() => _InitializationState();
}

class _InitializationState extends State<Initialization> {
  Future<void> load() async {
    await context.read<UserProvider>().init();
    //await mongoDB.init();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
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
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
