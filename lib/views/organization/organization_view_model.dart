import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ucd/repository/token.dart';

class OrganizationViewModel with ChangeNotifier {
  List<Map<String, dynamic>> organizations = []; // 조직 목록 (ID와 이름을 함께 저장)
  String? selectedOrganizationId; // 선택된 조직의 ID

  // 새로운 조직 추가 및 다이얼로그 로직을 함께 처리
  void showAddOrganizationDialog(BuildContext context) {
    String newOrganizationName = "";
    String newOrganizationDescription = ""; // 조직 설명 추가

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("새로운 조직 추가"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  newOrganizationName = value;
                },
                decoration: const InputDecoration(hintText: "조직 이름을 입력하세요"),
              ),
              TextField(
                onChanged: (value) {
                  newOrganizationDescription = value;
                },
                decoration: const InputDecoration(hintText: "조직 설명을 입력하세요"),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("취소"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("추가"),
              onPressed: () async {
                if (newOrganizationName.isNotEmpty) {
                  // HTTP POST 요청으로 조직을 추가
                  await addNewOrganization(
                      newOrganizationName, newOrganizationDescription);
                  Navigator.of(context).pop();
                  print(organizations); // 현재 조직 목록 출력
                  fetchUserInfo(
                      "your_jwt_token_here"); // fetchUserInfo 호출로 목록 갱신
                }
              },
            ),
          ],
        );
      },
    );
  }

  // 서버로부터 조직 정보를 가져오는 메서드
  Future<void> fetchOrganizations(String token) async {
    const String apiUrl =
        'https://your-api-url.com/api/organization/my'; // API 명세서에 따른 URL

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Cookie': 'jwt=$token', // JWT 토큰을 포함
      },
    );

    if (response.statusCode == 200) {
      print('Fetched organizations successfully');
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      // 서버로부터 받은 조직 정보를 저장
      organizations = List<Map<String, dynamic>>.from(responseData['data']);
      notifyListeners(); // UI 갱신
    } else {
      print(
          'Failed to fetch organizations with status: ${response.statusCode}');
    }
  }

  // 새로운 조직을 서버에 추가하고 조직 리스트는 갱신하지 않음 (fetchUserInfo로만 갱신)
  Future<void> addNewOrganization(
      String organizationName, String description) async {
    const String apiUrl =
        'https://run.mocky.io/v3/07491eff-4e81-46c1-bed7-ff5a0f7b5f34'; // Mocky API URL

    String token = "your_jwt_token_here";
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Cookie': 'jwt=$token', // JWT 토큰을 포함
      },
      body: jsonEncode({
        "organization_name": organizationName,
        "description": description,
      }),
    );

    if (response.statusCode == 201) {
      print('Organization added successfully!');
      // 조직이 추가되었으나, fetchUserInfo를 다시 호출하여 조직 목록을 갱신해야 함
    } else {
      print('Failed to add organization with status: ${response.statusCode}');
    }
  }

  // 조직 선택 시 ID를 저장
  void selectOrganization(String organizationId) {
    selectedOrganizationId = organizationId; // 선택된 조직의 ID 저장
    notifyListeners();
  }

  // 서버로부터 사용자와 조직 정보를 가져오는 메서드
  Future<void> fetchUserInfo(String token) async {
    const String apiUrl =
        'https://run.mocky.io/v3/d5776b50-fe82-4cdc-be4a-a7d4d3dd5781'; // 실제 API URL

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Cookie': 'jwt=$token', // JWT 토큰을 포함
      },
    );

    if (response.statusCode == 200) {
      print('Fetched user info successfully');
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      // 서버로부터 받은 조직 정보를 organizations 리스트에 저장
      organizations = List<Map<String, dynamic>>.from(
          responseData['data']['organizations']);
      print("ddd: $organizations");
      notifyListeners(); // UI 갱신
    } else {
      print('Failed to fetch user info with status: ${response.statusCode}');
    }
  }
}

 








// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:ucd/repository/token.dart';

// class OrganizationViewModel with ChangeNotifier {
//   List<String> organizations = []; // 조직 목록
//   String? selectedOrganization; // 현재 선택된 조직

//   // 새로운 조직 추가 및 다이얼로그 로직을 함께 처리
//   void showAddOrganizationDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         String newOrganizationName = "";
//         return AlertDialog(
//           title: const Text("새로운 조직 추가"),
//           content: TextField(
//             onChanged: (value) {
//               newOrganizationName = value;
//             },
//             decoration: const InputDecoration(hintText: "조직 이름을 입력하세요"),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text("취소"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: const Text("추가"),
//               onPressed: () {
//                 if (newOrganizationName.isNotEmpty) {
//                   addNewOrganization(newOrganizationName);
//                   Navigator.of(context).pop();
//                 }
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // 새로운 조직을 리스트에 추가하고 초기화
//   void addNewOrganization(String newOrganizationName) {
//     organizations.add(newOrganizationName);
//     notifyListeners();
//   }

//   void selectOrganization(String organization) {
//     selectedOrganization = organization;
//     // 새로운 조직을 선택할 때 채널을 초기화

//     notifyListeners();
//   }

//   Future<Map<String, dynamic>?> fetchUserInfo() async {
    
//     // 저장된 토큰을 가져옵니다.
//     final token = await getToken();

//     // 토큰이 없다면 요청을 중단합니다.
//     if (token == null) {
//       print('No token found');
//       return null;
//     }

//     final response = await http.get(
//       Uri.parse('https://run.mocky.io/v3/4e38e215-c541-4284-bf80-63e31f4484c8'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//         'Cookie': 'jwt=$token', // JWT 토큰을 Cookie 헤더에 포함
//       },
//     );

//     if (response.statusCode == 200) {
//       print('Response status: ${response.statusCode}');
//       print('Response body: ${response.body}');

//       try {
//         final Map<String, dynamic> userData = jsonDecode(response.body);
//         return userData['data']; // 서버로부터 받은 회원 정보 반환
//       } catch (e) {
//         print('Failed to parse JSON: $e');
//         return null;
//       }
//     } else {
//       // 오류 처리
//       print('Request failed with status: ${response.statusCode}');
//       return null;
//     }
//   }

//   void loginAndFetchUserInfo() async {
//     // 1. JWT 토큰을 사용해 회원 정보 요청
//     Map<String, dynamic>? userInfo = await fetchUserInfo();

//     if (userInfo != null) {
//       // 회원 정보 처리
//       print("User ID: ${userInfo['user_id']}");
//       print("User Name: ${userInfo['user_name']}");
//       // 추가적인 회원 정보 처리
//     } else {
//       print("Failed to fetch user info");
//     }
//   }
// }
