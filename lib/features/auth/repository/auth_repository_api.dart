import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import 'package:new_project_fes/features/auth/model/login_request_model.dart';
import 'package:new_project_fes/features/auth/model/login_response_model.dart';
import 'auth_repository.dart';

class AuthRepositoryApi implements AuthRepository {
  final ApiClient _apiClient;

  AuthRepositoryApi(this._apiClient);

  @override
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    try {
      final response = await _apiClient.dio.post(
        '/Auth/login',
        data: request.toMap(),
      );

      if (response.data is! Map) {
        throw Exception('فرمت پاسخ ورود نامعتبر است.');
      }

      return LoginResponseModel.fromMap(
        Map<String, dynamic>.from(response.data as Map),
      );
    } on DioException {
      rethrow;
    }
  }
}
