import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../models/index.dart';
import '../widgets/index.dart';
Future<void> payment(
    {required BuildContext context,
    required UserModel user,
    required String amount,
    required String description,
    required Function(String ,dynamic) callBack}) async {
  Razorpay _razorpay;
  _razorpay = Razorpay();

  _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
      (PaymentSuccessResponse response) {
    callBack("PaymentSuccessResponse",response);
  });
  _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (PaymentFailureResponse response) {
    callBack("PaymentFailureResponse",response);
  });
  _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
      (ExternalWalletResponse response) {
    callBack("ExternalWalletResponse",response);
  });
  var options = {
    'key': 'rzp_test_1DP5mmOlF5G5ag',
   // 'key': 'rzp_test_U0vjGU89ekgwmm',
    'amount': amount.toString(),
    'name': 'E2EM',
    'description': description,
    'prefill': {'contact': user.phoneNumber, 'email': user.email},
    'external': {
      'wallets': ['paytm']
    }
  };
  try {
    _razorpay.open(options);
  } catch (e) {
    debugPrint('Error: e');
  }
}

ExternalWalletResponse _handleExternalWallet(ExternalWalletResponse response) {
  return response;
  //Fluttertoast.showToast(
  //  msg: "EXTERNAL_WALLET: " + response.walletName,
  //  toastLength: Toast.LENGTH_SHORT);
}
