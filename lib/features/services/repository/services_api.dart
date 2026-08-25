import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:new_project_fes/core/network/api_client.dart';
import 'package:new_project_fes/features/services/model/service_model.dart';

class ServiceApi {
  final ApiClient _apiClient;

  ServiceApi(this._apiClient);

  Future<List<ServiceModel>> getServices() async {
    final response = await _apiClient.dio.get('/Services');

    return (response.data as List)
        .map((json) => ServiceModel.fromJson(json))
        .toList();
  }

  Future<ServiceModel> getService(int id) async {
    final response = await _apiClient.dio.get('/Services/$id');

    return ServiceModel.fromJson(response.data);
  }

  Future<ServiceModel> createService(ServiceModel service) async {
    try {
      final data = service.toJson();

      debugPrint('SERVICE REQUEST: $data');

      final response = await _apiClient.dio.post('/Services', data: data);

      debugPrint('SERVICE STATUS: ${response.statusCode}');
      debugPrint('SERVICE RESPONSE: ${response.data}');

      return ServiceModel.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('SERVICE ERROR STATUS: ${e.response?.statusCode}');
      debugPrint('SERVICE ERROR DATA: ${e.response?.data}');
      debugPrint('SERVICE ERROR MESSAGE: ${e.message}');

      rethrow;
    }
  }

  Future<ServiceModel> updateService(ServiceModel service) async {
    if (service.id == null) {
      throw Exception('Service id is required for update.');
    }

    final response = await _apiClient.dio.put(
      '/Services/${service.id}',
      data: service.toJson(),
    );

    return ServiceModel.fromJson(response.data);
  }

  Future<void> deleteService(int id) async {
    await _apiClient.dio.delete('/Services/$id');
  }
}
