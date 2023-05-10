import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State;
import 'package:provider/provider.dart';

import '../index_files.dart';

class WalletProvider with ChangeNotifier {
  int get walletBalance => _walletBalance;
  int _walletBalance = 0;

//  int get minimumBalance => _minimumBalance;
  // int _minimumBalance = 20700;

  // int get minimumRecharge => _minimumRecharge;
  // int _minimumRecharge = 27600;

  int get usableBalance => _usableBalance;
  int _usableBalance = 0;

  Future<void> init({required BuildContext context}) async {
    AuthenticationProvider ap = context.read<AuthenticationProvider>();
    try {
      await mongoDB.maintainMongoDBConnection(context);
      if (ap.loginType == LoginType.hub) {
        DbCollection hubs = mongoDB.db.collection('hubs');
        await hubs.find({"hubId": ap.loginId}).toList().then((res) async {
              if (res.isNotEmpty) {
                _walletBalance = res.first['wallet'] ?? 0;
                notifyListeners();
              }
            });
      } else {}
      if (ap.loginType == LoginType.driver) {
        DbCollection drivers = mongoDB.db.collection('drivers');
        await drivers.find({"driverId": ap.loginId}).toList().then((res) async {
              if (res.isNotEmpty) {
                _walletBalance = res.first['wallet'] ?? 0;
                notifyListeners();
              }
            });
      } else {}
      _usableBalance = (_walletBalance < ap.hub!.minBalance)
          ? 0
          : (_walletBalance - ap.hub!.minBalance);
      notifyListeners();
      print("Wallet init done");
    } catch (e) {
      print(e);
    }
  }

  Future<bool> updateWalletAmount(
      {required BuildContext context,
      required LoginType loginType,
      required String loginId,
      required int amount,
      required bool credit}) async {
    AuthenticationProvider ap = context.read<AuthenticationProvider>();
    bool updated = false;
    try {
      await mongoDB.maintainMongoDBConnection(context);
      if (loginType == LoginType.hub) {
        DbCollection hubs = mongoDB.db.collection('hubs');
        await init(context: context);
        int updatedAmount = _walletBalance;
        if (credit) {
          updatedAmount = _walletBalance + amount;
          updated = true;
        } else if ((_walletBalance - (ap.hub!.minBalance + amount)) > amount) {
          updatedAmount = _walletBalance - amount;
          updated = true;
        } else {
          updated = false;
          messageDialog(context, "Insufficient Balance");
        }
        await hubs.update(
            where.eq("hubId", loginId), modify.set('wallet', updatedAmount));
      } else {}
      print("Wallet Amount Updated");
    } catch (e) {
      updated = false;
      print(e);
    }
    return updated;
  }
}
