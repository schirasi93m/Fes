import '../models/customer_model.dart';

class CustomerService {
  void validate(CustomerModel customer) {
    if (customer.fullName.trim().isEmpty) {
      throw Exception('نام مشتری را وارد کنید.');
    }

    if (customer.phone.trim().isEmpty) {
      throw Exception('شماره تماس را وارد کنید.');
    }

    if (customer.phone.trim().length != 11) {
      throw Exception('شماره تماس باید ۱۱ رقم باشد.');
    }
  }

  CustomerModel createCustomer({
    required String fullName,
    required String phone,
    required String address,
  }) {
    final customer = CustomerModel(
      fullName: fullName.trim(),
      phone: phone.trim(),
      address: address.trim(),
    );

    validate(customer);

    return customer;
  }
}