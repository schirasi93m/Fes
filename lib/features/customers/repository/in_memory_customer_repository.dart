import '../models/customer_model.dart';
import '../../../core/enums/entity_state.dart';
import 'customer_repository.dart';

class InMemoryCustomerRepository implements CustomerRepository {
  final List<CustomerModel> _customers = [];

  // فقط برای Repository حافظه
  // در SQL Server مقدار Id توسط دیتابیس تولید می‌شود.
  int _nextId = 1;

  @override
  Future<List<CustomerModel>> getList() async {
    return List.unmodifiable(_customers);
  }

  @override
  Future<CustomerModel> insert(CustomerModel customer) async {
    final savedCustomer = customer.copyWith(
      id: _nextId++,
      entityState: EntityState.unchanged,
    );

    _customers.add(savedCustomer);

    return savedCustomer;
  }

  @override
  Future<CustomerModel> update(CustomerModel customer) async {
    final index = _customers.indexWhere((e) => e.id == customer.id);

    if (index == -1) {
      throw const CustomerNotFoundException();
    }

    final updatedCustomer = customer.copyWith(
      entityState: EntityState.unchanged,
    );

    _customers[index] = updatedCustomer;

    return updatedCustomer;
  }

  @override
  Future<void> delete(CustomerModel customer) async {
    final index = _customers.indexWhere((e) => e.id == customer.id);

    if (index == -1) {
      throw const CustomerNotFoundException();
    }

    _customers.removeAt(index);
  }
}
