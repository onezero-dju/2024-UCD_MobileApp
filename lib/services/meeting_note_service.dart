import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ucd/util/router/token_shared_preferences.dart';

class MeetingNoteService {
  final String baseUrl = "http://34.64.241.110:8080";

  Future<bool> createMeetingNote({
    required String meetingTitle,
    required int channelId,
    required String channelName,
    int? categoryId,
    String? categoryName,
    String? agenda,
  }) async {
    final String apiUrl = "$baseUrl/api/meetings/create";
    final token = await getToken();

    if (token == null) {
      print("Token is null");
      return false;
    }
    print(meetingTitle);
    print(channelId);
    print(channelName);
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "meeting_title": meetingTitle,
          "channel_id": channelId,
          "channel_name": channelName,
          if (categoryId != null) "category_id": categoryId,
          if (categoryName != null) "category_name": categoryName,
          if (agenda != null) "agenda": agenda,
        }),
      );
      fetchMeetingNotes(channelId);
      if (response.statusCode == 201) {
        print("Meeting note created successfully");
        return true;
      } else {
        print("Failed to create meeting note: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error occurred while creating meeting note: $e");
      return false;
    }
  }

  //채널 내 회의 조회, 카테고리 화면에서 회의 목록 보는 api
  Future<List<Map<String, dynamic>>> fetchMeetingNotes(int channelId) async {
    final String apiUrl = "$baseUrl/api/meetings/by_channel/$channelId";
    final token = await getToken();
    print(apiUrl);
    if (token == null) {
      print("Token is null");
      return [];
    }

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print("Fetched meeting notes successfully");
        print(response);
        final String decodeBody = utf8.decode(response.bodyBytes);
        print("decodebody: $decodeBody");
        return List<Map<String, dynamic>>.from(jsonDecode(decodeBody));
      } else {
        print("Failed to fetch meeting notes: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error occurred while fetching meeting notes: $e");
      return [];
    }
  }

  //단일 회의 내용 열람
  // 단일 회의 내용 열람
  Future<Map<String, dynamic>?> fetchMeetingDetails(String meetingId) async {
    final String apiUrl = "$baseUrl/api/meetings/$meetingId/view";
    print(apiUrl);
    final token = await getToken();

    if (token == null) {
      print("Token is null");
      return null;
    }

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print("Fetched meeting details successfully");
        final String decodeBody = utf8.decode(response.bodyBytes);
        print(jsonDecode(decodeBody) as Map<String, dynamic>);
        return jsonDecode(decodeBody) as Map<String, dynamic>;
      } else {
        print("Failed to fetch meeting details: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error occurred while fetching meeting details: $e");
      return null;
    }
  }

  //회의 참여 시 참여자 명단에 추가

  Future<void> addParticipant(String meetingId) async {
    final url = Uri.parse('$baseUrl/api/meetings/$meetingId/add_participant');
    final token = await getToken();
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print("회의 참여 시 참여자 명단에 추가 response.statusCode: ${response.statusCode}");
      if (response.statusCode == 200) {
        // 성공적으로 참가자 추가됨

        print('Participant added successfully.');
        // 추가적인 로직이 필요하다면 여기에 작성
      } else {
        // 에러 처리
        print('Failed to add participant. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // 예외 처리
      print('Error occurred while adding participant: $e');
    }
  }

  // 실시간 협업 방 참여 메서드
  // SSE를 이용해 실시간 협업 방에 참여하는 스트림
  Stream<String>? joinCollaborationRoom(String meetingId) async* {
    final String apiUrl = "$baseUrl/sse/$meetingId";
    final token = await getToken();

    if (token == null) {
      print("Token is null");
      return;
    }

    final request = http.Request('GET', Uri.parse(apiUrl));
    request.headers.addAll({
      'Accept': 'text/event-stream',
      'Authorization': 'Bearer $token',
    });

    // 요청을 보내고 응답을 Stream 형식으로 수신
    final response = await http.Client().send(request);
    print("협업방 statuscode: ${response.statusCode}");
    // 스트리밍 데이터 읽기
    await for (var event in response.stream.transform(utf8.decoder)) {
      yield event;
    }
  }
}
