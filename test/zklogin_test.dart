import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:sui/sui.dart';
import 'package:sui/utils/hex.dart';
import 'package:zklogin/address.dart';
import 'package:zklogin/utils.dart';

import 'package:dio/dio.dart';

void main() {
  test('dummy zkLogin transaction', () async {
    const maxEpoch = 216;

    const randomness = "57467610606496987453846336456547213816";
    const nonce = 'hX_jG9iwpufsk3AuwTwwLM4LcL8';

    const jwtStr =
        'eyJhbGciOiJSUzI1NiIsImtpZCI6IjkzNGE1ODE2NDY4Yjk1NzAzOTUzZDE0ZTlmMTVkZjVkMDlhNDAxZTQiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiIxMDgzNDY3MjMzNDE4LWk2ZXN0MmpnMG1iZDU5cHRkZHJmNmVsaDJrZzd1dmY0LmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29tIiwiYXVkIjoiMTA4MzQ2NzIzMzQxOC1pNmVzdDJqZzBtYmQ1OXB0ZGRyZjZlbGgya2c3dXZmNC5hcHBzLmdvb2dsZXVzZXJjb250ZW50LmNvbSIsInN1YiI6IjEwODAxMjYxOTMwNjMwMjU1ODk1MiIsIm5vbmNlIjoiaFhfakc5aXdwdWZzazNBdXdUd3dMTTRMY0w4IiwibmJmIjoxNzEyMDcxNzc5LCJpYXQiOjE3MTIwNzIwNzksImV4cCI6MTcxMjA3NTY3OSwianRpIjoiOTMwZGY1ZDQ5YjIyMjA5Y2NlMWYzMTVhMzljNzI0ZmM2ZGU3NDNiYiJ9.RtymGZ3ID9054OPLCMjRv6IXuvhyg-f8g4eQMa6IivP8H-Hqz6tUyKN4RZedjUW3OwwzQG_tk_D4Y-K3pPxy2BQglfmd3b3E4lSkYlBKOfLkfgzfRotPUd4AiDIUBKow5wGD9UQGxTswDcDmL-XTM6iopB2-9PgfAMqIuZuyoqpFLR-4M_kW6CZ-KydTJ0Thlq8o03V3ObWDF9NH1yiTmhnZ0FSMYyfBzO1P8AGUFYzAfKQOLYcPYYFYGxiEUd6v7oXEn_ynfFDumV41kOTftDSAmXXB0_qvZSvkJUCu2uIaeK4WNB2kJfLoXfrG4sJtOAeK6asH06GUckXWeF-7NQ';
    final userSalt = BigInt.parse('255873485666802367946136116146407409355');
    final jwt = decodeJwt(jwtStr);
    final address = jwtToAddress(jwtStr, userSalt);

    final faucet = FaucetClient(SuiUrls.faucetDev);
    var faucetResponse = await faucet.requestSuiFromFaucetV0(address);
    print('faucetResponse: $faucetResponse');
    print('address: $address');
    final client = SuiClient(SuiUrls.devnet);
    Uint8List key = Uint8List.fromList([
      164,
      156,
      32,
      214,
      200,
      237,
      239,
      29,
      13,
      9,
      146,
      44,
      26,
      67,
      60,
      20,
      237,
      80,
      193,
      54,
      97,
      96,
      227,
      31,
      98,
      123,
      225,
      228,
      135,
      196,
      68,
      59
    ]);
    final ephemeralKeypair =
        Ed25519Keypair.fromSecretKey(base64Decode(base64Encode(key)));
    print('ephemeralKeypair: $ephemeralKeypair');
    final extendedEphemeralPublicKey =
        getExtendedEphemeralPublicKey(ephemeralKeypair.getPublicKey());

    final body = {
      "jwt": jwtStr,
      "extendedEphemeralPublicKey": extendedEphemeralPublicKey,
      "maxEpoch": maxEpoch,
      "jwtRandomness": randomness,
      "salt": userSalt.toString(),
      "keyClaimName": "sub",
    };
    var proofs_string =
        '{"proofPoints": {"a": ["16461840453103398514762313742467832624467620379461083256308191034517030079026", "13503507008057329463249598011980853249866235817571947358919274920090763970141", "1"], "b": [["17906902124098895485966490498679842031431706018171564167314034750245514574261", "6405488764367045896242185689568483346067786331519913735305360372323132481597"], ["1023907046669560159112040447839984184043627236655891502812381519893876492329", "2324243979415403551905669305395064417652700592001060642963110297809904458399"], ["1", "0"]], "c": ["8851448735762343084274496591484441982593820624847458217451878608617682055059", "1018071060610917913186397015154551015942675879216445030826456878594422233526", "1"]}, "issBase64Details": {"value": "yJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLC", "indexMod4": 1}, "headerBase64": "eyJhbGciOiJSUzI1NiIsImtpZCI6IjkzNGE1ODE2NDY4Yjk1NzAzOTUzZDE0ZTlmMTVkZjVkMDlhNDAxZTQiLCJ0eXAiOiJKV1QifQ"}';
    var proof = jsonDecode(proofs_string);
    print('valuemap: ${proof['proofPoints']}');

    print("proof $proof");
    final addressSeed = genAddressSeed(
        userSalt, 'sub', jwt['sub'].toString(), jwt['aud'].toString());

    ProofPoints proofPoints = ProofPoints.fromJson(proof['proofPoints']);
    print('proofPoints $proofPoints');
    ZkLoginSignatureInputs zkLoginSignatureInputs = ZkLoginSignatureInputs(
      proofPoints: proofPoints,
      issBase64Details: Claim.fromJson(proof['issBase64Details']),
      addressSeed: addressSeed.toString(),
      headerBase64: proof['headerBase64'],
    );

    // final zkProof =
    // final zkProof = (await Dio().post('https://prover-dev.mystenlabs.com/v1', data: body)).data;

    final txb = TransactionBlock();
    txb.setSender(address);
    // final coin = txb.splitCoins(txb.gas, [txb.pureInt(22222)]);
    // txb.transferObjects([coin], txb.pureAddress(address));

    final sign =
        await txb.sign(SignOptions(signer: ephemeralKeypair, client: client));

    // zkProof["addressSeed"] = addressSeed.toString();

    final zksign = getZkLoginSignature(ZkLoginSignature(
        inputs: zkLoginSignatureInputs,
        maxEpoch: maxEpoch,
        userSignature: base64Decode(sign.signature)));

    final resp = await client.executeTransactionBlock(sign.bytes, [zksign],
        options: SuiTransactionBlockResponseOptions(showEffects: true));
    print('resp: ${resp.digest}');
    expect(resp.effects?.status.status, ExecutionStatusType.success);
  });
}
