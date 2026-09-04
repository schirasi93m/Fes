class LoginResponseModel {
  final int id;
  final String fullName;
  final String username;
  final String role;

  const LoginResponseModel({
    required this.id,
    required this.fullName,
    required this.username,
    required this.role,
  });

  factory LoginResponseModel.fromMap(Map<String, dynamic> map) {
    return LoginResponseModel(
      id: map['id'] as int? ?? 0,
      fullName: map['fullName'] as String? ?? '',
      username: map['username'] as String? ?? '',
      role: map['role'] as String? ?? '',
    );
  }
}
