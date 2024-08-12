import 'package:flutter/material.dart';

class OrganizationProvider with ChangeNotifier {
  List<String> organizations = []; // 조직 목록
  Map<String, List<String>> channels = {}; // 각 조직에 대한 채널 목록
  String? selectedOrganization; // 현재 선택된 조직
  String? selectedChannel; // 현재 선택된 채널

  void addNewOrganization(String newOrganizationName) {
    organizations.add(newOrganizationName);
    channels[newOrganizationName] = []; // 새로운 조직에 대한 채널 리스트 초기화
    notifyListeners();
  }

  void addNewChannel(String channelName) {
    if (selectedOrganization != null) {
      channels[selectedOrganization]!.add(channelName); // 현재 선택된 조직에 채널 추가
      notifyListeners();
    }
  }

  void selectOrganization(String organization) {
    selectedOrganization = organization;
    selectedChannel = null; // 새로운 조직 선택 시 채널 초기화
    notifyListeners();
  }

  void selectChannel(String channel) {
    selectedChannel = channel;
    notifyListeners();
  }
}
