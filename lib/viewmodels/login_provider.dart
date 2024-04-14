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

import '../models/request_proof_model.dart';
import '../states/login_state.dart';
import 'package:http/http.dart' as http;

import '../zkLogin/ZkSignBuilder.dart';
import '../zkLogin/my_address.dart';
import '../zkLogin/my_utils.dart';
import '../zkSend/builder.dart';
import '../zkSend/zk_bag.dart';

class LoginProvider extends ChangeNotifier {
  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };
  LoginState _state = LoginState.initial;

  LoginState get state => _state;

  String zkSignature = '';
  String userAddress = '';
  var suiClient = SuiClient(SuiUrls.mainnet);

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
    Ed25519Keypair ephemeralKeyPair = res['ephemeralKeyPair'];
    print('myProof: $proof');
    print('ephemeralKeyPair: $ephemeralKeyPair');

    // var txb = TransactionBlock();
    // txb.setSender(userAddress);
    // const packageObjectId =
    //     '0x51f4a1e3bda48c305656d3bfb46db227a2029fdf5e738af341e3a29118d089ca';
    // txb.moveCall('$packageObjectId::event::new_ticket', arguments: [
    //   txb.pureString('name ticket 1'),
    //   txb.pureString('des ticket 1'),
    //   txb.pureString(
    //       'https://coinz.com.vn/wp-content/uploads/2022/10/sui-blockchain-thumbnail.webp'),
    //   txb.pure(
    //       '0x51f4a1e3bda48c305656d3bfb46db227a2029fdf5e738af341e3a29118d089ca')
    // ]);

    // final faucet = FaucetClient(SuiUrls.faucetTest);
    // var faucetResponse = await faucet.requestSuiFromFaucetV0(userAddress);
    // // Test ZkSend //////////////////////////////////
    // const TESTNET_IDS = ZkBagContractOptions(
    //   packageId:
    //       '0x036fee67274d0d85c3532f58296abe0dee86b93864f1b2b9074be6adb388f138',
    //   bagStoreId:
    //       '0x5c63e71734c82c48a3cb9124c54001d1a09736cfb1668b3b30cd92a96dd4d0ce',
    //   bagStoreTableId:
    //       '0x4e1bc4085d64005e03eb4eab2510d52 7aeba9548cda431cb8f149ff37451f870',
    // );
    // const MAINNET_IDS = ZkBagContractOptions(
    //   packageId:
    //       '0x5bb7d0bb3240011336ca9015f553b2646302a4f05f821160344e9ec5a988f740',
    //   bagStoreId:
    //       '0x65b215a3f2a951c94313a89c43f0adbd2fd9ea78a0badf81e27d1c9868a8b6fe',
    //   bagStoreTableId:
    //       '0x616db54ca564660cd58e36a4548be68b289371ef2611485c62c374a60960084e',
    // );
    //
    // ZkBag contract = ZkBag(package: TESTNET_IDS.packageId);
    // txb = TransactionBlock();
    // ZkBag contract = ZkBag(package: MAINNET_IDS.packageId);
    // txb.setSender(userAddress);
    // var receive = SuiAccount.ed25519Account();
    // print('recive address: ${receive.getAddress()}');
    // //new
    // contract.newTransaction(txb,
    //     arguments: [MAINNET_IDS.bagStoreId, receive.getAddress()]);
    //
    // final splits = txb.splitCoins(txb.gas, [txb.pureInt(300000000)]);
    // contract.add(txb,
    //     arguments: [MAINNET_IDS.bagStoreId, receive.getAddress(), splits[0]],
    //     typeArguments: ['0x2::coin::Coin<0x2::sui::SUI>']);
    // var suiObjectRef = SuiObjectRef(
    //     "CtMynByksfRDEmDGQ77WRfKSQbe9qEANTJaQetHGB8dV",
    //     "0xd8c1f5b9530abb3a454ed145740616fcfec0bca6ef735342560e254198f1e1a8",
    //     29091180);
    // final objectRef = Inputs.objectRef(suiObjectRef);
    // final String objectType =
    //     '0xfdba6d8e99368a97d27d4e797da45ef43fe47e90aa70f80d5eeaa2e5689bda64::event::Ticket';
    //
    // contract.add(txb,
    //     arguments: [TESTNET_IDS.bagStoreId, receive.getAddress(), objectRef],
    //     typeArguments: [objectType]);

    // final sign = await txb
    //     .sign(SignOptions(signer: ephemeralKeyPair, client: suiClient));
    //
    // print('sign.signature: ${sign.signature}');
    // final zkSign = getZkLoginSignature(ZkLoginSignature(
    //     inputs: zkLoginSignatureInputs,
    //     maxEpoch: int.parse((res['maxEpoch']!).toString().replaceAll('.0', '')),
    //     userSignature: base64Decode(sign.signature)));
    ZkSignBuilder.setInfo(
        inputZkLoginSignatureInputs: zkLoginSignatureInputs,
        inputMaxEpoch:
            int.parse((res['maxEpoch']!).toString().replaceAll('.0', '')));

    String myUrl = await ZkSendLinkBuilder.createLink(
        ephemeralKeyPair: ephemeralKeyPair,
        senderAddress: userAddress,
        balances: 300000000);
    // final resp = await suiClient.executeTransactionBlock(sign.bytes, [zkSign],
    //     options: SuiTransactionBlockResponseOptions(showEffects: true));
    // String zkSignature = resp.digest;
    // print('userAdrress: $userAddress');
    // // Change to zkSign
    // final respZkSend = await suiClient.executeTransactionBlock(
    //   sign.bytes,
    //   [zkSign],
    //   options: SuiTransactionBlockResponseOptions(showEffects: true),
    // );
    // print('respZkSend: ${respZkSend.digest}');
    //
    // //
    // var url = ZkSendLinkBuilder.getLink(receive.getSecretKey());
    print('myUrl: $myUrl');
    //
    print('userAdrress: $userAddress');
    print('getObjectFields');
    getObjects(userAddress);
    return {
      'userAddress': userAddress,
      'zkSign': 'zkSign',
      'zkSignature': zkSignature,
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

    var res = await http.post(
        Uri.parse('http://192.168.1.15:3000/api/v1/contract/getZkProof'),
        headers: headers,
        body: jsonEncode(requestProofModel.toJson()));
    if (res.statusCode == 200) {
      Map<String, dynamic> response = jsonDecode(res.body);
      return response;
    } else {
      throw Exception("Load page fail ${res.statusCode}");
    }
  }

  Future<void> getObjects(String userAddress) async {
    final objects = await suiClient.getOwnedObjects(userAddress);
    objects.data.forEach((element) {
      print('objectID ${element.data?.objectId}');
      print('type ${element.data?.type}');
      print('version ${element.data?.version}');
      print('digest ${element.data?.digest}');
    });
  }

  Future<void> getEvents() async {
    final obj = await suiClient.getObject(userAddress,
        options: SuiObjectDataOptions(showContent: true));
  }
}
