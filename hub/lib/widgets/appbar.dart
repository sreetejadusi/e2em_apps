import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hub/index_files.dart';
import 'package:hub/providers/user_provider.dart';
import 'package:provider/provider.dart';

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GradientAppBar(
      {super.key,
      required this.title,
      required this.automaticallyImplyLeading,
      this.actions = const [ProfileImage()]});
  final String title;
  final bool automaticallyImplyLeading;
  final List<Widget> actions;
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: kToolbarHeight * 2.2,
      decoration: BoxDecoration(gradient: lg),
      child: AppBar(
        automaticallyImplyLeading: automaticallyImplyLeading,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        title: FittedBox(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: TextStyle(
              color: Color(0xFF303030),
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),
        ),
        centerTitle: false,
        // actions: [
        // Row(
        //   children: [
        //     Icon(
        //       Icons.compass_calibration_outlined,
        //       color: up.serverConnection ? Colors.black : Colors.deepOrange,
        //     ),
        //     /* SizedBox(width: 10,),
        //       Icon(
        //         Icons.network_cell,
        //         color: up.internetConnection
        //             ? Colors.greenAccent
        //             : Colors.deepOrange,
        //       ),*/
        //     SizedBox(
        //       width: 15,
        //     ),
        //     /*IconButton(
        //           onPressed: () async {
        //             await mongoDB.maintainMongoDBConnection(context);
        //           },
        //           tooltip: "Refresh",
        //           icon: Icon(
        //             Icons.refresh,
        //             color: Colors.greenAccent,
        //           )),*/
        //   ],
        // ),
        //   Padding(
        //     padding: const EdgeInsets.only(right: 12.0),
        //     child: InkWell(
        //       onTap: () {
        //         if (ap.loginType == LoginType.hub) {
        //           Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //                 builder: (context) => const HubProfile(
        //                       appBar: true,
        //                     )),
        //           );
        //         }
        //       },
        //       child: ClipOval(
        //         child: Image.asset(
        //           'assets/sample_avatar.png',
        //           width: 60,
        //           height: 60,
        //         ),
        //       ),
        //     ),
        //   )
        // ],
        actions: actions,
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight * 1.3);
}

class ProfileImage extends StatelessWidget {
  const ProfileImage({super.key});

  @override
  Widget build(BuildContext context) {
    UserProvider up = context.watch<UserProvider>();
    AuthenticationProvider ap = context.watch<AuthenticationProvider>();
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: InkWell(
        onTap: () {
          if (ap.loginType == LoginType.hub) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const HubProfile(
                        appBar: true,
                      )),
            );
          }
        },
        child: ClipOval(
          child: Image.asset(
            'assets/sample_avatar.png',
            width: 60,
            height: 60,
          ),
        ),
      ),
    );
  }
}
