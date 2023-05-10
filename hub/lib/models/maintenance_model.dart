import 'package:mongo_dart/mongo_dart.dart';

class MaintenanceModel {
  String maintenanceId, hubId, vehicleId, issue, description, status, datetime;
  MaintenanceModel({
    required this.maintenanceId,
    required this.vehicleId,
    required this.hubId,
    required this.issue,
    required this.description,
    required this.status,
    required this.datetime,
  });

  factory MaintenanceModel.fromMap(Map<String, dynamic> json) {
    return MaintenanceModel(
      maintenanceId: json["maintenanceId"],
      vehicleId: json["vehicleId"],
      hubId: json["hubId"],
      issue: json["issue"],
      description: json["description"],
      status: json["status"],
      datetime: json["datetime"],
    );
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
        "maintenanceId": maintenanceId,
        "vehicleId": vehicleId,
        "hubId": hubId,
        "issue": issue,
        "description": description,
        "status": status,
        "datetime": datetime,
      };
}
