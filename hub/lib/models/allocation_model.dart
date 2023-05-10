import '../index_files.dart';

class AllocationModel {
  String allocationId;
  String date;
  AllocationStatus allocationStatus;

  AllocationModel({
    required this.allocationId,
    required this.date,
    required this.allocationStatus,
  });

  factory AllocationModel.fromMap(Map<String, dynamic> json) {
    return AllocationModel(
      allocationId: json["allocationId"],
      date: json["date"],
      allocationStatus: allocationStatusEnum(json["allocationStatus"]),
    );
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
        "allocationId": allocationId,
        "date": date,
        "allocationStatus": allocationStatus.name,
      };
}
