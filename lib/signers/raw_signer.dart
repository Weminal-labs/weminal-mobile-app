
import 'package:sui/cryptography/keypair.dart';
import 'package:sui/cryptography/secp256k1_keypair.dart';
import 'package:sui/serialization/base64_buffer.dart';
import 'package:sui/signers/signer_with_provider.dart';
import 'package:sui/signers/txn_data_serializers/txn_data_serializer.dart';
import 'package:sui/types/common.dart';

class RawSigner extends SignerWithProvider {
  late final Keypair _keypair;

  RawSigner(
    Keypair keypair,
    {String? endpoint,
    TxnDataSerializer? serializer}
  ): super(endpoint ?? "", serializer) {
    _keypair = keypair;
  }

  @override
  SuiAddress getAddress() {
    return _keypair.getPublicKey().toSuiAddress();
  }

  @override
  SignaturePubkeyPair signData(Base64DataBuffer data) {
    return SignaturePubkeyPair(
      _keypair.getKeyScheme(),
      _keypair.signData(data),
      _keypair.getPublicKey()
    );
  }

  bool verify(Base64DataBuffer data, SignaturePubkeyPair signature) {
    var pubKeyBytes = signature.pubKey.toBytes();
    if (_keypair is Secp256k1Keypair) {
      pubKeyBytes = (_keypair as Secp256k1Keypair).publicKeyBytes(false);
    }
    bool success = _keypair.verify(data, signature.signature, pubKeyBytes);
    return success;
  }
}
