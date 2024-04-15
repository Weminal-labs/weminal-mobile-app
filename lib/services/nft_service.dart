import 'package:sui/sui.dart';
import 'package:weminal_app/utilities/constants.dart';

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
}
