import 'dart:async';
import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State hide Center;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/index.dart';
import '../utils/index.dart';
import 'index.dart';
import '../widgets/index.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../models/index.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({Key? key}) : super(key: key);

  @override
  _TransactionHistoryState createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory>
    with TickerProviderStateMixin {
  bool pay = false;
  bool isLoading = false;

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

  Future<void> load() async {
    UserProvider userProvider = context.read<UserProvider>();
    WalletProvider walletProvider = context.read<WalletProvider>();
    setState(() {
      isLoading = true;
    });
    await context.read<TransactionsProvider>().init();
    await context.read<WalletProvider>().init();
    setState(() {
      isLoading = false;
    });
  }

  Widget item({required TransactionModel t}) {
    WalletProvider walletProvider = context.read<WalletProvider>();
    UserProvider userProvider = context.read<UserProvider>();
    TransactionsProvider transactionsProvider =
        context.read<TransactionsProvider>();
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            tileColor: Colors.transparent,
            title: Text(
              transactionsProvider.description(t),
              style: GoogleFonts.breeSerif(
                textStyle: TextStyle(),
              ),
            ),
            subtitle: Text(
              t.timestamp!.toFormattedDate(),
              style: GoogleFonts.breeSerif(
                textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w100),
              ),
            ),
            trailing: t.from == "pending"
                ? ActionChip(
                    label: const Text("Pay"),
                    onPressed: () {
                      setState(() {
                        pay = !pay;
                      });
                      ////////////////////////////////////////////////////////////////
                      /*showDialog(
                          context: context,
                          builder: (context) {
                            return RoundDialog(
                              title: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.payment,
                                    size: 95,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'payment'.toUpperCase(),
                                    style: GoogleFonts.breeSerif(
                                      textStyle: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              children: <Widget>[
                                ////$///4////
                              ],
                            );
                          });*/
                      ////////////////////////////////////////////////////////////////
                    },
                  )
                : null,
            leading: Padding(
              padding: const EdgeInsets.only(left: 15, right: 20),
              child: Text(
                t.amount!,
                textAlign: TextAlign.center,
                style: GoogleFonts.breeSerif(
                  textStyle: TextStyle(
                      fontSize: 25,
                      color: t.from == "pending" ? Colors.blue : Colors.green),
                ),
              ),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          if (t.from == "pending" && pay) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  child: FloatingActionButton.extended(
                    elevation: 0,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    onPressed: () async {
                      if (walletProvider.wallet.balance! < 200) {
                        alertDialog(context, "Insufficient Balance",
                            'Your wallet has less amount', 'Ok');
                      } else {
                        setState(() {
                          isLoading = true;
                        });
                        await checkMongoDBConnection();
                        DbCollection wallets = mongoDB.db.collection('wallets');
                        DbCollection transactions =
                            mongoDB.db.collection('transactions');
                        await wallets.update(
                            where.eq('userId', userProvider.user.id),
                            modify.set('balance',
                                walletProvider.wallet.balance! - 200));
                        await transactions.update(
                            where.eq('_id', ObjectId.fromHexString(t.id!)),
                            modify.set('from', "wallet"));
                        await transactions.update(
                            where.eq('_id', ObjectId.fromHexString(t.id!)),
                            modify.set('timestamp', DateTime.now().toString()));
                        walletProvider.init();
                        transactionsProvider.init();
                        fullScreenMessageDialog(
                            context: context,
                            color: Theme.of(context).colorScheme.secondary,
                            icon: Icons.verified,
                            title: 'Congrats',
                            subtitle: 'Payment Successful',
                            onBack: () {
                              //Navigator.pop(context);
                              Navigator.pop(context);
                            });
                        setState(() {
                          isLoading = false;
                        });
                      }
                    },
                    label: Text(
                      "Wallet",
                      style: TextStyle(color: Colors.black),
                    ),
                    icon: null,
                  ),
                ),
                Text(
                  "OR",
                  style: TextStyle(color: Colors.white),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  child: FloatingActionButton.extended(
                    elevation: 0,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    onPressed: () async {
                      await checkMongoDBConnection();
                      await payment(
                          context: context,
                          user: userProvider.user,
                          amount: "200" + ".0",
                          description: "Pay for Ride",
                          callBack: (String type, dynamic data) async {
                            switch (type) {
                              case "PaymentSuccessResponse":
                                PaymentSuccessResponse response = data;
                                setState(() {
                                  isLoading = true;
                                });
                                await checkMongoDBConnection();
                                DbCollection transactions =
                                    mongoDB.db.collection('transactions');
                                await transactions.update(
                                    where.eq(
                                        '_id', ObjectId.fromHexString(t.id!)),
                                    modify.set('from', "payment"));
                                walletProvider.init();
                                transactionsProvider.init();
                                fullScreenMessageDialog(
                                    context: context,
                                    color: Theme.of(context).colorScheme.secondary,
                                    icon: Icons.verified,
                                    title: 'Congrats',
                                    subtitle: 'Payment Successful',
                                    onBack: () {
                                      //Navigator.pop(context);
                                      Navigator.pop(context);
                                    });
                                setState(() {
                                  isLoading = false;
                                });
                                break;
                              case "PaymentFailureResponse":
                                PaymentFailureResponse response = data;
                                fullScreenMessageDialog(
                                    context: context,
                                    color: Colors.red,
                                    icon: Icons.error,
                                    title: 'Try Again',
                                    subtitle: 'Payment Failed',
                                    onBack: () {
                                      //Navigator.pop(context);
                                      Navigator.pop(context);
                                    });
                                break;
                              case "ExternalWalletResponse":
                                ExternalWalletResponse response = data;
                                fullScreenMessageDialog(
                                    context: context,
                                    color: Theme.of(context).colorScheme.secondary,
                                    icon: Icons.verified,
                                    title: 'Congrats',
                                    subtitle: 'Payment Successful',
                                    onBack: () {
                                      //Navigator.pop(context);
                                      Navigator.pop(context);
                                    });
                                setState(() {
                                  isLoading = false;
                                });
                                break;
                            }
                          });
                    },
                    label: Text(
                      "Payment",
                      style: TextStyle(color: Colors.black),
                    ),
                    icon: null,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
          ]
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.watch<UserProvider>();
    WalletProvider walletProvider = context.watch<WalletProvider>();
    TransactionsProvider transactionsProvider =
        context.watch<TransactionsProvider>();
    return SafeArea(
      child: Scaffold(
        body: walletProvider.isLoading ||
                transactionsProvider.isLoading ||
                isLoading
            ? Center(child: loaderSpin(context))
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
                    child: HeaderText(
                      text: "Payments",
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        for (var i = 0;
                            i < transactionsProvider.transactions.length;
                            i++) ...[
                          if (transactionsProvider.transactions[i].from !=
                                  "wallet" &&
                              transactionsProvider.transactions[i].to !=
                                  "wallet") ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              child: item(
                                t: transactionsProvider.transactions[i],
                              ),
                            ),
                          ],
                        ],
                        SizedBox(
                          height: 100,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
