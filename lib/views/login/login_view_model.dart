// import 'package:flutter/material.dart';
// import 'package:ucd/models/user_model.dart';
// import 'package:ucd/services/auth_service.dart/login_service.dart';

// import 'package:ucd/views/organization/organization_view.dart';

// class LoginViewModel extends ChangeNotifier {
//   final LoginService _loginService = LoginService();

//   Future<void> login(UserModel userModel, BuildContext context) async {
//     final token = await _loginService.login(userModel);
//     if (token != null) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => const OrganizationScreen(),
//         ),
//       );
//       print('Login Success');
//     } else {
//       print('Login Failed');
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ucd/models/user_model.dart';
import 'package:ucd/services/auth_service.dart/login_service.dart';


class LoginViewModel extends ChangeNotifier {
  final LoginService _loginService = LoginService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> login(UserModel userModel, BuildContext context) async {
    _isLoading = true;
    _errorMessage = null; // Reset error message
    notifyListeners();

    try {
      final token = await _loginService.login(userModel);
      if (token != null) {
GoRouter.of(context).goNamed('organization');

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
}
