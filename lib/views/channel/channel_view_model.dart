import 'package:flutter/material.dart';

class ChannelViewModel with ChangeNotifier {
  Map<String, List<String>> channels = {}; // 조직 ID를 키로 하고, 채널 리스트를 값으로 가짐
  String? selectedOrganizationId;
  String? selectedChannel;

  // 새로운 채널 추가 메서드
  void addNewChannel(String organizationId, String channelName) {
    channels[organizationId] ??= []; // 조직 ID에 대한 채널 리스트 초기화
    channels[organizationId]!.add(channelName); // 해당 조직에만 채널 추가
    notifyListeners();
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newChannelName = "";
        return AlertDialog(
          title: const Text("새로운 채널 추가"),
          content: TextField(
            onChanged: (value) {
              newChannelName = value;
            },
            decoration: const InputDecoration(hintText: "채널 이름을 입력하세요"),
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
                  addNewChannel(organizationId, newChannelName);
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
