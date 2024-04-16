import 'package:flutter/cupertino.dart';
import 'package:sui/cryptography/keypair.dart';

import '../services/nft_service.dart';
import '../states/state.dart';

class DetailProvider extends ChangeNotifier {
  static EventState _state = EventState.initial;

  EventState get state => _state;

  void setState(EventState state) {
    _state = state;
    notifyListeners();
  }

  void createNft(
      {required Keypair ephemeralKeyPair,
        required String senderAddress,
        required String name,
        required String description,
        required String imageUrl}) async {

    final resp = await NftService.createNft(
      ephemeralKeyPair: ephemeralKeyPair,
      senderAddress: senderAddress,
      name: '${name} Ticket',
      description: description,
      imageUrl: imageUrl,
    );
    if (resp.isNotEmpty)
      setState(EventState.loaded);
    }

}





