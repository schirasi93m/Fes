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
      'serviceDate': serviceDate.toIso8601String(),
      'nextServiceDate': nextServiceDate.toIso8601String(),
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
      serviceDate: DateTime.parse(json['serviceDate']),
      nextServiceDate: DateTime.parse(json['nextServiceDate']),
      description: json['description'],
      needsValve: json['needsValve'] ?? false,
      needsGauge: json['needsGauge'] ?? false,
      needsPipe: json['needsPipe'] ?? false,
      needsPowder: json['needsPowder'] ?? false,
      needsHose: json['needsHose'] ?? false,
    );
  }
}
