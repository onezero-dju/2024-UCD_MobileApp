import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ucd/models/user_model.dart';
import 'package:ucd/services/token_service.dart';

class LoginService {
  final String baseUrl = 'http://34.64.165.164:8080';

  Future<String?> login(UserModel userModel) async {
    final url = Uri.parse('$baseUrl/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': userModel.email,
          'password': userModel.password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData.containsKey('token')) {
          String token = responseData['token'];
          await saveToken(token);
          return token;
        }
      } else {
        print('Login Failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Login Error: $e');
    }
    return null;
  }

//    Future<UserModel?> getUserInfo() async {
//   final url = Uri.parse('$baseUrl/api/users/me');
//   final token = await getToken(); // 저장된 JWT 토큰 가져오기

//   if (token == null) {
//     print("Token is not available.");
//     return null;
//   }

//   try {
//     final response = await http.get(
//       url,
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token',
//       },
//     );
//     print(response.statusCode);
//     if (response.statusCode == 200) {
//       final responseData = jsonDecode(response.body);
//       print(responseData);
      
//       // 'data' 부분만 파싱하도록 수정
//       final userData = responseData['data'];
//       return UserModel.fromJson(userData);
//     } else {
//       print('Failed to get user info: ${response.statusCode}');
//     }
//   } catch (e) {
//     print('Error fetching user info: $e');
//   }
//   return null;
// }
}

