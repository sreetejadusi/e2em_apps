library custom_switch;

import '../utils/index.dart';
import 'package:flutter/material.dart';

class CustomSwitch extends StatefulWidget {
  final bool value;
  final double size;
  final ValueChanged<bool> onChanged;
  //final Gradient gradient;
  final String activeText;
  final String inactiveText;
  final Color activeTextColor;
  final Color inactiveTextColor;

  const CustomSwitch(
      {Key? key,
      required this.value,
      this.size = 55.0,

      /// required this.gradient,
      required this.onChanged,
      this.activeText = 'On',
      this.inactiveText = 'Off',
      this.activeTextColor = Colors.green,
      this.inactiveTextColor = Colors.red})
      : super(key: key);

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch>
    with SingleTickerProviderStateMixin {
  late Animation _circleAnimation;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 10));
    _circleAnimation = AlignmentTween(
            begin: widget.value ? Alignment.centerRight : Alignment.centerLeft,
            end: widget.value ? Alignment.centerLeft : Alignment.centerRight)
        .animate(CurvedAnimation(
            parent: _animationController, curve: Curves.linear));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            if (_animationController.isCompleted) {
              _animationController.reverse();
            } else {
              _animationController.forward();
            }
            widget.value == false
                ? widget.onChanged(true)
                : widget.onChanged(false);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                //width: 150.0,
                //height: 70.0,
                decoration: BoxDecoration(
                  color: bgColor,
                  // gradient: widget.gradient,
                  borderRadius: BorderRadius.circular(50.0),
                ),
                /*color: _circleAnimation.value == Alignment.centerLeft
                        ? widget.inactiveColor
                        : widget.activeColor),*/
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      _circleAnimation.value == Alignment.centerRight
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 7),
                              child: Stack(
                                children: [
                                  Opacity(
                                    opacity: 0,
                                    child: Text(
                                      widget.inactiveText,
                                      style: TextStyle(
                                          //color: widget.inactiveTextColor,
                                          color: widget.inactiveTextColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: widget.size * 0.90),
                                    ),
                                  ),
                                  Text(
                                    widget.activeText,
                                    style: TextStyle(
                                        //color: widget.activeTextColor,
                                        color: widget.activeTextColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: widget.size * 0.90),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                      Align(
                        alignment: _circleAnimation.value,
                        child: Container(
                          width: widget.size,
                          height: widget.size,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                _circleAnimation.value == Alignment.centerRight
                                    ? widget.activeTextColor
                                    : widget.inactiveTextColor,
                          ),
                        ),
                      ),
                      _circleAnimation.value == Alignment.centerLeft
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 7),
                              child: Stack(
                                children: [
                                  Opacity(
                                    opacity: 0,
                                    child: Text(
                                      widget.activeText,
                                      style: TextStyle(
                                          //color: widget.inactiveTextColor,
                                          color: widget.activeTextColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: widget.size * 0.90),
                                    ),
                                  ),
                                  Text(
                                    widget.inactiveText,
                                    style: TextStyle(
                                        //color: widget.inactiveTextColor,
                                        color: widget.inactiveTextColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: widget.size * 0.90),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
