import '../models/customer_model.dart';
import '../repository/customer_repository.dart';
import '../services/customer_service.dart';

class CustomerController {
  final CustomerRepository _repository;
  final CustomerService _service = CustomerService();

  CustomerController(this._repository);

  Future<List<CustomerModel>> getAll() async {
    return await _repository.getList();
  }

  Future<CustomerModel> add(CustomerModel customer) async {
    _service.validate(customer);

    return await _repository.insert(customer);
  }

  Future<CustomerModel> update(CustomerModel customer) async {
    _service.validate(customer);

    return await _repository.update(customer);
  }

  Future<void> remove(CustomerModel customer) async {
    await _repository.delete(customer);
  }
}
