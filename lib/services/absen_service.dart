import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';



Future<String> getToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('token') ?? '';
}

Future<int> getUserId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getInt('id') ?? 0;
}

String? getStringImage(File? file) {
  if(file == null) return null;
  return base64Encode(file.readAsBytesSync());
}

// logout
Future<bool> logout() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return await pref.remove('token');
}