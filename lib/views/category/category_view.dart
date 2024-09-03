import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ucd/views/category/category_view_model.dart';
import 'package:ucd/views/channel/channel_view_model.dart';
import 'package:ucd/views/meeting_note/meeting_note_view.dart';
import 'package:ucd/views/meeting_note/meeting_note_view_model.dart';
import 'package:ucd/views/organization/organization_view_model.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  Map<String, bool> isExpanded = {};

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Consumer3<ChannelViewModel, CategoryViewModel, MeetingNoteViewModel>(
      builder: (context, channelViewModel, categoryViewModel,
          meetingNoteViewModel, child) {
        final selectedChannel = channelViewModel.selectedChannel;
        final categories = categoryViewModel.getCategories(selectedChannel!);

        // Print the organization, channel, and category details

        print('Current channel: $selectedChannel');
        print('Categories in the current channel: $categories');

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
                    onPressed: () => categoryViewModel.showAddCategoryDialog(
                        context, selectedChannel),
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
                              left: screenWidth * 0.1,
                              bottom: screenHeight * 0.03),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // CategoryScreen에서 카테고리 버튼을 클릭할 때
                                  ElevatedButton(
                                    onPressed: () {
                                      categoryViewModel.selectCategory(
                                          categoryId); // 선택된 카테고리를 설정합니다.
                                      categoryViewModel.toggleCategoryExpansion(
                                          categoryId, isExpanded);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      fixedSize: Size(screenWidth * 0.5,
                                          screenHeight * 0.06),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      foregroundColor: Colors.black,
                                      side: BorderSide(
                                        color: Colors.black,
                                        width: screenWidth * 0.005,
                                      ),
                                    ),
                                    child: Text(
                                      categoryId,
                                      style: TextStyle(
                                          fontSize: screenWidth * 0.05),
                                    ),
                                  ),

                                  IconButton(
                                    onPressed: () {
                                      categoryViewModel
                                          .showAddMeetingNoteDialog(
                                              context, categoryId);
                                    },
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
                                Column(
                                  children: meetingNoteViewModel
                                      .getMeetingNotes(categoryId)
                                      .map((note) => Padding(
                                            padding: EdgeInsets.only(
                                                top: screenHeight * 0.01),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                meetingNoteViewModel
                                                    .selectMeetingNote(
                                                        note); // 미팅 노트 선택
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const MeetingNoteScreen(),
                                                  ),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                padding: EdgeInsets.all(
                                                    screenWidth * 0.02),
                                                fixedSize: Size(
                                                    screenWidth * 0.6,
                                                    screenHeight * 0.06),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                side: BorderSide(
                                                  color: Colors.black,
                                                  width: screenWidth * 0.005,
                                                ),
                                              ),
                                              child: Text(
                                                note,
                                                style: TextStyle(
                                                  fontSize: screenWidth * 0.045,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                )
                            ],
                          ),
                        );
                      },
                    ),
            ),
            SizedBox(height: screenHeight * 0.03),
          ],
        );
      },
    );
  }
}
