import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State hide Center;
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/index.dart';
import '../utils/index.dart';
import 'index.dart';
import '../providers/index.dart';
import '../models/index.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String? name,
      email,
      phoneNumber,
      city,
      occupation,
      age,
      password,
      confirmPassword;
  String? pass;
  bool _secureText1 = true;
  bool _secureText2 = true;
  TextEditingController occupationController = new TextEditingController();
  showHide1() {
    setState(() {
      _secureText1 = !_secureText1;
    });
  }

  showHide2() {
    setState(() {
      _secureText2 = !_secureText2;
    });
  }

  Future<void> signUp() async {
    setState(() {
      isLoading = true;
    });
    await checkMongoDBConnection();
    DbCollection users = mongoDB.db.collection('users');
    DbCollection wallets = mongoDB.db.collection('wallets');
    try {
      await users
          .find({'phoneNumber': '+91' + phoneNumber!})
          .toList()
          .then((value1) async {
            if (value1.length != 0) {
              alertDialog(
                  context, "Sign up", 'Phone Number Already Registered', 'Ok');
            } else {
              await users.find({'email': email}).toList().then((value2) async {
                    if (value2.length != 0) {
                      alertDialog(
                          context, "Sign up", 'Email Already Registered', 'Ok');
                    } else {
                      UserModel user = UserModel(
                          name: name,
                          email: "",
                          phoneNumber: '+91' + phoneNumber!,
                          phoneNumberVerified: false,
                          emailVerified: false);
                      user.name = name;
                      user.email = "";
                      user.phoneNumber = '+91' + phoneNumber!;
                      user.password = password;
                      user.city = "";
                      user.occupation = "";
                      user.age = "";
                      // user.email = email;
                      // user.city = city;
                      //user.occupation = occupation;
                      //user.age = age;
                      user.phoneNumberVerified = false;
                      user.emailVerified = false;
                      var addUser = await users.insertOne(user.toMap());
                      if (addUser.isSuccess) {
                        print(addUser.id);
                        ObjectId _id = addUser.id;
                        WalletModel wallet = WalletModel();
                        wallet.userId = _id.$oid.toString();
                        wallet.balance = 0;
                        var addWallet = await wallets.insertOne(wallet.toMap());
                        if (addWallet.isSuccess) {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setString("userId", _id.$oid.toString());
                          prefs.setBool("loggedIn", true);
                          await context.read<UserProvider>().init();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()),
                          );
                          /* await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: email.trim(),
                                  password: password.trim())
                              .then((value3) async {

                          });*/
                        }
                      }
                    }
                  });
            }
          });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: isLoading
          ? Center(child: LoaderCircular())
          : SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: SafeArea(
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/bg.png"),
                          fit: BoxFit.cover)),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1,
                        ),
                        // Image.asset(
                        //   'assets/rove.png',
                        //   alignment: Alignment.centerLeft,
                        //   height: MediaQuery.of(context).size.width * 0.22,
                        //   width: MediaQuery.of(context).size.width * 0.22,
                        // ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        FadeAnimation(
                            1,
                            Text(
                              "Sign Up",
                              style: GoogleFonts.gugi(
                                textStyle: TextStyle(
                                    color: Colors.white, fontSize: 37),
                              ),
                            )),
                        FadeAnimation(
                            1.3,
                            Text(
                              "Please enter your details",
                              // "A Promise of The Most Fuss-Free And Refreshing Ride Ever With Us",
                              textAlign: TextAlign.justify,
                              style: GoogleFonts.breeSerif(
                                textStyle: TextStyle(
                                    color: Colors.white.withOpacity(1),
                                    fontSize: 17),
                              ),
                            )),
                        SizedBox(
                          height: 40,
                        ),
                        FadeAnimation(
                          0.5,
                          TextFieldOuter(
                            child: TextFormField(
                              onSaved: (value) => name = value,
                              cursorColor: cursorColor,
                              onChanged: (value) {},
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Name field cannot be empty";
                                }
                                return null;
                              },
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 16),
                                hintText: "Name",
                                border: border,
                                labelStyle: labelStyle,
                                errorBorder: errorBorder,
                                enabledBorder: enabledBorder,
                                focusedBorder: focusedBorder,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        FadeAnimation(
                          0.5,
                          TextFieldOuter(
                            child: TextFormField(
                              onSaved: (value) => phoneNumber = value,
                              cursorColor: cursorColor,
                              onChanged: (value) {},
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Phone Number field cannot be empty";
                                } else if (value.toString().length != 10) {
                                  return "Phone Number should be 10 digit number";
                                }
                                return null;
                              },
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 16),
                                border: border,
                                labelStyle: labelStyle,
                                errorBorder: errorBorder,
                                enabledBorder: enabledBorder,
                                focusedBorder: focusedBorder,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                hintText: "Phone Number",
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        /* FadeAnimation(
                              0.5,
                              TextFieldOuter(
                                child: TextFormField(
                                  onSaved: (value) => email = value,
                                  cursorColor: cursorColor,
                                  onChanged: (value) {},
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Email field cannot be empty";
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.email,
                                      color: Theme.of(context).colorScheme.secondary,
                                    ),
                                    hintText: "Email ID",
                                    border: border,
                                    labelStyle: labelStyle,
                                    errorBorder: errorBorder,
                                    enabledBorder: enabledBorder,
                                    focusedBorder: focusedBorder,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.auto,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            FadeAnimation(
                              0.5,
                              TextFieldOuter(
                                child: TextFormField(
                                  onSaved: (value) => age = value,
                                  cursorColor: cursorColor,
                                  onChanged: (value) {},
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Age field cannot be empty";
                                    } else if (value.toString().length != 2) {
                                      return "Age should be 2 digit number";
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.calendar_today,
                                      color: Theme.of(context).colorScheme.secondary,
                                    ),
                                    hintText: "Age",
                                    border: border,
                                    labelStyle: labelStyle,
                                    errorBorder: errorBorder,
                                    enabledBorder: enabledBorder,
                                    focusedBorder: focusedBorder,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.auto,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            FadeAnimation(
                              0.5,
                              TextFieldOuter(
                                child: TextFormField(
                                    onSaved: (value) => occupation = value,
                                    cursorColor: cursorColor,
                                    onChanged: (value) {},
                                    readOnly: true,
                                    controller: occupationController,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Occupation field cannot be empty";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.work,
                                        color: Theme.of(context).colorScheme.secondary,
                                      ),
                                      hintText: "Occupation",
                                      border: border,
                                      labelStyle: labelStyle,
                                      errorBorder: errorBorder,
                                      enabledBorder: enabledBorder,
                                      focusedBorder: focusedBorder,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.auto,
                                    ),
                                    onTap: () {
                                      showDropdownDialog(
                                          context: context,
                                          title: 'Select Occupation',
                                          items: ["Student", "Other"],
                                          onChanged: (String value) {
                                            setState(() {
                                              occupationController.text = value;
                                            });
                                          });
                                    }),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            FadeAnimation(
                              0.5,
                              TextFieldOuter(
                                child: TextFormField(
                                  onSaved: (value) => city = value,
                                  cursorColor: cursorColor,
                                  onChanged: (value) {},
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "City field cannot be empty";
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.location_city,
                                      color: Theme.of(context).colorScheme.secondary,
                                    ),
                                    hintText: "City",
                                    border: border,
                                    labelStyle: labelStyle,
                                    errorBorder: errorBorder,
                                    enabledBorder: enabledBorder,
                                    focusedBorder: focusedBorder,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.auto,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),*/
                        FadeAnimation(
                          0.5,
                          TextFieldOuter(
                            child: TextFormField(
                              onSaved: (value) => password = value,
                              cursorColor: cursorColor,
                              onChanged: (value) {
                                setState(() {
                                  pass = value;
                                });
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Password field cannot be empty";
                                } else if (value.toString().length < 8) {
                                  return "Password length should be \natleast 8 characters";
                                }
                                return null;
                              },
                              keyboardType: TextInputType.text,
                              obscureText: _secureText1,
                              decoration: InputDecoration(
                                hintText: "Password",
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 14),
                                suffixIcon: IconButton(
                                  alignment: Alignment.center,
                                  onPressed: showHide1,
                                  icon: Icon(
                                      _secureText1
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Theme.of(context)
                                          .textTheme
                                          .caption!
                                          .color!),
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
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        FadeAnimation(
                          0.5,
                          TextFieldOuter(
                            child: TextFormField(
                              onSaved: (value) => confirmPassword = value,
                              cursorColor: cursorColor,
                              onChanged: (value) {},
                              validator: (value) {
                                if (value != pass || pass != value) {
                                  return "password and confirm password should be same";
                                }
                                return null;
                              },
                              keyboardType: TextInputType.text,
                              obscureText: _secureText2,
                              decoration: InputDecoration(
                                hintText: "Confirm Password",
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 14),
                                suffixIcon: IconButton(
                                  alignment: Alignment.center,
                                  onPressed: showHide2,
                                  icon: Icon(
                                      _secureText2
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Theme.of(context)
                                          .textTheme
                                          .caption!
                                          .color!),
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
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        FadeAnimation(
                          1.2,
                          Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      Color(0xFF187498))),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  SystemChannels.textInput
                                      .invokeMethod('TextInput.hide');
                                  await signUp();
                                }
                              },
                              // padding: EdgeInsets.all(0),
                              // shape: RoundedRectangleBorder(
                              //   borderRadius: BorderRadius.circular(6),
                              // ),
                              child: Text(
                                "Sign up",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        FadeAnimation(
                          0.5,
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Already have an account?",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignIn()),
                                    );
                                  },
                                  child: Text(
                                    "Sign in",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF187498)),
                                  ),
                                )
                              ],
                            ),
                          ),
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
