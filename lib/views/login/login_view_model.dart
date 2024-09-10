import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ucd/models/login_model.dart';

class LoginViewModel extends ChangeNotifier {
  Future<void> login(LoginModel loginModel) async {
    final url = Uri.parse(
        'https://run.mocky.io/v3/4f88ac23-4cbb-4aab-a23f-f30022637454');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(loginModel.toJson()),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        // 응답 데이터 처리
        if (responseData != null) {
          if (responseData.containsKey('jwt')) {
            String token = responseData['jwt'];
            // await saveToken(token);
            print(token);
          } else {
            print('JWT token is missing in the response');
          }
        } else {
          print('Response data is null');
        }
        print('Login Success: ${responseData['message']}');
      } else {
        // 에러 처리
        print('Login Failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Login Error: $e');
    }
  }
}
