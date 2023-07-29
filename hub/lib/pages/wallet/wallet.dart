import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hub/widgets/appbar.dart';
import 'package:intl/intl.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State;
import 'package:provider/provider.dart';

import '../../index_files.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  List<WalletTransactionModel> walletTransactions = [];
  List<TWalletModel> tWallet = [];
  bool l = false;
  load() async {
    WalletProvider wp = context.read<WalletProvider>();
    setState(() {
      l = true;
    });
    await wp.init(context: context);
    await loadWalletTransactions();
    await loadTWallet();
    setState(() {
      l = false;
    });
  }

  Future<void> loadWalletTransactions() async {
    AuthenticationProvider ap = context.read<AuthenticationProvider>();
    try {
      await mongoDB.maintainMongoDBConnection(context);
      DbCollection wallet = mongoDB.db.collection('wallet');
      await wallet.find({"userId": ap.loginId}).toList().then((res) async {
            setState(() {
              walletTransactions = [
                for (final item in res.reversed.toList())
                  WalletTransactionModel.fromMap(item)
              ];
            });
          });

      print("Wallet Transactions loaded");
    } catch (e) {
      print(e);
    }
  }

  Future<void> loadTWallet() async {
    AuthenticationProvider ap = context.read<AuthenticationProvider>();
    try {
      await mongoDB.maintainMongoDBConnection(context);
      DbCollection twallet = mongoDB.db.collection('twallet');
      await twallet.find({"userId": ap.loginId}).toList().then((res) async {
            setState(() {
              tWallet = [
                for (final item in res.reversed.toList())
                  TWalletModel.fromMap(item)
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
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: accentColor1,
      //   title: const Padding(
      //     padding: EdgeInsets.symmetric(vertical: 15),
      //     child: Text(
      //       "Wallet",
      //       style: TextStyle(color: Colors.white),
      //     ),
      //   ),
      //   centerTitle: true,
      //   actions: [],
      // ),
      appBar: GradientAppBar(title: 'Wallet', automaticallyImplyLeading: true),
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const WalletAddMoney()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: accentColor1,
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  height: 40,
                  width: w * 0.35,
                  child: Center(
                    child: Text(
                      "Add Money",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
      body: l
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 18, right: 18, top: 18, bottom: 8),
                child: Column(
                  children: [
                    // CustomContainer(
                    //   context: context,
                    //   widget: Padding(
                    //     padding: EdgeInsets.all(8.0),
                    //     child: ListTile(
                    //       title: Text(
                    //         "Wallet Balance",
                    //         style: TextStyle(
                    //             fontSize: 18, fontWeight: FontWeight.bold),
                    //       ),
                    //       leading: Icon(
                    //         Icons.account_balance_wallet,
                    //         size: 35,
                    //         color: Colors.black,
                    //       ),
                    //       trailing: Text(
                    //         wp.walletBalance.toString(),
                    //         style: TextStyle(
                    //             fontSize: 25, fontWeight: FontWeight.bold),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 12,
                    // ),
                    // CustomContainer(
                    //   context: context,
                    //   widget: Padding(
                    //     padding: EdgeInsets.all(0.0),
                    //     child: Row(
                    //       children: [
                    //         Expanded(
                    //           flex: 1,
                    //           child: ListTile(
                    //             title: Center(
                    //               child: Text(
                    //                 "Min Balance",
                    //                 style: TextStyle(
                    //                     fontSize: 18,
                    //                     fontWeight: FontWeight.normal),
                    //               ),
                    //             ),
                    //             subtitle: Padding(
                    //               padding: EdgeInsets.only(top: 5),
                    //               child: Center(
                    //                 child: Text(
                    //                   ap.hub!.minBalance.toString(),
                    //                   style: TextStyle(
                    //                       fontSize: 18,
                    //                       fontWeight: FontWeight.normal),
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //         Expanded(
                    //           flex: 1,
                    //           child: ListTile(
                    //             title: const Center(
                    //               child: Text(
                    //                 "Usable Balance",
                    //                 style: TextStyle(
                    //                     fontSize: 18,
                    //                     fontWeight: FontWeight.normal),
                    //               ),
                    //             ),
                    //             subtitle: Padding(
                    //               padding: const EdgeInsets.only(top: 5),
                    //               child: Center(
                    //                 child: Text(
                    //                   wp.usableBalance.toString(),
                    //                   style: const TextStyle(
                    //                       fontSize: 18,
                    //                       fontWeight: FontWeight.normal),
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    Row(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(vertical: 6),
                          width: 173,
                          height: 123,
                          decoration: BoxDecoration(
                              color: accentColor1,
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(48)),
                                  child: Icon(FontAwesomeIcons.wallet)),
                              Text(
                                'Total Balance',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'RS ${wp.walletBalance}',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              balanceWidget('Minimum Balance',
                                  ap.hub!.minBalance.toString()),
                              SizedBox(
                                height: 4,
                              ),
                              balanceWidget(
                                  'Usable Balance', wp.usableBalance.toString())
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    // Expanded(
                    //   child: CustomContainer(
                    //     context: context,
                    //     widget: Padding(
                    //       padding: EdgeInsets.symmetric(vertical: largeRadius),
                    //       child: Scrollbar(
                    //         thumbVisibility: true,
                    //         child: ListView(
                    //           physics: BouncingScrollPhysics(),
                    //           children: [
                    //             const Padding(
                    //               padding: EdgeInsets.symmetric(horizontal: 18),
                    //               child: ListTile(
                    //                 title: Text(
                    //                   "Pending Wallet Transactions",
                    //                   style:
                    //                       TextStyle(fontWeight: FontWeight.bold),
                    //                 ),
                    //               ),
                    //             ),
                    //             for (var i = 0; i < tWallet.length; i++) ...[
                    //               if (tWallet[i].status == "pending") ...[
                    //                 walletTransactionItem(
                    //                   title: tWallet[i].status,
                    //                   description: "",
                    //                   amount: tWallet[i].amount.toString(),
                    //                   subtitle:
                    //                       dateFromString(tWallet[i].timestamp),
                    //                 ),
                    //               ],
                    //             ],
                    //             const Padding(
                    //               padding: EdgeInsets.symmetric(horizontal: 18),
                    //               child: ListTile(
                    //                 title: Text(
                    //                   "Wallet Transactions",
                    //                   style:
                    //                       TextStyle(fontWeight: FontWeight.bold),
                    //                 ),
                    //               ),
                    //             ),
                    //             for (var i = 0;
                    //                 i < walletTransactions.length;
                    //                 i++) ...[
                    //               walletTransactionItem(
                    //                 title: walletTransactions[i].type,
                    //                 description:
                    //                     walletTransactions[i].description,
                    //                 amount:
                    //                     walletTransactions[i].amount.toString(),
                    //                 subtitle: dateFromString(
                    //                     walletTransactions[i].timestamp),
                    //               ),
                    //             ],
                    //           ],
                    //         ),
                    //       ),

                    //     ),
                    //   ),
                    // ),
                    transacionsWidget('Pending Transactions', [
                      for (var i = 0; i < tWallet.length; i++) ...[
                        if (tWallet[i].status == "pending") ...[
                          walletTransactionItem(
                              title: tWallet[i].status,
                              description: "",
                              amount: tWallet[i].amount.toString(),
                              subtitle: dateFromString(tWallet[i].timestamp),
                              leading: ''),
                        ],
                      ]
                    ]),
                    SizedBox(
                      height: 18,
                    ),
                    transacionsWidget('Wallet Transactions', [
                      for (var i = 0; i < walletTransactions.length; i++) ...[
                        walletTransactionItem(
                          title: walletTransactions[i].type,
                          description: walletTransactions[i].description,
                          amount: walletTransactions[i].amount.toString(),
                          subtitle:
                              dateFromString(walletTransactions[i].timestamp),
                          leading:
                              (walletTransactions[i].metadata.toUpperCase()),
                        )
                      ]
                    ])
                  ],
                ),
              ),
            ),
    );
  }

  Widget transacionsWidget(String title, List<Widget> widgets) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Color(0xFF7d7d7d).withOpacity(0.25),
                offset: Offset(1, 2),
                blurRadius: 10)
          ]),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: Color(0xFF4d4d4d),
          collapsedIconColor: Color(0xFF4d4d4d),
          textColor: Color(0xFF1d1d1d),
          collapsedTextColor: Color(0xFF1d1d1d),
          initiallyExpanded: true,
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          children: widgets,
        ),
      ),
    );
  }

  Widget walletTransactionItem(
      {required String title,
      required String description,
      required String amount,
      required String subtitle,
      required String leading}) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return ListTile(
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(largeRadius),
      ),
      trailing: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          (title == "credit" ? '+' : '-') + amount,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: title == "credit"
                  ? Colors.green
                  : title == "debit"
                      ? Colors.red
                      : Colors.black),
        ),
      ),

      title: Text(
        capitalize(description),
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),

      // subtitle: Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   mainAxisSize: MainAxisSize.min,
      //   children: [
      //     if (description.isNotEmpty) ...[
      //       Text(description),
      //     ],
      //     Text(subtitle),
      //   ],
      // )),
      subtitle: Text(
        subtitle + '\n' + leading,
      ),
    );
  }

  Widget cardItem(
      {required int num,
      required String title,
      required IconData icon,
      required Function() onTap}) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: CustomContainer(
        context: context,
        widget: InkWell(
          onTap: onTap,
          radius: largeRadius,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(smallRadius),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(
                          icon,
                          color: Colors.black,
                        ),
                      )),
                ),
                Center(
                  child: Text(
                    num.toString(),
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 10),
                    child: Text(
                      title,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget balanceWidget(String heading, balance) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 6),
    width: double.infinity,
    decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: accentColor1,
          width: 1.8,
        ),
        borderRadius: BorderRadius.circular(10)),
    child: Column(children: [
      Text(heading),
      Text(
        balance,
        style: TextStyle(color: accentColor1),
      ),
    ]),
  );
}
