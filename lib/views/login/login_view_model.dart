import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ucd/models/login_model.dart';
import 'package:ucd/services/token_service.dart';
import 'package:ucd/views/organization/organization_view.dart';

class LoginViewModel extends ChangeNotifier {
  Future<void> login(LoginModel loginModel, BuildContext context) async {
    final url = Uri.parse('http://192.168.0.181:8080/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(loginModel.toJson()),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        // 응답 데이터 처리
        if (responseData.containsKey('data')) {
          String token = responseData['data'];
          await saveToken(token);
          print(token);
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const OrganizationScreen(),
          ),
        );
        print(response.statusCode);
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
