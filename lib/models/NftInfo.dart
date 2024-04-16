import 'package:sui/sui.dart';
import 'package:weminal_app/models/NftInfoData.dart';

class NftInfo {
  final SuiObjectRef suiObjectRef;
  final String objectType;
  final Nftinfodata data;

  NftInfo({required this.suiObjectRef, required this.objectType, required this.data});
}
