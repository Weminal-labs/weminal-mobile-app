import 'package:bcs/bcs.dart';
import 'package:bcs/hex.dart';
import 'package:ed25519_edwards/ed25519_edwards.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sui/sui.dart';
import 'package:sui/zklogin/nouch.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:sui/zklogin/salt.dart';
import 'package:buffer/buffer.dart';

var extendedEphemeralPublicKey;
// String jwtClientLogin =
//     'eyJhbGciOiJSUzI1NiIsImtpZCI6ImJhNjI1OTZmNTJmNTJlZDQ0MDQ5Mzk2YmU3ZGYzNGQyYzY0ZjQ1M2UiLCJ0eXAiOiJKV1QifQ.eyJuYW1lIjoiUGjDoXQgTMOqIEh14buzbmgiLCJwaWN0dXJlIjoiaHR0cHM6Ly9saDMuZ29vZ2xldXNlcmNvbnRlbnQuY29tL2EvQUNnOG9jTDZNWEo0Ul9OMG5KdUxpSFUxb3MwazRiVDFaVkdLMTNYVlYwc2VCZkRxPXM5Ni1jIiwiaXNzIjoiaHR0cHM6Ly9zZWN1cmV0b2tlbi5nb29nbGUuY29tL3dlbmltYWwtZDQ3NzkiLCJhdWQiOiJ3ZW5pbWFsLWQ0Nzc5IiwiYXV0aF90aW1lIjoxNzExODkxMTg2LCJ1c2VyX2lkIjoiOGNQdGVYWXYxV1djVFhtNVV6RXRaQm9zWFRrMiIsInN1YiI6IjhjUHRlWFl2MVdXY1RYbTVVekV0WkJvc1hUazIiLCJpYXQiOjE3MTE4OTExODYsImV4cCI6MTcxMTg5NDc4NiwiZW1haWwiOiJwaGF0bGVodXluaDI4QGdtYWlsLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJmaXJlYmFzZSI6eyJpZGVudGl0aWVzIjp7Imdvb2dsZS5jb20iOlsiMTA4MDEyNjE5MzA2MzAyNTU4OTUyIl0sImVtYWlsIjpbInBoYXRsZWh1eW5oMjhAZ21haWwuY29tIl19LCJzaWduX2luX3Byb3ZpZGVyIjoiZ29vZ2xlLmNvbSJ9fQ.kP07ZawiXrYsomSPoLQO3w_wY8e1SsshNpZSj92fzoGPeVgLEfqn25JHxsyFmZDFffcAb3KuZWMjD71rl9LR_FbgEBnXaQCvXAcySMxb1I-LSPMOnf9S1SP6mHXjX91sjfqfVL8ElxX960u0yb-xPBzKstdKyxmiOtUUiGcHicmBXnxYRAlWqyZOIHdjFfamRaQs';
// String jwtClientLogin =
//     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoiUGjDoXQgTMOqIEh14buzbmgiLCJwaWN0dXJlIjoiaHR0cHM6Ly9saDMuZ29vZ2xldXNlcmNvbnRlbnQuY29tL2EvQUNnOG9jTDZNWEo0Ul9OMG5KdUxpSFUxb3MwazRiVDFaVkdLMTNYVlYwc2VCZkRxPXM5Ni1jIiwiaXNzIjoiaHR0cHM6Ly9hY2NvdW50cy5nb29nbGUuY29tIiwiYXVkIjoid2VuaW1hbC1kNDc3OSIsImF1dGhfdGltZSI6MTcxMTg5MTE4NiwidXNlcl9pZCI6IjhjUHRlWFl2MVdXY1RYbTVVekV0WkJvc1hUazIiLCJzdWIiOiI4Y1B0ZVhZdjFXV2NUWG01VXpFdFpCb3NYVGsyIiwiaWF0IjoxNzExODkxNzU1LCJleHAiOjE3MTE4OTQ3ODYsImVtYWlsIjoicGhhdGxlaHV5bmgyOEBnbWFpbC5jb20iLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwiZmlyZWJhc2UiOnsiaWRlbnRpdGllcyI6eyJnb29nbGUuY29tIjpbIjEwODAxMjYxOTMwNjMwMjU1ODk1MiJdLCJlbWFpbCI6WyJwaGF0bGVodXluaDI4QGdtYWlsLmNvbSJdfSwic2lnbl9pbl9wcm92aWRlciI6Imdvb2dsZS5jb20ifX0.15MdFQpAArWcEukTH5M4lmFD89qCiIIij6U7lP6osH4';
String jwtClientLogin =
    'eyJhbGciOiJSUzI1NiIsImtpZCI6IjkzNGE1ODE2NDY4Yjk1NzAzOTUzZDE0ZTlmMTVkZjVkMDlhNDAxZTQiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiIxMDgzNDY3MjMzNDE4LWk2ZXN0MmpnMG1iZDU5cHRkZHJmNmVsaDJrZzd1dmY0LmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29tIiwiYXVkIjoiMTA4MzQ2NzIzMzQxOC1pNmVzdDJqZzBtYmQ1OXB0ZGRyZjZlbGgya2c3dXZmNC5hcHBzLmdvb2dsZXVzZXJjb250ZW50LmNvbSIsInN1YiI6IjEwODAxMjYxOTMwNjMwMjU1ODk1MiIsIm5vbmNlIjoiIFBtM2hkQVY1alkxY3V2OCIsIm5iZiI6MTcxMTk2NjgxMiwiaWF0IjoxNzExOTY3MTEyLCJleHAiOjE3MTE5NzA3MTIsImp0aSI6ImQ2ZTQxNzdjNDYyNWRmY2I3Y2E2Y2U0ZjllMjljODE3Y2Y4ZmVlMTUifQ.s4TPd79beO2bHTdW9IHmJPqGMbTAzX7-QLkiewElibysGl2XPYqgXflE-3lzwQ6xi4smpE5ZIoTTorxuuX32woNaTvT-QuCFYxdkyF9vwAAe5P6vu0rlGO1xJLr0E2lSq8SQ9mW9KEhyqIi6Wgl3ALtJUjaUxIQJLlIVT3hVJGrWCgddwNb7yeVu9_T4ddgF3h-NvSWJ5RibbDqq-GEVboIGAKehhct5C1Y1xWYEG3g89OHLjLwMHhTvmxcXxCA47yp5Tw7P3ZYaQH-ZBQuEOY3wNwGun0gIqm-oYAE-5hecfLxEfz8lZKV940UGRV5npodxi52WMAmPO6Cr2b6CCQ';
