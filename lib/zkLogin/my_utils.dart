import "dart:typed_data";
import "package:sui/utils/hex.dart";
import "package:weminal_app/zkLogin/my_poseidon.dart";

const MAX_KEY_CLAIM_NAME_LENGTH = 32;
const MAX_KEY_CLAIM_VALUE_LENGTH = 115;
const MAX_AUD_VALUE_LENGTH = 145;
const PACK_WIDTH = 248;

int findFirstNonZeroIndex(Uint8List bytes) {
  for (int i = 0; i < bytes.length; i++) {
    if (bytes[i] != 0) {
      return i;
    }
  }
  return -1;
}

/// Derive bytearray from num where the bytearray is padded to the left with 0s to the specified width.
Uint8List toPaddedBigEndianBytes(BigInt num, int width) {
  String hex = num.toRadixString(16);
  String paddedHex = hex.padLeft(width * 2, '0');
  return Hex.decode(paddedHex.substring(paddedHex.length - width * 2));
}

/// Derive bytearray from num where the bytearray is not padded with 0.
Uint8List toBigEndianBytes(BigInt num, int width) {
  Uint8List bytes = toPaddedBigEndianBytes(num, width);

  int firstNonZeroIndex = findFirstNonZeroIndex(bytes);

  if (firstNonZeroIndex == -1) {
    return Uint8List.fromList([0]);
  }

  return bytes.sublist(firstNonZeroIndex);
}

/// hashes an ASCII string to a field element
BigInt hashASCIIStrToField(String str, int maxSize) {
  if (str.length > maxSize) {
    throw ArgumentError('String $str is longer than $maxSize chars');
  }

  // Padding with zeroes is safe because we are only using this function to map human-readable sequence of bytes.
  // So the ASCII values of those characters will never be zero (null character).
  //final strPadded = str.padRight(maxSize, String.fromCharCode(0));
  List<int> strPadded = str.padRight(maxSize, String.fromCharCode(0)).codeUnits;

  const chunkSize = PACK_WIDTH ~/ 8;
  final packed = chunkArray(strPadded, chunkSize)
      .map((chunk) => bytesBEToBigInt(chunk.map((e) => e as int).toList()))
      .toList();
  return poseidonHash(packed);
}

BigInt bytesBEToBigInt(List<int> bytes) {
  String hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  if (hex.isEmpty) {
    return BigInt.zero;
  }
  return BigInt.parse('0x$hex');
}

/// Splits an array into chunks of size chunk_size. If the array is not evenly
/// divisible by chunk_size, the first chunk will be smaller than chunk_size.
///
/// E.g., arrayChunk([1, 2, 3, 4, 5], 2) => [[1], [2, 3], [4, 5]]
/// Note: Can be made more efficient by avoiding the reverse() calls.
List<List<dynamic>> chunkArray<T>(List<T> array, int chunkSize) {
  final revArray = array.reversed;
  List<List<dynamic>> chunks = List.generate(
    (revArray.length / chunkSize).ceil(),
    (i) => List.from(
        revArray.skip(i * chunkSize).take(chunkSize).toList().reversed),
  ).toList();
  return chunks.reversed.toList();
}

BigInt genAddressSeed(
  BigInt salt,
  String name,
  String value,
  String aud, {
  int maxNameLength = MAX_KEY_CLAIM_NAME_LENGTH,
  int maxValueLength = MAX_KEY_CLAIM_VALUE_LENGTH,
  int maxAudLength = MAX_AUD_VALUE_LENGTH,
}) {
  return poseidonHash([
    hashASCIIStrToField(name, maxNameLength),
    hashASCIIStrToField(value, maxValueLength),
    hashASCIIStrToField(aud, maxAudLength),
    poseidonHash([salt]),
  ]);
}
