
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SpeedMeter extends StatelessWidget {
  const SpeedMeter({required this.speed, this.size = 150});

  final double speed;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        painter: SpeedometerPainter(
          speed: speed,
        ),
        size: Size(size, size));
  }
}

class SpeedometerPainter extends CustomPainter {
  SpeedometerPainter({
    required this.speed,
  });

  final double speed;

  late Size size;
  late Canvas canvas;
  late Offset center;
  late Paint paintObject;

  @override
  void paint(Canvas canvas, Size size) {
    _init(canvas, size);

    //_drawOuterCircle();
    // _drawInnerCircle();
    //_drawMarkers();
    _drawSpeedIndicators(size);
    //_drawNeedle(0.15 + (speed / 100), Colors.blue, size.width / 70);
    //_drawNeedleHolder();
    _drawSpeed();
  }

  void _drawSpeedIndicators(Size size) {
    for (double percentage = 0.10; percentage <= 0.90; percentage += 2.6 / 80) {
     // print(percentage);
      _drawSpeedIndicator(percentage);
    }

    for (double percentage = 0.10;
    percentage < 0.10 + (speed / 31.9);
    percentage += 2.6 / 80) {
     // print(percentage);
      _drawSpeedIndicator(percentage, true);
    }
  }

  void _drawMarkers() {
    paintObject.style = PaintingStyle.fill;

    for (double relativeRotation = 0.15;
    relativeRotation <= 0.851;
    relativeRotation += 0.01) {
      double normalizedDouble =
      double.parse((relativeRotation - 0.15).toStringAsFixed(2));
      int normalizedPercentage = (normalizedDouble * 100).toInt();
      bool isBigMarker = normalizedPercentage % 10 == 0;

      _drawRotated(relativeRotation, () => _drawMarker(isBigMarker));

      if (isBigMarker) {
        _drawRotated(
            relativeRotation,
                () => _drawSpeedScaleText(
                relativeRotation, normalizedPercentage.toString()));
      }
    }
  }

  void _drawSpeedIndicator(double relativeRotation, [bool highlight = false]) {
    paintObject.shader = null;
    paintObject.strokeWidth = 1;
    paintObject.style = PaintingStyle.stroke;
    paintObject.color = Colors.transparent;

    if (highlight) {
      paintObject.color = Color.lerp(
          Colors.yellow,Colors.red,(relativeRotation - 0.15) / 0.7)!;
      paintObject.style = PaintingStyle.fill;
    }

    Path markerPath = Path()
      ..addRect(Rect.fromLTRB(
          center.dx - size.width / 35,
          size.width - (size.width / 45),
          center.dx,
          size.width - (size.width / 140)));

    _drawRotated(relativeRotation, () {
      canvas.drawPath(markerPath, paintObject);
    });
  }

  void _init(Canvas canvas, Size size) {
    this.canvas = canvas;
    this.size = size;
    center = size.center(Offset.zero);
    paintObject = Paint();
  }

  void _drawNeedleHolder() {
    RadialGradient gradient = RadialGradient(
        colors: [
          Colors.blue,
          Colors.greenAccent,
          Colors.lightBlue,
          Colors.greenAccent
        ],
        radius: 1.2,
        stops: [0.0, 0.7, 0.9, 1.0]);

    paintObject
      ..color = Colors.blueGrey
      ..shader = gradient.createShader(Rect.fromCenter(
          center: center, width: size.width / 20, height: size.width / 20));

    canvas.drawCircle(size.center(Offset.zero), size.width / 15, paintObject);
  }

  void _drawRotated(double angle, Function drawFunction) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle * pi * 2);
    canvas.translate(-center.dx, -center.dy);
    drawFunction();
    canvas.restore();
  }

  void _drawMarker(bool isBigMarker) {
    paintObject
      ..color = Colors.blue
      ..shader = null;

    Path markerPath = Path()
      ..addRect(Rect.fromLTRB(
        center.dx - size.width / (isBigMarker ? 200 : 300),
        center.dy + (size.width / 2.2),
        center.dx + size.width / (isBigMarker ? 200 : 300),
        center.dy + (size.width / (isBigMarker ? 2.5 : 2.35)),
      ));

    canvas.drawPath(markerPath, paintObject);
  }

  void _drawSpeedScaleText(double rotation, String text) {
    TextSpan span = new TextSpan(
        style: new TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue,
            fontSize: size.width / 20),
        text: text);
    TextPainter textPainter = TextPainter(
        text: span,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center);

    textPainter.layout();

    final textCenter = Offset(
        center.dx, size.width - (size.width / 5.5) + (textPainter.width / 2));

    final textTopLeft = Offset(textCenter.dx - (textPainter.width / 2),
        textCenter.dy - (textPainter.height / 2));

    canvas.save();

    // Rotate the canvas around the position of the text so that the text is oriented properly

    canvas.translate(textCenter.dx, textCenter.dy);
    canvas.rotate(-rotation * pi * 2);
    canvas.translate(-textCenter.dx, -textCenter.dy);

    textPainter.paint(canvas, textTopLeft);

    canvas.restore();
  }

  void _drawSpeed() {
    TextPainter textPainter1 = TextPainter(
        text: new TextSpan(
            style: new TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.yellow,
                fontSize: size.width / 5.5),
            text: '${speed.toStringAsFixed(0)}'),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center);
    textPainter1.layout();
    textPainter1.paint(
        canvas,
        Offset(center.dx - (textPainter1.width / 2),
            center.dy - 5 - (textPainter1.width / 2)));
    /* TextPainter textPainter2 = TextPainter(
        text: new TextSpan(
            style: new TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.yellow,
                fontSize: size.width / 10.5),
            text: 'Speed'),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center);
    textPainter2.layout();
    textPainter2.paint(
        canvas,
        Offset(
            center.dx - (textPainter2.width / 2),
            center.dy -
                (size.width / 3) -
                (textPainter2.width / 2) +
                (textPainter2.width / 2)));*/
    /*  TextPainter textPainter3 = TextPainter(
        text: new TextSpan(
            style: new TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.yellow,
                fontSize: size.width / 12.5),
            text: 'Highest : 24'),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center);
    textPainter3.layout();
    textPainter3.paint(
        canvas,
        Offset(
            center.dx - (textPainter3.width / 2),
            center.dy +
                (size.width / 8) -
                (textPainter3.width / 2) +
                (textPainter3.width / 2)));*/


  }

  void _drawNeedle(double rotation, Color color, double width) {
    paintObject
      ..style = PaintingStyle.fill
      ..color = color;

    Path needlePath = Path()
      ..moveTo(center.dx - width, center.dy)
      ..lineTo(center.dx + width, center.dy)
      ..lineTo(center.dx, center.dy + size.width / 2.5)
      ..moveTo(center.dx - width, center.dy);

    _drawRotated(rotation, () {
      canvas.drawPath(needlePath, paintObject);
    });
  }

  void _drawInnerCircle() {
    paintObject
      ..color = Colors.red.withOpacity(0.4)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 4, paintObject);
  }

  void _drawOuterCircle() {
    paintObject
      ..color = Colors.blue
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.2, paintObject);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
