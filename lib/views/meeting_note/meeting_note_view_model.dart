import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ucd/models/user_model.dart';
import 'package:ucd/services/meeting_note_service.dart';
import 'package:ucd/views/channel/channel_view_model.dart';
import 'package:ucd/views/login/login_view_model.dart';

class MeetingNoteViewModel with ChangeNotifier {
  final MeetingNoteService _meetingNoteService = MeetingNoteService();

  Map<int, List<Map<String, dynamic>>> meetingNotes = {}; // 채널 ID에 대한 미팅 노트 목록

  Future<void> fetchMeetingNotes(int channelId) async {
    try {
      final fetchedMeetingNotes = await _meetingNoteService.fetchMeetingNotes(channelId);
      meetingNotes[channelId] = fetchedMeetingNotes;
      print("조회된 meetingnote는: ${meetingNotes[channelId]}");
      notifyListeners();
    } catch (e) {
      print('Failed to fetch meeting notes: $e');
    }
  }

    Future<void> createMeetingNote({
    required String meetingTitle,
    required int channelId,
    String? agenda,
    int? categoryId,
    required String channelName,
    required BuildContext context,
  }) async {
    // Consumer를 사용해 LoginViewModel의 최신 상태를 가져옵니다.
      final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
      final loggedInUser = await loginViewModel.fetchUserInfo();
      if (loggedInUser == null) {
        print("로그인된 사용자 정보가 없습니다.");
        return;
      }
      else{
        print('dd');
      }

    final success = await _meetingNoteService.createMeetingNote(
      meetingTitle: meetingTitle,
      channelId: channelId,
      channelName: channelName,
      agenda: agenda,
      categoryId: categoryId,
      categoryName: categoryId != null ? "카테고리 이름" : null,
    );

    if (success) {
      meetingNotes[channelId] ??= [];
      meetingNotes[channelId]!.add({
        "meetingTitle": meetingTitle,
        "categoryId": categoryId,
      });
      notifyListeners();
    }
  }

}
