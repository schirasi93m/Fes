import '../models/customer_model.dart';

class CustomerController {
  final List<CustomerModel> _customers = [];

  List<CustomerModel> get customers => List.unmodifiable(_customers);

  void add(CustomerModel customer) {
    _customers.add(customer);
  }

  void remove(CustomerModel customer) {
    _customers.remove(customer);
  }

  void update(int index, CustomerModel customer) {
    _customers[index] = customer;
  }

  void clear() {
    _customers.clear();
  }
}
