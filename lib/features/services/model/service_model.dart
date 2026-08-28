import 'package:new_project_fes/core/widgets/app_date_utils.dart';

class ServiceModel {
  int? id;

  int customerId;
  int extinguisherId;

  DateTime serviceDate;
  DateTime nextServiceDate;

  String? description;

  bool needsValve;
  bool needsGauge;
  bool needsPipe;
  bool needsPowder;
  bool needsHose;

  ServiceModel({
    this.id,
    required this.customerId,
    required this.extinguisherId,
    required this.serviceDate,
    required this.nextServiceDate,
    this.description,
    this.needsValve = false,
    this.needsGauge = false,
    this.needsPipe = false,
    this.needsPowder = false,
    this.needsHose = false,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'customerId': customerId,
      'extinguisherId': extinguisherId,
      'serviceDate': AppDateUtils.toApiDate(serviceDate),
      'nextServiceDate': AppDateUtils.toApiDate(nextServiceDate),
      'description': description,
      'needsValve': needsValve,
      'needsGauge': needsGauge,
      'needsPipe': needsPipe,
      'needsPowder': needsPowder,
      'needsHose': needsHose,
    };

    // فقط در حالت ویرایش ارسال می‌شود.
    if (id != null) {
      data['id'] = id;
    }

    return data;
  }

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      customerId: json['customerId'],
      extinguisherId: json['extinguisherId'],
      serviceDate: AppDateUtils.fromApiDate(json['serviceDate'])!,
      nextServiceDate: AppDateUtils.fromApiDate(json['nextServiceDate'])!,
      description: json['description'],
      needsValve: json['needsValve'] ?? false,
      needsGauge: json['needsGauge'] ?? false,
      needsPipe: json['needsPipe'] ?? false,
      needsPowder: json['needsPowder'] ?? false,
      needsHose: json['needsHose'] ?? false,
    );
  }
}
