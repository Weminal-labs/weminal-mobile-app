import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:sui/sui.dart';
import 'package:weminal_app/helper/helper.dart';
import 'package:weminal_app/zkLogin/my_address.dart';
import 'package:weminal_app/zkLogin/my_utils.dart';
import '../models/request_proof_model.dart';
import 'my_nonce.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MaterialApp(
    home: MyPage(),
  ));
}

class WebViewPage extends StatefulWidget {
  final String url;

  const WebViewPage({super.key, required this.url});
  @override
  State<WebViewPage> createState() => _WebViewPageState();
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
            String temp = redierct.replaceAll('$REDIRECT_URL', '');
            temp = temp.substring(0, temp.indexOf('&'));
            Navigator.pop(context, temp);
          },
          onNavigationRequest: (NavigationRequest request) {
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
            String URL =
                'https://accounts.google.com/o/oauth2/v2/auth/oauthchooseaccount?client_id=1083467233418-i6est2jg0mbd59ptddrf6elh2kg7uvf4.apps.googleusercontent.com&response_type=id_token&redirect_uri=$REDIRECT_URL&scope=openid&nonce=${res['nonce']}&service=lso&o2v=2&theme=mn&ddm=0&flowName=GeneralOAuthFlow';
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

                  requestProofModel.jwt = loginResRedirect;
                  _handleLogin(requestProofModel, res);
                },
                child: const Text('Login'),
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

  void _handleLogin(RequestProofModel requestProofModel, dynamic res) async {
    var proof = await getProof(RequestProofModel(
        jwt: requestProofModel.jwt,
        extendedEphemeralPublicKey:
            requestProofModel.extendedEphemeralPublicKey,
        maxEpoch: requestProofModel.maxEpoch,
        jwtRandomness: requestProofModel.jwtRandomness,
        salt: requestProofModel.salt,
        keyClaimName: requestProofModel.keyClaimName));
    var userAddress = jwtToAddress(
        requestProofModel.jwt!, BigInt.parse(requestProofModel.salt));
    // Save User Address
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userAddress', userAddress);

    final decodedJWT = JwtDecoder.decode(requestProofModel.jwt!);
    var addressSeed = genAddressSeed(BigInt.parse(requestProofModel.salt),
        'sub', decodedJWT['sub'], decodedJWT['aud']);
    ProofPoints proofPoints = ProofPoints.fromJson(proof['proofPoints']);
    ZkLoginSignatureInputs zkLoginSignatureInputs = ZkLoginSignatureInputs(
      proofPoints: proofPoints,
      issBase64Details: Claim.fromJson(proof['issBase64Details']),
      addressSeed: addressSeed.toString(),
      headerBase64: proof['headerBase64'],
    );
    Ed25519Keypair ephemeralKeyPair = res['ephemeralKeyPair'];
    var suiClient = SuiClient(SuiUrls.devnet);

    final txb = TransactionBlock();
    txb.setSender(userAddress);

    final faucet = FaucetClient(SuiUrls.faucetDev);
    var faucetResponse = await faucet.requestSuiFromFaucetV0(userAddress);

    final sign = await txb
        .sign(SignOptions(signer: ephemeralKeyPair, client: suiClient));

    final zkSign = getZkLoginSignature(ZkLoginSignature(
        inputs: zkLoginSignatureInputs,
        maxEpoch: int.parse((res['maxEpoch']!).toString().replaceAll('.0', '')),
        userSignature: base64Decode(sign.signature)));

    final resp = await suiClient.executeTransactionBlock(sign.bytes, [zkSign],
        options: SuiTransactionBlockResponseOptions(showEffects: true));
    String zkSignature = resp.digest;
    prefs.setString('zkSignature', zkSignature);
  }
}
