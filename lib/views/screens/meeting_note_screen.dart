import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ucd/providers/meeting_note_provider.dart';

class MeetingNoteScreen extends StatelessWidget {
  final String categoryId;

  const MeetingNoteScreen({super.key, required this.categoryId});

  void _addNewMeetingNote(BuildContext context) {
    final meetingNoteProvider =
        Provider.of<MeetingNoteProvider>(context, listen: false);
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
    final meetingNotes =
        Provider.of<MeetingNoteProvider>(context).getMeetingNotes(categoryId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Meeting Notes",
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.w500,
              ),
            ),
            IconButton(
              onPressed: () => _addNewMeetingNote(context),
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
        if (meetingNotes.isEmpty)
          Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.02),
            child: const Text("아직 Meeting Note가 없습니다."),
          )
        else
          ...meetingNotes.map((note) => Padding(
                padding: EdgeInsets.only(
                  top: screenHeight * 0.01,
                ),
                child: Container(
                  width: screenWidth * 0.8,
                  padding: EdgeInsets.all(screenWidth * 0.02),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: Colors.black,
                      width: screenWidth * 0.005,
                    ),
                  ),
                  child: Text(
                    note,
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                    ),
                  ),
                ),
              ))
      ],
    );
  }
}
