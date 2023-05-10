import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../providers/index.dart';
import '../utils/index.dart';
import '../widgets/index.dart';

class MenuDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.watch<UserProvider>();
    return ConstrainedBox(
      constraints: new BoxConstraints(maxWidth: 270, minWidth: 200),
      child: Container(
        color: Theme.of(context).primaryColor,
        child: Scrollbar(
          controller: _scrollController,
          isAlwaysShown: true,
          thickness: 3.5,
          child: ListView(
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            controller: _scrollController,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 3,
                            color: Theme.of(context).textTheme.caption!.color!),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(540),
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 90,
                            width: 90,
                            child: FadeInImage(
                              image: AssetImage("assets/rove.png"),
                              placeholder:
                                  AssetImage('assets/icons/loading.gif'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userProvider.user.name!,
                          style: GoogleFonts.breeSerif(
                            textStyle: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        /* SizedBox(height: 10.0),
                        AutoSizeText(
                          userProvider.user.email,
                          style: GoogleFonts.breeSerif(
                            textStyle: TextStyle(
                                fontSize: 10.0, fontWeight: FontWeight.bold),
                          ),
                        ),*/
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              DrawerItem(Icons.person, "Profile", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Profile()),
                );
              }),
              DrawerItem(Icons.delivery_dining, "Riding History", () {}),
              DrawerItem(Icons.inventory, "Invite Friends", () {}),
              DrawerItem(Icons.settings, "Settings", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Settings()),
                );
              }),
              DrawerItem(Icons.card_giftcard, "My Offers", () {}),
              DrawerItem(Icons.support_agent, "Online Support", () {}),
              DrawerItem(Icons.logout, "Logout", () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                //await context.read<UserProvider>().reset();
                prefs.setBool("loggedIn", false);
                prefs.setString("userId", "");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Welcome()),
                );
              }),
              DrawerItem(Icons.enhanced_encryption, "Encrypt", () {
                String enc = vehicleIdEncypt("101");
                print(enc);
              }),
            ],
          ),
        ),
      ),
    );
  }
}
