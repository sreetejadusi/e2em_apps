import 'package:flutter/material.dart';
import 'package:rove_personnel/utils/index.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

Widget speedometer(double v) {
  double fw = 20;
  double sw = 10;
  return
      SfRadialGauge(
    enableLoadingAnimation: false,
    axes: <RadialAxis>[
      RadialAxis(
          showLabels: false,
          showTicks: false,
          radiusFactor: 0.9,
          maximum: 240,
          axisLineStyle: AxisLineStyle(
              cornerStyle: CornerStyle.bothCurve,
              thickness: sw,
              color: accentColor),
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
                angle: 90,
                widget: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(v.toInt().toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                      child: Text(
                        'km/h',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20),
                      ),
                    )
                  ],
                )),
            GaugeAnnotation(
              angle: 124,
              positionFactor: 1.2,
              widget: Text('0', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700)),
            ),
            GaugeAnnotation(
              angle: 54,
              positionFactor: 1.2,
              widget: Text('240', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700)),
            ),
          ],
          pointers: <GaugePointer>[
            RangePointer(
              value: v,
              width: fw,
              pointerOffset: -(fw - sw) / 2,
              cornerStyle: CornerStyle.bothCurve,
              color: Color(0xFF70CFA3),
              gradient: SweepGradient(
                  colors: <Color>[Color(0xFF70CFA3), Color(0xFF70CFA3)],
                  stops: <double>[0.25, 0.75]),
            ),
            MarkerPointer(
              value: v - (fw / 3),
              borderWidth: (fw / 5),
              color: Colors.black,
              borderColor: Colors.black,
              markerType: MarkerType.circle,
            ),
          ]),
    ],
  );
}
