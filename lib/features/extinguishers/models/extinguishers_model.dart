import 'package:new_project_fes/core/enums/entity_state.dart';
import 'package:new_project_fes/core/models/entity_base.dart';
import 'package:new_project_fes/core/widgets/app_date_utils.dart';

class ExtinguisherModel extends EntityBase {
  final int? id;
  final String serialNumber;
  final int typeId;
  final double capacity;
  final String? location;
  final int customerId;

  final DateTime? productionDate;
  final DateTime? lastServiceDate;
  final DateTime? nextServiceDate;

  final bool isActive;

  final List<int>? rowVersion;

  const ExtinguisherModel({
    this.id,
    required this.serialNumber,
    required this.typeId,
    required this.capacity,
    this.location,
    required this.customerId,
    this.productionDate,
    this.lastServiceDate,
    this.nextServiceDate,
    this.isActive = true,
    this.rowVersion,
    super.entityState,
  });

  ExtinguisherModel copyWith({
    int? id,
    String? serialNumber,
    int? typeId,
    double? capacity,
    String? location,
    int? customerId,
    DateTime? productionDate,
    DateTime? lastServiceDate,
    DateTime? nextServiceDate,
    bool? isActive,
    List<int>? rowVersion,
    EntityState? entityState,
  }) {
    return ExtinguisherModel(
      id: id ?? this.id,
      serialNumber: serialNumber ?? this.serialNumber,
      typeId: typeId ?? this.typeId,
      capacity: capacity ?? this.capacity,
      location: location ?? this.location,
      customerId: customerId ?? this.customerId,
      productionDate: productionDate ?? this.productionDate,
      lastServiceDate: lastServiceDate ?? this.lastServiceDate,
      nextServiceDate: nextServiceDate ?? this.nextServiceDate,
      isActive: isActive ?? this.isActive,
      rowVersion: rowVersion ?? this.rowVersion,
      entityState: entityState ?? this.entityState,
    );
  }

  Map<String, dynamic> toApiMap() {
    final map = <String, dynamic>{
      'serialNumber': serialNumber,
      'typeId': typeId,
      'capacity': capacity,
      'location': location,
      'customerId': customerId,
      'productionDate': AppDateUtils.toApiDate(productionDate),
      'lastServiceDate': AppDateUtils.toApiDate(lastServiceDate),
      'nextServiceDate': AppDateUtils.toApiDate(nextServiceDate),
      'isActive': isActive,
      'entityState': entityState.index,
    };

    if (id != null) {
      map['id'] = id;
    }

    if (rowVersion != null) {
      map['rowVersion'] = rowVersion;
    }

    return map;
  }

  factory ExtinguisherModel.fromMap(Map<String, dynamic> map) {
    return ExtinguisherModel(
      id: map['id'] as int?,
      serialNumber: map['serialNumber'] as String? ?? '',
      typeId: map['typeId'] as int? ?? 0,
      capacity: (map['capacity'] as num?)?.toDouble() ?? 0,
      location: map['location'] as String?,
      customerId: map['customerId'] as int? ?? 0,
      productionDate: _parseDate(map['productionDate']),
      lastServiceDate: _parseDate(map['lastServiceDate']),
      nextServiceDate: _parseDate(map['nextServiceDate']),
      isActive: map['isActive'] as bool? ?? true,
      rowVersion: _parseRowVersion(map['rowVersion']),
      entityState: EntityState.unchanged,
    );
  }

  static DateTime? _parseDate(dynamic value) {
    return AppDateUtils.fromApiDate(value);
  }

  static List<int>? _parseRowVersion(dynamic value) {
    if (value is List) {
      return value.whereType<num>().map((item) => item.toInt()).toList();
    }

    return null;
  }
}
