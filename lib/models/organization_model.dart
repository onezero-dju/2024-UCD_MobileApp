class Organization {
  final int id;
  final String name;
  final String description;
  final String role;

  final DateTime joinedAt;

  Organization({
    required this.id,
    required this.name,
    required this.description,
    required this.role,
    required this.joinedAt,
  });

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      id: json['organizationId'], // 변경된 키
      name: json['organizationName'], // 변경된 키
      description: json['description'] ?? '',
      role: json['role'],
      joinedAt: DateTime.parse(json['joinedAt']),
    );
  }
}
