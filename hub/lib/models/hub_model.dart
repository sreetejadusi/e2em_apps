import 'package:mongo_dart/mongo_dart.dart';

class HubModel {
  String hubId, name, address, username, password, pinCode;
  int wallet;
  int minBalance, minRecharge, allocationCost, batterySwapCost;
  bool blacklisted;
  int dateOperative;
  HubModel(
      {required this.hubId,
      required this.name,
      required this.address,
      required this.wallet,
      required this.username,
      required this.pinCode,
      required this.password,
      required this.minBalance,
      required this.minRecharge,
      required this.allocationCost,
      required this.batterySwapCost,
      required this.blacklisted,
      required this.dateOperative});

  factory HubModel.fromMap(Map<String, dynamic> json) {
    return HubModel(
        hubId: json["hubId"],
        name: json["name"],
        address: json["address"],
        username: json["username"],
        pinCode: json["pinCode"],
        password: json["password"],
        wallet: int.parse((json["wallet"] ?? "0").toString()),
        minBalance: int.parse((json["minBalance"] ?? "0").toString()),
        minRecharge: int.parse((json["minRecharge"] ?? "0").toString()),
        allocationCost: int.parse((json["allocationCost"] ?? "0").toString()),
        batterySwapCost: int.parse((json["batterySwapCost"] ?? "0").toString()),
        blacklisted: ((json['blacklisted'] ?? false)),
        dateOperative: json['dateOperative']);
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
        "hubId": hubId,
        "name": name,
        "address": address,
        "pinCode": pinCode,
        "username": username,
        "password": password,
        "wallet": wallet,
        "minBalance": minBalance,
        "minRecharge": minRecharge,
        "allocationCost": allocationCost,
        "batterySwapCost": batterySwapCost,
        "dateOperative":dateOperative
      };
}
