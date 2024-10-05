class UserModel {
  final int? userId;
  final String email;
  final String password;
  final String? username;
  final String? role;
  final String? createdAt;
  final String? updatedAt;

  UserModel({
    this.userId,
    required this.email,
    required this.password,
    this.username,
    this.role,
    this.createdAt,
    this.updatedAt,
  });

  // JSON 데이터를 받아서 UserModel 객체로 변환하는 factory constructor
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'],
      email: json['email'],
      password: json['password'],
      username: json['username'],
      role: json['role'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  // UserModel 객체를 JSON 형태로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'email': email,
      'password': password,
      'username': username,
      'role': role,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
