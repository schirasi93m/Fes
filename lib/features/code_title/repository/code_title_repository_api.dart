import '../../../core/network/api_client.dart';
import '../models/code_title_model.dart';
import 'code_title_repository.dart';

class CodeTitleRepositoryApi implements CodeTitleRepository {
  final ApiClient _apiClient;

  CodeTitleRepositoryApi(this._apiClient);

  @override
  Future<List<CodeTitleModel>> getList() async {
    final response = await _apiClient.dio.get('/CodeTitle');

    final data = response.data;

    if (data is! List) {
      throw Exception('فرمت پاسخ لیست کد عنوان‌ها نامعتبر است.');
    }

    return data
        .map(
          (item) =>
              CodeTitleModel.fromMap(Map<String, dynamic>.from(item as Map)),
        )
        .toList();
  }

  @override
  Future<List<CodeTitleModel>> getByCategoryId(int categoryId) async {
    if (categoryId <= 0) {
      throw Exception('شناسه دسته‌بندی نامعتبر است.');
    }

    final response = await _apiClient.dio.get(
      '/CodeTitle/category/$categoryId',
    );

    final data = response.data;

    if (data is! List) {
      throw Exception('فرمت پاسخ کد عنوان‌های دسته‌بندی نامعتبر است.');
    }

    return data
        .map(
          (item) =>
              CodeTitleModel.fromMap(Map<String, dynamic>.from(item as Map)),
        )
        .toList();
  }

  @override
  Future<CodeTitleModel> getById(int id) async {
    if (id <= 0) {
      throw Exception('شناسه نامعتبر است.');
    }

    final response = await _apiClient.dio.get('/CodeTitle/$id');

    final data = response.data;

    if (data is! Map) {
      throw Exception('فرمت پاسخ کد عنوان نامعتبر است.');
    }

    return CodeTitleModel.fromMap(Map<String, dynamic>.from(data));
  }
}
