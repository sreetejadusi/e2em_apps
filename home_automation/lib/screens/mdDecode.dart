import 'package:google_fonts/google_fonts.dart';

import '../widgets/index.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MdDecode extends StatefulWidget {
  final String title;
  final String data;
  MdDecode({this.title, this.data});
  @override
  _MdDecodeState createState() => _MdDecodeState();
}

class _MdDecodeState extends State<MdDecode> {
  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        elevation: 4,
        title: Text(
          '${widget.title}',
          style: GoogleFonts.breeSerif(
            textStyle: TextStyle(),
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [],
        centerTitle: true,
      ),
      body: Markdown(
        data: widget.data,
        styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
          blockSpacing: 12,
          h2: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
            fontFamily: 'ProductSans',
          ),
          p: TextStyle(
            fontSize: 17,
            color: Theme.of(context).textTheme.caption.color,
          ),
        ),
      ),
    );
  }
}
