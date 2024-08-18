import 'package:flutter/material.dart';

class MeetingNoteViewModel with ChangeNotifier {
  Map<String, List<String>> meetingNotes = {}; // 각 카테고리에 대한 미팅 노트 목록

  void addNewMeetingNote(String categoryId, String note) {
    if (categoryId.isNotEmpty && note.isNotEmpty) {
      meetingNotes[categoryId] ??= [];
      meetingNotes[categoryId]!.add(note); // 현재 카테고리에 미팅 노트 추가
      notifyListeners();
    }
  }

  List<String> getMeetingNotes(String categoryId) {
    return meetingNotes[categoryId] ?? []; // 카테고리에 해당하는 미팅 노트 목록 반환
  }
}
