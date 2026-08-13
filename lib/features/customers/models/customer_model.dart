import 'package:new_project_fes/core/enums/entity_state.dart';

class CustomerModel {
  final int? id;
  final String fullName;
  final String phone;
  final String address;
  final bool isActive;
  final EntityState entityState;

  const CustomerModel({
    this.id,
    required this.fullName,
    required this.phone,
    required this.address,
    this.isActive = true,
    this.entityState = EntityState.inserted,
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
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      isActive: isActive ?? this.isActive,
      entityState: entityState ?? this.entityState,
    );
  }

  // اطلاعات مورد نیاز API
  Map<String, dynamic> toApiMap() {
    final map = <String, dynamic>{
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

  // فقط برای استفاده محلی Flutter
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'phone': phone,
      'address': address,
      'isActive': isActive,
      'entityState': entityState.index,
    };
  }

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    final entityStateIndex = map['entityState'] as int?;

    return CustomerModel(
      id: map['id'] as int?,
      fullName: map['fullName'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      address: map['address'] as String? ?? '',
      isActive: map['isActive'] as bool? ?? true,
      entityState:
          entityStateIndex != null &&
              entityStateIndex >= 0 &&
              entityStateIndex < EntityState.values.length
          ? EntityState.values[entityStateIndex]
          : EntityState.unchanged,
    );
  }
}
