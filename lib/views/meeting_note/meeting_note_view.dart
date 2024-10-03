import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ucd/views/organization/organization_view_model.dart';
import 'package:ucd/views/channel/channel_view_model.dart';
import 'package:ucd/views/category/category_view_model.dart';
import 'package:ucd/views/meeting_note/meeting_note_view_model.dart';

class MeetingNoteScreen extends StatefulWidget {
  const MeetingNoteScreen({super.key});

  @override
  _MeetingNoteScreenState createState() => _MeetingNoteScreenState();
}

class _MeetingNoteScreenState extends State<MeetingNoteScreen> {
  bool isMeetingStarted = false;

  @override
  Widget build(BuildContext context) {
    final selectedNote =
        Provider.of<MeetingNoteViewModel>(context).selectedNote;

    return Consumer4<OrganizationViewModel, ChannelViewModel, CategoryViewModel,
        MeetingNoteViewModel>(
      builder: (context, organizationProvider, channelProvider,
          categoryProvider, meetingNoteProvider, child) {
        final selectedChannel = channelProvider.selectedChannel;
        final selectedCategory = categoryProvider.selectedCategory;

        return Scaffold(
          appBar: AppBar(
            title: selectedNote != null
                ? Text(
                    selectedNote,
                    style: const TextStyle(fontSize: 24),
                  )
                : const Center(
                    child: Text(
                      '제목 없음',
                      style:
                          TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                    ),
                  ),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.mic,
                    size: 100,
                  ),
                  onPressed: () {
                    setState(() {
                      isMeetingStarted = true;
                    });

                    if (selectedNote != null) {
                      print('회의 시작');

                      print('채널: $selectedChannel');
                      print('카테고리: $selectedCategory');
                      print('회의 노트: $selectedNote');
                    } else {
                      print('회의 노트가 선택되지 않았습니다.');
                    }
                  },
                ),
                if (isMeetingStarted)
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      '실시간 협업 공간 webview 작동중',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isMeetingStarted = false;
                          });
                        },
                        child: const Text(
                          '회의 종료',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        )),
                  ],
                )
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: const Text(
              '요약',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}
