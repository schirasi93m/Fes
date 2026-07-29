import 'package:new_project_fes/core/enums/entity_state.dart';

import '../models/customer_model.dart';
import '../services/customer_service.dart';
class CustomerController {
final CustomerService _service = CustomerService();
  final List<CustomerModel> _customers = [];
  List<CustomerModel> get customers => List.unmodifiable(_customers);

  void add(CustomerModel customer) {
  _service.validate(customer);

  _customers.add(
    customer.copyWith(
      entityState: EntityState.inserted,
    ),
  );
}

  void update(CustomerModel customer) {
    final index = _customers.indexWhere((e) => e.id == customer.id);

    if (index == -1) return;

    _customers[index] = customer.copyWith(
      entityState: EntityState.modified,
    );
  }

  void remove(CustomerModel customer) {
    final index = _customers.indexWhere((e) => e.id == customer.id);

    if (index == -1) return;

    if (customer.id == null) {
      _customers.removeAt(index);
    } else {
      _customers[index] = customer.copyWith(
        entityState: EntityState.deleted,
      );
    }
  }

  void clear() {
    _customers.clear();
  }
}