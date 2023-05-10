import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../providers/index.dart';
import 'package:provider/provider.dart';

String addLeadingZeros(int num) => num.toString().padLeft(2, '0');

func({required BuildContext context}) {
  DataProvider dp = context.read<DataProvider>();
  dp.updateLastChange(DateTime.now());
  dp.updateChanging(true);
  /*Future.delayed(const Duration(seconds: 2), () {
    if (DateTime.now().difference(dp.lastChange).inSeconds > 3) {
      dp.updateSliderValue(0);
      dp.updateChanging(false);
    }
  });*/
}

String getTimeString({required BuildContext context, required double ratio}) {
  DataProvider dp = context.read<DataProvider>();
  String dis = "00:00";
  for (int i = 1; i < times.keys.length; i++) {
    //if(){}
  }
  times.keys.toList().forEach((element) {});
  return dis;
}

Widget durationPicker(
    {required BuildContext context,
    required double val,
    required String timerTime,
    required Function(int min) onTap}) {
  DataProvider dp = context.read<DataProvider>();
  double lineThickness = 0.17;
  double sliderValue = dp.sliderValue;
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      if (dp.timerOn) ...[
        Text(
          "00:00",
          style: GoogleFonts.breeSerif(
            textStyle: const TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.normal),
          ),
        ),
      ],
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.65,
        height: MediaQuery.of(context).size.width * 0.65,
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            SfRadialGauge(axes: <RadialAxis>[
              RadialAxis(
                  axisLineStyle: AxisLineStyle(
                    thickness: lineThickness,
                    color: Colors.grey.shade300,
                    thicknessUnit: GaugeSizeUnit.factor,
                    cornerStyle: CornerStyle.bothCurve,
                  ),
                  showTicks: false,
                  showLabels: false,
                  minimum: 1,
                  maximum: dp.timerOn ? 100 : times.keys.length.toDouble(),
                  startAngle: 120,
                  endAngle: 60,
                  labelOffset: -30,
                  pointers: <GaugePointer>[
                    RangePointer(
                        color: Colors.blue,
                        value: sliderValue,
                        cornerStyle: CornerStyle.startCurve,
                        width: lineThickness,
                        sizeUnit: GaugeSizeUnit.factor),
                    MarkerPointer(
                      value: sliderValue,
                      overlayRadius: 0,
                      borderColor: dp.timerOn ? Colors.blue : Colors.black,
                      //overlayColor: Colors.black,
                      borderWidth: dp.timerOn ? 10 : 15,
                      color: Colors.black,
                      onValueChanged: dp.online
                          ? (double value) {
                              if (dp.timerOn) {
                              } else {
                                dp.updateSliderValue(value);
                                func(context: context);
                              }
                            }
                          : (double value) {},
                      elevation: 0,
                      enableDragging: true,
                      markerType: MarkerType.circle,
                    ),
                  ],
                  annotations: [])
            ]),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 5,
                ),
                Text(
                  dp.changing
                      ? times.values.toList()[sliderValue.toInt()].toString()
                      : timerTime,
                  style: GoogleFonts.breeSerif(
                    textStyle: TextStyle(
                        color: Colors.blue,
                        fontSize: 47,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                if (!dp.changing && !dp.timerOn) ...[
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Run Time",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.w600),
                  ),
                ],
                const SizedBox(
                  height: 5,
                ),
                if (dp.timerOn || dp.changing) ...[
                  ActionChip(
                    label: Text(
                      dp.timerOn
                          ? "Cancel"
                          : dp.changing
                              ? "Set"
                              : "",
                      style: GoogleFonts.breeSerif(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontSize: 20),
                      ),
                    ),
                    onPressed: () {
                      if (dp.timerOn) {
                        onTap(0);
                      } else if (dp.changing) {
                        onTap(times.keys.toList()[sliderValue.toInt()]);
                      } else {}
                    },
                  ),
                ],
                if (dp.changing && !dp.timerOn) ...[
                  const SizedBox(
                    height: 5,
                  ),
                  InkWell(
                      onTap: () {
                        dp.updateSliderValue(1);
                        dp.updateChanging(false);
                      },
                      child: Icon(Icons.close)),
                ],
              ],
            ),
          ],
        ),
      ),
      if (dp.timerOn) ...[
        Text(
          addLeadingZeros((dp.totalTimer - dp.totalTimer.remainder(60)) ~/ 60) +
              ":" +
              addLeadingZeros(dp.totalTimer.remainder(60)),
          style: GoogleFonts.breeSerif(
            textStyle: const TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.normal),
          ),
        ),
      ],
    ],
  );
  /* Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      if (dp.timerOn) ...[
        Text(
          "00:00",
          style: GoogleFonts.breeSerif(
            textStyle: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.normal),
          ),
        ),
      ],
      SleekCircularSlider(
        enabled: !dp.timerOn,
        appearance: CircularSliderAppearance(
          animationEnabled: false,
          angleRange: 305,
          startAngle: 120,
          size: MediaQuery.of(context).size.width * 0.60,
          customColors: CustomSliderColors(
            progressBarColor: Colors.blue,
            trackColor: Colors.grey.shade300,
            dotColor: Colors.black,
            shadowColor: bgColor,
          ),
          customWidths: CustomSliderWidths(
            shadowWidth: 0,
            trackWidth: 20,
            progressBarWidth: 20,
            handlerSize: dp.timerOn ? 0 : 10,
          ),
        ),
        min: 1,
        max: dp.timerOn ? 100 : times.length.toDouble(),
        initialValue: val,
        //dp.sliderValue,
        // initialValue:1,
        //  dp.timerOn && !cal ? ((dp.timerMin / dp.totalTimer) * 100) : 1,
        onChange: (value) async {
          func(context: context);
        },
        innerWidget: (double value) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 5,
              ),
              Text(
                dp.changing
                    ? times.keys.toList()[value.toInt() - 1]
                    : timerTime,
                style: GoogleFonts.breeSerif(
                  textStyle: TextStyle(
                      color: Colors.blue,
                      fontSize: 47,
                      fontWeight: FontWeight.bold),
                ),
              ),
              if (!dp.changing && !dp.timerOn) ...[
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "Run Time",
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.w600),
                ),
              ],
              const SizedBox(
                height: 10,
              ),
              ActionChip(
                label: Text(
                  dp.timerOn
                      ? "Cancel"
                      : dp.changing
                          ? "Set"
                          : "",
                  style: GoogleFonts.breeSerif(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: 20),
                  ),
                ),
                onPressed: () {
                  if (dp.timerOn) {
                    onTap(0);
                  } else {
                    onTap(times.values.toList()[value.toInt() - 1]);
                  }
                },
              ),
            ],
          );
        },
      ),
      if (dp.timerOn) ...[
        Text(
          addLeadingZeros((dp.totalTimer - dp.totalTimer.remainder(60)) ~/ 60) +
              ":" +
              addLeadingZeros(dp.totalTimer.remainder(60)),
          style: GoogleFonts.breeSerif(
            textStyle: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.normal),
          ),
        ),
      ],
    ],
  );*/
}
