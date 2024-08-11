class Organization {
  final int id;
  final String name;
  final String role;
  final DateTime joinedAt;

  Organization({
    required this.id,
    required this.name,
    required this.role,
    required this.joinedAt,
  });

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      id: json['organization_id'],
      name: json['organization_name'],
      role: json['user_role'],
      joinedAt: DateTime.parse(json['joined_date']),
    );
  }
}
