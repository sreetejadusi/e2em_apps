import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:row_collection/row_collection.dart';

class LaunchCountdown extends StatefulWidget {
  final DateTime launchDate;

  const LaunchCountdown(this.launchDate);

  @override
  State createState() => _LaunchCountdownState();
}

class _LaunchCountdownState extends State<LaunchCountdown>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    setState(() {});
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: widget.launchDate.difference(DateTime.now()).inSeconds,
      ),
    );
    _controller.forward(from: 0.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.launchDate.isBefore(DateTime.now())
        ? SizedBox.shrink()
        : Countdown(
            animation: StepTween(
              begin: widget.launchDate.millisecondsSinceEpoch,
              end: DateTime.now().millisecondsSinceEpoch,
            ).animate(_controller),
            launchDate: widget.launchDate,
          );
  }
}

class Countdown extends AnimatedWidget {
  final Animation<int> animation;
  final DateTime launchDate;

  const Countdown({
    Key key,
    this.animation,
    this.launchDate,
  }) : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Duration _launchDateDiff = launchDate.difference(DateTime.now());
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Icon(
          Icons.timer,
          size: 15,
        ),
        SizedBox(
          width: 3,
        ),
        _countdownChild(
          context: context,
          title: digitsToString(
            (_launchDateDiff.inHours % 24) ~/ 10,
            (_launchDateDiff.inHours % 24) % 10,
          ),
        ),
        Text(
          ':',
          style: TextStyle(
            color: Theme.of(context).textTheme.caption.color,
            shadows: <Shadow>[
              Shadow(
                offset: Offset(0, 0),
                blurRadius: 1,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
        _countdownChild(
          context: context,
          title: digitsToString(
            (_launchDateDiff.inMinutes % 60) ~/ 10,
            (_launchDateDiff.inMinutes % 60) % 10,
          ),
        ),
        Text(
          ':',
          style: TextStyle(
            color: Theme.of(context).textTheme.caption.color,
            shadows: <Shadow>[
              Shadow(
                offset: Offset(0, 0),
                blurRadius: 2,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
        _countdownChild(
          context: context,
          title: digitsToString(
            (_launchDateDiff.inSeconds % 60) ~/ 10,
            (_launchDateDiff.inSeconds % 60) % 10,
          ),
        ),
      ],
    );
  }

  Widget _countdownChild({
    BuildContext context,
    String title,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _countdownText(context: context, text: title),
      ],
    );
  }

  Widget _countdownText({BuildContext context, String text}) {
    return Text(
      text,
      style: TextStyle(
        color: Theme.of(context).textTheme.caption.color,
        shadows: <Shadow>[
          Shadow(
            offset: Offset(0, 0),
            blurRadius: 2,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }

  String digitsToString(int digit0, int digit1) =>
      digit0.toString() + digit1.toString();
}
