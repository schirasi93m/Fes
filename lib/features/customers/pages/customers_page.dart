import 'package:flutter/material.dart';
import 'package:new_project_fes/core/models/app_table_column.dart';
import 'package:new_project_fes/core/theme/app_sizes.dart';
import 'package:new_project_fes/core/widgets/app_notifier.dart';
import 'package:new_project_fes/core/widgets/app_page_toolbar.dart';
import 'package:new_project_fes/core/widgets/app_table/app_table.dart';
import 'package:new_project_fes/core/widgets/status_badge.dart';
import 'package:new_project_fes/features/customers/widgets/customer_delete_dialog.dart';

import '../../../core/theme/app_colors.dart';
import '../controllers/customer_controller.dart';
import '../models/customer_model.dart';
import '../widgets/customer_form_dialog.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  final TextEditingController searchController = TextEditingController();
  final CustomerController customerController = CustomerController();

  List<CustomerModel> _filteredCustomers = [];

  @override
  void initState() {
    super.initState();

    _filteredCustomers = customerController.customers;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _searchCustomers(String value) {
    final query = value.trim();

    if (query.isEmpty) {
      setState(() {
        _filteredCustomers = customerController.customers;
      });

      return;
    }

    final results = customerController.customers.where((customer) {
      return customer.fullName.contains(query) ||
          customer.phone.contains(query) ||
          customer.address.contains(query);
    }).toList();

    setState(() {
      _filteredCustomers = results;
    });
  }

  List<List<Widget>> _buildRows() {
    return _filteredCustomers.map((customer) {
      return [
        Text(customer.fullName),
        Text(customer.phone),
        Text(customer.address),

        StatusBadge(
          text: customer.isActive ? "فعال" : "غیرفعال",
          type: customer.isActive
              ? StatusBadgeType.success
              : StatusBadgeType.warning,
        ),

        const SizedBox.shrink(),
      ];
    }).toList();
  }

  Future<void> _addCustomer() async {
    final CustomerModel? customer = await CustomerDialog.show(context);

    if (customer == null) return;

    customerController.add(customer);

    _searchCustomers(searchController.text);

    AppNotifier.success(context, "مشتری با موفقیت ثبت شد.");
  }

  Future<void> _editCustomer(int index) async {
    final customer = _filteredCustomers[index];

    final updatedCustomer = await CustomerDialog.show(
      context,
      customer: customer,
    );

    if (updatedCustomer == null) return;

    customerController.update(updatedCustomer);

    _searchCustomers(searchController.text);

    AppNotifier.success(context, "اطلاعات مشتری با موفقیت ویرایش شد.");
  }

  Future<void> _deleteCustomer(int index) async {
    final customer = _filteredCustomers[index];

    final confirmed = await CustomerDeleteDialog.show(context);

    if (!confirmed) return;

    customerController.remove(customer);

    _searchCustomers(searchController.text);

    AppNotifier.success(context, "مشتری با موفقیت حذف شد.");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Column(
        children: [
          PageToolbar(
            searchController: searchController,
            searchHint: "جستجوی مشتری...",

            showRefresh: true,
            showFilter: true,

            primaryButtonText: "مشتری جدید",

            onPrimaryPressed: _addCustomer,

            onSearchChanged: _searchCustomers,
          ),

          Expanded(
            child: AppTable(
              showDeleteAction: true,
              showEditAction: true,

              onEdit: _editCustomer,

              onDelete: _deleteCustomer,

              columns: const [
                AppTableColumn(
                  title: "نام مشتری",
                  width: AppTableSizes.customerName,
                ),
                AppTableColumn(
                  title: "شماره تماس",
                  width: AppTableSizes.customerPhone,
                ),
                AppTableColumn(
                  title: "آدرس",
                  width: AppTableSizes.customerAddress,
                ),
                AppTableColumn(
                  title: "وضعیت",
                  width: AppTableSizes.customerStatus,
                ),
                AppTableColumn(
                  title: "عملیات",
                  width: AppTableSizes.customerActions,
                ),
              ],

              rows: _buildRows(),
            ),
          ),
        ],
      ),
    );
  }
}
