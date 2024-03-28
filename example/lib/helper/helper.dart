import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sui/sui.dart';

var suiClient = SuiClient(SuiUrls.devnet);

void showSnackBar(BuildContext context, String title, {int seconds = 3}) {
  Flushbar(
    icon: const Icon(Icons.info_outline),
    message: title,
    duration: Duration(seconds: seconds),
  ).show(context);
}

void showToast(BuildContext context, String title,
    {int seconds = 3, bool success = true}) {
  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: success ? Colors.greenAccent : Colors.redAccent,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(success ? Icons.check : Icons.close),
        const SizedBox(width: 12.0),
        Text(title),
      ],
    ),
  );
  FToast().init(context).showToast(
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 3),
      child: toast);
}

void showErrorToast(BuildContext context, String title, {int seconds = 3}) {
  showToast(context, title, seconds: seconds, success: false);
}

Future<SuiAccount> getSuiAccount() async {
  String? priKey =
      '4f8758c084e6ccc70d3380320e78e586011fd16cb9f03a25affdd50ff3445db7';

  return SuiAccount.fromPrivateKey(priKey, SignatureScheme.Ed25519);
}
