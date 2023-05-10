import 'dart:convert';

import 'package:encrypt/encrypt.dart';

String aesKey = "jg9e1b4n564sao8h";

String vehicleIdDecrypt(String data) {
  final key = Key.fromUtf8(aesKey);
  final iv = IV.fromLength(16);
  final encrypter = Encrypter(AES(key));
  String decrypted = encrypter.decrypt64(data, iv: iv);
  return decrypted;
}

String vehicleIdEncypt(String data) {
  final key = Key.fromUtf8(aesKey);
  final iv = IV.fromLength(16);
  final encrypter = Encrypter(AES(key));
  String encrypted = encrypter.encrypt(data, iv: iv).base64;
  return encrypted;
}
