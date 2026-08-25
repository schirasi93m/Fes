import '../../../core/network/api_client.dart';
import '../model/service_model.dart';

class ServiceApi {
  final ApiClient _apiClient;

  ServiceApi(this._apiClient);

  Future<List<ServiceModel>> getServices() async {
    final response = await _apiClient.dio.get('/Services');

    if (response.data is! List) {
      throw Exception('فرمت پاسخ لیست سرویس‌ها نامعتبر است.');
    }

    return (response.data as List)
        .map((json) => ServiceModel.fromJson(
              Map<String, dynamic>.from(json as Map),
            ))
        .toList();
  }

  Future<ServiceModel> getService(int id) async {
    final response = await _apiClient.dio.get('/Services/$id');

    return ServiceModel.fromJson(response.data);
  }

  Future<ServiceModel> createService(ServiceModel service) async {
    final response = await _apiClient.dio.post(
      '/Services',
      data: service.toJson(),
    );

    if (response.statusCode == 204 || response.data == null) {
      return service;
    }

    if (response.data is! Map) {
      throw Exception('فرمت پاسخ ثبت سرویس نامعتبر است.');
    }

    return ServiceModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }

  Future<ServiceModel> updateService(ServiceModel service) async {
    if (service.id == null || service.id! <= 0) {
      throw Exception('Service id is required for update.');
    }

    final response = await _apiClient.dio.put(
      '/Services/${service.id}',
      data: service.toJson(),
    );

    if (response.statusCode == 204 || response.data == null) {
      return service;
    }

    if (response.data is! Map) {
      throw Exception('فرمت پاسخ ویرایش سرویس نامعتبر است.');
    }

    return ServiceModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }

  Future<void> deleteService(int id) async {
    await _apiClient.dio.delete('/Services/$id');
  }
}