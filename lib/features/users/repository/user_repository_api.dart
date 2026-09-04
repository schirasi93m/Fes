import 'package:flutter/foundation.dart';

import '../../../core/network/api_client.dart';
import '../models/app_user_model.dart';
import 'user_repository.dart';

class UserRepositoryApi implements UserRepository {
  final ApiClient _apiClient;

  UserRepositoryApi(this._apiClient);

  @override
  Future<List<AppUserModel>> getList() async {
    try {
      debugPrint('[UserRepositoryApi.getList] درخواست GET /Users');
      final response = await _apiClient.dio.get('/Users');
      debugPrint('[UserRepositoryApi.getList] پاسخ دریافت شد: statusCode=${response.statusCode}');

      final data = response.data;
      debugPrint('[UserRepositoryApi.getList] data type: ${data.runtimeType}');

      if (data is! List) {
        debugPrint('[UserRepositoryApi.getList] خطا: data یک List نیست!');
        throw Exception('فرمت پاسخ لیست کاربران نامعتبر است. دریافت شده: ${data.runtimeType}');
      }

      debugPrint('[UserRepositoryApi.getList] تعداد کاربران: ${data.length}');
      return data
          .map(
            (item) =>
                AppUserModel.fromMap(Map<String, dynamic>.from(item as Map)),
          )
          .toList();
    } catch (e) {
      debugPrint('[UserRepositoryApi.getList] خطا: $e');
      rethrow;
    }
  }

  @override
  Future<AppUserModel> insert(AppUserModel user) async {
    try {
      debugPrint('[UserRepositoryApi.insert] ارسال کاربر جدید: ${user.fullName}');
      final response = await _apiClient.dio.post(
        '/Users',
        data: user.toCreateApiMap(),
      );
      debugPrint('[UserRepositoryApi.insert] پاسخ: statusCode=${response.statusCode}');

      if (response.data is! Map) {
        throw Exception('فرمت پاسخ ثبت کاربر نامعتبر است. دریافت شده: ${response.data.runtimeType}');
      }

      return AppUserModel.fromMap(
        Map<String, dynamic>.from(response.data as Map),
      );
    } catch (e) {
      debugPrint('[UserRepositoryApi.insert] خطا: $e');
      rethrow;
    }
  }

  @override
  Future<AppUserModel> update(AppUserModel user) async {
    try {
      final id = user.id;

      if (id == null || id <= 0) {
        throw Exception('شناسه کاربر برای ویرایش الزامی است.');
      }

      debugPrint('[UserRepositoryApi.update] ویرایش کاربر: id=$id, ${user.fullName}');
      final response = await _apiClient.dio.put(
        '/Users/$id',
        data: user.toUpdateApiMap(),
      );
      debugPrint('[UserRepositoryApi.update] پاسخ: statusCode=${response.statusCode}');

      if (response.statusCode == 204 || response.data == null) {
        return user;
      }

      if (response.data is! Map) {
        throw Exception('فرمت پاسخ ویرایش کاربر نامعتبر است.');
      }

      return AppUserModel.fromMap(
        Map<String, dynamic>.from(response.data as Map),
      );
    } catch (e) {
      debugPrint('[UserRepositoryApi.update] خطا: $e');
      rethrow;
    }
  }

  @override
  Future<void> delete(AppUserModel user) async {
    try {
      final id = user.id;

      if (id == null || id <= 0) {
        throw Exception('شناسه کاربر برای حذف الزامی است.');
      }

      debugPrint('[UserRepositoryApi.delete] حذف کاربر: id=$id');
      await _apiClient.dio.delete('/Users/$id');
      debugPrint('[UserRepositoryApi.delete] حذف شد');
    } catch (e) {
      debugPrint('[UserRepositoryApi.delete] خطا: $e');
      rethrow;
    }
  }
}
