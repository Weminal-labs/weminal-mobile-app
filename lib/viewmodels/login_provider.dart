import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sui/builder/transaction_block.dart';
import 'package:sui/cryptography/ed25519_keypair.dart';
import 'package:sui/rpc/faucet_client.dart';
import 'package:sui/sui_client.dart';
import 'package:sui/sui_urls.dart';
import 'package:sui/types/transactions.dart';
import 'package:sui/zklogin/signature.dart';
import 'package:sui/zklogin/types.dart';

import '../models/request_proof_model.dart';
import '../states/login_state.dart';
import 'package:http/http.dart' as http;

import '../zkLogin/my_address.dart';
import '../zkLogin/my_utils.dart';

class LoginProvider extends ChangeNotifier {
  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };
  LoginState _state = LoginState.initial;

  LoginState get state => _state;

  String zkSignature = '';
  String userAddress = '';

  void loadAddressAndSignature(
      String userJwt, Map<String, dynamic> resProofRequestInfo) async {
    _state = LoginState.loading;
    notifyListeners();
    Map<String, String> addressAndSignature =
        await _handleLogin(userJwt, resProofRequestInfo);
    zkSignature = addressAndSignature['zkSignature']!;
    userAddress = addressAndSignature['userAddress']!;

    _state = LoginState.loaded;
    notifyListeners();
  }

  Future<Map<String, String>> _handleLogin(String userJwt, dynamic res) async {
    RequestProofModel requestProofModel = RequestProofModel(
      extendedEphemeralPublicKey: res['extendedEphemeralPublicKey']!,
      maxEpoch: res['maxEpoch']!,
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
    return {'userAddress': userAddress, 'zkSignature': zkSignature};
  }

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
}
