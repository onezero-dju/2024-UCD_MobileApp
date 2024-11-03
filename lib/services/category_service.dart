import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ucd/util/router/token_shared_preferences.dart';

class CategoryService {
  // 카테고리 생성 메서드
  Future<bool> addNewCategory(int channelId, String categoryName) async {
    final String apiUrl =
        'http://34.64.165.164:8080/api/channels/$channelId/categories';
    final token = await getToken();

    if (token == null) {
      print('토큰을 가져오지 못했습니다.');
      return false;
    }

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "name": categoryName,
      }),
    );

    if (response.statusCode == 201) {
      print('Category created successfully!');
      return true;
    } else {
      print('Failed to create category with status: ${response.statusCode}');
      return false;
    }
  }

  // 카테고리 목록 가져오기 (임시 데이터 사용)
  // Future<List<String>> getCategories(int channelId) async {
  //   await Future.delayed(Duration(seconds: 1)); // 네트워크 지연을 가정한 딜레이
  //   return []; // 임시로 빈 리스트를 반환
  // }

  // 조직 내 카테고리 조회
  Future<List<Map<String, dynamic>>> fetchCategory(int channelId) async {
    final token = await getToken();
    print(token);
    final String apiUrl =
        'http://34.64.165.164:8080/api/channels/$channelId/categories';
    print("category_service파일에서: $apiUrl");
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    final String decodeBody = utf8.decode(response.bodyBytes); //utf8 수동 디코딩
    if (response.statusCode == 200) {
      print('Fetched category successfully');
      print(List<Map<String, dynamic>>.from(jsonDecode(decodeBody)['data']));
      return List<Map<String, dynamic>>.from(jsonDecode(decodeBody)['data']);
    } else {
      print('Failed to fetch channels with status: ${response.statusCode}');
      throw Exception('Failed to load channels');
    }
  }
}
