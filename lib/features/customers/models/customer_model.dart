import 'package:new_project_fes/core/enums/entity_state.dart';
import 'package:new_project_fes/core/models/entity_base.dart';

class CustomerModel extends EntityBase {
  final int? id;
  final int code;
  final String fullName;
  final String phone;
  final String address;
  final bool isActive;

  const CustomerModel({
    this.id,
    required this.code,
    required this.fullName,
    required this.phone,
    required this.address,
    this.isActive = true,
    super.entityState,
  });

  CustomerModel copyWith({
    int? id,
    String? fullName,
    String? phone,
    String? address,
    bool? isActive,
    EntityState? entityState,
  }) {
    return CustomerModel(
      id: id ?? this.id,
      code: code,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      isActive: isActive ?? this.isActive,
      entityState: entityState ?? this.entityState,
    );
  }

  Map<String, dynamic> toApiMap() {
    final map = <String, dynamic>{
      'code': code,
      'fullName': fullName,
      'phone': phone,
      'address': address,
      'isActive': isActive,
    };

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      id: map['id'] as int?,
      code: map['code']as int,
      fullName: map['fullName'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      address: map['address'] as String? ?? '',
      isActive: map['isActive'] as bool? ?? true,

      // چون API وضعیت EntityState را نمی‌فرستد،
      // داده دریافتی از سرور را فعلاً Unchanged در نظر می‌گیریم.
      entityState: EntityState.unchanged,
    );
  }
}