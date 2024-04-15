import 'dart:convert';

import 'package:sui/sui.dart';
import 'package:weminal_app/utilities/constants.dart';

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

  static void createNft(
      {required Keypair ephemeralKeyPair,
      required String senderAddress,
      required String arg1,
      required String arg2,
      required String arg3,
      required String packageId,
      required String userAddress}) async {
    final txb = TransactionBlock();
    txb.setSender(userAddress);

    const packageObjectId =
        '0xbfec71e0f811e27d3393b0470941fe3da85df8c7df8497d5538cc758f90cb2ef';
    txb.moveCall('$packageObjectId::event::new_ticket', arguments: [
      txb.pureString('name ticket 1'),
      txb.pureString('name ticket 1'),
      txb.pureString('des ticket 1'),
      txb.pure(
          '0xbfec71e0f811e27d3393b0470941fe3da85df8c7df8497d5538cc758f90cb2ef'),
      txb.pure(userAddress)
    ]);

    final sign = await txb
        .sign(SignOptions(signer: ephemeralKeyPair, client: suiClient));
    final zkSign = ZkSignBuilder.getZkSign(signSignature: sign.signature);

    print('sign.signature: ${sign.signature}');

    final resp = await suiClient.executeTransactionBlock(sign.bytes, [zkSign],
        options: SuiTransactionBlockResponseOptions(showEffects: true));
    String zkSignature = resp.digest;

    var bytes = sign.bytes;
    print('zkSignature: $zkSignature');
    var serializedSignature = parseSerializedSignature(zkSign);
    print('serializedSignature: ${serializedSignature}');

    base64Decode(zkSign).toList();
    List<String> tepm =
        base64Decode(zkSign).toList().map((e) => e.toString()).toList();
    print('base64Decode(zkSign): ${base64Decode(zkSign)}');
    var txbres = await suiClient.executeTransactionBlock(
      sign.bytes,
      [zkSign],
    );
    print('createNft: ${txbres.digest}');
  }
}
