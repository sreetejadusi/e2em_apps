import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State;
import 'package:provider/provider.dart';

import '../providers/index.dart';
import '../utils/index.dart';
import 'index.dart';
import '../widgets/index.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../models/index.dart';

class MyWallet extends StatefulWidget {
  const MyWallet({Key? key}) : super(key: key);

  @override
  _MyWalletState createState() => _MyWalletState();
}

class _MyWalletState extends State<MyWallet> with TickerProviderStateMixin {
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
    await context.read<WalletProvider>().init();
    setState(() {
      isLoading = false;
    });
  }

  Widget item(
      {Color? color,
      IconData? icon,
      String? title,
      String? dateTime,
      String? amount}) {
    return ListTile(
      tileColor: Theme.of(context).cardColor,
      title: Text(
        title!,
        style: GoogleFonts.breeSerif(
          textStyle: TextStyle(),
        ),
      ),
      subtitle: Text(
        dateTime!,
        style: GoogleFonts.breeSerif(
          textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w100),
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.only(left: 15, right: 20),
        child: Text(
          amount!,
          textAlign: TextAlign.center,
          style: GoogleFonts.breeSerif(
            textStyle: TextStyle(fontSize: 25, color: color),
          ),
        ),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
    /* ListTile(
      tileColor: Theme.of(context).cardColor,
      title: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dateTime,
              style: GoogleFonts.breeSerif(
                textStyle: TextStyle(fontSize: 15),
              ),
            ),
            Spacer(),
            Text(
              amount,
              style: GoogleFonts.breeSerif(
                textStyle: TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
      ),
      subtitle: Row(
        children: [
          Icon(
            icon,
            color: color,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            title,
            style: GoogleFonts.breeSerif(
              textStyle: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
      /*  leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)), //here
              color: color,
            ),
          ),
          SizedBox(
            width: 11,
          ),

        ],
      ),*/
      //  trailing: trailing,
      contentPadding:
      EdgeInsets.symmetric(horizontal: 10),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)),
    );*/
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.watch<UserProvider>();
    WalletProvider walletProvider = context.watch<WalletProvider>();
    TransactionsProvider transactionsProvider =
        context.watch<TransactionsProvider>();
    return SafeArea(
      child: Scaffold(
        floatingActionButton: SizedBox(
          height: 50,
          child: FlatButton(
            onPressed: () async {
              Color c = Colors.white;
              showDialog(
                  context: context,
                  builder: (context) {
                    String amount = '0';
                    return CustomDialog(
                      icon: Icons.payment,
                      widget: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: TextFormField(
                          onChanged: (value) {
                            amount = value;
                          },
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: c),
                          cursorColor: c,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: c),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: c),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: c),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            hintText: 'Enter Amount',
                            hintStyle: TextStyle(color: c),
                            //labelText: label,
                          ),
                          maxLines: 1,
                        ),
                      ),
                      buttonlabel: 'Proceed',
                      buttonPressed: () async {
                        SystemChannels.textInput.invokeMethod('TextInput.hide');
                        await payment(
                            context: context,
                            user: userProvider.user,
                            amount: amount + ".0",
                            description: "Add Money to wallet",
                            callBack: (String type, dynamic data) async {
                              setState(() {
                                isLoading = true;
                              });
                              await checkMongoDBConnection();
                              switch (type) {
                                case "PaymentSuccessResponse":
                                  PaymentSuccessResponse response = data;
                                  //  await context
                                  //  .read<WalletProvider>()
                                  //  .init();
                                  DbCollection wallets =
                                      mongoDB.db.collection('wallets');
                                  DbCollection transactions =
                                      mongoDB.db.collection('transactions');
                                  await wallets.update(
                                      where.eq('userId', userProvider.user.id),
                                      modify.set(
                                          'balance',
                                          walletProvider.wallet.balance! +
                                              int.parse(amount)));
                                  TransactionModel transaction =
                                      TransactionModel();
                                  transaction.userId = userProvider.user.id;
                                  transaction.amount = amount;
                                  transaction.from = "payment";
                                  transaction.to = "wallet";
                                  transaction.timestamp =
                                      DateTime.now().toString();
                                  transaction.paymentId = response.paymentId;
                                  await transactions
                                      .insertOne(transaction.toMap());
                                  walletProvider.init();
                                  transactionsProvider.init();
                                  fullScreenMessageDialog(
                                      context: context,
                                      color: Theme.of(context).accentColor,
                                      icon: Icons.verified,
                                      title: 'Congrats',
                                      subtitle: 'Payment Successful',
                                      onBack: () {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      });
                                  setState(() {
                                    isLoading = false;
                                  });
                                  break;
                                case "PaymentFailureResponse":
                                  PaymentFailureResponse response = data;
                                  Navigator.pop(context);
                                  fullScreenMessageDialog(
                                      context: context,
                                      color: Colors.red,
                                      icon: Icons.error,
                                      title: 'Try Again',
                                      subtitle: 'Payment Failed',
                                      onBack: () {
                                        Navigator.pop(context);
                                      });
                                  setState(() {
                                    isLoading = false;
                                  });
                                  break;
                                case "ExternalWalletResponse":
                                  ExternalWalletResponse response = data;
                                  Navigator.pop(context);
                                  fullScreenMessageDialog(
                                      context: context,
                                      color: Theme.of(context).accentColor,
                                      icon: Icons.verified,
                                      title: 'Congrats',
                                      subtitle: 'Payment Successful',
                                      onBack: () {
                                        Navigator.pop(context);
                                      });
                                  setState(() {
                                    isLoading = false;
                                  });
                                  break;
                              }
                            });
                      },
                    );
                  });
            },
            padding: EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            child: Ink(
              decoration: BoxDecoration(
                color: Color(0xFF26352e),
                // color: Theme.of(context).accentColor.withOpacity(0.3),
                /* gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            Colors.blue,
                                            Colors.greenAccent,
                                          ],
                                        ),*/
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                alignment: Alignment.center,
                constraints: BoxConstraints(
                    minHeight: 75,
                    maxWidth: MediaQuery.of(context).size.width * 0.50),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add_to_photos,
                      color: Theme.of(context).accentColor,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Add Money',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        /* Transform.scale(
          scale: 1.0,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                border: Border.all(width: 1.5, color: Colors.blue
                    //color:Color(0xFFA8EE90),
                    )),
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: FloatingActionButton.extended(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                onPressed: () async {

                },
                elevation: 5,
                label: Text(
                  'Add Money',
                  style: GoogleFonts.breeSerif(
                    textStyle: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                icon: Icon(
                  Icons.add_to_photos,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
        ),*/
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: MoveBackButton(
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            walletProvider.isLoading ||
                    transactionsProvider.isLoading ||
                    isLoading
                ? Center(child: loaderSpin(context))
                : Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: ListView(
                        children: [
                          HeaderText(text: 'My Wallet'),
                          Container(
                            decoration: BoxDecoration(
                              // color: Theme.of(context).accentColor,
                              color: Color(0xFF26352e),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  child: Center(
                                    child: Icon(
                                      Icons.account_balance_wallet_outlined,
                                      size: 130,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Text(
                                  "Balance:",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.breeSerif(
                                    textStyle: TextStyle(fontSize: 20),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "₹ " +
                                      walletProvider.wallet.balance.toString(),
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.breeSerif(
                                    textStyle: TextStyle(fontSize: 25),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Divider(
                            thickness: 3,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WidgetScreen(
                                          title: "Wallet Transactions",
                                          widget: ListView(
                                            children: [
                                              for (var i = 0;
                                                  i <
                                                      transactionsProvider
                                                          .transactions.length;
                                                  i++) ...[
                                                if (transactionsProvider
                                                            .transactions[i]
                                                            .from ==
                                                        "wallet" ||
                                                    transactionsProvider
                                                            .transactions[i]
                                                            .to ==
                                                        "wallet") ...[
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 10,
                                                        horizontal: 15),
                                                    child: item(
                                                      color: transactionsProvider
                                                                  .transactions[
                                                                      i]
                                                                  .from ==
                                                              "wallet"
                                                          ? Colors.red
                                                          : Colors.green,
                                                      icon: Icons.payment,
                                                      title: transactionsProvider
                                                          .description(
                                                              transactionsProvider
                                                                  .transactions[i]),
                                                      dateTime:
                                                          transactionsProvider
                                                              .transactions[i]
                                                              .timestamp!
                                                              .toFormattedDate(),
                                                      amount:
                                                          transactionsProvider
                                                              .transactions[i]
                                                              .amount,
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ],
                                          ),
                                        )),
                              );
                            },
                            tileColor: Theme.of(context).cardColor,
                            title: Text(
                              "Wallet Transactions",
                              style: GoogleFonts.breeSerif(
                                textStyle: TextStyle(),
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            trailing: Icon(Icons.arrow_right),
                          ),
                          /* ExpansionTile(
                            title: Text(
                              "Wallet Transactions",
                              style: GoogleFonts.breeSerif(
                                textStyle: TextStyle(),
                              ),
                            ),
                            children: <Widget>[
                              for (var i = 0;
                                  i < transactionsProvider.transactions.length;
                                  i++) ...[
                                if (transactionsProvider.transactions[i].from ==
                                        "wallet" ||
                                    transactionsProvider.transactions[i].to ==
                                        "wallet") ...[
                                  item(
                                    color: transactionsProvider.transactions[i].from ==
                                            "wallet"
                                        ? Colors.red
                                        : Colors.green,
                                    icon: Icons.payment,
                                    title: transactionsProvider.description(
                                        transactionsProvider.transactions[i]),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          transactionsProvider.transactions[i].timestamp
                                              .toFormattedDate(),
                                          style: GoogleFonts.breeSerif(
                                            textStyle:
                                                TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Text(
                                          transactionsProvider.transactions[i].id,
                                          style: GoogleFonts.breeSerif(
                                            textStyle:
                                                TextStyle(fontWeight: FontWeight.w200),
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: Text(
                                      (transactionsProvider.transactions[i].from ==
                                                  "wallet"
                                              ? "-"
                                              : "+") +
                                          transactionsProvider.transactions[i].amount,
                                      style: GoogleFonts.breeSerif(
                                        textStyle: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ],
                          ),*/
                          SizedBox(
                            height: 100,
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
