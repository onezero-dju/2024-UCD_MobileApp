import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ucd/views/channel/channel_view_model.dart';

class OrganizationViewModel with ChangeNotifier {
  List<String> organizations = []; // 조직 목록
  String? selectedOrganization; // 현재 선택된 조직

  // 새로운 조직 추가 및 다이얼로그 로직을 함께 처리
  void showAddOrganizationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newOrganizationName = "";
        return AlertDialog(
          title: const Text("새로운 조직 추가"),
          content: TextField(
            onChanged: (value) {
              newOrganizationName = value;
            },
            decoration: const InputDecoration(hintText: "조직 이름을 입력하세요"),
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
                if (newOrganizationName.isNotEmpty) {
                  addNewOrganization(newOrganizationName);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  // 새로운 조직을 리스트에 추가하고 초기화
  void addNewOrganization(String newOrganizationName) {
    organizations.add(newOrganizationName);
    notifyListeners();
  }

  void selectOrganization(String organization) {
    selectedOrganization = organization;
    // 새로운 조직을 선택할 때 채널을 초기화

    notifyListeners();
  }
}
