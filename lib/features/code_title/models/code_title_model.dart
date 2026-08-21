class CodeTitleModel {
  final int id;
  final int code;
  final String title;
  final String latinTitle;
  final int categoryId;

  const CodeTitleModel({
    required this.id,
    required this.code,
    required this.title,
    required this.latinTitle,
    required this.categoryId,
  });

  factory CodeTitleModel.fromMap(Map<String, dynamic> map) {
    return CodeTitleModel(
      id: map['id'] as int? ?? 0,
      code: map['code'] as int? ?? 0,
      title: map['title'] as String? ?? '',
      latinTitle: map['latinTitle'] as String? ?? '',
      categoryId: map['categoryId'] as int? ?? 0,
    );
  }
}
