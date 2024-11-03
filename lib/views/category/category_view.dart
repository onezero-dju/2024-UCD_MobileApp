import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ucd/views/category/category_view_model.dart';
import 'package:ucd/views/channel/channel_view_model.dart';
import 'package:ucd/views/meeting_note/meeting_note_view_model.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({Key? key}) : super(key: key);

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  final Map<int, bool> _expandedCategories = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _fetchData();
    });
  }

  Future<void> _fetchData() async {
    final channelProvider =
        Provider.of<ChannelViewModel>(context, listen: false);
    final categoryProvider =
        Provider.of<CategoryViewModel>(context, listen: false);
    final meetingProvider =
        Provider.of<MeetingNoteViewModel>(context, listen: false);
    final int? channelId = channelProvider.selectedChannel;

    if (channelId != null) {
      print("initstate에서: $channelId");
      await categoryProvider.fetchCategory(channelId); // 카테고리 목록을 가져옴
      await meetingProvider.fetchMeetingNotes(channelId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Consumer3<CategoryViewModel, ChannelViewModel, MeetingNoteViewModel>(
      builder: (context, categoryProvider, channelProvider, meetingNoteProvider,
          child) {
        final int? channelId = channelProvider.selectedChannel;
        final String? channelName = channelProvider.selectedChannelName;
        // meetingNoteProvider.fetchMeetingNotes(channelId!);
        if (channelId == null) {
          return const Scaffold(
            body: Center(child: Text("채널이 선택되지 않았습니다.")),
          );
        }

        final categories = categoryProvider.categories[channelId] ?? [];
        final meetings = meetingNoteProvider.meetingNotes[channelId] ?? [];

        // Category 별로 분리된 미팅 노트와 카테고리 없이 배치할 미팅 노트를 구분합니다.
        final Map<int, List<Map<String, dynamic>>> categorizedMeetings = {};
        final List<Map<String, dynamic>> uncategorizedMeetings = [];

        for (var meeting in meetings) {
          if (meeting.containsKey('category_id') &&
              meeting['category_id'] != null) {
            final int categoryId = meeting['category_id'];
            if (categoryId == -1) {
              uncategorizedMeetings.add(meeting);
            } else if (!categorizedMeetings.containsKey(categoryId)) {
              categorizedMeetings[categoryId] = [];
            }
            categorizedMeetings[categoryId]?.add(meeting);
          }
        }

        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.1),
              Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 선택된 채널의 이름을 표시 (null 여부 확인)
                    Text(
                      channelName ?? "채널 이름 없음",
                      style: TextStyle(
                        fontSize: screenWidth * 0.08,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            _showAddMeetingNoteDialog(
                                context,
                                meetingNoteProvider,
                                channelProvider,
                                categoryProvider);
                          },
                          icon: const Icon(Icons.meeting_room_outlined),
                          color: Colors.black,
                          iconSize: screenWidth * 0.07,
                        ),
                        IconButton(
                          onPressed: () => categoryProvider
                              .showAddCategoryDialog(context, channelId),
                          icon: Icon(
                            Icons.add,
                            size: screenWidth * 0.07,
                          ),
                          color: Colors.black,
                          iconSize: screenWidth * 0.07,
                          splashColor: Colors.grey.withOpacity(0.2),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Expanded(
                child: ListView(
                  children: [
                    // 카테고리별로 미팅 노트를 표시합니다.
                    for (var category in categories)
                      Padding(
                        padding: EdgeInsets.only(
                          left: screenWidth * 0.04,
                          bottom: screenHeight * 0.03,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _expandedCategories[category['category_id']] =
                                      !(_expandedCategories[
                                              category['category_id']] ??
                                          false);
                                });
                              },
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _expandedCategories[category[
                                            'category_id']] = //_TypeError (type 'Null' is not a subtype of type 'int')
                                        !(_expandedCategories[
                                                category['category_id']] ??
                                            false);
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  fixedSize: Size(
                                      screenWidth * 0.7, screenHeight * 0.06),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  side: BorderSide(
                                    color: Colors.black,
                                    width: screenWidth * 0.005,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: screenWidth * 0.05),
                                      child: Text(
                                        category['name'] ?? '카테고리 이름 없음',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.05,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Icon(_expandedCategories[
                                                category['category_id']] ==
                                            true
                                        ? Icons.expand_less
                                        : Icons.expand_more),
                                  ],
                                ),
                              ),
                            ),
                            if (_expandedCategories[category['category_id']] ==
                                true)
                              ...categorizedMeetings[category['category_id']]
                                      ?.map((meeting) {
                                    final List<dynamic> meetingDtoList =
                                        meeting['meeting_dtolist'] ?? [];
                                    return Column(
                                      children: [
                                        for (var meetingDto in meetingDtoList)
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: screenHeight * 0.01),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                meetingNoteProvider
                                                    .setSelectedMeetingTitle(
                                                        meetingDto[
                                                            'meeting_title']);
                                                GoRouter.of(context)
                                                    .push('/meeting');
                                              },
                                              style: ElevatedButton.styleFrom(
                                                padding: EdgeInsets.zero,
                                                fixedSize: Size(
                                                    screenWidth * 0.6,
                                                    screenHeight * 0.06),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                backgroundColor: Colors.white,
                                                foregroundColor: Colors.black,
                                                side: BorderSide(
                                                  color: Colors.black,
                                                  width: screenWidth * 0.005,
                                                ),
                                              ),
                                              child: Text(
                                                meetingDto['meeting_title'] ??
                                                    '미팅 제목 없음',
                                                style: TextStyle(
                                                    fontSize:
                                                        screenWidth * 0.05),
                                              ),
                                            ),
                                          ),
                                      ],
                                    );
                                  }) ??
                                  [],
                          ],
                        ),
                      ),
                    // 카테고리에 포함되지 않은 미팅 노트를 별도로 표시합니다.
                    if (uncategorizedMeetings.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.02,
                            horizontal: screenWidth * 0.04),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "카테고리 없음",
                              style: TextStyle(
                                fontSize: screenWidth * 0.06,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ...uncategorizedMeetings.map((meeting) {
                              final List<dynamic> meetingDtoList =
                                  meeting['meeting_dtolist'] ?? [];
                              return Column(
                                children: [
                                  for (var meetingDto in meetingDtoList)
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: screenHeight * 0.01),
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          fixedSize: Size(screenWidth * 0.6,
                                              screenHeight * 0.06),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          backgroundColor: Colors.white,
                                          foregroundColor: Colors.black,
                                          side: BorderSide(
                                            color: Colors.black,
                                            width: screenWidth * 0.005,
                                          ),
                                        ),
                                        child: Text(
                                          meetingDto['meeting_title'] ??
                                              '미팅 제목 없음',
                                          style: TextStyle(
                                              fontSize: screenWidth * 0.05),
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddMeetingNoteDialog(
      BuildContext context,
      MeetingNoteViewModel meetingNoteProvider,
      ChannelViewModel channelProvider,
      CategoryViewModel categoryProvider) {
    String meetingTitle = "";
    String agenda = "";
    int? selectedCategory;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("새로운 회의 노트 추가"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  meetingTitle = value;
                },
                decoration: const InputDecoration(hintText: "회의 제목을 입력하세요"),
              ),
              DropdownButtonFormField<int>(
                value: selectedCategory,
                items: [
                  const DropdownMenuItem(
                      value: null, child: Text("카테고리 선택 안함")),
                  ...categoryProvider
                          .categories[channelProvider.selectedChannel]
                          ?.map((category) {
                        return DropdownMenuItem(
                          value: category["category_id"],
                          child: Text(category["name"] ?? "카테고리 이름 없음"),
                        );
                      }) ??
                      []
                ],
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
                decoration: const InputDecoration(hintText: "카테고리를 선택하세요"),
              ),
              TextField(
                onChanged: (value) {
                  agenda = value;
                },
                decoration: const InputDecoration(hintText: "agenda를 입력하세요"),
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
              onPressed: () async {
                if (meetingTitle.isNotEmpty) {
                  final categoryName = selectedCategory != null
                      ? categoryProvider
                          .categories[channelProvider.selectedChannel]
                          ?.firstWhere((category) =>
                              category['category_id'] ==
                              selectedCategory)['name']
                      : null;
                  meetingNoteProvider.createMeetingNote(
                    meetingTitle: meetingTitle,
                    channelId: channelProvider.selectedChannel!,
                    categoryId: selectedCategory,
                    channelName: channelProvider.selectedChannelName!,
                    categoryName: categoryName, //categoryName 들어가야 한다
                    agenda: agenda,
                    context: context,
                  );
                  await _fetchData();
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
