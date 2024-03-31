import 'package:flutter_test/flutter_test.dart';
import 'package:sui/sui.dart';
import 'package:sui/zklogin/nouch.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

void getSalt() {}

Future<String> getNonce() async {
  SuiClient client = SuiClient(SuiUrls.devnet);
  var getEpoch = await client.getLatestSuiSystemState();
  var epoch = getEpoch.epoch;
  var maxEpoch = double.parse(epoch) + 2;

  var randomness = generateRandomness();
  var ephemeralkey = Ed25519Keypair();

  String nonce =
      generateNonce(ephemeralkey.getPublicKey(), maxEpoch, randomness);
  return nonce;
}

void getproof() {}

void main() {
  test('test getNonce', () async {
    String nonce = await getNonce();
    print(nonce);
    // jwt decode
    String jwtClientLogin =
        "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6Ijc0X1k0ZVdBMHNQMWVZS2F3OEVLZyJ9.eyJnaXZlbl9uYW1lIjoiUGjDoXQiLCJmYW1pbHlfbmFtZSI6IkzDqiBIdeG7s25oIiwibmlja25hbWUiOiJwaGF0bGVodXluaDI4IiwibmFtZSI6IlBow6F0IEzDqiBIdeG7s25oIiwicGljdHVyZSI6Imh0dHBzOi8vbGgzLmdvb2dsZXVzZXJjb250ZW50LmNvbS9hL0FDZzhvY0w2TVhKNFJfTjBuSnVMaUhVMW9zMGs0YlQxWlZHSzEzWFZWMHNlQmZEcT1zOTYtYyIsImxvY2FsZSI6InZpIiwidXBkYXRlZF9hdCI6IjIwMjQtMDMtMzBUMTg6MTE6MDEuMDYzWiIsImVtYWlsIjoicGhhdGxlaHV5bmgyOEBnbWFpbC5jb20iLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwiaXNzIjoiaHR0cHM6Ly9xdWl6bGV0ZnJvbnRlbmQuanAuYXV0aDAuY29tLyIsImF1ZCI6IkFYdnlSUWdCRlNZWnZSZjZUZm4xd0lzcEg2N0tTOEFtIiwiaWF0IjoxNzExODIyMjYxLCJleHAiOjE3MTE4NTgyNjEsInN1YiI6Imdvb2dsZS1vYXV0aDJ8MTA4MDEyNjE5MzA2MzAyNTU4OTUyIiwic2lkIjoicTdueDN0OUlzM2hXWUpXSTVlSEIySGdzX2NOTVZvQ0UiLCJub25jZSI6IkNyMGRkMm5ub21SYVdOVlM2NnJmQ1lhU3pkVjl3bzkxeWEwbXZyVUZoQ0UifQ.13DDnWb4HqemWsx-vxpY7C3rY4cKxQOpiehc0wpNdIAUheG4zT63dO3pyAiZ5lezkjFFVmQHfnAKabI3DXydR3VLJt-ujJFeofsoxvldxuz68Ew22kHzIHsPZRRxgy9Zv3Y0Pm9svvI6FIufj8DIqXLmlzRlm1GcptzmWbDsnyojSnl";
    Map<String, dynamic> decodedToken = JwtDecoder.decode(jwtClientLogin);
    print(decodedToken);

    final jwt = JWT(
      // Payload
      {
        "iss": "https://accounts.google.com",
        "azp": "AXvyRQgBFSYZvRf6Tfn1wIspH67KS8Am",
        "aud": "AXvyRQgBFSYZvRf6Tfn1wIspH67KS8Am",
        "sub": "google-oauth2|108012619306302558952",
        "nonce": nonce,
        "exp": 1711858261,
        "jti": "41b4c1240159f801cd85032d9c35f901a64bd7ce"
      },
    );

// Sign it (default with HS256 algorithm)
    final token = jwt.sign(SecretKey('secret passphrase'));

    print('Signed token: $token\n');

    // Generate salt

    expect(true, true);
  });
}
