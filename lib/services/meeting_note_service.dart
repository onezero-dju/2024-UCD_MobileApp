import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ucd/services/token_service.dart';

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
        final String decodeBody = utf8.decode(response.bodyBytes);

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
}