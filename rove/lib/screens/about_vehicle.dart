import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../widgets/index.dart';

class AboutVehicle extends StatefulWidget {
  const AboutVehicle({Key? key}) : super(key: key);

  @override
  _AboutVehicleState createState() => _AboutVehicleState();
}

class _AboutVehicleState extends State<AboutVehicle>
    with TickerProviderStateMixin {
  final PageController _controller = PageController(
    initialPage: 0,
  );

  int selected = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

/*
 Image.asset(
            'assets/av1.png',
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
*/
  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
  }

  List<Widget> widgets() {
    return [
      item(image: 'assets/av1.png', text: "Weight just 26.9 lbs"),
      item(
          image: 'assets/av2.png',
          text:
              "Portable folding design for easy storage at home or hand carry when necessary"),
      item(
          image: 'assets/av1.png',
          text:
              " High capacity battery with a maximum travel range of up to 18.6 miles under specific conditions"),
      item(
          image: 'assets/av2.png',
          text:
              "The sturdy frame is made of aerospace-grade aluminum, and a special Red Safety"),
      item(
          image: 'assets/av1.png',
          text:
              "Our Smart Battery Management System ensures the battery safety, and extends the battery life"),
      item(
          image: 'assets/av2.png',
          text:
              "The large 8.5-inch front pneumatic tires make riding comfortable, even on rough road or bump terrain"),
      item(
          image: 'assets/av1.png',
          text:
              "A 250W motor propels the e-scooter to a max speed of 15.5 MPH"),
    ];
  }

  Widget item({String? image, String? text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Image.asset(
            image!,
            width: MediaQuery.of(context).size.height * 0.40,
            height: MediaQuery.of(context).size.height * 0.40,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Text(
            text!,
            // minFontSize: 5,
            textAlign: TextAlign.center,
            style: GoogleFonts.breeSerif(
                fontSize: 25, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(
              widgets().length,
              (index) => Container(
                margin: EdgeInsets.symmetric(horizontal: 7),
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                  color: selected == index
                      ? Theme.of(context).colorScheme.secondary
                      : Colors.white70,
                  border: Border.all(
                      color: selected == index
                          ? Theme.of(context).colorScheme.secondary
                          : Colors.white70),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: MoveBackButton(
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: HeaderText(text: 'About Vehicle'),
            ),
            Expanded(
              child: PageView(
                physics: BouncingScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    selected = index;
                  });
                },
                controller: _controller,
                children: widgets(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
