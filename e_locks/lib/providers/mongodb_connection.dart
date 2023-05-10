import 'dart:io';
import 'dart:async';
import 'package:mongo_dart/mongo_dart.dart';

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
      db = Db('mongodb://myTester:abc123@44.194.197.162:27017/test');
      await db.open();
      if (db.isConnected) {
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

  Future<void> checkMongoDBConnection() async {
    print('mongoDB.db.isConnected : ' + db.isConnected.toString());
    if (db.isConnected) {
    } else {
      try {
        await init();
      } catch (e) {
        print(e);
      }
    }
  }
}
