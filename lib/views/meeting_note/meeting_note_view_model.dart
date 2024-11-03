// lib/views/meeting_note/meeting_note_view_model.dart
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ucd/models/user_model.dart';

import 'package:ucd/services/meeting_note_service.dart';
import 'package:ucd/views/login/login_view_model.dart';

import '../../services/audio_service.dart';

class MeetingNoteViewModel with ChangeNotifier {
  final MeetingNoteService _meetingNoteService = MeetingNoteService();
  final AudioService _audioService = AudioService();

  Map<int, List<Map<String, dynamic>>> meetingNotes = {}; // 채널 ID에 대한 미팅 노트 목록
  String? selectedMeetingTitle;
  Map<String, dynamic>? selectedMeetingDetails;
  List<String> activeUsernames = []; // 실시간 참여 중인 사용자 리스트
  bool _isRecording = false;

  bool get isRecording => _isRecording;

  StreamSubscription<String>? _sseSubscription;
  List<Map<String, dynamic>> collaborationMessages = []; // 실시간 메시지 리스트

  bool _isInCollaborationRoom = false;
  bool get isInCollaborationRoom => _isInCollaborationRoom;
  MeetingNoteViewModel() {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await _audioService.initialize();
      notifyListeners();
    } catch (e) {
      // 에러 처리 (예: UI에 에러 메시지 전달)
      print(e);
    }
  }

  // 녹음 관련 메소드
  Future<void> startRecording() async {
    if (selectedMeetingDetails == null) return;
    String meetingId = selectedMeetingDetails!['id'];
    String participantCount =
        (selectedMeetingDetails!['participants'] as List).length.toString();

    _isRecording = true;
    print("녹음 시작: isRecording = $_isRecording");
    notifyListeners();

    await _audioService.startRecording(meetingId, participantCount,
        (filePath) async {
      await uploadRecording(filePath);
    });
  }

  Future<void> stopRecording() async {
    if (selectedMeetingDetails == null) return;
    String meetingId = selectedMeetingDetails!['id'];
    String participantCount =
        (selectedMeetingDetails!['participants'] as List).length.toString();

    _isRecording = false;
    print("녹음 종료: isRecording = $_isRecording");
    notifyListeners();

    await _audioService.stopRecording(meetingId, participantCount,
        (filePath) async {
      await uploadRecording(filePath);
    });
  }

  Future<void> playRecording() async {
    try {
      await _audioService.playRecording();
      notifyListeners();
    } catch (e) {
      // 에러 처리
      print(e);
    }
  }

  Future<void> uploadRecording(String filePath) async {
    try {
      await _audioService.uploadToFTP(filePath);
      notifyListeners();
    } catch (e) {
      // 에러 처리
      print(e);
    }
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }

  void setSelectedMeetingTitle(String title) {
    selectedMeetingTitle = title;
    notifyListeners();
  }

  Future<void> fetchMeetingNotes(int channelId) async {
    try {
      final fetchedMeetingNotes =
          await _meetingNoteService.fetchMeetingNotes(channelId);
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
    String? categoryName,
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

    final success = await _meetingNoteService.createMeetingNote(
      meetingTitle: meetingTitle,
      channelId: channelId,
      channelName: channelName,
      agenda: agenda,
      categoryId: categoryId,
      categoryName: categoryName,
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

  // 단일 회의 내용 열람
  Future<void> fetchMeetingDetails(String meetingId) async {
    try {
      final meetingDetails =
          await _meetingNoteService.fetchMeetingDetails(meetingId);
      if (meetingDetails != null) {
        selectedMeetingDetails = meetingDetails;

        notifyListeners();
        print("조회된 회의 내용: $selectedMeetingDetails");
      } else {
        print("회의 내용을 가져오는 데 실패했습니다.");
      }
    } catch (e) {
      print("Failed to fetch meeting details: $e");
    }
  }

  // 회의 참여 시 참여자 명단에 추가
  Future<void> addParticipant(String meetingId) async {
    try {
      await _meetingNoteService.addParticipant(meetingId);
      // 참가자 추가 후 다른 동작이 필요하면 여기에 추가
      print("참가자 추가 후 다른 작업을 진행합니다.");
    } catch (e) {
      print("Failed to add participant: $e");
    }
  }

  String? getMeetingIdByTitle(String meetingTitle) {
    for (var meetings in meetingNotes.values) {
      for (var meeting in meetings) {
        final meetingDtoList = meeting['meeting_dtolist'] ?? [];
        for (var meetingDto in meetingDtoList) {
          if (meetingDto['meeting_title'] == meetingTitle) {
            return meetingDto['meeting_id'];
          }
        }
      }
    }
    return null;
  }

  // 실시간 협업 방 참여 메서드
  Future<void> joinCollaborationRoom(String meetingId) async {
    _isInCollaborationRoom = true;
    notifyListeners();

    final sseStream = _meetingNoteService.joinCollaborationRoom(meetingId);
    if (sseStream != null) {
      _sseSubscription = sseStream.listen((event) {
        try {
          // 수신된 JSON 데이터를 파싱하여 현재 참여자 리스트에 추가
          final jsonData = jsonDecode(event);
          final username = jsonData["username"];

          // 중복된 사용자 이름이 없을 경우에만 추가
          if (!activeUsernames.contains(username)) {
            activeUsernames.add(username);
            notifyListeners(); // UI 갱신
          }
        } catch (e) {
          print("Error parsing event: $e");
        }
      }, onError: (error) {
        print("Error in SSE connection: $error");
      });
    }
  }

  // SSE 연결 종료
  void leaveCollaborationRoom() {
    _sseSubscription?.cancel();
    _sseSubscription = null;
    _isInCollaborationRoom = false;
    activeUsernames.clear(); // 연결 종료 시 리스트 초기화
    notifyListeners();
  }
}
