import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ucd/services/token_service.dart';


class ChannelService {
  // 채널 생성 메서드
  Future<bool> addNewChannel(
    
      String organizationId, String channelName, String channelDescription, String token) async {
    final String apiUrl = 'http://34.64.165.164:8080/api/organizations/$organizationId/channels';
 
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "name": channelName,
        "description": channelDescription,
      }),
    );

    if (response.statusCode == 201) {
      print('Channel created successfully!');
      return true;
    } else {
      print('Failed to create channel with status: ${response.statusCode}');
      return false;
    }
  }

  // 조직 내 채널 목록 조회 메서드
  Future<List<Map<String, dynamic>>> getChannels(
      String organizationId) async {
        final token = await getToken();
    final String apiUrl = 'http://34.64.165.164:8080/api/organizations/$organizationId/channels';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print('Fetched channels successfully');
      print(List<Map<String, dynamic>>.from(jsonDecode(response.body)['data']));
      return List<Map<String, dynamic>>.from(jsonDecode(response.body)['data']);
    } else {
      print('Failed to fetch ㅇchannels with status: ${response.statusCode}');
      throw Exception('Failed to load channels');
    }
  }
}
