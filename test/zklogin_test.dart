
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:sui/sui.dart';
import 'package:sui/utils/hex.dart';
import 'package:zklogin/address.dart';
import 'package:zklogin/utils.dart';

import 'package:dio/dio.dart';


void main() {
  
  test('dummy zkLogin transaction', () async {

    const maxEpoch = 189;

    //const randomness = '229768962062079207372752627732214193858';
    const randomness = "235308021608294320893368612548894185348";
    const nonce = 'kcTLcCB0Ue9PkRSOTyAYvLjLc2w';
    //const nonce = 'EJf_HVNM2Fj4PDaTkqOAqVBN7Kg';

    // token id  
    //const jwtStr = "eyJhbGciOiJSUzI1NiIsImtpZCI6IjkzNGE1ODE2NDY4Yjk1NzAzOTUzZDE0ZTlmMTVkZjVkMDlhNDAxZTQiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiI1NzMxMjAwNzA4NzEtMGs3Z2E2bnM3OWllMGpwZzFlaTZpcDV2amUyb3N0dDYuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiI1NzMxMjAwNzA4NzEtMGs3Z2E2bnM3OWllMGpwZzFlaTZpcDV2amUyb3N0dDYuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMDYxMzE5NzE3MTQ2MjA3MDU5MjkiLCJub25jZSI6IkVKZl9IVk5NMkZqNFBEYVRrcU9BcVZCTjdLZyIsIm5iZiI6MTcxMjA2MDkwOCwiaWF0IjoxNzEyMDYxMjA4LCJleHAiOjE3MTIwNjQ4MDgsImp0aSI6ImIyZmVkOTBjMzllMDIyNWI3NzdmZWJiZWVlYTc4ZjlmYmZiODY0NTUifQ.Nb5ZKRY2TD8HNvpi3ldYSOfAL5oc8wwMNLBRVfaj1QOEsmmeJhRqcDM2njf8yLsblIgI7keVFfILsonYA_ytosT5q6WI43DnrBqLsTH1NCIMh3CL3vs1bxw-vCnDpOAXqhBkQQBPhB_JpIllwXicKDmKXG8tmBFZWN0Hq6QIwCJYePYLkaeTjlvQx_UBn5VZc6BSAQmVH0nF7eATjGvlbbX8EURd5lWean2ZgxndobEm7z5N5kCMnzlcPAvoM5tiO9YpzNup53p5SdCOewHs0otbKemZjL5o3Kd32Iiitt8jR9GdYmx-wws9JZcAOZsy6BVxpgog51OjjuOyepJl1w";
    const jwtStr = "eyJhbGciOiJSUzI1NiIsImtpZCI6IjkzNGE1ODE2NDY4Yjk1NzAzOTUzZDE0ZTlmMTVkZjVkMDlhNDAxZTQiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiIxMDgzNDY3MjMzNDE4LWk2ZXN0MmpnMG1iZDU5cHRkZHJmNmVsaDJrZzd1dmY0LmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29tIiwiYXVkIjoiMTA4MzQ2NzIzMzQxOC1pNmVzdDJqZzBtYmQ1OXB0ZGRyZjZlbGgya2c3dXZmNC5hcHBzLmdvb2dsZXVzZXJjb250ZW50LmNvbSIsInN1YiI6IjEwODAxMjYxOTMwNjMwMjU1ODk1MiIsIm5vbmNlIjoia2NUTGNDQjBVZTlQa1JTT1R5QVl2TGpMYzJ3IiwibmJmIjoxNzEyMDYxNzk0LCJpYXQiOjE3MTIwNjIwOTQsImV4cCI6MTcxMjA2NTY5NCwianRpIjoiYmY2ZDJmNDA5NWU3ZWVkNzg1OWRlZThiN2RlYjQyNGEyZWRhZDJiMyJ9.pgS-eT_TJvvd38Am0P7NGuuApqCQszHn_xDlb--4JOqEAvC4ewVfU62Phxg5ENHiLnKLNwQAV4NmOgQ-1fjwZxhAmZ8F3dr7Nwy8jc1J7AIFAoiSUWx1_Yjm8ZvY0z2l1bAS9PHfQLM7KrHNugYuwhKnbT-eB9nfGzLWrWkE0PC896mmpIpkBLJOJ6wnbsEblmfqgOQHL9mXyZY2Qys-TFiTNqCVRmDZ8ZebJmW0gtN4Y-0iG4SoWuc3sqN-s510c8nsSdNuqU5XMNDzEMW_TfjWgLTblNkfbsRGdYLYiVI8YatGWwdfyJU9X-TH9VcpuVjgCsy7AvCo-cRlu3ojKw";
    final userSalt = BigInt.parse('255873485666802367946136116146407409355');
    final jwt = decodeJwt(jwtStr);
    final address = jwtToAddress(jwtStr, userSalt);

    final faucet = FaucetClient(SuiUrls.faucetDev);
    var faucetResponse = await faucet.requestSuiFromFaucetV0(address);
    print('address: $address');
    final client = SuiClient(SuiUrls.devnet);
    final coins = await client.getCoins(
    address,
    coinType: '0x2::sui::SUI');
    final ephemeralKeypair = Ed25519Keypair.fromSecretKey(base64Decode('mv5/Qz3wa39DX/xwOuEwd7V46IofykuEvkOT+Sj3YB8='));
    print(base64Decode('mv5/Qz3wa39DX/xwOuEwd7V46IofykuEvkOT+Sj3YB8='));
    final extendedEphemeralPublicKey = getExtendedEphemeralPublicKey(ephemeralKeypair.getPublicKey());

    final body = {
      "jwt": jwtStr,
      "extendedEphemeralPublicKey": extendedEphemeralPublicKey,
      "maxEpoch": maxEpoch,
      "jwtRandomness": randomness,
      "salt": userSalt.toString(),
      "keyClaimName": "sub",
    };


    var proofs_string = "{proofPoints: {a: [17577226138867111966795313323161951396915922621237744217473645725079920387456, 15418131813873830254274901669818026207443697635823425077834652535175590470142, 1], b: [[4802721390573397561582992485931103678032488746400873009985094324277222656773, 9241748858067659104262656865555558434106685866044338237359719121692866222199], [20362470581825862944384366948877512739461469039232999981877503182466077220628, 15939707428527817889005484385119275121077906243266454016792133026333208792204], [1, 0]], c: [11428170472929519281245154579034162467693082783456718884876148750513617259802, 5607807711926147557196663334922229096695187263530792733402953588413353184826, 1]}, issBase64Details: {value: yJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLC, indexMod4: 1}, headerBase64: eyJhbGciOiJSUzI1NiIsImtpZCI6IjkzNGE1ODE2NDY4Yjk1NzAzOTUzZDE0ZTlmMTVkZjVkMDlhNDAxZTQiLCJ0eXAiOiJKV1QifQ}";
    var valuemap = jsonEncode(proofs_string);
    Map<String, dynamic>  proof = jsonDecode(valuemap);
    
    // print("proof $proof");
    final addressSeed = genAddressSeed(userSalt, 'sub', jwt['sub'].toString(), jwt['aud'].toString());

    ProofPoints proofPoints = ProofPoints.fromJson(proof['proofPoints']);
    print('proofPoints $proofPoints');
    ZkLoginSignatureInputs zkLoginSignatureInputs =
        ZkLoginSignatureInputs(
      proofPoints: proofPoints,
      issBase64Details: Claim.fromJson(proof['issBase64Details']),
      addressSeed: addressSeed.toString(),
      headerBase64: proof['headerBase64'],
    );
    
    //final zkProof = 
    // final zkProof = (await Dio().post('https://prover-dev.mystenlabs.com/v1', data: body)).data;



    // final txb = TransactionBlock();
    // txb.setSender(address);
    // // final coin = txb.splitCoins(txb.gas, [txb.pureInt(22222)]);
    // // txb.transferObjects([coin], txb.pureAddress(address));
  
    // final sign = await txb.sign(SignOptions(signer: ephemeralKeypair, client: client));

    // // zkProof["addressSeed"] = addressSeed.toString();

    // final zksign = getZkLoginSignature(ZkLoginSignature(
    //     inputs: zkLoginSignatureInputs, 
    //     maxEpoch: maxEpoch, 
    //     userSignature: base64Decode(sign.signature)
    //   )
    // );

    // final resp = await client.executeTransactionBlock(sign.bytes, [zksign], options: SuiTransactionBlockResponseOptions(showEffects: true));
    // expect(resp.effects?.status.status, ExecutionStatusType.success);

  });


}