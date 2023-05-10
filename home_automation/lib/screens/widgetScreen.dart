import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/index.dart';
import 'package:row_collection/row_collection.dart';
import 'package:provider/provider.dart';
import '../widgets/index.dart';
import '../providers/index.dart';

class WidgetScreen extends StatefulWidget {
  final String title;
  final Widget widget;
  WidgetScreen({this.title, this.widget});
  @override
  _WidgetScreenState createState() => _WidgetScreenState();
}

class _WidgetScreenState extends State<WidgetScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: Theme.of(context).iconTheme,
        elevation: 0,
        title: Text(
          widget.title,
          style: GoogleFonts.breeSerif(
            textStyle: TextStyle(
                color: Theme.of(context).textTheme.caption.color,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [],
        centerTitle: true,
      ),
      body: widget.widget,
    );
  }
}