var ephemeralkey = Ed25519Keypair();
SuiClient client = SuiClient(SuiUrls.devnet);
var getEpoch;
var epoch;
var maxEpoch;
var randomness = generateRandomness();
var userSalt = BigInt.parse('255873485666802367946136116146407409355');

Future<void> getMaxEpochFunction() async {
  getEpoch = await client.getLatestSuiSystemState();
  epoch = getEpoch.epoch;
  maxEpoch = double.parse(epoch) + 10;
  print('maxEpoch: $maxEpoch');
}

void getSalt() {}

Future<String> getNonce() async {
  await getMaxEpochFunction();

  String nonce =
      generateNonce(ephemeralkey.getPublicKey(), maxEpoch, randomness);
  return nonce;
}

Future<void> getProofs() async {
  getMaxEpochFunction();
  print('GET PROOFS');
  print('token: $jwtClientLogin');
  print(
      'extendedEphemeralPublicKey: ${toBigIntBE(ephemeralkey.getPublicKey().toSuiBytes()).toString()}');
  print('maxEpoch: $maxEpoch');
  print('jwtRandomness: ${randomness.toString()}');
  print('salt: $userSalt');
  print('keyClaimName: "sub"');

  final toProof = {
    'jwt': jwtClientLogin,
    'extendedEphemeralPublicKey':
        toBigIntBE(ephemeralkey.getPublicKey().toSuiBytes()).toString(),
    'maxEpoch': maxEpoch,
    'jwtRandomness': randomness.toString(),
    'salt': userSalt,
    'keyClaimName': "sub",
  };
  // final jwtParsed = decodeJwt(jwtClientLogin);
  // dynamic proofs;
  // if (_prover is Function) {
  //   proofs = await _prover(toProof);
  // } else {
  //   // _prover is a server url
  //   final response = await http.post(
  //     Uri.parse(_prover),
  //     headers: {
  //       "Content-Type": "application/json",
  //     },
  //     body: jsonEncode(toProof),
  //   );
  //   proofs = jsonDecode(response.body);
  // }
  // final addressSeed = genAddressSeed(
  //   salt,
  //   'sub',
  //   jwtParsed['sub'],
  //   (jwtParsed['aud'] is List ? jwtParsed['aud'][0] : jwtParsed['aud']),
  // );
  // _state = {
  //   'address': toSuiAddress(),
  //   'proofs': proofs,
  //   'maxEpoch': _maxEpoch,
  //   'addressSeed': addressSeed.toString(),
  //   'ephemeralKeyPair': _ephemeralKeyPair.export(),
  // };
  // _stateIsOk = true;
  // dispatchEvent(Event('state'));
  // dispatchEvent(Event('ready'));
  // print('state', _state);
  // return {
  //   ...proofs,
  //   'addressSeed': addressSeed.toString(),
  // };
}

void main() {
  test('test getNonce', () async {
    String nonce = await getNonce();
    print('nonce: $nonce');
    // jwt decode
    Map<String, dynamic> decodedToken = JwtDecoder.decode(jwtClientLogin);
    print('decodedToken: $decodedToken');

    // Generate salt
    // var userSalt = deriveUserSalt(jwtClientLogin);
    // print('salt: $userSalt');

    // Generate user addess
    var userAddress = jwtToAddress(jwtClientLogin, userSalt);
    print('UserAddress: $userAddress');
    getProofs();
    expect(true, true);
  });
}
