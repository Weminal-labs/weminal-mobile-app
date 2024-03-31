import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:pointycastle/pointycastle.dart' as pointycastle;
import 'package:convert/convert.dart';
import 'package:sui/sui.dart';
import 'package:sui/utils/poseidon.dart';
import '../cryptography/keypair.dart';
import 'package:poseidon/poseidon.dart';

const int NONCE_LENGTH = 27;

Uint8List randomBytes([int bytesLength = 32]) {
  final Random random = Random.secure();
  return Uint8List.fromList(
      List<int>.generate(bytesLength, (_) => random.nextInt(256)));
}

BigInt toBigIntBE(Uint8List bytes) {
  String hex =
      bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join('');
  if (hex.isEmpty) {
    return BigInt.zero;
  }
  return BigInt.parse(hex, radix: 16);
}

String generateRandomness() {
  Uint8List bytes = randomBytes(16);
  BigInt bigInt = toBigIntBE(bytes);
  return bigInt.toString();
}

String generateNonce(PublicKey publicKey, num maxEpoch, randomness) {
  if (!(randomness is String || randomness is BigInt)) {
    throw ArgumentError('Invalid randomness type: $randomness');
  } else {
    if (randomness is String) {
      randomness = BigInt.parse(randomness);
    }
    print('randomness: $randomness');
    var publicKeyBytes = toBigIntBE(publicKey.toSuiBytes());
    final eph_public_key_0 = publicKeyBytes ~/ BigInt.from(2).pow(128);
    final eph_public_key_1 = publicKeyBytes % BigInt.from(2).pow(128);
    var bigNum = poseidonHash([
      eph_public_key_0,
      eph_public_key_1,
      BigInt.from(maxEpoch),
      randomness
    ]); // poseidonHash không được dart hỗ trợ nên có thể sai cho quá trình chuyển đổi ts sang dart
    var Z = toBigEndianBytes(bigNum, 20);
    var nonce = base64Url.encode(Z);
    nonce = nonce.replaceAll('=', '');
    print(nonce);
    if (nonce.length != NONCE_LENGTH) {
      throw new Exception(
          'Length of nonce $nonce (${nonce.length}) is not equal to $NONCE_LENGTH');
    }
    return nonce;
  }
}
