class CustomerModel {
  final int? id;
  final String fullName;
  final String phone;
  final String address;
  final bool isActive;

  const CustomerModel({
    this.id,
    required this.fullName,
    required this.phone,
    required this.address,
    this.isActive = true,
  });

  CustomerModel copyWith({
    int? id,
    String? fullName,
    String? phone,
    String? address,
    bool? isActive,
  }) {
    return CustomerModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'phone': phone,
      'address': address,
      'isActive': isActive,
    };
  }

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      id: map['id'] as int?,
      fullName: map['fullName'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
      isActive: map['isActive'] ?? true,
    );
  }
}