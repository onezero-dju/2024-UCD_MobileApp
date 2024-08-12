import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ucd/views/screens/organization_screen.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const KeyNoteApp());
}

class KeyNoteApp extends StatelessWidget {
  const KeyNoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KeyNote',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // KeyNote 로고
                const SizedBox(height: 100),

                const SizedBox(height: 20),
                // Welcome 텍스트
                const Text(
                  "Key Note",
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                const SizedBox(height: 350),
                // 구글 로그인 버튼
                ImageButton(
                  imagePath: 'assets/images/google_login.svg',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const OrganizationScreen()),
                    );
                    // _launchURL(
                    //     //client id: 클라이언트 ID(애플리케이션 식별 역할)
                    //     //redirect_uri: 벡인드 서버 uri
                    //     //response_type: 권한 부여 코드 요청 지시
                    //     //scope: 어떤 정보를 요청할지 권한 범위
                    //     'https://accounts.google.com/o/oauth2/v2/auth?client_id=94929580240-hflmv2a514835bufvmacfajash3kira3.apps.googleusercontent.com&redirect_uri=http://localhost:8080/login/oauth2/code/google&response_type=code&scope=profile%20email');
                  },
                ),
                const SizedBox(height: 20),
                // 네이버 로그인 버튼
                ImageButton(
                  imagePath: 'assets/images/naver_login_button.svg',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const OrganizationScreen()),
                    );
                    // _launchURL(
                    //     'https://nid.naver.com/oauth2.0/authorize?client_id=hVb3dIveGV1qVblPIvPE&redirect_uri=http://localhost:8080/login/oauth2/code/naver&response_type=code');
                  },
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
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
        height: 50, // 버튼 높이 설정
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: SvgPicture.asset(
            imagePath,
            fit: BoxFit.cover, // 이미지가 버튼 크기에 맞춰짐
          ),
        ),
      ),
    );
  }
}
