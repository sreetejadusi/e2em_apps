import 'package:mongo_dart/mongo_dart.dart';

class UserModel {
  String id, type, name, username, homeId;

  UserModel({this.id='', required this.type, required this.name, required this.username, required this.homeId});

  factory UserModel.fromMap(Map<String, dynamic> json) {
    ObjectId _id = json['_id'];
    return new UserModel(
      id: _id.$oid.toString(),
      type: json["type"],
      name: json["name"],
      username: json["username"],
      homeId: json["homeId"],
    );
  }
}
