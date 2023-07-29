import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State, Center;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/index.dart';
import '../utils/index.dart';
import 'index.dart';
import '../widgets/index.dart';

class ManageUsers extends StatefulWidget {
  @override
  _ManageUsersState createState() => _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers> {
  List<Map<String, dynamic>> allUsers = [];
  bool isLoading = false;
  @override
  void dispose() {
    super.dispose();
  }

  load() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String homeId = (prefs.getString('homeId') ?? '');
    DbCollection users = mongoDB.db.collection('normalUsers');
    await users.find({'homeId': homeId}).toList().then((value) async {
          if (value.length > 0) {
            setState(() {
              allUsers = value;
            });
          }
        });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Manage Users",
          style: GoogleFonts.breeSerif(
            textStyle: TextStyle(color: Theme.of(context).iconTheme.color),
          ),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: FloatingActionButton.extended(
              elevation: 5,
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddUser()),
                );
                //addUser();
              },
              icon: Icon(Icons.person_add,
                  color: Theme.of(context).iconTheme.color),
              label: Text(
                'Add User',
                style: TextStyle(color: Theme.of(context).iconTheme.color),
              ),
            ),
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      ListTile(
                        title: Text('Users'),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                      ),
                      for (var i = 0; i < allUsers.length; i++) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          child: ListTile(
                            tileColor: Theme.of(context).cardColor,
                            title: Text(
                              allUsers[i]['name'] ?? '',
                              style: GoogleFonts.breeSerif(
                                textStyle: TextStyle(),
                              ),
                            ),
                            subtitle: Text(allUsers[i]['username'] ?? ''),
                            leading: Icon(Icons.person,
                                size: 40,
                                color: Theme.of(context).iconTheme.color),
                            /*  trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.edit,
                                      color: Theme.of(context).iconTheme.color),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.delete,
                                      color: Theme.of(context).iconTheme.color),
                                ),
                              ],
                            ),*/
                            onTap: () {},
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
