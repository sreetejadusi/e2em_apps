import 'package:mongo_dart/mongo_dart.dart';

class WalletModel {
  String? id, userId;
  int? balance;
  WalletModel(
      {this.id,
        this.userId,
        this.balance});

  factory WalletModel.fromMap(Map<String, dynamic> json) {
    ObjectId _id = json['_id'];
    return WalletModel(
      id: _id.$oid.toString(),
      userId: json["userId"],
      balance: json["balance"],

    );
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
    "userId": userId,
    "balance": balance,
  };
}
