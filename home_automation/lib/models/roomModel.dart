import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

class RoomModel {
  int id;
  String code, name, image;
  List<dynamic> devices;
  RoomModel({this.id, this.image, this.code, this.name, this.devices});

  factory RoomModel.fromMap(Map<String, dynamic> json) {
    return new RoomModel(
      code: json["code"],
      name: json["name"],
      image: json["image"],
      devices: json["devices"],
    );
  }

  factory RoomModel.fromDatabase(Map<String, dynamic> json) {
    List<dynamic> de = jsonDecode(json["devices"]);
    return new RoomModel(
      id: json["id"],
      code: json["code"],
      name: json["name"],
      image: json["image"],
      devices: de,
    );
  }
}
