import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

class CategoryModel {
  String code;
  CategoryModel({this.code});

  factory CategoryModel.fromMap(Map<String, dynamic> json) {
    return new CategoryModel(
      code: json["code"],
    );
  }
}
