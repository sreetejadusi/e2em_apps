import 'package:mongo_dart/mongo_dart.dart';

class TWalletModel {
  String userId, utr, status, timestamp;
  int amount;
  TWalletModel({
    required this.userId,
    required this.amount,
    required this.utr,
    required this.status,
    required this.timestamp,
    
  });

  factory TWalletModel.fromMap(Map<String, dynamic> json) {
    return TWalletModel(
      userId: json["userId"],
      amount: json["amount"],
      status: json["status"],
      utr: json["utr"],
      timestamp: json["timestamp"],
    );
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
    "userId": userId,
    "amount": amount,
    "status": status,
    "utr": utr,
    "timestamp": timestamp,
  };
}
