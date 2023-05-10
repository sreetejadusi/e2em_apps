import 'package:auto_size_text/auto_size_text.dart';
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
import '../sidebar/index.dart';

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
    RoomsAndDevicesProvider roomsAndDevicesProvider =
        context.watch<RoomsAndDevicesProvider>();
    DataProvider dataProvider = context.watch<DataProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: GoogleFonts.breeSerif(
            textStyle: TextStyle(color: Theme.of(context).iconTheme.color),
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ListCell.icon(
              icon: Icons.refresh,
              title: "Refresh",
              subtitle: "Refresh Rooms & Devices",
              onTap: () async {
                await DatabaseProvider.db.clearRooms();
                await DatabaseProvider.db.clearDevices();
                await DatabaseProvider.db.clearSensors();
                await DatabaseProvider.db.clearMiscellaneous();
                await dataProvider.init();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SideBarLayout()
                      // HomeScreen()
                      ),
                );
              }),
        ],
      ),
    );
  }
}
