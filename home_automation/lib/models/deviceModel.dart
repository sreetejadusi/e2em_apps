import 'dart:collection';
import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

class DeviceModel {
  int id, timer;
  String code, name, image, deviceId, timerTime;
  dynamic parameters;
  List<dynamic> data;
  String category;
  DeviceModel(
      {this.id,
      this.name,
      this.image,
      this.timer,
      this.code,
      this.timerTime,
      this.deviceId,
      this.data,
      this.parameters,
      this.category});

  factory DeviceModel.fromMap(Map<String, dynamic> json) {
    List<dynamic> d = [];
    d = json["data"].split(',');
    return new DeviceModel(
      name: json["name"],
      image: json["image"],
      code: json["code"],
      timer: json["timer"],
      timerTime: json["timerTime"] ?? '',
      deviceId: json["deviceId"],
      data: d,
      parameters: "",
      category: json["category"],
    );
  }

  factory DeviceModel.fromDatabase(Map<String, dynamic> json) {
    List<dynamic> params1 = [];
    List<dynamic> d = [];
    d = json["data"].split(',');
    for (var m = 0; m < jsonDecode(json["parameters"]).length; m++) {
      List<dynamic> l1 = jsonDecode(json["parameters"])[m];
      List<dynamic> ml1 = [];
      for (var n = 0; n < l1.length; n++) {
        ml1.add(l1[n]);
      }
      params1.add(ml1);
    }
    return new DeviceModel(
      id: json["id"],
      code: json["code"],
      name: json["name"],
      image: json["image"],
      timerTime: json["timerTime"] ?? '',
      timer: json["timer"],
      data: d,
      deviceId: json["deviceId"],
      parameters: params1,
      category: json["category"],
    );
  }
}
