import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../index_files.dart';
import '../main.dart';

class AuthenticationProvider with ChangeNotifier {
  HubModel? get hub => _hub;
  HubModel? _hub;
  String get displayName => _displayName;
  String _displayName = " ";

  String get displayId => _displayId;
  String _displayId = " ";

  LoginType get loginType => _loginType;
  LoginType _loginType = LoginType.none;

  String get loginId => _loginId;
  String _loginId = "";

  bool get signInLoading => _signInLoading;
  bool _signInLoading = false;

  Future<void> signInLoadingState(bool status) async {
    _signInLoading = status;
    notifyListeners();
  }

  Future<void> init(BuildContext context) async {
    await loadLoginId(context);
    await loadLoginType(context);
  }

  Future<void> checkLoggedIn(BuildContext context) async {
    if (_loginType == LoginType.driver ||
        _loginType == LoginType.hub ||
        _loginType == LoginType.admin) {
      await mongoDB.maintainMongoDBConnection(context);
      DbCollection users = mongoDB.db.collection(_loginType == LoginType.driver
          ? 'drivers'
          : _loginType == LoginType.hub
              ? "hubs"
              : "admins");
      try {
        await users
            .find({
              (_loginType == LoginType.driver
                  ? 'driverId'
                  : _loginType == LoginType.hub
                      ? "hubId"
                      : "adminId"): _loginId
            })
            .toList()
            .then((value) async {
              if (value.isEmpty) {
                signOut(context);
              } else {
                _displayName = value.first['name'];
                _displayId = value.first[_loginType == LoginType.driver
                    ? 'driverId'
                    : _loginType == LoginType.hub
                        ? "hubId"
                        : "adminId"];
                notifyListeners();
              }
            });
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> loadLoginType(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String lt = prefs.getString('loginType') ?? "none";
    _loginType = loginTypeEnum(lt);
    await checkLoggedIn(context);
    notifyListeners();
  }

  Future<void> loadLoginId(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('loginId') ?? "";
    _loginId = id;
    notifyListeners();
  }

  Future<void> updateLoginType(BuildContext context, LoginType lt) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('loginType', loginTypeMap(lt));
    await loadLoginType(context);
    notifyListeners();
  }

  Future<void> updateLoginId(BuildContext context, String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('loginId', id);
    await loadLoginId(context);
    notifyListeners();
  }

  Future<void> signOut(BuildContext context) async {
    await updateLoginType(context, LoginType.none);
    await updateLoginId(context, "");
    notifyListeners();
  }

  Future<void> updateHub(HubModel hubModel) async {
    _hub = hubModel;
    notifyListeners();
  }

  Future<void> login(
      {required BuildContext context,
      required LoginType lt,
      required String username,
      required String password}) async {
    signInLoadingState(true);
    await mongoDB.maintainMongoDBConnection(context);
    DbCollection users = mongoDB.db.collection(lt == LoginType.driver
        ? 'drivers'
        : lt == LoginType.hub
            ? "hubs"
            : "admins");
    try {
      await users
          .find({'username': username, 'password': password})
          .toList()
          .then((value) async {
            if (value.isEmpty) {
              signInLoadingState(false);
              messageDialog(context, "Invalid Credentials");
            } else {
              if (lt == LoginType.hub) {
                updateHub(HubModel.fromMap(value.first));
              }

              _displayName = value.first['name'];
              _displayId = value.first[lt == LoginType.driver
                  ? 'driverId'
                  : lt == LoginType.hub
                      ? "hubId"
                      : "adminId"];
              notifyListeners();
              if (lt == LoginType.driver) {
                updateLoginId(context, value.first["driverId"]);
              } else if (lt == LoginType.hub) {
                updateLoginId(context, value.first["hubId"]);
              } else if (lt == LoginType.admin) {
                updateLoginId(context, value.first["adminId"]);
              } else {}
              await updateLoginType(context, lt);
              signInLoadingState(false);
            }
          });
    } catch (e) {
      signInLoadingState(false);
      print(e);
    }
  }
}
