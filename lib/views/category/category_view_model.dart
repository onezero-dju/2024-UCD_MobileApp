// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:ucd/views/meeting_note/meeting_note_view_model.dart';

// class CategoryViewModel with ChangeNotifier {
//   Map<String, List<String>> categories = {}; // 각 채널에 대한 카테고리 목록
//   String? selectedCategory; // 현재 선택된 카테고리

//   // 새로운 카테고리 추가 메서드
//   void addNewCategory(String channelId, String categoryName) {
//     if (channelId.isNotEmpty) {
//       categories[channelId] ??= []; // 채널 ID에 대한 카테고리 리스트 초기화
//       categories[channelId]!.add(categoryName); // 현재 채널에만 카테고리 추가
//       notifyListeners();
//     }
//   }

//   // 특정 채널에 대한 카테고리 목록 반환 메서드
//   List<String> getCategories(String channelId) {
//     return categories[channelId] ?? []; // 채널에 해당하는 카테고리 목록 반환
//   }

//   // 카테고리 확장/축소 상태 변경 메서드
//   void toggleCategoryExpansion(
//       String categoryId, Map<String, bool> isExpanded) {
//     isExpanded[categoryId] = !(isExpanded[categoryId] ?? true);
//     notifyListeners();
//   }

//   // 카테고리 추가를 위한 다이얼로그 메서드
//   void showAddCategoryDialog(BuildContext context, String selectedChannel) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         String newCategoryName = "";
//         return AlertDialog(
//           title: const Text("새로운 카테고리 추가"),
//           content: TextField(
//             onChanged: (value) {
//               newCategoryName = value;
//             },
//             decoration: const InputDecoration(hintText: "카테고리 이름을 입력하세요"),
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
//                 if (newCategoryName.isNotEmpty) {
//                   addNewCategory(
//                       selectedChannel, newCategoryName); // 채널 ID를 기반으로 카테고리 추가
//                   Navigator.of(context).pop(); // 다이얼로그 닫기
//                 }
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void selectCategory(String category) {
//     selectedCategory = category;
//     print('Selected Category: $selectedCategory'); // 로그로 확인합니다.
//     notifyListeners();
//   }

//   // Meeting Note 추가를 위한 다이얼로그 메서드
//   void showAddMeetingNoteDialog(BuildContext context, String categoryId) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         String newNote = "";
//         return AlertDialog(
//           title: const Text("새로운 Meeting Note 추가"),
//           content: TextField(
//             onChanged: (value) {
//               newNote = value;
//             },
//             decoration: const InputDecoration(hintText: "Meeting Note를 입력하세요"),
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
//                 if (newNote.isNotEmpty) {
//                   Provider.of<MeetingNoteViewModel>(context, listen: false)
//                       .addNewMeetingNote(categoryId, newNote);
//                   Navigator.of(context).pop(); // 다이얼로그 닫기
//                 }
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:ucd/services/category_service.dart';

class CategoryViewModel with ChangeNotifier {
  final CategoryService _categoryService = CategoryService();
  Map<int, List<Map<String, dynamic>>> categories = {}; // 채널별 카테고리 목록 저장

  String? selectedCategory; // 현재 선택된 카테고리

  // 카테고리 조회
  Future<void> fetchCategory(int channelId) async {
    try {
      final fetchCategories = await _categoryService.fetchCategory(channelId);
      categories[channelId] = fetchCategories;
      print("Fetch categㅇory: ${categories[channelId]}");
      notifyListeners();
    } catch (e) {
      print("view model에서 카테고리 조회 중 오류 발생: $e");
    }
  }

  // 새로운 카테고리 추가 메서드
  Future<void> addNewCategory(int channelId, String categoryName) async {
    try {
      final success = await _categoryService.addNewCategory(channelId, categoryName);
      if (success) {
        categories[channelId] ??= [];
        categories[channelId]!.add({"name": categoryName});
        notifyListeners();
      }
    } catch (e) {
      print('Failed to add new category: $e');
    }
  }

  void selectCategory(String categoryName) {
    print('Selected Category: $categoryName');
    notifyListeners();
  }

    void clearSelectedCategory() {
    selectedCategory = null;

    notifyListeners();
  }
  void showAddCategoryDialog(BuildContext context, int channelId) {
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
              onPressed: () async {
                if (newCategoryName.isNotEmpty) {
                  await addNewCategory(channelId, newCategoryName);
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