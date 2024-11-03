class Organization {
  final int id;
  final String name;
  final String description;
  final String role;
//   //   final String createdAt;
//   // final String updatedAt;
  final DateTime joinedAt;

  Organization({
    required this.id,
    required this.name,
    required this.description,
    required this.role,
    required this.joinedAt,
    //     // required this.createdAt, 
//     // required this.updatedAt, 
  });

factory Organization.fromJson(Map<String, dynamic> json) {
  final id = json['organization_id'] ?? json['organizationId'];
  final name = json['organization_name'] ?? json['organizationName'];

  if (id == null) {
    throw Exception('organization_id 또는 organizationId가 없습니다.');
  }

  if (name == null) {
    throw Exception('organization_name 또는 organizationName이 없습니다.');
  }

  return Organization(
    id: id is int ? id : int.parse(id.toString()),
    name: name,
    description: json['description'] ?? '',
    role: json['role'] ?? '',
   joinedAt: json['joinedAt'] != null ? DateTime.parse(json['joinedAt']) : DateTime.now(),
  );
}
}


// class Organization {
//   final int id;
//   final String name;
//   final String description;
//   final String role;
//   //   final String createdAt;
//   // final String updatedAt;


//   Organization({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.role,
//     // required this.createdAt, 
//     // required this.updatedAt, 
//   });

//   factory Organization.fromJson(Map<String, dynamic> json) {
//     return Organization(
//       id: json['organization_id'], // 변경된 키
//       name: json['organization_name'], // 변경된 키
//       description: json['description'] ?? '',
//       role: json['role'],
//       // createdAt: json['created_at'],
//       // updatedAt: json['updated_at'],
//     );
//   }
// }
