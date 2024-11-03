import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ucd/models/user_model.dart';

class SignUpService {
  final String baseUrl = 'http://34.64.165.164:8080';

  Future<bool> signUp(UserModel userModel) async {
    final url = Uri.parse('$baseUrl/api/users/signup');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userModel.toJson()),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData.containsKey('message')) {
          print('Sign Up Success: ${responseData['message']}');
          return true;
        }
      } else {
        print('Sign Up Failed: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Sign Up Error: $e');
    }
    return false;
  }
}
