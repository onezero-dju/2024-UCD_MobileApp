// organization_service/organization_service.dart

import 'package:http/http.dart' as http;
import 'dart:convert';

class OrganizationService {
  final String baseUrl = 'http://10.224.101.47:8080/api/organizations/my';

  // 조직 목록 조회
  Future<List<dynamic>> fetchOrganizations(String token) async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      print(data);
      return data['data'] as List<dynamic>;
    } else {
      throw Exception('조직 데이터를 불러올 수 없습니다.');
    }
  }

  //조직 조회
  Future<List<String>> searchOrganization(
      String token, String keyword, int page, int size) async {
    final queryParameters = {
      'keyword': keyword,
      'page': page.toString(),
      'size': size.toString(),
    };

    // URL 확인
    final url = Uri.http(
        '10.224.101.47:8080', '/api/organizations/search', queryParameters);

    // 요청 전 정보 출력
    print('Request URL: $url');
    print(
        'Request Headers: {Content-Type: application/json, Authorization: Bearer $token}');
    print('Request Parameters: $queryParameters');

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    // 응답 상태코드와 응답 내용 출력
    print('Response Status Code: ${response.statusCode}');
    print('Response Headers: ${response.headers}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> organizations = data['data'] as List<dynamic>;

      // 조직 이름만 리스트로 반환
      return organizations
          .map((org) => org['organizationName'] as String)
          .toList();
    } else {
      print(
          'Failed to fetch organizations. Status code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      throw Exception('조직 검색에 실패했습니다.');
    }
  }

  //조직 생성
  Future<void> createOrganizations(
      String token, String name, String description) async {
    final response = await http.post(
      Uri.parse('http://10.224.101.47:8080/api/organizations'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'organization_name': name,
        'description': description,
      }),
    );

    print(response.statusCode);

    if (response.statusCode == 201) {
      // 조직 생성이 성공한 후 조직 목록을 다시 불러옴
      fetchOrganizations(token);
    } else {
      throw Exception('조직 생성에 실패했습니다.');
    }
  }
}
