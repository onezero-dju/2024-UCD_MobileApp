import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ucd/providers/category_provider.dart';
import 'package:ucd/providers/meeting_note_provider.dart';
import 'package:ucd/providers/organization_provider.dart';
import 'package:ucd/views/screens/meeting_note_list.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  Map<String, bool> isExpanded = {};

  void _addNewCategory(BuildContext context) {
    final categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    final selectedChannel =
        Provider.of<OrganizationProvider>(context, listen: false)
            .selectedChannel;

    if (selectedChannel != null) {
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
                    categoryProvider.addNewCategory(
                        selectedChannel, newCategoryName);
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

  void _addNewMeetingNote(BuildContext context, String categoryId) {
    final meetingNoteProvider =
        Provider.of<MeetingNoteProvider>(context, listen: false);
    meetingNoteProvider.selectCategory(categoryId); // 선택된 카테고리 설정

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
                  meetingNoteProvider.addNewMeetingNote(categoryId, newNote);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final selectedChannel =
        Provider.of<OrganizationProvider>(context).selectedChannel;
    final categories =
        Provider.of<CategoryProvider>(context).getCategories(selectedChannel!);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: screenHeight * 0.1),
        Padding(
          padding: EdgeInsets.only(left: screenWidth * 0.1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                selectedChannel,
                style: TextStyle(
                  fontSize: screenWidth * 0.08,
                  fontWeight: FontWeight.w500,
                ),
              ),
              IconButton(
                onPressed: () => _addNewCategory(context),
                icon: Icon(
                  Icons.add,
                  size: screenWidth * 0.07,
                ),
                color: Colors.black,
                iconSize: screenWidth * 0.07,
              ),
            ],
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        Expanded(
          child: categories.isEmpty
              ? const Center(child: Text("카테고리가 없습니다. 카테고리를 추가하세요."))
              : ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    String categoryId = categories[index];
                    bool expanded =
                        isExpanded[categoryId] ?? true; // 기본값을 true로 설정

                    return Padding(
                      padding: EdgeInsets.only(
                          left: screenWidth * 0.1, bottom: screenHeight * 0.03),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    isExpanded[categoryId] =
                                        !(isExpanded[categoryId] ?? true);
                                  });
                                  // 선택된 카테고리를 설정
                                  Provider.of<MeetingNoteProvider>(context,
                                          listen: false)
                                      .selectCategory(categoryId);
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  fixedSize: Size(
                                    screenWidth * 0.5,
                                    screenHeight * 0.06,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  foregroundColor: Colors.black,
                                  side: BorderSide(
                                    color: Colors.black,
                                    width: screenWidth * 0.005,
                                  ),
                                ),
                                child: Text(
                                  categoryId,
                                  style:
                                      TextStyle(fontSize: screenWidth * 0.05),
                                ),
                              ),
                              IconButton(
                                onPressed: () =>
                                    _addNewMeetingNote(context, categoryId),
                                icon: Icon(
                                  Icons.add,
                                  size: screenWidth * 0.07,
                                ),
                                color: Colors.black,
                                iconSize: screenWidth * 0.07,
                              ),
                            ],
                          ),
                          if (expanded)
                            const MeetingNoteScreen(), // 카테고리 선택 시 MeetingNoteScreen을 표시
                        ],
                      ),
                    );
                  },
                ),
        ),
        SizedBox(height: screenHeight * 0.03),
      ],
    );
  }
}
