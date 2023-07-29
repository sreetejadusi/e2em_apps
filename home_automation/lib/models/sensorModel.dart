import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

class SensorModel {
  int id;
  String code, name, image, deviceId;
  List<dynamic> data;
  SensorModel(
      {this.id=0, required this.image, required this.data, required this.deviceId, required this.code, required this.name});

  factory SensorModel.fromMap(Map<String, dynamic> json) {
    List<dynamic> d = [];
    d = json["data"].split(',');
    return new SensorModel(
      deviceId: json["deviceId"],
      code: json["code"],
      name: json["name"],
      data: d,
      image: json["image"],
    );
  }

  factory SensorModel.fromDatabase(Map<String, dynamic> json) {
    List<dynamic> d = [];
    d = json["data"].split(',');
    return new SensorModel(
      id: json["id"],
      deviceId: json["deviceId"],
      code: json["code"],
      data: d,
      name: json["name"],
      image: json["image"],
    );
  }
}
