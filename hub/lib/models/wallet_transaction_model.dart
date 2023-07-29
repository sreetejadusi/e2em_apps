import 'package:mongo_dart/mongo_dart.dart';

class WalletTransactionModel {
  String userId, type, timestamp, description, metadata;
  int amount;

  WalletTransactionModel({
    required this.userId,
    required this.amount,
    required this.type,
    required this.description,
    required this.timestamp,
    required this.metadata,
  });

  factory WalletTransactionModel.fromMap(Map<String, dynamic> json) {
    return WalletTransactionModel(
        userId: json["userId"],
        amount: json["amount"],
        type: json["type"],
        description: json["description"],
        timestamp: json["timestamp"],
        metadata: json['metadata'] ?? '');
  }
}
