import '../models/customer_model.dart';

abstract class CustomerRepository {
  Future<List<CustomerModel>> getList();

  Future<CustomerModel> insert(CustomerModel customer);

  Future<CustomerModel> update(CustomerModel customer);

  Future<void> delete(CustomerModel customer);

  // Future<void> deleteById(int id);
}

class CustomerNotFoundException implements Exception {
  final String message;
  const CustomerNotFoundException([this.message = 'مشتری مورد نظر یافت نشد.']);

  @override
  String toString() => message;
}
