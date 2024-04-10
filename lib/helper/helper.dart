import 'package:shared_preferences/shared_preferences.dart';

Future<String?> getUserAddress() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userAddress = prefs.getString('userAddress');
  return userAddress;
}

Future<String?> getUserZkSignature() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? zkSignature = prefs.getString('zkSignature');
  return zkSignature;
}

Future<String?> getUserJwt() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userJwt = prefs.getString('userJwt');
  return userJwt;
}
