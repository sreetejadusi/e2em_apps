import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../index_files.dart';

class AllocateCollectTab extends StatefulWidget {
  const AllocateCollectTab({super.key, required this.tabChange});
  final Function(int) tabChange;

  @override
  State<AllocateCollectTab> createState() => _AllocateCollectTabState();
}

class _AllocateCollectTabState extends State<AllocateCollectTab> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    VehiclesProvider vp = context.watch<VehiclesProvider>();
    AuthenticationProvider ap = context.watch<AuthenticationProvider>();
    HubManager hubManager = context.watch<HubManager>();
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: TabBar(
              indicatorColor: accentColor1,
              isScrollable: false,
              indicatorPadding: const EdgeInsets.symmetric(horizontal: 20),
              indicatorWeight: 2.5,
              indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(width: 2.0, color: accentColor1),
                  insets: EdgeInsets.symmetric(horizontal: 24.0)),
              tabs: const [
                Tab(
                  child: Text(
                    "Allocate",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 18),
                  ),
                ),
                Tab(
                  child: Text(
                    "Collect",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              AllocateVehicle(
                vehicleId: null,
                tabChange: (int index) {
                  widget.tabChange(index);
                },
              ),
              CollectVehicle(
                vehicleId: null,
                tabChange: (int index) {
                  widget.tabChange(index);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
