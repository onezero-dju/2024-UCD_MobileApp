class Channel {
  final int channelId;  // 채널 ID
  final DateTime createdAt;  // 생성 날짜
  final String description;  // 설명
  final String name;  // 채널 이름
  final int organizationId;  // 조직 ID
  final DateTime updatedAt;  // 업데이트 날짜

  // 생성자
  Channel({
    required this.channelId,
    required this.createdAt,
    required this.description,
    required this.name,
    required this.organizationId,
    required this.updatedAt,
  });                                           

  // JSON 데이터를 객체로 변환하는 팩토리 메서드
  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      channelId: json['channel_id'],
      createdAt: DateTime.parse(json['created_at']),
      description: json['description'],
      name: json['name'],
      organizationId: json['organization_id'],
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // 객체를 JSON 형식으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'channel_id': channelId,
      'created_at': createdAt.toIso8601String(),
      'description': description,
      'name': name,
      'organization_id': organizationId,
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
