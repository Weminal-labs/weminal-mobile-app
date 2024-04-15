import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:sui/sui.dart';
import 'package:weminal_app/helper/helper.dart';
import 'package:weminal_app/utilities/router_manager.dart';
import 'package:weminal_app/viewmodels/login_provider.dart';
import 'package:weminal_app/zkLogin/my_address.dart';
import 'package:weminal_app/zkLogin/my_nonce.dart';
import 'package:weminal_app/zkLogin/my_utils.dart';
import '../models/request_proof_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MaterialApp(
    home: LoginPage(),
  ));
}

class WebViewPage extends StatefulWidget {
  final String url;

  const WebViewPage({super.key, required this.url});
  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  bool isLoading = false;
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
            setState(() {
              isLoading = true;
            });
            if (error.url?.contains('account.google.com') ?? false) {
              print('error: ${error.url}');
              setState(() {
                isLoading = false;
              });
            }
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
            child: Center(
              child: WebViewWidget(
                controller: getWebViewController(context),
              ),
            )
          ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final REDIRECT_URL = 'http%3A%2F%2Flocalhost%3A3000';
  final CLIENT_ID =
      '1083467233418-no9crphhseet7cgn7grsn98l16odg613.apps.googleusercontent.com';

  late Map<String, dynamic> info;

  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };

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
            print('ephemeralPrivateKey: ${res['ephemeralPrivateKey']}');
            return Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                        image: AssetImage('assets/images/bg_app.png'),
                        fit: BoxFit.cover,
                      )),
                ),
                Container(
                  padding: const EdgeInsets.only(
                      bottom: 50,
                      right: 50,
                      left: 30,
                      top: 20), // Add top padding
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "TOGETHER",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 40.0,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                          decoration: TextDecoration.none,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "WE",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              letterSpacing: 5,
                              fontSize: 40.0,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              decoration: TextDecoration.none,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            "CAN",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              letterSpacing: 5,
                              fontSize: 40.0,
                              fontWeight: FontWeight.w900,
                              color: Color.fromRGBO(86, 105, 255, 1.000),
                              decoration: TextDecoration.none,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            "!",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 40.0,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              decoration: TextDecoration.none,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      const Text(
                        "Fauget Foundation is looking for dedicated volunteers to help us with our charity works.",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      const Text(
                        "JOIN WITH US",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 40.0,
                          fontWeight: FontWeight.w900,
                          color: Color.fromRGBO(86, 105, 255, 1.000),
                          decoration: TextDecoration.none,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 40.0),
                      OutlinedButton(
                        onPressed: () async {
                          // login with google
                          try {
                            await _handleLoginButtonClick(
                                URL, requestProofModel, res);
                          } catch (e) {
                            print('Exception');

                            throw Exception(e.toString());
                          }
                          _goToMainPage();
                        },
                        style: OutlinedButton.styleFrom(
                            foregroundColor:
                                const Color.fromRGBO(86, 105, 255, 1.000),
                            textStyle: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                            padding: const EdgeInsets.only(
                                left: 50, right: 50, top: 20, bottom: 20)),
                        child: const Row(children: [
                          Image(
                            image: AssetImage("assets/images/icon_google.png"),
                            height: 30,
                            width: 30.0,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 30),
                            child: Text("Login with google"),
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('ERROR'),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Future<void> _handleLoginButtonClick(
      String URL, RequestProofModel requestProofModel, dynamic res) async {
    var loginResRedirect = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WebViewPage(
            url: URL,
          ),
        ));
    print('loginResRedirect: $loginResRedirect');
    if (loginResRedirect != null) {
      requestProofModel.jwt = loginResRedirect;
      // _handleLogin(requestProofModel, res);
      context
          .read<LoginProvider>()
          .loadAddressAndSignature(loginResRedirect, res);
    }
  }

  void _goToMainPage() {
    Navigator.pushReplacementNamed(context, Routes.mainPage);
  }
}
