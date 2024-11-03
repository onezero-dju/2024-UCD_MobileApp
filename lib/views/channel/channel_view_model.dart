import 'package:flutter/material.dart';

import 'package:ucd/services/channel_service.dart';
import 'package:ucd/util/router/token_shared_preferences.dart';

class ChannelViewModel with ChangeNotifier {
  final ChannelService _channelService = ChannelService();

  Map<String, List<Map<String, dynamic>>> channels = {};
  int? selectedOrganizationId;
  int? selectedChannel;
  String? selectedChannelName;
  // 채널 조회 메서드
  Future<void> fetchChannels(String organizationId, String token) async {
    try {
      final fetchedChannels = await _channelService.getChannels(organizationId);
      print(fetchedChannels);
      channels[organizationId] = fetchedChannels;
      notifyListeners();
    } catch (e) {
      print('Failed to fetch channels: $e');
    }
  }

  // 서버에 새로운 채널을 추가하는 메서드
  Future<void> addNewChannel(String organizationId, String channelName,
      String channelDescription) async {
    try {
      final token = await getToken(); // 토큰을 비동기적으로 가져옴
      if (token == null) {
        throw Exception('토큰을 가져오지 못했습니다.');
      }

      final success = await _channelService.addNewChannel(
          organizationId, channelName, channelDescription, token);
      if (success) {
        await fetchChannels(organizationId, token); // 성공적으로 추가 후 채널 목록 갱신
      }
    } catch (e) {
      print('채널 추가 중 오류 발생: $e');
    }
  }

  // 채널 선택 메서드
  void selectChannel(int organizationId, int channel, String channelName) {
    selectedOrganizationId = organizationId;
    selectedChannel = channel;
    selectedChannelName = channelName;
    notifyListeners();
  }

  // 채널 선택 해제 메서드
  void clearSelectedChannel() {
    selectedOrganizationId = null;
    selectedChannel = null;
    notifyListeners();
  }

  // 채널 추가를 위한 다이얼로그 메서드
  Future<void> showAddChannelDialog(
      BuildContext context, int organizationId) async {
    try {
      String newChannelName = "";
      String newChannelDescription = "";

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
                  if (newChannelName.isNotEmpty &&
                      newChannelDescription.isNotEmpty) {
                    addNewChannel(organizationId.toString(), newChannelName,
                        newChannelDescription);
                    Navigator.of(context).pop();
                  } else {
                    print("모든 필드를 채워주세요.");
                  }
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error occurred while getting token: $e');
      // 토큰을 가져오지 못한 경우 사용자에게 알림
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('토큰을 가져오는 데 실패했습니다. 다시 시도해주세요.')),
      );
    }
  }
}
