// import 'package:flutter/foundation.dart';
// import 'package:ucd/models/user_model.dart';
// import 'package:ucd/services/auth_service.dart/sign_up_service.dart';


// class SignUpViewModel extends ChangeNotifier {
//   final SignUpService _signUpService = SignUpService();

//   Future<void> signUp(UserModel userModel) async {
//     final success = await _signUpService.signUp(userModel);
//     if (success) {
//       print('Sign Up Success');
//     } else {
//       print('Sign Up Failed');
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ucd/models/user_model.dart';
import 'package:ucd/services/auth_service.dart/sign_up_service.dart';


class SignUpViewModel extends ChangeNotifier {
  final SignUpService _signUpService = SignUpService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> signUp(UserModel userModel, BuildContext context) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _signUpService.signUp(userModel);
      if (success) {
       GoRouter.of(context).go('/');
      } else {
        _errorMessage = "회원가입 실패: 다시 시도해주세요.";
      }
    } catch (e) {
      _errorMessage = "회원가입 에러: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
