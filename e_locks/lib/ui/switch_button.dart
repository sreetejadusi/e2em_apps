import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../providers/index.dart';

class SwitchButton extends StatefulWidget {
  final bool enabled;
  final Function() onDown;
  const SwitchButton({Key? key, required this.enabled, required this.onDown})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SwitchButtonState();
  }
}

class _SwitchButtonState extends State<SwitchButton> {
  double paddingTop = 0;
  @override
  Widget build(BuildContext context) {
    DataProvider dp = context.watch<DataProvider>();

    ///
    final h = MediaQuery.of(context).size.height;
    double height = h * 0.30;
    double width = height * 0.45;
    double sidePadding = 15;
    double buttonHeight = height * 0.55;
    double top = 0;
    double bottom = height - buttonHeight - (sidePadding * 2);

    ///
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: width,
      height: height,
      padding: EdgeInsets.all(sidePadding),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(500.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.25), //color of shadow
            spreadRadius: 6, //spread radius
            blurRadius: 12, // blur radius
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            right: 0,
            top: paddingTop,
            child: GestureDetector(
              ///onPanUpdate
              onPanUpdate: dp.unlocked || !widget.enabled
                  ? (DragUpdateDetails details) {}
                  : (DragUpdateDetails details) {
                      setState(() {
                        paddingTop += details.delta.dy;
                        if (paddingTop < top) {
                          paddingTop = top;
                        } else if (paddingTop > bottom) {
                          paddingTop = bottom;
                        } else {}
                      });
                    },

              ///onPanEnd
              onPanEnd: !widget.enabled
                  ? (DragEndDetails details) {}
                  : (DragEndDetails details) {
                      if (!dp.unlocked) {
                        dp.changeUnlocked(true);
                        setState(() {
                          paddingTop = bottom;
                        });
                        Future.delayed(const Duration(seconds: 2), () async {
                          dp.changeUnlocked(false);
                          setState(() {
                            paddingTop = top;
                          });
                        });
                        widget.onDown();
                      } else {}
                    },
              child: Container(
                width: double.infinity,
                height: buttonHeight,
                decoration: BoxDecoration(
                  color:
                      dp.unlocked ? Colors.green.withOpacity(0.5) : Colors.grey,
                  borderRadius: BorderRadius.circular(500),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        height: 5,
                        width: width * 0.2,
                        decoration: BoxDecoration(
                          color: dp.unlocked ? Colors.green : Colors.red,
                          borderRadius: BorderRadius.circular(500.0),
                          boxShadow: [
                            BoxShadow(
                              color: dp.unlocked
                                  ? Colors.green.withOpacity(0.4)
                                  : Colors.red
                                      .withOpacity(0.4), //color of shadow
                              spreadRadius: 5, //spread radius
                              blurRadius: 5, // blur radius
                              offset:
                                  Offset(0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      dp.unlockWaiting
                          ? "Unlocking"
                          : dp.unlocked
                              ? "Unlocked"
                              : "Locked",
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF39424B),
                          borderRadius: BorderRadius.circular(500.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child:
                              Icon(dp.unlocked ? Icons.lock_open : Icons.lock),
                        )),
                  ],
                ),
              ),
            ),
          ),
          if (dp.unlocked || paddingTop > bottom * 0.7) ...[
            ///ARROW UP
            Positioned(
                top: bottom / 3 - sidePadding,
                left: 0,
                right: 0,
                child: RotatedBox(
                  quarterTurns: -2,
                  child: SvgPicture.asset("assets/arrows.svg",
                      color: Colors.red, semanticsLabel: 'u'),
                )),
          ],
          if (!dp.unlocked && paddingTop < bottom * 0.3) ...[
            ///ARROW DOWN
            Positioned(
              bottom: bottom / 3 - sidePadding,
              left: 0,
              right: 0,
              child: SvgPicture.asset("assets/arrows.svg",
                  color: Colors.green, semanticsLabel: 'd'),
            ),
          ],
        ],
      ),
    );
  }
}
