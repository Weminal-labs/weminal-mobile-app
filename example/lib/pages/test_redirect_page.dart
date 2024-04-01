import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:sui/zklogin/zklogin.dart';
import 'package:sui/zklogin/nouch.dart';

void main() {
  runApp(MaterialApp(
    home: MyPage(),
  ));
}

class WebViewPage extends StatefulWidget {
  @override
  _WebViewPageState createState() => _WebViewPageState();
}

String CLIENT_ID =
    '1083467233418-no9crphhseet7cgn7grsn98l16odg613.apps.googleusercontent.com';
String REDIRECT_URL = 'http%3A%2F%2Flocalhost%3A3000';
String NONCE = 'Pm3hdAV5jY1cuv8';
var redierct = '';

class _WebViewPageState extends State<WebViewPage> {
  Future<WebViewController> getWebViewController(BuildContext context) async {
    var info = await getInfoRequestProof();
    print('infoRequest: $info');
    NONCE = info['nonce']!;
    String url =
        'https://accounts.google.com/o/oauth2/v2/auth/oauthchooseaccount?client_id=1083467233418-i6est2jg0mbd59ptddrf6elh2kg7uvf4.apps.googleusercontent.com&response_type=id_token&redirect_uri=$REDIRECT_URL&scope=openid&nonce=$NONCE&service=lso&o2v=2&theme=mn&ddm=0&flowName=GeneralOAuthFlow';

    print('url: $url');

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
            String temp = redierct.replaceAll('${REDIRECT_URL}#id_token=', '');
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
      ..loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Simple Example')),
      body: FutureBuilder(
        future: getWebViewController(context),
        builder:
            (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
          if (snapshot.hasData) {
            return WebViewWidget(
              controller: snapshot.data!,
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('ERROR'),
            );
          } else {
            return SizedBox(
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

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            var loginResRedirect = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WebViewPage(),
                ));

            print('loginResRedirect: $loginResRedirect');
          },
          child: Text('Login'),
        ),
      ),
    );
  }
}
