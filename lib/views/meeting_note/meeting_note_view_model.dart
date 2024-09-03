import 'package:flutter/material.dart';

class MeetingNoteViewModel with ChangeNotifier {
  Map<String, List<String>> meetingNotes =
      {}; // 카테고리 ID를 키로 하고, 미팅 노트 리스트를 값으로 가짐
  String? selectedMeetingNote; // 선택된 미팅 노트

  // 미팅 노트 추가 메서드
  void addNewMeetingNote(String categoryId, String note) {
    meetingNotes[categoryId] ??= [];
    meetingNotes[categoryId]!.add(note);
    notifyListeners();
  }

  // 미팅 노트 선택 메서드
  void selectMeetingNote(String note) {
    selectedMeetingNote = note;
    notifyListeners();
  }

  // 미팅 노트 리스트 반환 메서드
  List<String> getMeetingNotes(String categoryId) {
    return meetingNotes[categoryId] ?? [];
  }

  // 선택된 미팅 노트 반환 메서드
  String? get selectedNote => selectedMeetingNote;
}
