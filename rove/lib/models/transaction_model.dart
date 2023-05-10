import 'package:mongo_dart/mongo_dart.dart';

class TransactionModel {
  String? id, userId, amount, from, to, paymentId, timestamp;
  TransactionModel(
      {this.id,
      this.userId,
      this.amount,
      this.from,
      this.to,
      this.paymentId,
      this.timestamp});

  factory TransactionModel.fromMap(Map<String, dynamic> json) {
    ObjectId _id = json['_id'];
    return TransactionModel(
      id: _id.$oid.toString(),
      userId: json["userId"],
      amount: json["amount"],
      from: json["from"],
      to: json["to"],
      timestamp: json["timestamp"],
      paymentId: json["paymentId"],
    );
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
        "userId": userId,
        "amount": amount,
        "from": from,
        "to": to,
        "timestamp": timestamp,
        "paymentId": paymentId,
      };
}
