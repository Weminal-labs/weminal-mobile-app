import 'package:flutter_test/flutter_test.dart';
import 'package:sui/sui.dart';

void getSalt() {}

String generateNonce(dynamic publicEphemeral, double maxEpoch) {
  return "";
}

void getNonce(pubEphemeral) async {
  SuiClient client = SuiClient(SuiUrls.devnet);
  var getEpoch = await client.getLatestSuiSystemState();
  var epoch = getEpoch.epoch;
  var maxEpoch = double.parse(epoch) + 2;

  var ephemeralkey = Ed25519Keypair();
  final nonce = generateNonce(ephemeralkey.getPublicKey(), maxEpoch);
}

void getproof() {}

void main() {
  // JavascriptRuntime flutterJs = getJavascriptRuntime();

  // test('test generates the correct address', () async {
  //   JavascriptRuntime flutterJs = getJavascriptRuntime();
  //
  //   // String _jsResult = '';
  //   // try {
  //   //   JsEvalResult jsResult =
  //   //       flutterJs.evaluate("Math.trunc(Math.random() * 100).toString();");
  //   //   _jsResult = jsResult.stringResult;
  //   //   print('_jsResult: $_jsResult');
  //   // } catch (e) {
  //   //   print('ERRO: ${e}');
  //   // }
  //
  //   // final txb = TransactionBlock();
  //   // final ephemeralkey = Ed25519Keypair();
  //   // print(ephemeralkey.getPublicKey());
  //   // print(ephemeralkey.getSecretKey());
  //   // print('xxx');
  //   // expect(true, true);
  // });
}
