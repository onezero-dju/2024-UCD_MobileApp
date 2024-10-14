
class MeetingNoteModel {
  final String id;
  final int channelId;
  final String channelName;
  final int? categoryId; // Nullable
  final String? categoryName; // Nullable
  final String meetingTitle;
  final DateTime createdAt;
  final DateTime editedAt;
  final List<Participant> participants;
  final String? agenda; // Nullable

  MeetingNoteModel({
    required this.id,
    required this.channelId,
    required this.channelName,
    this.categoryId,
    this.categoryName,
    required this.meetingTitle,
    required this.createdAt,
    required this.editedAt,
    required this.participants,
    this.agenda,
  });

  factory MeetingNoteModel.fromJson(Map<String, dynamic> json) {
    return MeetingNoteModel(
      id: json['_id'] as String,
      channelId: json['channel_id'] as int,
      channelName: json['channel_name'] as String,
      categoryId: json['category_id'] as int?,
      categoryName: json['category_name'] as String?,
      meetingTitle: json['meeting_title'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      editedAt: DateTime.parse(json['edited_at'] as String),
      participants: (json['participants'] as List<dynamic>)
          .map((participant) => Participant.fromJson(participant))
          .toList(),
      agenda: json['agenda'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'channel_id': channelId,
      'channel_name': channelName,
      'category_id': categoryId,
      'category_name': categoryName,
      'meeting_title': meetingTitle,
      'created_at': createdAt.toIso8601String(),
      'edited_at': editedAt.toIso8601String(),
      'participants': participants.map((participant) => participant.toJson()).toList(),
      'agenda': agenda,
    };
  }
}

class Participant {
  final int userId;
  final String userName;

  Participant({
    required this.userId,
    required this.userName,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      userId: json['user_id'] as int,
      userName: json['user_name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_name': userName,
    };
  }
}
