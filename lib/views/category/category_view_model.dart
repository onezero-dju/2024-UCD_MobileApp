import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ucd/views/meeting_note/meeting_note_view_model.dart';

class CategoryViewModel with ChangeNotifier {
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

  void toggleCategoryExpansion(
      String categoryId, Map<String, bool> isExpanded) {
    isExpanded[categoryId] = !(isExpanded[categoryId] ?? true);
    notifyListeners();
  }

  void showAddCategoryDialog(BuildContext context, String selectedChannel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newCategoryName = "";
        return AlertDialog(
          title: const Text("새로운 카테고리 추가"),
          content: TextField(
            onChanged: (value) {
              newCategoryName = value;
            },
            decoration: const InputDecoration(hintText: "카테고리 이름을 입력하세요"),
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
                if (newCategoryName.isNotEmpty) {
                  addNewCategory(selectedChannel, newCategoryName);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showAddMeetingNoteDialog(BuildContext context, String categoryId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newNote = "";
        return AlertDialog(
          title: const Text("새로운 Meeting Note 추가"),
          content: TextField(
            onChanged: (value) {
              newNote = value;
            },
            decoration: const InputDecoration(hintText: "Meeting Note를 입력하세요"),
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
                if (newNote.isNotEmpty) {
                  Provider.of<MeetingNoteViewModel>(context, listen: false)
                      .addNewMeetingNote(categoryId, newNote);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
