import '../../../core/enums/entity_state.dart';
import '../../../core/network/api_client.dart';
import '../models/extinguishers_model.dart';
import 'extinguisher_repository.dart';

class ExtinguisherRepositoryApi implements ExtinguisherRepository {
  final ApiClient _apiClient;

  ExtinguisherRepositoryApi(this._apiClient);

  @override
  Future<List<ExtinguisherModel>> getList() async {
    final response = await _apiClient.dio.get('/Extinguishers');

    final data = response.data;

    if (data is! List) {
      throw Exception('فرمت پاسخ لیست کپسول‌ها نامعتبر است.');
    }

    return data
        .map(
          (item) =>
              ExtinguisherModel.fromMap(Map<String, dynamic>.from(item as Map)),
        )
        .toList();
  }

  @override
  Future<ExtinguisherModel> insert(ExtinguisherModel extinguisher) async {
    final response = await _apiClient.dio.post(
      '/Extinguishers',
      data: extinguisher.toApiMap(),
    );

    if (response.data is! Map) {
      throw Exception('فرمت پاسخ ثبت کپسول نامعتبر است.');
    }

    return ExtinguisherModel.fromMap(
      Map<String, dynamic>.from(response.data as Map),
    );
  }

  @override
  Future<ExtinguisherModel> update(ExtinguisherModel extinguisher) async {
    final id = extinguisher.id;

    if (id == null || id <= 0) {
      throw Exception('شناسه کپسول برای ویرایش الزامی است.');
    }

    final response = await _apiClient.dio.put(
      '/Extinguishers/$id',
      data: extinguisher.toApiMap(),
    );

    if (response.statusCode == 204 || response.data == null) {
      return extinguisher.copyWith(entityState: EntityState.modified);
    }

    if (response.data is! Map) {
      throw Exception('فرمت پاسخ ویرایش کپسول نامعتبر است.');
    }

    return ExtinguisherModel.fromMap(
      Map<String, dynamic>.from(response.data as Map),
    ).copyWith(entityState: EntityState.modified);
  }

  @override
  Future<void> delete(ExtinguisherModel extinguisher) async {
    final id = extinguisher.id;

    if (id == null || id <= 0) {
      throw Exception('شناسه کپسول برای حذف الزامی است.');
    }

    await _apiClient.dio.delete('/Extinguishers/$id');
  }
}
