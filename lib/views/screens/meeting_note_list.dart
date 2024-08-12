import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ucd/providers/meeting_note_provider.dart';
import 'package:ucd/views/screens/meeting_screen.dart';

class MeetingNoteScreen extends StatelessWidget {
  const MeetingNoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    final selectedCategory =
        Provider.of<MeetingNoteProvider>(context).selectedCategory;

    return selectedCategory == null
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: Provider.of<MeetingNoteProvider>(context)
                .getMeetingNotes(selectedCategory)
                .map((note) => Padding(
                      padding: EdgeInsets.only(top: screenHeight * 0.02),
                      child: GestureDetector(
                        onTap: () {
                          Provider.of<MeetingNoteProvider>(context,
                                  listen: false)
                              .selectMeetingNote(note);

                          // MeetingScreen으로 이동
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MeetingNoteScreen(),
                            ),
                          );
                        },
                        child: Container(
                          width: screenWidth * 0.6,
                          padding: EdgeInsets.all(screenWidth * 0.02),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                                color: Colors.black,
                                width: screenWidth * 0.005),
                          ),
                          child: Text(
                            note,
                            style: TextStyle(fontSize: screenWidth * 0.045),
                          ),
                        ),
                      ),
                    ))
                .toList(),
          );
  }
}
