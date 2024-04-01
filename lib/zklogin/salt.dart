import 'dart:convert';
import 'dart:typed_data';
import 'package:bcs/hex.dart';
import 'package:crypto/crypto.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:convert/convert.dart';

// Static master seed value - store this securely and do not expose or change it!
final String MASTER_SEED = String.fromEnvironment('MASTER_SEED');
Map<String, dynamic> decodeJwt(String token) {
  try {
    return JwtDecoder.decode(token);
  } catch (e) {
    throw Exception("Invalid JWT token");
  }
}

BigInt deriveUserSalt(String token) {
  final decoded = decodeJwt(token);
  if (decoded.isEmpty) {
    throw Exception("Invalid JWT token");
  }
  final String iss = decoded['iss'];
  final String aud = decoded['aud'];
  final String sub = decoded['sub'];
  print('iss: $iss');
  return BigInt.parse('0x${hkdf(MASTER_SEED, "${iss}${aud}", sub)}');
}

String hkdf(String ikm, String salt, String info) {
  print('hkdf salt: $salt');
  final List<int> key =
      Hmac(sha256, utf8.encode(salt)).convert(utf8.encode(ikm)).bytes;
  final List<int> derived =
      Hmac(sha256, Uint8List.fromList(key)).convert(utf8.encode(info)).bytes;
  var x = Hex.encode(derived);
  print(Hex.decode(x));
  return x;
}
