import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ucd/models/user_model.dart';
import 'package:ucd/views/login/sign_up_view_model.dart';
import 'package:ucd/views/widgets/text_field.dart';

class SignUpView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  SignUpView({super.key});

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  String? _confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    } else if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SignUpViewModel>(
      create: (_) => SignUpViewModel(),
      child: Consumer<SignUpViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '회원 가입',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey[900],
                          ),
                        ),
                        const SizedBox(height: 40),
                        CustomTextField(
                          controller: _userNameController,
                          hintText: '이름',
                          icon: Icons.person,
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: _emailController,
                          hintText: '이메일',
                          icon: Icons.email,
                          validator: _emailValidator,
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: _passwordController,
                          hintText: '비밀번호',
                          icon: Icons.lock,
                          obscureText: true,
                          isPasswordField: true,
                          validator: _passwordValidator,
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: _confirmPasswordController,
                          hintText: '비밀번호 확인',
                          icon: Icons.lock_outline,
                          obscureText: true,
                          isPasswordField: true,
                          validator: _confirmPasswordValidator,
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: viewModel.isLoading
                              ? null
                              : () {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    final userModel = UserModel(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                      username: _userNameController.text,
                                    );
                                    viewModel.signUp(userModel, context);
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey[900],
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: viewModel.isLoading
                              ? const CircularProgressIndicator()
                              : const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                        if (viewModel.errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              viewModel.errorMessage!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            '이미 계정이 있으신가요? 로그인 하기',
                            style: TextStyle(
                              color: Colors.blueGrey[700],
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
