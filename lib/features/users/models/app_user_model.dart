class AppUserModel {
  final int id;
  final String fullName;
  final String username;
  final String password;
  final String role;
  final bool isActive;

  const AppUserModel({
    required this.id,
    required this.fullName,
    required this.username,
    required this.password,
    required this.role,
    required this.isActive,
  });

  AppUserModel copyWith({
    String? fullName,
    String? username,
    String? password,
    String? role,
    bool? isActive,
  }) {
    return AppUserModel(
      id: id,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      password: password ?? this.password,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
    );
  }
}
