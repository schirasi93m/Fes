import '../../../core/network/api_client.dart';
import '../models/customer_model.dart';
import 'customer_repository.dart';

class CustomerRepositoryApi implements CustomerRepository {
  final ApiClient _apiClient;

  CustomerRepositoryApi(this._apiClient);

  @override
  Future<List<CustomerModel>> getList() async {
    final response = await _apiClient.dio.get('/Customers');

    final data = response.data;

    if (data is! List) {
      throw Exception('فرمت پاسخ لیست مشتریان نامعتبر است.');
    }

    return data
        .map(
          (item) =>
              CustomerModel.fromMap(Map<String, dynamic>.from(item as Map)),
        )
        .toList();
  }

  @override
  Future<CustomerModel> insert(CustomerModel customer) async {
    final response = await _apiClient.dio.post(
      '/Customers',
      data: customer.toApiMap(),
    );

    if (response.data is! Map) {
      throw Exception('فرمت پاسخ ثبت مشتری نامعتبر است.');
    }

    return CustomerModel.fromMap(
      Map<String, dynamic>.from(response.data as Map),
    );
  }

  @override
  Future<CustomerModel> update(CustomerModel customer) async {
    final id = customer.id;

    if (id == null || id <= 0) {
      throw Exception('شناسه مشتری برای ویرایش الزامی است.');
    }

    final response = await _apiClient.dio.put(
      '/Customers/$id',
      data: customer.toApiMap(),
    );

    if (response.data is! Map) {
      throw Exception('فرمت پاسخ ویرایش مشتری نامعتبر است.');
    }

    return CustomerModel.fromMap(
      Map<String, dynamic>.from(response.data as Map),
    );
  }

  @override
  Future<void> delete(CustomerModel customer) async {
    final id = customer.id;

    if (id == null || id <= 0) {
      throw Exception('شناسه مشتری برای حذف الزامی است.');
    }

    await _apiClient.dio.delete('/Customers/$id');
  }
}
