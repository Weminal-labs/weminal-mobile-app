import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sui/builder/inputs.dart';
import 'package:sui/builder/transaction_block.dart';
import 'package:sui/cryptography/ed25519_keypair.dart';
import 'package:sui/rpc/faucet_client.dart';
import 'package:sui/sui.dart';
import 'package:sui/sui_client.dart';
import 'package:sui/sui_urls.dart';
import 'package:sui/types/transactions.dart';
import 'package:sui/zklogin/signature.dart';
import 'package:sui/zklogin/types.dart';
import 'package:weminal_app/utilities/constants.dart';

import '../models/event_model.dart';
import '../models/request_proof_model.dart';
import '../states/login_state.dart';
import 'package:http/http.dart' as http;

import '../utilities/fake_data.dart';
import '../zkLogin/ZkSignBuilder.dart';
import '../zkLogin/my_address.dart';
import '../zkLogin/my_utils.dart';
import '../zkSend/builder.dart';
import '../zkSend/zk_bag.dart';

class LoginProvider extends ChangeNotifier {
  static late Ed25519Keypair ephemeralKeyPair;
  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };
  LoginState _state = LoginState.initial;

  LoginState get state => _state;
  final String urlGetProof =
      'http://192.168.1.15:3000/api/v1/contract/getZkProof';

  // final String urlGetProof = 'https://prover-dev.mystenlabs.com/v1';

  String zkSignature = '';
  String userAddress = '';
  static String userAddressStatic = '';

  static final List<Event> eventList =
  FakeData.json.map((e) => Event.fromJson(e)).toList();
  var bytes;
  var zkSign;
  var suiClient = SuiClient(Constants.baseNet);

  List<Event> get events => eventList;

  void addEvent(Event event) {
    eventList.add(event);
    notifyListeners();
  }


  void loadAddressAndSignature(String userJwt,
      Map<String, dynamic> resProofRequestInfo) async {
    _state = LoginState.loading;
    notifyListeners();
    Map<String, String> addressAndSignature =
    await _handleLogin(userJwt, resProofRequestInfo);
    userAddress = addressAndSignature['userAddress']!;
    userAddressStatic = userAddress;
    _state = LoginState.loaded;
    notifyListeners();
  }

  Future<Map<String, String>> _handleLogin(String userJwt, dynamic res) async {
    RequestProofModel requestProofModel = RequestProofModel(
      extendedEphemeralPublicKey: res['extendedEphemeralPublicKey']!,
      maxEpoch: res['maxEpoch']!.toString().replaceAll('.0', ''),
      jwtRandomness: res['jwtRandomness']!,
      salt: res['salt']!,
    );
    requestProofModel.jwt = userJwt;

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
    print('userAddress: $userAddress');
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
    ephemeralKeyPair = res['ephemeralKeyPair'];
    print('myProof: $proof');
    print('ephemeralKeyPair: $ephemeralKeyPair');
    ZkSignBuilder.setInfo(
        inputZkLoginSignatureInputs: zkLoginSignatureInputs,
        inputMaxEpoch:
        int.parse((res['maxEpoch']!).toString().replaceAll('.0', '')));

    print('userAdrress: $userAddress');
    return {
      'userAddress': userAddress,
    };
  }

  Future<Map<String, dynamic>> getProof(
      RequestProofModel requestProofModel) async {
    print('requestProofModel.maxEpoch: ${requestProofModel.maxEpoch}');
    print(
        'requestProofModel.jwtRandomness: ${requestProofModel.jwtRandomness}');
    print('requestProofModel.salt: ${requestProofModel.salt}');
    print('requestProofModel.keyClaimName: ${requestProofModel.keyClaimName}');
    print('requestProofModel.toJson(): ${requestProofModel.toJson()}');

    var res = await http.post(Uri.parse(urlGetProof),
        headers: headers, body: jsonEncode(requestProofModel.toJson()));
    if (res.statusCode == 200) {
      Map<String, dynamic> response = jsonDecode(res.body);
      return response;
    } else {
      throw Exception("Load page fail ${res.statusCode}");
    }
  }

}
