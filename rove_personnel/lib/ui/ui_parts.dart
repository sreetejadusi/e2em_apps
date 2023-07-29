import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rove_personnel/providers/index.dart';
import 'index.dart';

import '../utils/index.dart';

Widget helloTile(BuildContext context) {
  return Text(
    "Hello Guna",
    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
  );
}

Widget temp(BuildContext context) {
  final w = MediaQuery.of(context).size.width;
  final h = MediaQuery.of(context).size.height;
  DataProvider dataProvider = context.watch<DataProvider>();
  dataProvider.loadWeather(context);
  return Row(
    children: [
      Image.asset(
        "assets/sun.png",
        height: h * 0.04,
      ),
      SizedBox(
        width: 12,
      ),
      Text(
        "${dataProvider.temp.toInt()}°C",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ],
  );
}

Widget sm(BuildContext context, double speed) {
  final w = MediaQuery.of(context).size.width;
  final h = MediaQuery.of(context).size.height;
  return Container(height: h * 0.26, child: speedometer(speed));
}

Widget stats(int SOH, int SOC, int KM) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      StatCard(
        gradient:
            LinearGradient(colors: [Color(0xFFEB5452), Color(0xFFF9774E)]),
        icon: Icons.heart_broken,
        perc: SOH,
        title: "SOH",
        subtitle: SOH.toString() + '%',
      ),
      StatCard(
        gradient:
            LinearGradient(colors: [Color(0xFF69F0B2), Color(0xFF4ED1F9)]),
        icon: Icons.flash_on,
        perc: SOC,
        title: "SOC",
        subtitle: SOC.toString() + '%',
      ),
      StatCard(
        gradient:
            LinearGradient(colors: [Color(0xFFFEAD3F), Color(0xFFF9D34E)]),
        icon: Icons.electric_moped,
        perc: 0,
        title: "KM",
        subtitle: KM.toString() + 'KM',
      ),
    ],
  );
}

class StatCard extends StatelessWidget {
  final LinearGradient gradient;
  final IconData icon;
  final int perc;
  final String title;
  final String subtitle;
  const StatCard(
      {Key? key,
      required this.gradient,
      required this.icon,
      this.perc = 0,
      required this.title,
      required this.subtitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    double ch = h * 0.20;
    double lh = ch * (perc / 100);
    double hh = ch - lh;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Container(
          height: ch,
          decoration: const BoxDecoration(
            color: accentColor,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(23),
              bottomLeft: Radius.circular(23),
              bottomRight: Radius.circular(8),
              topLeft: Radius.circular(8),
            ),
          ),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(24),
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(8),
                  topLeft: Radius.circular(8),
                ),
                // child: Column(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     // Container(
                //     //   height: hh,
                //     //   width: double.infinity,
                //     //   color: accentColor,
                //     // ),
                //     // Container(
                //     //   decoration: BoxDecoration(
                //     //     gradient: gradient,
                //     //   ),
                //     //   height: lh,
                //     //   width: double.infinity,
                //     // ),
                //   ],
                // ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              gradient.colors[1],
                              gradient.colors[0]
                            ]),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Icon(
                              icon,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Text(
                          perc.toString() + "%",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          // SizedBox(
                          //   height: 5,
                          // ),
                          // Text(
                          //   subtitle,
                          //   style: TextStyle(
                          //     fontSize: 15,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
