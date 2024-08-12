import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier {
  Map<String, List<String>> categories = {}; // 각 채널에 대한 카테고리 목록
  String? selectedCategory; // 현재 선택된 카테고리

  void addNewCategory(String channelId, String categoryName) {
    if (channelId.isNotEmpty) {
      categories[channelId] ??= [];
      categories[channelId]!.add(categoryName); // 현재 채널에 카테고리 추가
      notifyListeners();
    }
  }

  void selectCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }

  List<String> getCategories(String channelId) {
    return categories[channelId] ?? []; // 채널에 해당하는 카테고리 목록 반환
  }
}
