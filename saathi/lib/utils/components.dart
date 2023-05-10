import 'package:flutter/material.dart';

import 'package:flutter/painting.dart';

class Palette {
  static const Color darkBlue = Color(0xff092E34);
  static const Color lightBlue = Color(0xff489FB5);
  static const Color orange = Color(0xffFFA62B);
  static const Color darkOrange = Color(0xffCC7700);
}
const buttonTextStyle = TextStyle(
  color: Color(0xFF8B97AD),
  fontSize: 18,
);
Color errorColor = const Color(0xFFfa5a5a);
final border = OutlineInputBorder(borderRadius: BorderRadius.circular(15));

final errorBorder = border.copyWith(
  borderSide: BorderSide(
    width: 3,
    color: errorColor,
  ),
);

final focusedBorder = border.copyWith(
  borderSide: BorderSide(color: Colors.blue, width: 2),
);
RoundedRectangleBorder tileShape = const RoundedRectangleBorder(
  borderRadius: BorderRadius.all(
    Radius.circular(20.0),
  ),
);
Color tileColor = Colors.blue.withOpacity(0.1);
const bgColor = Color(0XFFFFFFFF);

Gradient greeenGradient = LinearGradient(
  colors: <Color>[
    Colors.green,
    Colors.green.shade800,
    //Color(0XFF00B9BB),
    //Color(0XFF00DC9E),
  ],
);
Gradient reedGradient = LinearGradient(
  colors: <Color>[
    Colors.red,
    Colors.red.shade800,
    //Color(0XFFcd5c5c),
    //Color(0XFFff9999),
  ],
);
Gradient curveGradient = RadialGradient(
  colors: <Color>[
    Colors.blue.withOpacity(0.1), Colors.blue.withOpacity(0.2),
    //Color(0xFFE0647B),
    //Color(0xff91c5fc)
    //Color(0XFFECF2FE),
    //Color(0XFFECF2FE),
  ],
  focalRadius: 16,
);

const vpnStyle = TextStyle(
  fontWeight: FontWeight.w600,
  color: Colors.white,
  fontSize: 34,
);

const txtSpeedStyle = TextStyle(
  fontWeight: FontWeight.w300,
  fontSize: 15,
  color: Color(0XFF6B81BD),
);

const kenyaFlagUrl =
    'https://upload.wikimedia.org/wikipedia/commons/thumb/4/49/Flag_of_Kenya.svg/255px-Flag_of_Kenya.svg.png';

const ugandaFlagUrl =
    'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4e/Flag_of_Uganda.svg/255px-Flag_of_Uganda.svg.png';

const connectedStyle = TextStyle(
  fontSize: 26,
  fontWeight: FontWeight.w600,
  height: 1.6,
  color: Colors.black,
);
const connectedGreenStyle = TextStyle(
  fontSize: 26,
  fontWeight: FontWeight.w600,
  color: Color(0XFF00DC9E),
);
const connectedSubtitle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w400,
  color: Colors.black,
);
const locationTitleStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w400,
  color: Color(0XFF9BB1BD),
);
/*const bgColor = Color(0XFF021B3A);

const curveGradient = RadialGradient(
  colors: <Color>[
    Color(0XFF313F70),
    Color(0XFF203063),
  ],
  focalRadius: 16,
);

const vpnStyle = TextStyle(
  fontWeight: FontWeight.w600,
  color: Colors.white,
  fontSize: 34,
);

const txtSpeedStyle = TextStyle(
  fontWeight: FontWeight.w300,
  fontSize: 15,
  color: Color(0XFF6B81BD),
);

const greenGradient = LinearGradient(
  colors: <Color>[
    Color(0XFF00D58D),
    Color(0XFF00C2A0),
  ],
);

const kenyaFlagUrl =
    'https://upload.wikimedia.org/wikipedia/commons/thumb/4/49/Flag_of_Kenya.svg/255px-Flag_of_Kenya.svg.png';

const ugandaFlagUrl =
    'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4e/Flag_of_Uganda.svg/255px-Flag_of_Uganda.svg.png';

const connectedStyle = TextStyle(
  fontSize: 26,
  fontWeight: FontWeight.w600,
  height: 1.6,
  color: Colors.white,
);
const connectedGreenStyle = TextStyle(
  fontSize: 26,
  fontWeight: FontWeight.w600,
  color: Colors.greenAccent,
);
const connectedSubtitle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w400,
  color: Colors.white,
);
const locationTitleStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w400,
  color: Color(0XFF9BB1BD),
);*/
