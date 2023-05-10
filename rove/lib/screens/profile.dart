import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/index.dart';

import 'package:provider/provider.dart';
import '../widgets/index.dart';
import '../providers/index.dart';

class Profile extends StatefulWidget {


  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with TickerProviderStateMixin {
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
        body: userProvider.isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
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
                    child: HeaderText(text: 'Profile'),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 10.0),
                          card(
                            Column(
                              children: [
                                ProfileListTile("Name",
                                    userProvider.user.name ?? '', Icons.person),
                                ProfileListTile(
                                    "Phone Number",
                                    userProvider.user.phoneNumber ?? "",
                                    Icons.phone_enabled),
                                ProfileListTile("Email",
                                    userProvider.user.email ?? "", Icons.mail),
                                ProfileListTile(
                                    "Age",
                                    userProvider.user.age ?? '',
                                    Icons.calendar_today_outlined),
                                ProfileListTile(
                                    "City",
                                    userProvider.user.city ?? '',
                                    Icons.location_on),
                                ProfileListTile(
                                    "Occupation",
                                    userProvider.user.occupation ?? "",
                                    Icons.work),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget card(Widget widget) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        elevation: 7.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: widget,
        ),
      ),
    );
  }
}
