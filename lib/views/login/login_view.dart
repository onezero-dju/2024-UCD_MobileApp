import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:ucd/models/login_model.dart';
import 'package:ucd/views/login/login_view_model.dart';
import 'package:ucd/views/login/sign_up_view.dart';
import 'package:ucd/views/organization/organization_view.dart';
import 'package:ucd/views/widgets/text_field.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
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
      return '비밀번호가 일치하지 않습니다';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: Scaffold(
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
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    final loginModel = LoginModel(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                    );
                                    Provider.of<LoginViewModel>(context,
                                            listen: false)
                                        .login(loginModel, context);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  side: const BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                child: const Text('로그인',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                    )),
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
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return SignUpView();
                                        },
                                      ));
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
                    ImageButton(
                      imagePath: 'assets/images/google_login.svg',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const OrganizationScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    ImageButton(
                      imagePath: 'assets/images/naver_login_button.svg',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const OrganizationScreen()),
                        );
                      },
                    ),
                    //const SizedBox(height: 20),
                    // SizedBox(
                    //   width: MediaQuery.of(context).size.width * 0.8,
                    //   height: 50,
                    //   child: ElevatedButton(
                    //     onPressed: () {
                    //       Navigator.push(context, MaterialPageRoute(
                    //         builder: (context) {
                    //           return SignUpView();
                    //         },
                    //       ));
                    //     },
                    //     style: ElevatedButton.styleFrom(
                    //       padding: EdgeInsets.zero,
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(8.0),
                    //       ),
                    //       side: const BorderSide(
                    //         color: Colors.black,
                    //       ),
                    //     ),
                    //     child: const Text('회원가입 하기',
                    //         style: TextStyle(
                    //           color: Colors.black,
                    //           fontWeight: FontWeight.bold,
                    //           fontSize: 25,
                    //         )),
                    //   ),
                    // ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $url';
    }
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
