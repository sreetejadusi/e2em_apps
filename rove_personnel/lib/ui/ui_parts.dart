import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'index.dart';

import '../utils/index.dart';

Widget helloTile(BuildContext context, bool control) {
  final w = MediaQuery.of(context).size.width;
  final h = MediaQuery.of(context).size.height;
  return ListTile(
    title: Text(
      "Hello Guna",
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    ),
    trailing: control
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.electric_moped,
                size: 25,
                color: Color(0xFF767777),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "106 km",
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF767777),
                ),
              ),
            ],
          )
        : null,
  );
}

Widget temp(BuildContext context) {
  final w = MediaQuery.of(context).size.width;
  final h = MediaQuery.of(context).size.height;
  return Container(
    height: h * 0.12,
    decoration: const BoxDecoration(
      color: accentColor,
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 25, top: 5, bottom: 5),
          child: Image.asset(
            "assets/sun.png",
            height: h * 0.05,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 45),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "28" + "°C",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              Text(
                "Cloudy",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget sm(BuildContext context, double speed) {
  final w = MediaQuery.of(context).size.width;
  final h = MediaQuery.of(context).size.height;
  return Container(height: h * 0.22, child: speedometer(speed));
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
        subtitle: "4h 30min",
      ),
      StatCard(
        gradient:
            LinearGradient(colors: [Color(0xFF69F0B2), Color(0xFF4ED1F9)]),
        icon: Icons.flash_on,
        perc: SOC,
        title: "SOC",
        subtitle: "4h 30min",
      ),
      StatCard(
        gradient:
            LinearGradient(colors: [Color(0xFFFEAD3F), Color(0xFFF9D34E)]),
        icon: Icons.electric_moped,
        perc: KM,
        title: "KM",
        subtitle: "4h 30min",
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
      required this.perc,
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
                  topRight: Radius.circular(23),
                  bottomLeft: Radius.circular(23),
                  bottomRight: Radius.circular(8),
                  topLeft: Radius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: hh,
                      width: double.infinity,
                      color: accentColor,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: gradient,
                      ),
                      height: lh,
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //SizedBox(width: 15,),
                        Container(
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
                              fontSize: 14, fontWeight: FontWeight.bold),
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
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
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
