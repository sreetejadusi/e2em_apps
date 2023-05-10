import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State;
import 'package:provider/provider.dart';
import 'index_files.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> with TickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  late TabController tabController;
  LoginType lt = LoginType.hub;
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isLoading = false;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
    tabController = TabController(initialIndex: 0, vsync: this, length: 2);
    tabController.addListener(() {
      if (tabController.index == 0) {
        setState(() {
          lt = LoginType.hub;
        });
      } else if (tabController.index == 1) {
        setState(() {
          lt = LoginType.admin;
        });
      } /*else if (tabController.index == 2) {
        setState(() {
          lt = LoginType.admin;
        });
      } */else {
        setState(() {
          lt = LoginType.none;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    AuthenticationProvider ap = context.watch<AuthenticationProvider>();
    UserProvider up = context.watch<UserProvider>();
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {},
                tooltip: "Internet Connection",
                icon: Icon(
                  Icons.signal_cellular_alt,
                  color: up.internetConnection
                      ? Colors.greenAccent
                      : Colors.deepOrange,
                )),
            IconButton(
                onPressed: () {},
                tooltip: "Server Connection",
                icon: Icon(
                  Icons.compass_calibration_outlined,
                  color: up.serverConnection
                      ? Colors.greenAccent
                      : Colors.deepOrange,
                )),
          ],
          /*flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: lg,
            ),
          ),*/
        ),
        bottomNavigationBar: InkWell(
          onTap: () {
            /* Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Start()),
            );*/
          },
          child: Container(
            decoration: BoxDecoration(gradient: lg),
            child: const ListTile(
              title: Text(
                "Forgot Password?",
                textAlign: TextAlign.center,
                style: TextStyle(
                    // fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      //gradient: lg,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(35),
                        bottomRight: Radius.circular(35),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            "assets/logo.png",
                            height: 200,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          /*SizedBox(
                            height: h * 0.15,
                            child: Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.circular(largeRadius),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Text(
                                      "EV2GO ${lt == LoginType.driver ? "Driver" : lt == LoginType.hub ? "Hub" : lt == LoginType.admin ? "Admin" : ""}",
                                      style: const TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue),
                                    ),
                                  ),
                                ),
                                /* Icon(
                                  Icons.login,
                                  size: 55,
                                  color: Colors.white,
                                ),*/
                              ),
                            ),
                          ),*/
                          SizedBox(
                            height: h * 0.010,
                          ),
                          /* Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),*/
                          /* SizedBox(
                            height: h * 0.02,
                          ),
                          Text(
                            "Please enter your details",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),*/
                          SizedBox(
                            height: h * 0.00,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: h * 0.00,
                  ),
                  TabBar(
                    controller: tabController,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black,
                    indicator: BoxDecoration(
                      color: accentColor1,
                      borderRadius: BorderRadius.circular(500),
                    ),
                    indicatorPadding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    tabs: const [
                     /* Tab(
                        child: Text(
                          "Driver",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),*/
                      Tab(
                        child: Text(
                          "Hub",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Tab(
                        child: Text(
                          "Admin",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: h * 0.02,
                        ),
                        textFieldTitle("Username"),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          cursorColor: cursorColor,
                          onChanged: (value) {},
                          controller: username,
                          onTap: () {
                            print("tap");
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
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
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            hintText: "Enter Username",
                            //labelText: "Name"
                          ),
                        ),
                        SizedBox(
                          height: h * 0.01,
                        ),
                        textFieldTitle("Password"),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          cursorColor: cursorColor,
                          onChanged: (value) {},
                          controller: password,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Password field cannot be empty";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: border,
                            labelStyle: labelStyle,
                            errorBorder: errorBorder,
                            enabledBorder: enabledBorder,
                            focusedBorder: focusedBorder,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            hintText: "Enter Password",
                            //labelText: "Password"
                          ),
                        ),
                        SizedBox(
                          height: h * 0.02,
                        ),
                        /*MaterialButton(
                  onPressed: () {},
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: thirdAccentColor),
                  ),
                ),*/
                        SizedBox(
                          height: h * 0.04,
                        ),
                        if (ap.signInLoading) ...[
                          const Center(child: CircularProgressIndicator())
                        ] else ...[
                          InkWell(
                            onTap: () async {
                              if (formKey.currentState!.validate()) {
                                SystemChannels.textInput
                                    .invokeMethod('TextInput.hide');
                                ap.login(
                                    context: context,
                                    lt: lt,
                                    username: username.text,
                                    password: password.text);
                              }
                            },
                            child: Container(
                                height: 48,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: accentColor1,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                ),
                                child: Center(
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )),
                          ),
                        ],
                        SizedBox(
                          height: h * 0.02,
                        ),
                      ],
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
