import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChannelViewModel with ChangeNotifier {
  Map<String, List<String>> channels = {}; // 조직 ID를 키로 하고, 채널 리스트를 값으로 가짐
  String? selectedOrganizationId;
  String? selectedChannel;

  Future<void> addNewChannel(String organizationId, String channelName,
      String channelDescription) async {
    // API 경로에 organization_id를 포함한 URL
    const String apiUrl =
        'https://run.mocky.io/v3/acaf4b19-aed6-460a-a688-fa0c0947fd4e';
//'https://your-api-endpoint.com/api/organizations/$organizationId/channels';  // 실제 API URL로 변경 필요
    // JWT 토큰을 가져옵니다. (여기서는 null이 아님을 가정)
    String token = "your_jwt_token_here";

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Cookie': 'jwt=$token', // JWT 토큰을 포함
      },
      body: jsonEncode({
        "name": channelName, // 채널 이름
        "description": channelDescription, // 채널 설명
      }),
    );

    if (response.statusCode == 201) {
      print('Channel created successfully!');
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      // 서버에서 받은 응답 데이터를 처리
      // 해당 조직의 채널 리스트에 채널 추가
      if (channels[organizationId] == null) {
        channels[organizationId] = []; // 채널 리스트가 없으면 새로 생성
      }
      channels[organizationId]!.add(responseData['data']['name']); // 새 채널 추가
      print(channels);
      notifyListeners(); // UI 갱신
    } else {
      print('Failed to create channel with status: ${response.statusCode}');
    }
  }

  // 채널 선택 메서드
  void selectChannel(String organizationId, String channel) {
    selectedOrganizationId = organizationId;
    selectedChannel = channel;
    notifyListeners();
  }

  // 채널 선택 해제 메서드
  void clearSelectedChannel() {
    selectedOrganizationId = null;
    selectedChannel = null;
    notifyListeners();
  }

// 채널 추가를 위한 다이얼로그 메서드
  void showAddChannelDialog(BuildContext context, String organizationId) {
    String newChannelName = "";
    String newChannelDescription = ""; // 채널 설명을 위한 변수 추가

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("새로운 채널 추가"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  newChannelName = value;
                },
                decoration: const InputDecoration(hintText: "채널 이름을 입력하세요"),
              ),
              TextField(
                onChanged: (value) {
                  newChannelDescription = value;
                },
                decoration: const InputDecoration(hintText: "채널 설명을 입력하세요"),
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
              onPressed: () {
                if (newChannelName.isNotEmpty) {
                  // 조직 ID와 함께 채널 생성
                  addNewChannel(
                      organizationId, newChannelName, newChannelDescription);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
