import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChannelViewModel with ChangeNotifier {
  Map<String, List<Map<String, dynamic>>> channels =
      {}; // 조직 ID를 키로 하고, 채널 리스트를 값으로 가짐
  String? selectedOrganizationId;
  String? selectedChannel;
  // 서버로부터 받은 채널 정보를 설정하는 메서드
  void setChannelsFromOrganizations(List<Map<String, dynamic>> organizations) {
    channels.clear();
    for (var organization in organizations) {
      final organizationId = organization['organization_id'].toString();
      channels[organizationId] =
          List<Map<String, dynamic>>.from(organization['channels']);
    }
    print(channels);
    notifyListeners(); // 채널 정보 갱신
  }

  // 서버에 새로운 채널을 추가하는 메서드
  Future<void> addNewChannel(String organizationId, String channelName,
      String channelDescription) async {
    // 실제 API URL을 설정합니다.
    const String apiUrl =
        'https://run.mocky.io/v3/acaf4b19-aed6-460a-a688-fa0c0947fd4e';

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
      // 서버로 채널이 성공적으로 추가된 후 UI 업데이트를 위해 서버로부터 데이터를 다시 가져올 수 있습니다.
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
    print(channels);
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
