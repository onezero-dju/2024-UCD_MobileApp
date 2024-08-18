import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ucd/views/category/category_view_model.dart';
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
    final selectedChannel =
        Provider.of<OrganizationViewModel>(context).selectedChannel;
    final categoryViewModel = Provider.of<CategoryViewModel>(context);
    final categories = categoryViewModel.getCategories(selectedChannel!);

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
                          left: screenWidth * 0.1, bottom: screenHeight * 0.03),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    categoryViewModel.toggleCategoryExpansion(
                                        categoryId, isExpanded);
                                  });
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
                                onPressed: () {
                                  categoryViewModel.showAddMeetingNoteDialog(
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
                              children:
                                  Provider.of<MeetingNoteViewModel>(context)
                                      .getMeetingNotes(categoryId)
                                      .map((note) => Padding(
                                            padding: EdgeInsets.only(
                                                top: screenHeight * 0.01),
                                            child: Container(
                                              width: screenWidth * 0.6,
                                              padding: EdgeInsets.all(
                                                  screenWidth * 0.02),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                border: Border.all(
                                                    color: Colors.black,
                                                    width: screenWidth * 0.005),
                                              ),
                                              child: Text(
                                                note,
                                                style: TextStyle(
                                                    fontSize:
                                                        screenWidth * 0.045),
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
  }
}
