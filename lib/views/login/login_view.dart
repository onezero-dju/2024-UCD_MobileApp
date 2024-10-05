import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ucd/models/user_model.dart';
import 'package:ucd/views/login/login_view_model.dart';
import 'package:ucd/views/organization/organization_view.dart';
import 'package:ucd/views/widgets/text_field.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'sign_up_view.dart'; // svg 관련 패키지

class LoginView
 extends StatefulWidget {
  const LoginView
  ({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginView
>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true); // 애니메이션 반복
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return '이메일을 입력하세요';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return '이메일 형식을 맞춰주세요';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return '비밀번호를 입력해주세요';
    } else if (value.length < 6) {
      return '비밀번호가 너무 짧습니다.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginViewModel>(
      create: (_) => LoginViewModel(),
      child: Consumer<LoginViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            body: SingleChildScrollView(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 100),
                        const Text(
                          "Key Note",
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                        const SizedBox(height: 50),
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
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
                                const SizedBox(height: 40),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: viewModel.isLoading
                                        ? null
                                        : () {
                                            if (_formKey.currentState
                                                    ?.validate() ??
                                                false) {
                                              final userModel = UserModel(
                                                email: _emailController.text,
                                                password: _passwordController
                                                    .text,
                                              );
                                              viewModel.login(
                                                  userModel, context);
                                            }
                                          },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      side: const BorderSide(
                                        color: Colors.black,
                                      ),
                                    ),
                                    child: viewModel.isLoading
                                        ? const CircularProgressIndicator()
                                        : const Text('로그인',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25,
                                            )),
                                  ),
                                ),
                                if (viewModel.errorMessage != null)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      viewModel.errorMessage!,
                                      style:
                                          const TextStyle(color: Colors.red),
                                    ),
                                  ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        right: 14,
                                        top: 10,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                         GoRouter.of(context).go('/signup');
                                        },
                                        child: const Text(
                                          '회원가입 하기',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 100),
                        // ImageButton(
                        //   imagePath: 'assets/images/google_login.svg',
                        //   onPressed: () {
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //           builder: (context) =>
                        //               const OrganizationScreen()),
                        //     );
                        //   },
                        // ),
                        // const SizedBox(height: 20),
                        // ImageButton(
                        //   imagePath: 'assets/images/naver_login_button.svg',
                        //   onPressed: () {
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //           builder: (context) =>
                        //               const OrganizationScreen()),
                        //     );
                        //   },
                        // ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class ImageButton extends StatelessWidget {
  final String imagePath;
  final VoidCallback onPressed;

  const ImageButton({
    super.key,
    required this.imagePath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: 50,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: SvgPicture.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
