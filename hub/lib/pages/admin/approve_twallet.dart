import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State;
import 'package:provider/provider.dart';

import '../../index_files.dart';

class ApproveTWallet extends StatefulWidget {
  const ApproveTWallet({super.key});

  @override
  State<ApproveTWallet> createState() => _ApproveTWalletState();
}

class _ApproveTWalletState extends State<ApproveTWallet>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  bool l = false;
  List<TWalletModel> tWalletList = [];
  load() async {
    setState(() {
      l = true;
    });
    await loadTWallet();
    setState(() {
      l = false;
    });
  }

  Future<void> loadTWallet() async {
    AuthenticationProvider ap = context.read<AuthenticationProvider>();
    try {
      await mongoDB.maintainMongoDBConnection(context);
      DbCollection twallet = mongoDB.db.collection('twallet');
      await twallet.find().toList().then((res) async {
        setState(() {
          tWalletList = [
            for (final item in res.reversed.toList()) TWalletModel.fromMap(item)
          ];
        });
      });

      print("T Wallet loaded");
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    load();
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    AuthenticationProvider ap = context.watch<AuthenticationProvider>();
    HubManager hubManager = context.watch<HubManager>();
    WalletProvider wp = context.watch<WalletProvider>();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        /* elevation: 0,

        title: const Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Text(
            "Approve Wallet",
            style: TextStyle(color: Colors.white),
          ),
        ),
        centerTitle: true,
        actions: [],*/
        flexibleSpace: TabBar(
          labelColor: accentColor1,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: accentColor1,
          isScrollable: false,
          controller: tabController,
          onTap: (int index) {},
          tabs: const [
            Tab(
              text: "Pending",
            ),
            Tab(
              text: "Approved",
            ),
            Tab(
              text: "Rejected",
            ),
          ],
        ),
      ),
      body: l
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                ///PENDING
                Padding(
                  padding: const EdgeInsets.only(
                      left: 18, right: 18, top: 18, bottom: 8),
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: largeRadius),
                          child: Scrollbar(
                            thumbVisibility: true,
                            child: ListView(
                              physics: const BouncingScrollPhysics(),
                              children: [
                                for (var i = 0;
                                    i < tWalletList.length;
                                    i++) ...[
                                  if (tWalletList[i].status == "pending") ...[
                                    tWalletItem(
                                      tWallet: tWalletList[i],
                                    ),
                                  ],
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                ///APPROVED
                Padding(
                  padding: const EdgeInsets.only(
                      left: 18, right: 18, top: 18, bottom: 8),
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: largeRadius),
                          child: Scrollbar(
                            thumbVisibility: true,
                            child: ListView(
                              physics: const BouncingScrollPhysics(),
                              children: [
                                for (var i = 0;
                                    i < tWalletList.length;
                                    i++) ...[
                                  if (tWalletList[i].status == "approved") ...[
                                    tWalletItem(
                                      tWallet: tWalletList[i],
                                    ),
                                  ],
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                ///Rejected
                Padding(
                  padding: const EdgeInsets.only(
                      left: 18, right: 18, top: 18, bottom: 8),
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: largeRadius),
                          child: Scrollbar(
                            thumbVisibility: true,
                            child: ListView(
                              physics: const BouncingScrollPhysics(),
                              children: [
                                for (var i = 0;
                                    i < tWalletList.length;
                                    i++) ...[
                                  if (tWalletList[i].status == "rejected") ...[
                                    tWalletItem(
                                      tWallet: tWalletList[i],
                                    ),
                                  ],
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget tWalletItem({
    required TWalletModel tWallet,
  }) {
    WalletProvider wp = context.read<WalletProvider>();
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.all(6),
      decoration: BoxDecoration(
          color: accentColor1.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Id: " + tWallet.userId.toUpperCase(),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "UTR: " + tWallet.utr,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    DateFormat('yyyy-MM-dd ~ kk:mm')
                        .format(DateTime.parse(tWallet.timestamp)),
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  tWallet.amount.toString(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (tWallet.status == "pending" ||
                    tWallet.status == "rejected") ...[
                  FloatingActionButton.small(
                    onPressed: () async {
                      try {
                        await mongoDB.maintainMongoDBConnection(context);
                        DbCollection twallet = mongoDB.db.collection('twallet');
                        await twallet.updateMany({
                          'userId': tWallet.userId,
                          'timestamp': tWallet.timestamp
                        }, modify.set('status', "approved"));
                        DbCollection wallet = mongoDB.db.collection('wallet');
                        await wallet.insertOne({
                          'userId': tWallet.userId,
                          'amount': tWallet.amount,
                          'description': "Added to Wallet",
                          'timestamp': tWallet.timestamp,
                          'type': 'credit'
                        });

                        bool success = await wp.updateWalletAmount(
                            context: context,
                            loginType: LoginType.hub,
                            loginId: tWallet.userId,
                            amount: tWallet.amount,
                            credit: true);
                        if (success) {
                          messageDialog(context, "T Wallet Approved", true);
                          print("T Wallet Approved");
                        } else {
                          messageDialog(
                              context, "Error in updating TWallet", false);
                        }

                        load();
                      } catch (e) {
                        print(e);
                      }
                    },
                    backgroundColor: Colors.blue,
                    child: const Icon(
                      Icons.touch_app_rounded,
                    ),
                  ),
                  if (tWallet.status == "pending") ...[
                    FloatingActionButton.small(
                      onPressed: () async {
                        try {
                          await mongoDB.maintainMongoDBConnection(context);
                          DbCollection twallet =
                              mongoDB.db.collection('twallet');
                          await twallet.updateMany({
                            'userId': tWallet.userId,
                            'timestamp': tWallet.timestamp
                          }, modify.set('status', "rejected"));
                          messageDialog(context, "T Wallet Rejected", false);
                          print("T Wallet Rejected");
                          load();
                        } catch (e) {
                          print(e);
                        }
                      },
                      backgroundColor: Colors.redAccent,
                      child: const Icon(Icons.not_interested),
                    ),
                  ],
                ] else ...[
                  Icon(
                    Icons.verified,
                    color: Colors.green,
                    size: 40,
                  )
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }
}
