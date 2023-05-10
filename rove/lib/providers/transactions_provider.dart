import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/index.dart';
import '../models/index.dart';
import '../providers/index.dart';
import 'base_provider.dart';
import 'index.dart';
import '../screens/index.dart';
import 'package:provider/provider.dart';

class TransactionsProvider extends BaseProvider {
  List<TransactionModel> get transactions => _transactions.reversed.toList();
  List<TransactionModel> _transactions = [];
  @override
  Future<void> init() async {
    try {
      startLoading();
      await checkMongoDBConnection();
      _transactions =[];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString("userId");
      print('userId');
      print(userId);
      DbCollection transactions = mongoDB.db.collection('transactions');
      await transactions.find({'userId': userId}).toList().then((t) async {
            _transactions = [
              for (final item in t) TransactionModel.fromMap(item)
            ];
          });
      notifyListeners();
      finishLoading();
      print("Transactions loaded");
    } catch (e) {
      receivedError();
      print(e);
    }
  }

  String description(TransactionModel transaction) {
    String description = '';
    if (transaction.from == 'wallet' && transaction.to == "ride") {
      description = "Paid to Ride";
    } else if (transaction.from == 'payment' && transaction.to == "wallet") {
      description = "Added to Wallet";
    } else if (transaction.from == 'payment' && transaction.to == "ride") {
      description = "Paid to Ride";
    }else if(transaction.from == 'pending' && transaction.to == "ride"){
      description = "Pending";
    }
    return description;
  }

  Future<void> reset() async {
    _transactions = [];
  }
}
