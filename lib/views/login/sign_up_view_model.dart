import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ucd/models/sign_up_model.dart';

class SignUpViewModel extends ChangeNotifier {
  Future<void> signUp(SignUpModel signUpModel) async {
    final url = Uri.parse('http://192.168.0.181:8080/api/users/signup');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(signUpModel.toJson()), // toJson 메서드를 사용하여 JSON으로 변환
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // 실제 응답을 확인해보기 위해 추가한 코드
        print('Response Body: ${response.body}');
        print('User Name: ${signUpModel.userName}');
        print('Email: ${signUpModel.email}');
        print('Password: ${signUpModel.password}');

        // 서버 응답 처리
        if (responseData.containsKey('message')) {
          print('Sign Up Success: ${responseData['message']}');
        } else {
          print('Sign Up Success, but no message in response.');
        }
      } else {
        // 에러 처리
        print('Error: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Sign Up Error: $e');
    }
  }
}

class ObscureTextViewModel extends ChangeNotifier {
  bool _obscureText = true;

  bool get obscureText => _obscureText;

  void toggleObscureText() {
    _obscureText = !_obscureText;
    notifyListeners();
  }
}
