import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State;
import 'package:provider/provider.dart';

import '../../index_files.dart';

class HubWallet extends StatefulWidget {
  const HubWallet({super.key, required this.hubId});
  final String hubId;

  @override
  State<HubWallet> createState() => _HubWalletState();
}

class _HubWalletState extends State<HubWallet> {
  int walletBalance = 0;
  int updatedBalance = 0;
  bool editBalance = false;
  List<WalletTransactionModel> walletTransactions = [];
  List<TWalletModel> tWallet = [];
  bool l = false;
  load() async {
    setState(() {
      l = true;
    });
    await loadBalance();
    await loadWalletTransactions();
    await loadTWallet();
    setState(() {
      l = false;
    });
  }

  Future<void> loadBalance() async {
    setState(() {
      l = true;
    });
    setState(() {
      editBalance = false;
    });
    try {
      await mongoDB.maintainMongoDBConnection(context);
      DbCollection hubs = mongoDB.db.collection('hubs');
      await hubs.find({"hubId": widget.hubId}).toList().then((res) async {
            if (res.isNotEmpty) {
              try {
                setState(() {
                  walletBalance = int.parse(res[0]['wallet'].toString());
                });
              } catch (e) {
                setState(() {
                  walletBalance = 0;
                });
                print(e);
              }
            }
          });
      setState(() {
        l = false;
      });
      print("Wallet Balance loaded");
    } catch (e) {
      setState(() {
        l = false;
      });
      print(e);
    }
  }

  Future<void> loadWalletTransactions() async {
    try {
      await mongoDB.maintainMongoDBConnection(context);
      DbCollection wallet = mongoDB.db.collection('wallet');
      await wallet.find({"userId": widget.hubId}).toList().then((res) async {
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
    try {
      await mongoDB.maintainMongoDBConnection(context);
      DbCollection twallet = mongoDB.db.collection('twallet');
      await twallet.find({"userId": widget.hubId}).toList().then((res) async {
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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: backgroundColor,
      body: l
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.only(
                  left: 18, right: 18, top: 18, bottom: 8),
              child: Column(
                children: [
                  CustomContainer(
                    context: context,
                    widget: Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        title: Text(
                          "Balance",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        leading: IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              editBalance = !editBalance;
                            });
                          },
                        ),
                        trailing: Text(
                          walletBalance.toString(),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  if (editBalance) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextFormField(
                              initialValue: walletBalance.toString(),
                              decoration: const InputDecoration(
                                  labelText: "Edit Balance"),
                              keyboardType: TextInputType.number,
                              onChanged: (String value) {
                                setState(() {
                                  updatedBalance = int.parse(value);
                                });
                              },
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ], // Only numbers can be entered
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.save,
                              color: Colors.black,
                            ),
                            onPressed: () async {
                              try {
                                await mongoDB
                                    .maintainMongoDBConnection(context);
                                DbCollection hubs =
                                    mongoDB.db.collection('hubs');
                                await hubs.update(
                                    where.eq("hubId", widget.hubId),
                                    modify.set('wallet', updatedBalance));
                                await loadBalance();
                                setState(() {
                                  l = false;
                                });
                                print("Wallet Balance updated");
                              } catch (e) {
                                setState(() {
                                  l = false;
                                });
                                print(e);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(
                    height: 5,
                  ),
                  CustomContainer(
                    context: context,
                    widget: Padding(
                      padding: EdgeInsets.all(0.0),
                      child: Row(
                        children: [],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Expanded(
                    child: CustomContainer(
                      context: context,
                      widget: Padding(
                        padding: EdgeInsets.symmetric(vertical: largeRadius),
                        child: Scrollbar(
                          thumbVisibility: true,
                          child: ListView(
                            physics: BouncingScrollPhysics(),
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 18),
                                child: ListTile(
                                  title: Text(
                                    "Pending Wallet Transactions",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              for (var i = 0; i < tWallet.length; i++) ...[
                                if (tWallet[i].status == "pending") ...[
                                  walletTransactionItem(
                                    title: tWallet[i].status,
                                    description: "",
                                    amount: tWallet[i].amount.toString(),
                                    subtitle:
                                        dateFromString(tWallet[i].timestamp),
                                  ),
                                ],
                              ],
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 18),
                                child: ListTile(
                                  title: Text(
                                    "Wallet Transactions",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              for (var i = 0;
                                  i < walletTransactions.length;
                                  i++) ...[
                                walletTransactionItem(
                                  title: walletTransactions[i].type,
                                  description:
                                      walletTransactions[i].description,
                                  amount:
                                      walletTransactions[i].amount.toString(),
                                  subtitle: dateFromString(
                                      walletTransactions[i].timestamp),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget walletTransactionItem({
    required String title,
    required String description,
    required String amount,
    required String subtitle,
  }) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ListTile(
          tileColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(largeRadius),
          ),
          trailing: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              amount,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: title == "credit"
                    ? Colors.green
                    : title == "debit"
                        ? Colors.red
                        : Colors.black,
              ),
            ),
          ),
          title: Text(
            capitalize(title),
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (description.isNotEmpty) ...[
                Text(description),
              ],
              Text(subtitle),
            ],
          )),
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
