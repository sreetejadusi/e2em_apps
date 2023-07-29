import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide State;
import 'package:mongo_dart/mongo_dart.dart';
import 'package:provider/provider.dart';
import '../index_files.dart';

MongoDBConnection mongoDB = MongoDBConnection();

class MongoDBConnection {
  static final MongoDBConnection mongoDB = MongoDBConnection._internal();
  late Db db;
  factory MongoDBConnection() {
    return mongoDB;
  }

  MongoDBConnection._internal();

  Future<void> init() async {
    try {
      //db = Db('mongodb://bucky:hoppe2em2021@44.194.197.162:27017/HOPP_DB');
      db = Db('mongodb://develop:ev2go2022@44.194.197.162:27017/EV2GO');
      await db.open();
      if (db.state == State.OPENING) {
        print('\n');
        print('MongoDB Connecting');
        print('\n');
      } else if (db.state == State.OPEN) {
        print('\n');
        print('MongoDB Connected');
        print('\n');
      } else {
        print('Error in MongoDB Connection');
      }
    } catch (e) {
      print(' ');
      print(e);
      print(' ');
    }
  }

  Future<void> maintainMongoDBConnection(BuildContext context) async {
    UserProvider up = context.read<UserProvider>();
    if (db.isConnected) {
      print('\n');
      print('MongoDB Already Connected');
      print('\n');
      up.updateServerConnectionStatus(true);
    } else {
      print('\n');
      print('MongoDB Not Connected');
      print('\n');
      up.updateServerConnectionStatus(false);
      init();
    }
  }

  bool checkMongoDBConnectivity(BuildContext context) {
    if (db.isConnected) {
      return true;
    } else {
      return false;
    }
  }
}
