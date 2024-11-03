import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<void> saveToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('token', token);
  print("token 값은: $token");
}

Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}
