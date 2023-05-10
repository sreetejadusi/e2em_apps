import 'package:mongo_dart/mongo_dart.dart';

class UserModel {
  String? id, name, email, phoneNumber, password, city, occupation, age;
  bool phoneNumberVerified, emailVerified;
  UserModel(
      {this.id,
      required this.name,
      required this.email,
      required this.phoneNumber,
      this.city,
      this.occupation,
      this.password,
      this.age,
      required this.phoneNumberVerified,
      required this.emailVerified});

  factory UserModel.fromMap(Map<String, dynamic> json) {
    ObjectId _id = json['_id'];
    return UserModel(
      id: _id.$oid.toString(),
      name: json["name"],
      email: json["email"],
      phoneNumber: json["phoneNumber"],
      city: json["city"],
      occupation: json["occupation"],
      age: json["age"],
      password: json["password"],
      phoneNumberVerified: json["phoneNumberVerified"],
      emailVerified: json["emailVerified"],
    );
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
        "name": name,
        "email": email,
        "phoneNumber": phoneNumber,
        "city": city,
        "occupation": occupation,
        "age": age,
        "password": password,
        "phoneNumberVerified": phoneNumberVerified,
        "emailVerified": emailVerified,
      };
}
