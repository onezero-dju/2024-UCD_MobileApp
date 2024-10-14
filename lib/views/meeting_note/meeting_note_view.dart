// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:ucd/views/organization/organization_view_model.dart';
// import 'package:ucd/views/channel/channel_view_model.dart';
// import 'package:ucd/views/category/category_view_model.dart';
// import 'package:ucd/views/meeting_note/meeting_note_view_model.dart';

// class MeetingNoteScreen extends StatefulWidget {
//   const MeetingNoteScreen({super.key});

//   @override
//   _MeetingNoteScreenState createState() => _MeetingNoteScreenState();
// }

// class _MeetingNoteScreenState extends State<MeetingNoteScreen> {
//   bool isMeetingStarted = false;

//   @override
//   Widget build(BuildContext context) {
//     final selectedNote =
//         Provider.of<MeetingNoteViewModel>(context).selectedNote;

//     return Consumer4<OrganizationViewModel, ChannelViewModel, CategoryViewModel,
//         MeetingNoteViewModel>(
//       builder: (context, organizationProvider, channelProvider,
//           categoryProvider, meetingNoteProvider, child) {
//         final selectedChannel = channelProvider.selectedChannel;
//         final selectedCategory = categoryProvider.selectedCategory;

//         return Scaffold(
//           appBar: AppBar(
//             title: selectedNote != null
//                 ? Text(
//                     selectedNote,
//                     style: const TextStyle(fontSize: 24),
//                   )
//                 : const Center(
//                     child: Text(
//                       '제목 없음',
//                       style:
//                           TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
//                     ),
//                   ),
//           ),
//           body: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 IconButton(
//                   icon: const Icon(
//                     Icons.mic,
//                     size: 100,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       isMeetingStarted = true;
//                     });

//                     if (selectedNote != null) {
//                       print('회의 시작');

//                       print('채널: $selectedChannel');
//                       print('카테고리: $selectedCategory');
//                       print('회의 노트: $selectedNote');
//                     } else {
//                       print('회의 노트가 선택되지 않았습니다.');
//                     }
//                   },
//                 ),
//                 if (isMeetingStarted)
//                   const Padding(
//                     padding: EdgeInsets.only(top: 20),
//                     child: Text(
//                       '실시간 협업 공간 webview 작동중',
//                       style:
//                           TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     ElevatedButton(
//                         onPressed: () {
//                           setState(() {
//                             isMeetingStarted = false;
//                           });
//                         },
//                         child: const Text(
//                           '회의 종료',
//                           style: TextStyle(
//                               fontSize: 24, fontWeight: FontWeight.bold),
//                         )),
//                   ],
//                 )
//               ],
//             ),
//           ),
//           floatingActionButton: FloatingActionButton(
//             onPressed: () {},
//             child: const Text(
//               '요약',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:ucd/views/meeting_note/meeting_note_view_model.dart';

// class MeetingNoteView extends StatelessWidget {
//   final int channelId;
//   final int? categoryId;

//   const MeetingNoteView({Key? key, required this.channelId, this.categoryId}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<MeetingNoteViewModel>(
//       builder: (context, meetingNoteProvider, child) {
//         final meetingNotes = categoryId != null
//             ? meetingNoteProvider.meetingNotes[categoryId] ?? []
//             : meetingNoteProvider.channelMeetingNotes;

//         return Scaffold(
//           appBar: AppBar(
//             title: Text(categoryId != null ? '카테고리 미팅 노트' : '채널 미팅 노트'),
//             actions: [
//               IconButton(
//                 icon: const Icon(Icons.add),
//                 onPressed: () => _showAddMeetingNoteDialog(context),
//               ),
//             ],
//           ),
//           body: ListView.builder(
//             itemCount: meetingNotes.length,
//             itemBuilder: (context, index) {
//               final note = meetingNotes[index];
//               return ListTile(
//                 title: Text(note),
//                 onTap: () {
//                   // Handle meeting note tap
//                 },
//               );
//             },
//           ),
//         );
//       },
//     );
//   }

//   void _showAddMeetingNoteDialog(BuildContext context) {
//     String meetingTitle = "";
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("새로운 미팅 노트 추가"),
//           content: TextField(
//             onChanged: (value) {
//               meetingTitle = value;
//             },
//             decoration: const InputDecoration(hintText: "미팅 노트 제목을 입력하세요"),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text("취소"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: const Text("추가"),
//               onPressed: () {
//                 if (meetingTitle.isNotEmpty) {
//                   Provider.of<MeetingNoteViewModel>(context, listen: false)
//                       .createMeetingNote(
//                     meetingTitle: meetingTitle,
//                     channelId: channelId,
//                     channelName: "Channel Name", // Replace with actual channel name
//                     categoryId: categoryId,
//                   );
//                   Navigator.of(context).pop();
//                 }
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:ucd/views/category/category_view_model.dart';
// import 'package:ucd/views/meeting_note/meeting_note_view_model.dart';


