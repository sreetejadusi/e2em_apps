
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/index.dart';
import '../utils/index.dart';
import 'index.dart';
import '../widgets/index.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> with TickerProviderStateMixin {
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
    UserProvider userProvider = context.watch<UserProvider>();
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: MoveBackButton(
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: HeaderText(text:'Settings'),
            ),
            Expanded(
              child: ListView(
                children: [
                  ListCell.icon(
                      icon: Icons.security,
                      title: "Change Password",
                      subtitle: "*********",
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VerifyOTP(
                                    phoneNumber: userProvider.user.phoneNumber!,
                                    val: (bool value) {
                                      if (value) {
                                        print(value);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ResetPassword(
                                                    phoneNumber:
                                                        userProvider.user.phoneNumber,
                                                    email: userProvider.user.email,
                                                    password:
                                                        userProvider.user.password,
                                                  )),
                                        );
                                      }
                                    },
                                  )),
                        );
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
