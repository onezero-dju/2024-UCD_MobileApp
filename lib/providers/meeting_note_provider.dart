import 'package:flutter/material.dart';

class MeetingNoteProvider with ChangeNotifier {
  Map<String, List<String>> meetingNotes = {};

  String? selectedCategory;
  String? selectedMeetingNote;
  void addNewMeetingNote(String categoryId, String note) {
    meetingNotes[categoryId] ??= [];
    meetingNotes[categoryId]!.add(note);
    notifyListeners();
  }

  List<String> getMeetingNotes(String categoryId) {
    return meetingNotes[categoryId] ?? [];
  }

  void selectCategory(String categoryId) {
    selectedCategory = categoryId;
    notifyListeners();
  }

  void selectMeetingNote(String note) {
    selectedMeetingNote = note;
    notifyListeners();
  }
}
