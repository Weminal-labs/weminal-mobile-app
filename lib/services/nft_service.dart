import 'dart:convert';

import 'package:sui/sui.dart';
import 'package:weminal_app/utilities/constants.dart';
import 'package:weminal_app/viewmodels/login_provider.dart';

import '../zkLogin/ZkSignBuilder.dart';

import '../zkLogin/ZkSignBuilder.dart';

class NftService {
  static final SuiClient suiClient = SuiClient(Constants.baseNet);
  static Future<List<SuiObjectResponse>> getNfts(String userAddress) async {
    final objects = await suiClient.getOwnedObjects(userAddress,
        options: SuiObjectDataOptions(showType: true, showContent: true));

    List<SuiObjectResponse> nfts = objects.data
        .where((e) => !isCoinType(e.data?.content?.fields.toString()))
        .toList();
    return nfts;
  }

  static bool isCoinType(String? type) {
    return type == '0x2::coin::Coin<0x2::sui::SUI>';
  }

  static Future<String> createNft(
      {required Keypair ephemeralKeyPair,
      required String senderAddress,
      required String name,
      required String description,
      required String imageUrl}) async {
    final txb = TransactionBlock();
    txb.setSender(senderAddress);

    const packageObjectId =
        '0xbfec71e0f811e27d3393b0470941fe3da85df8c7df8497d5538cc758f90cb2ef';
    txb.moveCall('$packageObjectId::event::new_ticket', arguments: [
      txb.pureString(name),
      txb.pureString(description),
      txb.pureString(
            imageUrl),
      txb.pure(
          packageObjectId),
      txb.pure(senderAddress)
    ]);

    final sign = await txb
        .sign(SignOptions(signer: ephemeralKeyPair, client: suiClient));
    final zkSign = ZkSignBuilder.getZkSign(signSignature: sign.signature);

    print('sign.signature: ${sign.signature}');

    final resp = await suiClient.executeTransactionBlock(sign.bytes, [zkSign],
        options: SuiTransactionBlockResponseOptions(showEffects: true));

    var txbres = await suiClient.executeTransactionBlock(
      sign.bytes,
      [zkSign],
    );

    return txbres.digest;
  }
}
