import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../utils/index.dart';
import 'package:auto_size_text/auto_size_text.dart';

Widget bottomTile(BuildContext context) {
  final w = MediaQuery.of(context).size.width;
  final h = MediaQuery.of(context).size.height;
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: SizedBox(
      height: h * 0.10,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          bottomOption(context, Icons.electric_bike, "Ride Details"),
          bottomOption(context, Icons.data_usage, "My Rides"),
          bottomOption(context, Icons.health_and_safety, "Vehicle Status"),
        ],
      ),
    ),
  );
}

Widget bottomOption(BuildContext context, IconData icon, String text) {
  final w = MediaQuery.of(context).size.width;
  final h = MediaQuery.of(context).size.height;
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        decoration: BoxDecoration(
          color: secondAccentColor,
          borderRadius: BorderRadius.circular(500),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon, size: 30,
                color: Color(0xFF17FEF2),
                //olor: Colors.black,
              ),
              SizedBox(
                height: 5,
              ),
              AutoSizeText(
                text,
                maxFontSize: 15,
                minFontSize: 2,
                style: TextStyle(fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

///SPEEDOMETER
Widget speedometer(BuildContext context, int speed, int battery) {
  final w = MediaQuery.of(context).size.width;
  final h = MediaQuery.of(context).size.height;
  double height = h * 0.35;
  return Stack(
    alignment: Alignment.center,
    children: [
      SizedBox(
        height: height,
        child: SfRadialGauge(
          axes: <RadialAxis>[
            RadialAxis(
                showLabels: false,
                showTicks: false,
                maximum: 30,
                minimum: 0,
                startAngle: 180,
                endAngle: 360,
                radiusFactor: 0.8,
                axisLineStyle: const AxisLineStyle(
                  cornerStyle: CornerStyle.bothCurve,
                  thicknessUnit: GaugeSizeUnit.factor,
                  color: Color(0xFF17FEF2),
                  thickness: 0.15,
                ),
                annotations: <GaugeAnnotation>[
                  GaugeAnnotation(
                    angle: 170,
                    positionFactor: 1.0,
                    widget: Text('0',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700)),
                  ),
                  GaugeAnnotation(
                    angle: 10,
                    positionFactor: 1.0,
                    widget: Text('30',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700)),
                  ),
                ],
                pointers: <GaugePointer>[
                  RangePointer(
                      value: speed.toDouble(),
                      cornerStyle: CornerStyle.bothCurve,
                      enableAnimation: true,
                      animationDuration: 1200,
                      sizeUnit: GaugeSizeUnit.factor,
                      color: firstAccentColor,
                      width: 0.15),
                ]),
          ],
        ),
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: height * 0.5,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '20',
                    style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'km/h',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          batteryIndicator(context, battery),
        ],
      ),
    ],
  );
}

///BATTERY INDICATOR
Widget batteryIndicator(BuildContext context, int percentage) {
  final w = MediaQuery.of(context).size.width;
  final h = MediaQuery.of(context).size.height;
  double height = h * 0.06;
  double innerW = ((height * 2) - 6 - 6) / 6.5;
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        height: height,
        width: height * 2,
        decoration: BoxDecoration(
          color: scaffoldBackgroundColor,
          border: Border.all(color: Colors.grey, width: 3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
          child: Stack(
            children: [
              Row(
                // mainAxisSize: MainAxisSize.min,
                //crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (int i = 0; i < 5; i++) ...[
                    percentage > (i + 1) * 20 ||
                            percentage > ((i + 1) * 20) - 19
                        ? Container(
                            width: innerW,
                            decoration: BoxDecoration(
                              color: Color(0xFF51BE25),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          )
                        : Container(
                            width: innerW,
                            decoration: BoxDecoration(
                              color: scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                  ],

                  /*  Container(
                    decoration: BoxDecoration(
                      color: scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),*/
                ],
              ),
              Center(
                child: Text(
                  percentage.toString() + "%",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
      SizedBox(
        width: 3,
      ),
      Container(
        width: height * 0.20,
        height: height * 0.50,
        decoration: const BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(0),
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(5),
            topRight: Radius.circular(5),
          ),
        ),
      ),
    ],
  );
}

Widget helloTile(BuildContext context, String name, bool loading) {
  final w = MediaQuery.of(context).size.width;
  final h = MediaQuery.of(context).size.height;
  return SizedBox(
    height: h * 0.07,
    child: Row(
      children: [
        Container(
          width: w * 0.50,
          decoration: const BoxDecoration(
            color: firstAccentColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0),
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(500),
              topRight: Radius.circular(500),
            ),
          ),
          child: Center(
            child: Text(
              "Hello " + name,
              style: TextStyle(fontSize: 17),
            ),
          ),
        ),
        Expanded(
            child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Opacity(
            opacity: loading ? 1 : 0,
            child: LinearProgressIndicator(
              color: Colors.white,
            ),
          ),
        )),
        //Spacer(),
      ],
    ),
  );
}

Widget optionsTile(
    BuildContext context, TabController tc, Function(int index) tap) {
  final w = MediaQuery.of(context).size.width;
  final h = MediaQuery.of(context).size.height;
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: Card(
      color: firstAccentColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      /*Container(
      //height: h * 0.10,
      decoration: BoxDecoration(
        color: firstAccentColor,
        borderRadius: BorderRadius.circular(50),
      ),*/
      child: TabBar(
        indicatorPadding: const EdgeInsets.all(5),
        indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(10), // Creates border
            color: secondAccentColor),
        /* indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.transparent),*/
        controller: tc,
        onTap: (int index) {
          tap(index);
        },
        tabs: [

          option(context, 10, Colors.red, Icons.control_camera, "Manual"),

          option(context, 19, Colors.blue, Icons.pedal_bike, "Pedal Assist"),

          option(context, 15, Colors.yellow, Icons.downhill_skiing,
              "Hill Asssist"),

          option(context, 12, Colors.deepOrange, Icons.rotate_90_degrees_ccw,
              "Throttle"),
          option(context, 12, Colors.green, Icons.cable_outlined,
              "Cruise"),

        ],
      ),
    ),
  );
}

Widget option(
    BuildContext context, int val, Color color, IconData icon, String text) {
  final w = MediaQuery.of(context).size.width;
  final h = MediaQuery.of(context).size.height;
  return Padding(
    padding: const EdgeInsets.only(top: 5, bottom: 5),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Tab(
          icon: Icon(
            icon,
            color: color,
          ),
          child: Text(

            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10),
          ),
        ),
        /* Chip(
          label: Text(val.toString()),
          backgroundColor: scaffoldBackgroundColor,
        ),*/
      ],
    ),
  );
}

Widget modeTile(BuildContext context) {
  final w = MediaQuery.of(context).size.width;
  final h = MediaQuery.of(context).size.height;
  return Container(
    height: h * 0.05,
    decoration: BoxDecoration(
      color: firstAccentColor,
      borderRadius: BorderRadius.circular(500),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: const [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Text(
              "Riding Mode",
              style: TextStyle(fontSize: 17),
            ),
          ),
        ),
      ],
    ),
  );
}
