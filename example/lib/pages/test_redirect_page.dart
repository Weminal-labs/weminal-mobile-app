import 'dart:convert';

import 'package:example/model/RequestProofModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sui/builder/transaction_block.dart';
import 'package:sui/cryptography/ed25519_keypair.dart';
import 'package:sui/cryptography/keypair.dart';
import 'package:sui/sui_client.dart';
import 'package:sui/sui_urls.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:sui/zklogin/zklogin.dart';
import 'package:sui/zklogin/nouch.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

void main() {
  runApp(const MaterialApp(
    home: MyPage(),
  ));
}

class WebViewPage extends StatefulWidget {
  final String url;

  const WebViewPage({super.key, required this.url});
  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  String REDIRECT_URL = 'http://localhost:3000/#id_token=';
  var redierct = '';
  WebViewController getWebViewController(BuildContext context) {
    return WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setUserAgent("random")
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {
            print('redierct: $redierct');
            String temp = redierct.replaceAll('$REDIRECT_URL', '');
            temp = temp.substring(0, temp.indexOf('&'));
            print('temp: $temp');
            Navigator.pop(context, temp);
          },
          onNavigationRequest: (NavigationRequest request) {
            print('onNavigationRequest: ${request.url}');
            redierct = request.url;
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    print('URL: ${widget.url}');
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Simple Example')),
      body: WebViewWidget(
        controller: getWebViewController(context),
      ),
    );
  }
}

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final REDIRECT_URL = 'http%3A%2F%2Flocalhost%3A3000';
  final CLIENT_ID =
      '1083467233418-no9crphhseet7cgn7grsn98l16odg613.apps.googleusercontent.com';

  late Map<String, dynamic> info;

  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };

  Future<Map<String, dynamic>> getProof(
      RequestProofModel requestProofModel) async {
    var res = await http.post(Uri.parse('https://prover-dev.mystenlabs.com/v1'),
        headers: headers, body: jsonEncode(requestProofModel.toJson()));
    if (res.statusCode == 200) {
      Map<String, dynamic> response = jsonDecode(res.body);
      return response;
    } else {
      throw Exception("Load page fail ${res.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getInfoRequestProof(),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> res = snapshot.data!;
            print('getInfoRequestProof: $res');
            String URL =
                'https://accounts.google.com/o/oauth2/v2/auth/oauthchooseaccount?client_id=1083467233418-i6est2jg0mbd59ptddrf6elh2kg7uvf4.apps.googleusercontent.com&response_type=id_token&redirect_uri=$REDIRECT_URL&scope=openid&nonce=${res['nonce']}&service=lso&o2v=2&theme=mn&ddm=0&flowName=GeneralOAuthFlow';
            print('before URL: $URL');
            RequestProofModel requestProofModel = RequestProofModel(
              extendedEphemeralPublicKey: res['extendedEphemeralPublicKey']!,
              maxEpoch: res['maxEpoch']!,
              jwtRandomness: res['jwtRandomness']!,
              salt: res['salt']!,
            );
            return Center(
              child: ElevatedButton(
                onPressed: () async {
                  var loginResRedirect = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WebViewPage(
                          url: URL,
                        ),
                      ));
                  print('loginResRedirect: $loginResRedirect');
                  print('loginResRedirect: $loginResRedirect');

                  requestProofModel.jwt = loginResRedirect;
                  var proof = await getProof(RequestProofModel(
                      jwt: requestProofModel.jwt,
                      extendedEphemeralPublicKey:
                          requestProofModel.extendedEphemeralPublicKey,
                      maxEpoch: requestProofModel.maxEpoch,
                      jwtRandomness: requestProofModel.jwtRandomness,
                      salt: requestProofModel.salt,
                      keyClaimName: requestProofModel.keyClaimName));
                  print('proof: $proof');
                  var userAddress = jwtToAddress(requestProofModel.jwt!,
                      BigInt.parse(requestProofModel.salt));
                  print('userAddress: $userAddress');
                  final decodedJWT = JwtDecoder.decode(requestProofModel.jwt!);
                  var addressSeed = genAddressSeed(
                      BigInt.parse(requestProofModel.salt),
                      'sub',
                      decodedJWT['sub'],
                      decodedJWT['aud']);
                  print('addressSeed: $addressSeed');
                  ProofPoints proofPoints =
                      ProofPoints.fromJson(proof['proofPoints']);
                  print('proofPoints $proofPoints');
                  ZkLoginSignatureInputs zkLoginSignatureInputs =
                      ZkLoginSignatureInputs(
                    proofPoints: proofPoints,
                    issBase64Details: Claim.fromJson(proof['issBase64Details']),
                    addressSeed: addressSeed.toString(),
                    headerBase64: proof['headerBase64'],
                  );
                  print(zkLoginSignatureInputs);
                  // get userSignature
                  Ed25519Keypair ephemeralKeyPair = res['ephemeralKeyPair'];
                  print('ephemeralKeyPair: $ephemeralKeyPair');
                  var suiClient = SuiClient(SuiUrls.devnet);
                  var txb = TransactionBlock();
                  txb.setSender(userAddress);

                  SignatureWithBytes signatureWithBytes = await txb.sign(
                    SignOptions(ephemeralKeyPair),
                  );
                  print('signatureWithBytes: $signatureWithBytes');
                  // var userSignature = signatureWithBytes.signature;
                  // print('userSignature: $userSignature');
                },
                child: Text('Login'),
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('ERROR'),
            );
          } else {
            return const SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
