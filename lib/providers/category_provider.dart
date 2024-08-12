import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier {
  final Map<String, List<String>> _categories = {};
  String? _selectedCategory;

  // 카테고리 리스트 불러오기
  List<String> getCategories(String channelId) {
    return _categories[channelId] ?? [];
  }

  // 새로운 카테고리 추가
  void addNewCategory(String channelId, String categoryName) {
    _categories[channelId] ??= [];
    _categories[channelId]!.add(categoryName);
    notifyListeners();
  }

  // 선택된 카테고리 설정
  void selectCategory(String categoryId) {
    _selectedCategory = categoryId;
    notifyListeners();
  }

  // 선택된 카테고리 가져오기
  String? get selectedCategory => _selectedCategory;
}
