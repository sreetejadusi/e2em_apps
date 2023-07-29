import 'package:mongo_dart/mongo_dart.dart';

import '../index_files.dart';

class VehicleModel {
  String id, vehicleId, vehicleStatus;
  String? hubId, driverId, maintenanceId, batteryId;
  bool unlocked;

  VehicleModel(
      {required this.id,
      required this.vehicleId,
      required this.maintenanceId,
      required this.driverId,
      required this.hubId,
      required this.vehicleStatus,
      required this.batteryId,
      required this.unlocked});

  factory VehicleModel.fromMap(Map<String, dynamic> json) {
    ObjectId oId = json['_id'];
    return VehicleModel(
      id: oId.$oid.toString(),
      vehicleId: json["vehicleId"],
      driverId: json["driverId"],
      maintenanceId: json["maintenanceId"],
      hubId: json["hubId"],
      vehicleStatus: json["vehicleStatus"],
      batteryId: json["batteryId"],
      unlocked: json['unlocked']
    );
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
        "vehicleId": vehicleId,
        "driverId": driverId,
        "maintenanceId": maintenanceId,
        "hubId": hubId,
        "vehicleStatus": vehicleStatus,
        "batteryId": batteryId,
        "unlocked":unlocked
      };

  VehicleStatus getVS() {
    return vehicleStatusEnum(vehicleStatus);
  }
}
