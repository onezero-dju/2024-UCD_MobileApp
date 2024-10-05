import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ucd/models/user_model.dart';
import 'package:ucd/services/token_service.dart';

class LoginService {
  final String baseUrl = 'http://34.64.165.164:8080';

  Future<String?> login(UserModel userModel) async {
    final url = Uri.parse('$baseUrl/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': userModel.email,
          'password': userModel.password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData.containsKey('token')) {
          String token = responseData['token'];
          await saveToken(token);
          return token;
        }
      } else {
        print('Login Failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Login Error: $e');
    }
    return null;
  }
}
