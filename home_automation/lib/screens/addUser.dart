import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/index.dart';
import '../utils/index.dart';
import 'index.dart';
import '../widgets/index.dart';
import '../sidebar/index.dart';
class AddUser extends StatefulWidget {
  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String name, username, password;
  bool _secureText = true;
  List<dynamic> val;
  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RoomsAndDevicesProvider roomsAndDevicesProvider =
        context.watch<RoomsAndDevicesProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add User",
          style: GoogleFonts.breeSerif(
            textStyle: TextStyle(color: Theme.of(context).iconTheme.color),
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: SafeArea(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 30,
                        ),
                        Column(
                          children: <Widget>[
                            TextFormField(
                              keyboardType: TextInputType.text,
                              onSaved: (value) => name = value,
                              onChanged: (value) {},
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Name field cannot be empty";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: border,
                                labelStyle: labelStyle,
                                errorBorder: errorBorder,
                                enabledBorder: enabledBorder,
                                focusedBorder: focusedBorder,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                labelText: "Name",
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              onSaved: (value) => username = value,
                              onChanged: (value) {},
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Username field cannot be empty";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: border,
                                labelStyle: labelStyle,
                                errorBorder: errorBorder,
                                enabledBorder: enabledBorder,
                                focusedBorder: focusedBorder,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                labelText: "Username",
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              onSaved: (value) => password = value,
                              onChanged: (value) {},
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Password field cannot be empty";
                                }
                                return null;
                              },
                              keyboardType: TextInputType.text,
                              obscureText: _secureText,
                              decoration: InputDecoration(
                                labelText: "Password",
                                suffixIcon: IconButton(
                                  alignment: Alignment.center,
                                  onPressed: showHide,
                                  icon: Icon(
                                      _secureText
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .color),
                                ),
                                border: border,
                                labelStyle: labelStyle,
                                errorBorder: errorBorder,
                                enabledBorder: enabledBorder,
                                focusedBorder: focusedBorder,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            FloatingActionButton.extended(
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  SystemChannels.textInput
                                      .invokeMethod('TextInput.hide');
                                  setState(() {
                                    isLoading = true;
                                  });
                                  await checkMongoDBConnection();
                                  setState(() {
                                    val = [];
                                  });
                                  DbCollection rootUsers =
                                      mongoDB.db.collection('rootUsers');
                                  DbCollection users =
                                      mongoDB.db.collection('normalUsers');
                                  try {
                                    await rootUsers
                                        .find({'username': username})
                                        .toList()
                                        .then((value1) async {
                                          if (value1.length > 0) {
                                            setState(() {
                                              val.add(value1.first);
                                            });
                                          }
                                        });
                                    await users
                                        .find({'username': username})
                                        .toList()
                                        .then((value2) async {
                                          if (value2.length > 0) {
                                            setState(() {
                                              val.add(value2.first);
                                            });
                                          }
                                        });
                                    if (val.length > 0) {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      alertDialog(
                                          context,
                                          "Add User",
                                          'User with same username already exists',
                                          'Ok');
                                    } else {
                                      SharedPreferences prefs = await SharedPreferences.getInstance();
                                      String homeId = (prefs.getString('homeId') ?? '');
                                      var userAdded = await users
                                          .insertOne(<String, dynamic>{
                                        "name": name,
                                        "username": username,
                                        "password": password,
                                        "homeId": homeId,
                                        "type": "user"
                                      });
                                      await context.read<RoomsAndDevicesProvider>().init();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomeScreen()
                                          // HomeScreen()
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    alertDialog(
                                        context,
                                        "Add User",
                                        'Something went wrong please try again',
                                        'Ok');
                                    print(e);
                                  }
                                }
                              },
                              label: Text('Add'),
                              icon: null,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
