class AppUserModel {
  final int id;
  final String fullName;
  final String username;
  final String role;
  final bool isActive;

  const AppUserModel({
    required this.id,
    required this.fullName,
    required this.username,
    required this.role,
    required this.isActive,
  });

  AppUserModel copyWith({
    String? fullName,
    String? username,
    String? role,
    bool? isActive,
  }) {
    return AppUserModel(
      id: id,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
    );
  }
}
