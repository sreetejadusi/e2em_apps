import 'package:mongo_dart/mongo_dart.dart';

class DriverModel {
  String id, driverId, hubId;
  List<dynamic> vehicleFrequency = [];

  DriverModel({
    required this.id,
    required this.driverId,
    required this.hubId,
    required this.vehicleFrequency,
  });

  factory DriverModel.fromMap(Map<String, dynamic> json) {
    ObjectId oId = json['_id'];
    return DriverModel(
      id: oId.$oid.toString(),
      driverId: json["driverId"],
      hubId: json["hubId"],
      vehicleFrequency: json["vehicleFrequency"] ?? [],
    );
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
        "driverId": driverId,
        "hubId": hubId,
        "vehicleFrequency": vehicleFrequency,
      };
}
