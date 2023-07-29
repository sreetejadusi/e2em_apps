import 'dart:math';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/index.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State hide Center;
import 'package:provider/provider.dart';
import '../colors.dart';
import '../providers/index.dart';
import '../widgets/index.dart';
import '../utils/index.dart';
import 'index.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications>
    with TickerProviderStateMixin {
  bool isLoading = false;
  List<NotificationModel> notifications = [];
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    load();
    super.initState();
  }

  reload() {
    NotificationsProvider notificationsProvider =
        context.read<NotificationsProvider>();
    setState(() {
      notifications.clear();
    });
    for (var i = 0; i < notificationsProvider.notifications.length; i++) {
      setState(() {
        notifications.add(notificationsProvider.notifications[i]);
      });
    }
  }

  load() async {
    setState(() {
      isLoading = true;
    });
    UserProvider userProvider = context.read<UserProvider>();
    await context.read<NotificationsProvider>().load(userProvider.user);
    reload();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    NotificationsProvider notificationsProvider =
        context.watch<NotificationsProvider>();
    return Scaffold(
      body: isLoading
          ? Center(child: loaderSpin(context))
          : SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                child: Column(
                  children: [
                    MoveBackButton(
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          HeaderText(text:'Notifications'),
                          for (var i = 0; i < notifications.length; i++) ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: ListTile(
                                tileColor: cardColor,
                                title: Text(
                                  notifications[i].title!,
                                  style: GoogleFonts.breeSerif(
                                    textStyle: TextStyle(),
                                  ),
                                ),
                                subtitle: Text(
                                  notifications[i].subtitle!,
                                  style: GoogleFonts.breeSerif(
                                    textStyle: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w100),
                                  ),
                                ),
                                leading: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Icon(
                                    notifications[i].icon,
                                    size: 35,
                                    color: notifications[i].color,
                                  ),
                                ),
                                /*Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                   /* Container(
                                      width: 4,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(10)), //here
                                        color: notifications[i].color,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 11,
                                    ),*/

                                  ],
                                ),*/
                                /*  trailing: Transform.scale(
                                  scale: 0.7,
                                  child: IconButton(
                                    onPressed: () async {
                                      await checkMongoDBConnection();
                                      if (notifications[i].id != "-") {
                                        print(notifications[i].id);
                                        DbCollection notif =
                                            mongoDB.db.collection('notifications');
                                        await notif.deleteOne(<String, dynamic>{
                                          '_id':
                                              ObjectId.fromHexString(notifications[i].id)
                                        });
                                        await notificationsProvider.init();
                                        reload();
                                      } else {
                                        //notifications.removeAt(i);
                                        await notificationsProvider.removeNotification(
                                            notificationsProvider.notifications.length -
                                                1 -
                                                i);
                                        reload();
                                      }
                                    },
                                    icon: Center(child: Icon(Icons.close)),
                                  ),
                                ),*/
                                onTap: (){},
                                /*notifications[i].id != "-"
                                    ? () {
                                        print(notifications[i].id!);
                                      }
                                    : notifications[i].onTap!,*/
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                            )
                          ]
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
