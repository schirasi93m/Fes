import 'package:new_project_fes/core/enums/entity_state.dart';
import 'package:new_project_fes/core/models/entity_base.dart';

class AppUserModel extends EntityBase {
  final int? id;
  final String fullName;
  final String username;
  final String password;
  final String role;
  final bool isActive;

  const AppUserModel({
    this.id,
    required this.fullName,
    required this.username,
    this.password = '',
    required this.role,
    this.isActive = true,
    super.entityState,
  });

  AppUserModel copyWith({
    int? id,
    String? fullName,
    String? username,
    String? password,
    String? role,
    bool? isActive,
    EntityState? entityState,
  }) {
    return AppUserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      password: password ?? this.password,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      entityState: entityState ?? this.entityState,
    );
  }

  /// اطلاعات مورد نیاز برای ایجاد کاربر
  Map<String, dynamic> toCreateApiMap() {
    return {
      'fullName': fullName,
      'username': username,
      'password': password,
      'role': role,
      'isActive': isActive,
    };
  }

  /// اطلاعات مورد نیاز برای ویرایش کاربر
  ///
  /// اگر password خالی باشد، اصلاً ارسال نمی‌شود.
  /// در این حالت Backend رمز قبلی را حفظ می‌کند.
  Map<String, dynamic> toUpdateApiMap() {
    final map = <String, dynamic>{
      'fullName': fullName,
      'username': username,
      'role': role,
      'isActive': isActive,
    };

    if (password.trim().isNotEmpty) {
      map['password'] = password.trim();
    }

    return map;
  }

  /// این متد را فعلاً برای سازگاری با کدهای قبلی نگه می‌داریم.
  ///
  /// در ایجاد کاربر استفاده می‌شود.
  Map<String, dynamic> toApiMap() {
    return toCreateApiMap();
  }

  factory AppUserModel.fromMap(Map<String, dynamic> map) {
    return AppUserModel(
      id: map['id'] as int?,
      fullName: map['fullName'] as String? ?? '',
      username: map['username'] as String? ?? '',

      // Backend عمداً Password را برنمی‌گرداند.
      // بنابراین در دریافت اطلاعات از API خالی است.
      password: map['password'] as String? ?? '',

      role: map['role'] as String? ?? '',
      isActive: map['isActive'] as bool? ?? true,
      entityState: EntityState.unchanged,
    );
  }
}
