// lib/views/meeting_note/meeting_note_view.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ucd/views/meeting_note/meeting_note_view_model.dart';

class MeetingNoteView extends StatefulWidget {
  const MeetingNoteView({super.key});

  @override
  State<MeetingNoteView> createState() => _MeetingNoteViewState();
}

class _MeetingNoteViewState extends State<MeetingNoteView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final meetingNoteProvider =
          Provider.of<MeetingNoteViewModel>(context, listen: false);

      // `selectedMeetingTitle`에서 `meetingId`를 가져오고, 방에 자동으로 입장
      final String? meetingTitle = meetingNoteProvider.selectedMeetingTitle;
      if (meetingTitle != null) {
        final meetingId = meetingNoteProvider.getMeetingIdByTitle(meetingTitle);

        if (meetingId != null) {
          await meetingNoteProvider.fetchMeetingDetails(meetingId);
          // await meetingNoteProvider.joinCollaborationRoom(meetingId);
        }
      }
    });
  }

  // @override
  // void dispose() {
  //   // 뷰가 해제될 때 실시간 협업 방 연결 종료
  //   Provider.of<MeetingNoteViewModel>(context, listen: false)
  //       .leaveCollaborationRoom();
  //   super.dispose();
  // }

  //화면 나가면 협업방 탈출
  // @override
  // void dispose() {
  //   final meetingNoteProvider =
  //       Provider.of<MeetingNoteViewModel>(context, listen: false);
  //   meetingNoteProvider.leaveCollaborationRoom();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<MeetingNoteViewModel>(
      builder: (context, meetingNoteProvider, child) {
        final String? meetingTitle = meetingNoteProvider.selectedMeetingTitle;
        final participants =
            meetingNoteProvider.selectedMeetingDetails?['participants'] ?? [];
        final agenda =
            meetingNoteProvider.selectedMeetingDetails?['agenda'] ?? '';
        final meetingId =
            meetingNoteProvider.selectedMeetingDetails?['id'] ?? '';
        final participantCount = participants.length.toString();
        final activeUsernames = meetingNoteProvider.activeUsernames;
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                context.pop(); // 카테고리, 회의 목록 화면으로 돌아가기
              },
              icon: const Icon(Icons.arrow_back_ios_new),
            ),
            title: Text(meetingTitle ?? 'Meeting'),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60.0),
              child: SizedBox(
                height: 70.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  // itemCount: participants.length,
                  itemCount: activeUsernames.length,
                  itemBuilder: (context, index) {
                    final username = activeUsernames[index];
                    final participant = participants[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black),
                        ),
                        child: CircleAvatar(
                          radius: 30.0,
                          backgroundColor: Colors.white,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              username,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            // child: CircleAvatar(
                            //   radius: 30.0,
                            //   backgroundColor: Colors.white,
                            //   child: FittedBox(
                            //     fit: BoxFit.scaleDown,
                            //     child: Text(
                            //       participant['user_name'] ?? 'User',
                            //       style: const TextStyle(
                            //         color: Colors.black,
                            //         fontSize: 12,
                            //       ),
                            //       textAlign: TextAlign.center,
                            //     ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          body: Column(
            children: [
              const Divider(
                height: 1,
                color: Colors.black,
                thickness: 1,
              ),
              const SizedBox(
                height: 10,
              ),
              // Expanded를 사용하여 스크롤 가능한 영역을 설정
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Agenda: $agenda',
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        const Text(
                          '회의 요약',
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.2,
                        ),
                        const Text(
                          '안건 추천',
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.2,
                        ),
                        const Text(
                          '결정 사항',
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // 녹음 버튼을 화면 하단에 고정
              if (meetingId.isNotEmpty && participantCount.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 25.0),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: child,
                      );
                    },
                    child: IconButton(
                      key: ValueKey<bool>(meetingNoteProvider.isRecording),
                      iconSize: 60.0,
                      icon: Icon(
                        meetingNoteProvider.isRecording
                            ? FontAwesomeIcons.circleStop
                            : FontAwesomeIcons.microphone,
                        color: meetingNoteProvider.isRecording
                            ? Colors.red
                            : Colors.black,
                      ),
                      tooltip:
                          meetingNoteProvider.isRecording ? '회의 종료' : '회의 시작',
                      onPressed: () {
                        if (meetingNoteProvider.isRecording) {
                          meetingNoteProvider.stopRecording();
                        } else {
                          meetingNoteProvider.startRecording();
                        }
                      },
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
