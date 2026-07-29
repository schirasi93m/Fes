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
    return CustomerModel(
      id: map['id'] as int?,
      fullName: map['fullName'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
      isActive: map['isActive'] ?? true,
      entityState:
          EntityState.values[map['entityState'] ?? EntityState.unchanged.index],
    );
  }
}
