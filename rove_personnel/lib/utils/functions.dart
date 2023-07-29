import 'dart:typed_data';

import 'package:flutter/cupertino.dart';

Uint8List alpha_to_unit8list(String asciiString) {
  String as = asciiString;
  List<int> codes = as.codeUnits;
  Uint8List data = Uint8List(codes.length);
  for (int i = 0; i < codes.length; i++) {
    data[i] = codes[i];
  }
  return data;
}
