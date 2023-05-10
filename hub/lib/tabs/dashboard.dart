import 'package:flutter/material.dart';

import '../index_files.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: ListView(
          physics: BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 18,vertical: 18),
          scrollDirection: Axis.vertical,
          children: [
            /*tile(
                title: "Allocate Vehicle",
                icon: Icons.add_box_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AllocateVehicle()),
                  );
                }),*/
           /* tile(
                title: "Financial Review",
                icon: Icons.rate_review_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FinancialReview()),
                  );
                }),*/
            tile(
                title: "Documents View",
                icon: Icons.sticky_note_2_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DocumentsView()),
                  );
                }),
            /*tile(
                title: "Maintenance",
                icon: Icons.data_saver_on_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Maintenance(vehicleId: null,)),
                  );
                }),*/
            tile(
                title: "Alarms",
                icon: Icons.notifications_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Alarms()),
                  );
                }),
          ],
      ),
    );
  }

  Widget tile(
      {required String title,
      required IconData icon,
      required Function() onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Card(
        elevation: 2,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(largeRadius),
        ),
        child:Container(
          decoration: BoxDecoration(
            gradient: clg,
            borderRadius: BorderRadius.circular(largeRadius),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: ListTile(
            onTap: onTap,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(largeRadius),
            ),
            leading: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(smallRadius),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Icon(icon,color: Colors.black,),
                )),
            title: Text(
              title,
              style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
              size: 15,
            ),
          ),
          ),
        ),
      ),
    );
  }
}
