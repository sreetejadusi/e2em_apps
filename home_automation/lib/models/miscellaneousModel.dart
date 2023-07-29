import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

class MiscellaneousModel {
  int id, timer;
  String code, name, image, deviceId, hasControl, timerTime;
  List<dynamic> data;
  MiscellaneousModel(
      {this.id=0,
      required this.image,
      required this.code,
      required this.data,
      required this.timer,
      required this.timerTime,
      required this.deviceId,
      required this.hasControl,
      required this.name});

  factory MiscellaneousModel.fromMap(Map<String, dynamic> json) {
    List<dynamic> d = [];
    d = json["data"].split(',');
    return new MiscellaneousModel(
      deviceId: json["deviceId"],
      code: json["code"],
      name: json["name"],
      image: json["image"],
      data: d,
      hasControl: json["hasControl"],
      timerTime: json["timerTime"] ?? '',
      timer: json["timer"] ?? 0,
    );
  }

  factory MiscellaneousModel.fromDatabase(Map<String, dynamic> json) {
    List<dynamic> d = [];
    d = json["data"].split(',');
    return new MiscellaneousModel(
      id: json["id"],
      deviceId: json["deviceId"],
      code: json["code"],
      name: json["name"],
      image: json["image"],
      data: d,
      hasControl: json["hasControl"],
      timerTime: json["timerTime"] ?? '',
      timer: json["timer"] ?? 0,
    );
  }
}
