import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rove/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import '../utils/index.dart';
import '../widgets/index.dart';
import '../providers/index.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State hide Center;
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String? phoneNumber, password;
  bool _secureText = true;
  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  Future<void> signIn() async {
    setState(() {
      isLoading = true;
    });
    await checkMongoDBConnection();
    DbCollection users = mongoDB.db.collection('users');
    try {
      await users
          .find({'phoneNumber': '+91' + phoneNumber!})
          .toList()
          .then((value1) async {
            if (value1.length == 0) {
              setState(() {
                isLoading = false;
              });
              alertDialog(
                  context, "Login", 'Phone Number Not Registered', 'Ok');
            } else {
              await users
                  .find({
                    'phoneNumber': '+91' + phoneNumber!,
                    'password': password
                  })
                  .toList()
                  .then((value2) async {
                    if (value2.length == 0) {
                      setState(() {
                        isLoading = false;
                      });
                      alertDialog(context, "Login", 'Invalid Password', 'Ok');
                    } else {
                      print(value2.first);
                      ObjectId _id = value2.first['_id'];
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString("userId", _id.$oid.toString());
                      prefs.setBool("loggedIn", true);
                      setState(() {
                        isLoading = false;
                      });
                      await context.read<UserProvider>().init();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    }
                  });
            }
          });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      alertDialog(
          context, "Login", 'Something went wrong please try again', 'Ok');
      print(e);
    }
  }

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Welcome()),
        );
        return false;
      },
      child: Scaffold(
        // appBar: ,
        body: isLoading
            ? Center(child: LoaderCircular())
            : SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: SafeArea(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/bg.png"),
                            fit: BoxFit.cover)),
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          AppBar(
                            backgroundColor: Colors.transparent,
                            title: Text(''),
                            leading: IconButton(
                              icon: Icon(Icons.arrow_back),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Welcome()),
                                );
                              },
                            ),
                            elevation: 0,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          FadeAnimation(
                              1,
                              Text(
                                "Login",
                                style: GoogleFonts.gugi(
                                  textStyle: TextStyle(
                                      color: Colors.white, fontSize: 37),
                                ),
                              )),
                          FadeAnimation(
                              1.3,
                              Text(
                                "Please enter your details.",
                                // "A Promise of The Most Fuss-Free And Refreshing Ride Ever With Us",
                                textAlign: TextAlign.justify,
                                style: GoogleFonts.breeSerif(
                                  textStyle: TextStyle(
                                      color: Colors.white.withOpacity(1),
                                      fontSize: 17),
                                ),
                              )),
                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            children: <Widget>[
                              FadeAnimation(
                                0.5,
                                TextFieldOuter(
                                  child: TextFormField(
                                    keyboardType: TextInputType.phone,
                                    onSaved: (value) => phoneNumber = value,
                                    cursorColor: cursorColor,
                                    onChanged: (value) {},
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Phone Number field cannot be empty";
                                      } else if (value.toString().length !=
                                          10) {
                                        return "Phone Number should be 10 digit number";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 14),
                                      /* prefix: Text(
                                        '+91',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 16.0),
                                      ),*/
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
                              FadeAnimation(
                                0.5,
                                TextFieldOuter(
                                  child: TextFormField(
                                    onSaved: (value) => password = value,
                                    cursorColor: cursorColor,
                                    onChanged: (value) {},
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Password field cannot be empty";
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.text,
                                    obscureText: _secureText,
                                    decoration: InputDecoration(
                                      hintText: "Password",
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 14),
                                      suffixIcon: IconButton(
                                        alignment: Alignment.center,
                                        onPressed: showHide,
                                        icon: Icon(
                                            _secureText
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
                                height: 4,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: FadeAnimation(
                                  0.5,
                                  TextButton(
                                    child: Text(
                                      "Forgot Password ?",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: accentColor2,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EnterPhoneNumber()),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              FadeAnimation(
                                1.2,
                                Container(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                accentColor2)),
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();
                                        SystemChannels.textInput
                                            .invokeMethod('TextInput.hide');
                                        await signIn();
                                      }
                                    },
                                    // padding: EdgeInsets.all(0),
                                    // shape: RoundedRectangleBorder(
                                    //   borderRadius: BorderRadius.circular(6),
                                    // ),
                                    child: Text(
                                      "Login",
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
                            ],
                          ),
                          FadeAnimation(
                            0.5,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Don't have an account?",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignUp()),
                                    );
                                  },
                                  child: Text(
                                    "Sign up",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: accentColor2),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
        /* SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Card(
                      color: Theme.of(context).cardColor,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(
                              height: 15,
                            ),
                            Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.w600),
                              ),
                            ),
                            SizedBox(height: 20),
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    useEmail = !useEmail;
                                  });
                                },
                                child: useEmail
                                    ? Text(
                                        'Login with phone number',
                                        style: TextStyle(color: acc),
                                      )
                                    : Text(
                                        'Login with email id',
                                        style: TextStyle(color: acc),
                                      )),
                            if (useEmail) ...[
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Text(
                                  "Email",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 16.0),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.withOpacity(0.5),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                margin: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 5.0),
                                child: Row(
                                  children: <Widget>[
                                    new Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 15.0),
                                      child: Icon(
                                        Icons.email,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Container(
                                      height: 30.0,
                                      width: 1.0,
                                      color: Colors.grey.withOpacity(0.5),
                                      margin: const EdgeInsets.only(
                                          left: 00.0, right: 10.0),
                                    ),
                                    new Expanded(
                                      child: TextFormField(
                                        onSaved: (value) => email = value,
                                        onChanged: (value) {},
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            this.setState(() => errors.add(
                                                "Email field cannot be empty"));
                                          }
                                          return null;
                                        },
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Enter your email',
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ] else ...[
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Text(
                                  "Phone Number",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 16.0),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.withOpacity(0.5),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                margin: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 5.0),
                                child: Row(
                                  children: <Widget>[
                                    new Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 15.0),
                                      child: Icon(
                                        Icons.phone,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Container(
                                      height: 30.0,
                                      width: 1.0,
                                      color: Colors.grey.withOpacity(0.5),
                                      margin: const EdgeInsets.only(
                                          left: 00.0, right: 10.0),
                                    ),
                                    new Expanded(
                                      child: TextFormField(
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Enter your phone number',
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text(
                                "Password",
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 16.0),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.5),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 5.0),
                              child: Row(
                                children: <Widget>[
                                  new Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 15.0),
                                    child: Icon(
                                      Icons.lock,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Container(
                                    height: 30.0,
                                    width: 1.0,
                                    color: Colors.grey.withOpacity(0.5),
                                    margin: const EdgeInsets.only(
                                        left: 00.0, right: 10.0),
                                  ),
                                  new Expanded(
                                    child: TextFormField(
                                      onSaved: (value) => password = value,
                                      onChanged: (value) {},
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          this.setState(() => errors.add(
                                              "Password field cannot be empty"));
                                        } else if (value.toString().length <
                                            6) {
                                          this.setState(() => errors.add(
                                              "Password length should be \natleast 6 characters"));
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.text,
                                      obscureText: _secureText,
                                      decoration: InputDecoration(
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
                                        border: InputBorder.none,
                                        hintText: 'Enter your password',
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20.0),
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20.0),
                              child: new Row(
                                children: <Widget>[
                                  new Expanded(
                                    child: FlatButton(
                                      shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(30.0)),
                                      splashColor: acc.withOpacity(0.5),
                                      color: acc.withOpacity(0.9),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15),
                                        child: new Row(
                                          children: <Widget>[
                                            new Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20.0),
                                              child: Text(
                                                "LOGIN",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            new Expanded(
                                              child: Container(),
                                            ),
                                            new Transform.translate(
                                              offset: Offset(15.0, 0.0),
                                              child: new Container(
                                                padding: const EdgeInsets.only(
                                                    right: 15),
                                                child: Icon(
                                                  Icons.arrow_forward,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      onPressed: () async {
                                        if (_formKey.currentState.validate()) {
                                          if (errors.isEmpty) {
                                            _formKey.currentState.save();
                                            SystemChannels.textInput
                                                .invokeMethod('TextInput.hide');
                                            signIn();
                                          } else if (errors.isNotEmpty) {
                                            String error = "";
                                            for (var i = 0;
                                                i < errors.length;
                                                i++) {
                                              error = error +
                                                  (i != 0 ? "\n" : "") +
                                                  errors[i].toString();
                                            }
                                            alertDialog(
                                                context, "Login", error, 'Ok');

                                            this.setState(() => errors.clear());
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            TextButton(
                              onPressed: () async {},
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                alignment: Alignment.centerRight,
                                child: Text('Forgot Password ?',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: acc,
                                        fontWeight: FontWeight.w500)),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => SignUp()),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 20),
                                alignment: Alignment.bottomCenter,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Don\'t have an account ?',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'Signup',
                                      style: TextStyle(
                                          color: acc,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800),
                                    ),
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
              ],
            ),
          ),
        ),*/
        /*Container(
          padding: EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FadeAnimation(
                  1.2,
                  Text(
                    "Login",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  )),
              SizedBox(
                height: 30,
              ),
              FadeAnimation(
                  1.5,
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey[300]))),
                          child: TextField(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintStyle:
                                    TextStyle(color: Colors.grey.withOpacity(.8)),
                                hintText: "Email or Phone number"),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(),
                          child: TextField(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintStyle:
                                    TextStyle(color: Colors.grey.withOpacity(.8)),
                                hintText: "Password"),
                          ),
                        ),
                      ],
                    ),
                  )),
              SizedBox(
                height: 40,
              ),
              FadeAnimation(
                  1.8,
                  Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Scan()),
                        );
                      },
                      child: Container(
                        width: 120,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.blue[800]),
                        child: Center(
                            child: Text(
                          "Login",
                          style: TextStyle(color: Colors.white.withOpacity(.7)),
                        )),
                      ),
                    ),
                  )),
            ],
          ),
        ),*/
      ),
    );
  }
}
