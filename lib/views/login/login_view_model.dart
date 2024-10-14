import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ucd/models/user_model.dart';
import 'package:ucd/services/auth_service.dart/login_service.dart';
import 'package:ucd/services/token_service.dart';

class LoginViewModel extends ChangeNotifier {
  final LoginService _loginService = LoginService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  UserModel? loggedInUser;

  int? a;
  Future<void> login(UserModel userModel, BuildContext context) async {
    _isLoading = true;
    _errorMessage = null; // Reset error message
    try {
      final token = await _loginService.login(userModel);
      if (token != null) {
        // 로그인 성공 시 사용자 정보 가져오기
        final userInfo = await fetchUserInfo();
        if (userInfo != null) {
          print("userinfo: $userInfo");
          loggedInUser = userInfo;
          print("로그인 할 때 loggedInUser: $loggedInUser");
          a = 4;
          notifyListeners();
          GoRouter.of(context).goNamed('organization');
        } else {
          _errorMessage = "사용자 정보를 가져오지 못했습니다.";
        }
      } else {
        _errorMessage = "로그인 실패: 잘못된 이메일 또는 비밀번호입니다.";
      }
    } catch (e) {
      _errorMessage = "로그인 에러: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }




  // 사용자 정보 조회
  Future<UserModel?> fetchUserInfo() async {
    final String baseUrl = 'http://34.64.165.164:8080';
    final url = Uri.parse('$baseUrl/api/users/me');
    final token = await getToken();

    if (token == null) {
      print("Token is not available.");
      return null;
    }

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print("usermodel.fromjson: ${UserModel.fromJson(responseData['data'])}");
        return UserModel.fromJson(responseData['data']);
      } else {
        print('Failed to get user info: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user info: $e');
    }
    return null;
  }
}