// class MeetingNoteView extends StatefulWidget {
//   final int channelId;

//   const MeetingNoteView({Key? key, required this.channelId}) : super(key: key);

//   @override
//   _MeetingNoteViewState createState() => _MeetingNoteViewState();
// }

// class _MeetingNoteViewState extends State<MeetingNoteView> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final meetingNoteProvider = Provider.of<MeetingNoteViewModel>(context, listen: false);
//       meetingNoteProvider.fetchMeetingNotes(widget.channelId);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<MeetingNoteViewModel>(
//       builder: (context, meetingNoteProvider, child) {
//         final meetingNotes = meetingNoteProvider.meetingNotes[widget.channelId] ?? [];

//         return Scaffold(
//           appBar: AppBar(
//             title: const Text('회의 노트'),
//             actions: [
//               IconButton(
//                 icon: const Icon(Icons.add),
//                 onPressed: () => _showAddMeetingNoteDialog(context, meetingNoteProvider),
//               ),
//             ],
//           ),
//           body: meetingNotes.isEmpty
//               ? const Center(child: Text("회의 노트가 없습니다. 회의를 추가하세요."))
//               : ListView.builder(
//                   itemCount: meetingNotes.length,
//                   itemBuilder: (context, index) {
//                     final note = meetingNotes[index];
//                     return ListTile(
//                       title: Text(note["meetingTitle"] ?? "회의 제목 없음"),
//                       onTap: () {
//                         // Handle meeting note tap
//                       },
//                     );
//                   },
//                 ),
//         );
//       },
//     );
//   }

//   void _showAddMeetingNoteDialog(BuildContext context, MeetingNoteViewModel meetingNoteProvider) {
//     String meetingTitle = "";
//     int? selectedCategory;
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("새로운 회의 노트 추가"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 onChanged: (value) {
//                   meetingTitle = value;
//                 },
//                 decoration: const InputDecoration(hintText: "회의 제목을 입력하세요"),
//               ),
//               DropdownButtonFormField<int>(
//                 value: selectedCategory,
//                 items: [
//                   DropdownMenuItem(value: null, child: Text("카테고리 선택 안함")),
//                   // Example: Load categories from provider
//                   ...Provider.of<CategoryViewModel>(context, listen: false)
//                       .categories[widget.channelId]?.map((category) {
//                     return DropdownMenuItem(
//                       value: category["category_id"],
//                       child: Text(category["name"] ?? "카테고리 이름 없음"),
//                     );
//                   }) ?? []
//                 ],
//                 onChanged: (value) {
//                   setState(() {
//                     selectedCategory = value;
//                   });
//                 },
//                 decoration: const InputDecoration(hintText: "카테고리를 선택하세요"),
//               ),
//             ],
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text("취소"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: const Text("추가"),
//               onPressed: () {
//                 if (meetingTitle.isNotEmpty) {
//                   meetingNoteProvider.createMeetingNote(
//                     meetingTitle: meetingTitle,
//                     channelId: widget.channelId,
//                     categoryId: selectedCategory,
//                   );
//                   Navigator.of(context).pop();
//                 }
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
// class MeetingNoteView extends StatelessWidget {
//   final int channelId;

//   const MeetingNoteView({Key? key, required this.channelId}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<MeetingNoteViewModel>(
//       builder: (context, meetingNoteProvider, child) {
//         final meetingNotes = meetingNoteProvider.channelMeetingNotes[channelId] ?? [];

//         return Scaffold(
//           appBar: AppBar(
//             title: const Text('채널 미팅 노트'),
//             actions: [
//               IconButton(
//                 icon: const Icon(Icons.add),
//                 onPressed: () => _showAddMeetingNoteDialog(context),
//               ),
//             ],
//           ),
//           body: ListView.builder(
//             itemCount: meetingNotes.length,
//             itemBuilder: (context, index) {
//               final note = meetingNotes[index];
//               return ListTile(
//                 title: Text(note),
//                 onTap: () {
//                   // Handle meeting note tap
//                 },
//               );
//             },
//           ),
//         );
//       },
//     );
//   }

//   void _showAddMeetingNoteDialog(BuildContext context) {
//     String meetingTitle = "";
//     String agenda = "";
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("새로운 미팅 노트 추가"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 onChanged: (value) {
//                   meetingTitle = value;
//                 },
//                 decoration: const InputDecoration(hintText: "미팅 노트 제목을 입력하세요"),
//               ),
//               TextField(
//                 onChanged: (value) {
//                   agenda = value;
//                 },
//                 decoration: const InputDecoration(hintText: "회의 안건을 입력하세요"),
//               ),
//             ],
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text("취소"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: const Text("추가"),
//               onPressed: () {
//                 if (meetingTitle.isNotEmpty) {
//                   Provider.of<MeetingNoteViewModel>(context, listen: false).createMeetingNote(
//                     meetingTitle: meetingTitle,
//                     channelId: channelId,
//                     agenda: [agenda],
//                   );
//                   Navigator.of(context).pop();
//                 }
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
