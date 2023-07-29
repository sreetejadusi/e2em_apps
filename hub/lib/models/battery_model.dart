import 'package:mongo_dart/mongo_dart.dart';

import '../index_files.dart';

class BatteryModel {
  String id, batteryId, hubId, batteryStatus;

  BatteryModel({
    required this.id,
    required this.batteryId,
    required this.hubId,
    required this.batteryStatus,
  });

  factory BatteryModel.fromMap(Map<String, dynamic> json) {
    ObjectId oId = json['_id'];
    return BatteryModel(
      id: oId.$oid.toString(),
      batteryId: json["batteryId"],
      hubId: json["hubId"],
      batteryStatus: json["batteryStatus"],
    );
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
        "batteryId": batteryId,
        "hubId": hubId,
        "batteryStatus": batteryStatus,
      };

  BatteryStatus getBS() {
    return batteryStatusEnum(batteryStatus);
  }
}
