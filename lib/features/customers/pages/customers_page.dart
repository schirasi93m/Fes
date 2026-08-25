import 'package:flutter/material.dart';

import 'package:new_project_fes/core/models/app_table_column.dart';
import 'package:new_project_fes/core/network/api_client.dart';
import 'package:new_project_fes/core/theme/app_sizes.dart';
import 'package:new_project_fes/core/widgets/app_form_page.dart';
import 'package:new_project_fes/core/widgets/app_notifier.dart';
import 'package:new_project_fes/core/widgets/status_badge.dart';

import 'package:new_project_fes/features/customers/widgets/customer_delete_dialog.dart';
import '../controllers/customer_controller.dart';
import '../models/customer_model.dart';
import '../widgets/customer_form_dialog.dart';
import '../repository/customer_repository_api.dart';

class CustomersPage extends AppFormPage {
  final CustomerModel? customerToEdit;
  final VoidCallback? onCustomerEditHandled;

  const CustomersPage({
    super.key,
    this.customerToEdit,
    this.onCustomerEditHandled,
  });

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends AppFormPageState<CustomersPage> {
  final CustomerController _customerController = CustomerController(
    CustomerRepositoryApi(ApiClient()),
  );

  List<CustomerModel> _allCustomers = [];

  bool _didOpenRequestedCustomer = false;

  // ------------------------------------------------------------
  // Page Settings
  // ------------------------------------------------------------

  @override
  String get pageTitle => 'مشتریان';

  @override
  String get searchHint => 'جستجوی مشتری...';

  @override
  String get primaryButtonText => 'مشتری جدید';

  @override
  bool get showFilter => false;

  // ------------------------------------------------------------
  // Columns
  // ------------------------------------------------------------

  @override
  List<AppTableColumn> get columns => const [
    AppTableColumn(title: 'کد', width: AppTableSizes.code),
    AppTableColumn(title: 'نام مشتری', width: AppTableSizes.name),
    AppTableColumn(title: 'شماره تماس', width: AppTableSizes.number),
    AppTableColumn(title: 'آدرس', width: AppTableSizes.address),
    AppTableColumn(title: 'وضعیت', width: AppTableSizes.status),
    AppTableColumn(title: 'عملیات', width: AppTableSizes.actions),
  ];

  // ------------------------------------------------------------
  // Load Data
  // ------------------------------------------------------------

  @override
  Future<void> loadData() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      final customers = await _customerController.getAll();

      if (!mounted) {
        return;
      }

      setState(() {
        _allCustomers = customers;
        isLoading = false;
      });

      await _openRequestedCustomer(customers);
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        isLoading = false;
      });

      AppNotifier.error(context, 'دریافت لیست مشتریان با خطا مواجه شد.');
    }
  }

  // ------------------------------------------------------------
  // Search
  // ------------------------------------------------------------

  @override
  void onSearchChanged(String value) {
    setState(() {});
  }

  List<CustomerModel> get _filteredCustomers {
    final query = searchController.text.trim();

    if (query.isEmpty) {
      return _allCustomers;
    }

    return _allCustomers.where((customer) {
      return customer.code.toString().contains(query) ||
          customer.fullName.contains(query) ||
          customer.phone.contains(query) ||
          customer.address.contains(query);
    }).toList();
  }

  // ------------------------------------------------------------
  // Add
  // ------------------------------------------------------------

  @override
  Future<void> addItem() async {
    final customer = await CustomerDialog.show(context);

    if (customer == null) {
      return;
    }

    try {
      await _customerController.add(customer);

      if (!mounted) {
        return;
      }

      AppNotifier.success(context, 'مشتری با موفقیت ثبت شد.');

      await loadData();
    } catch (e) {
      if (!mounted) {
        return;
      }

      AppNotifier.error(
        context,
        'ثبت مشتری با خطا مواجه شد. دوباره تلاش کنید.',
      );
    }
  }

  // ------------------------------------------------------------
  // Edit
  // ------------------------------------------------------------

  @override
  Future<void> editItem(int index) async {
    final customer = _filteredCustomers[index];

    final updatedCustomer = await CustomerDialog.show(
      context,
      customer: customer,
    );

    if (updatedCustomer == null) {
      return;
    }

    try {
      await _customerController.update(updatedCustomer);

      if (!mounted) {
        return;
      }

      AppNotifier.success(context, 'اطلاعات مشتری با موفقیت ویرایش شد.');

      await loadData();
    } catch (e) {
      if (!mounted) {
        return;
      }

      AppNotifier.error(
        context,
        'ویرایش مشتری با خطا مواجه شد. دوباره تلاش کنید.',
      );
    }
  }

  // ------------------------------------------------------------
  // Delete
  // ------------------------------------------------------------

  @override
  Future<void> deleteItem(int index) async {
    final customer = _filteredCustomers[index];

    final confirmed = await CustomerDeleteDialog.show(context);

    if (!confirmed) {
      return;
    }

    try {
      await _customerController.remove(customer);

      if (!mounted) {
        return;
      }

      AppNotifier.success(context, 'مشتری با موفقیت حذف شد.');

      await loadData();
    } catch (e) {
      if (!mounted) {
        return;
      }

      AppNotifier.error(context, 'حذف مشتری با خطا مواجه شد.');
    }
  }

  // ------------------------------------------------------------
  // Rows
  // ------------------------------------------------------------

  @override
  List<List<Widget>> get rows {
    return _filteredCustomers.map((customer) {
      return [
        Text(customer.code.toString()),

        Text(customer.fullName),

        Text(customer.phone),

        Text(customer.address),

        StatusBadge(
          text: customer.isActive ? 'فعال' : 'غیرفعال',
          type: customer.isActive
              ? StatusBadgeType.success
              : StatusBadgeType.warning,
        ),

        const SizedBox.shrink(),
      ];
    }).toList();
  }

  // ------------------------------------------------------------
  // Open Requested Customer
  // ------------------------------------------------------------

  Future<void> _openRequestedCustomer(List<CustomerModel> customers) async {
    final requestedCustomer = widget.customerToEdit;

    if (_didOpenRequestedCustomer || requestedCustomer == null) {
      return;
    }

    CustomerModel? customer;

    for (final item in customers) {
      if (item.id == requestedCustomer.id) {
        customer = item;
        break;
      }
    }

    if (customer == null) {
      return;
    }

    _didOpenRequestedCustomer = true;

    widget.onCustomerEditHandled?.call();

    await Future<void>.delayed(Duration.zero);

    if (!mounted) {
      return;
    }

    final updatedCustomer = await CustomerDialog.show(
      context,
      customer: customer,
    );

    if (updatedCustomer == null || !mounted) {
      return;
    }

    try {
      await _customerController.update(updatedCustomer);

      if (!mounted) {
        return;
      }

      AppNotifier.success(context, 'اطلاعات مشتری با موفقیت ویرایش شد.');

      await loadData();
    } catch (e) {
      if (!mounted) {
        return;
      }

      AppNotifier.error(
        context,
        'ویرایش مشتری با خطا مواجه شد. دوباره تلاش کنید.',
      );
    }
  }
}
