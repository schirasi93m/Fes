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
import '../../../core/network/api_client.dart';
import '../repository/customer_repository_api.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  final TextEditingController searchController = TextEditingController();
  final CustomerController customerController = CustomerController(
    CustomerRepositoryApi(ApiClient()),
  );

  // Full, unfiltered list as last loaded from the repository.
  List<CustomerModel> _allCustomers = [];
  List<CustomerModel> _filteredCustomers = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCustomers() async {
    setState(() => _isLoading = true);

    try {
      final customers = await customerController.getAll();

      setState(() {
        _allCustomers = customers;
        _isLoading = false;
      });

      _applyFilter(searchController.text);
    } catch (e) {
      setState(() => _isLoading = false);

      if (!mounted) return;
      AppNotifier.error(context, "دریافت لیست مشتریان با خطا مواجه شد.");
    }
  }

  void _applyFilter(String value) {
    final query = value.trim();

    if (query.isEmpty) {
      setState(() => _filteredCustomers = _allCustomers);
      return;
    }

    final results = _allCustomers.where((customer) {
      return customer.fullName.contains(query) ||
          customer.phone.contains(query) ||
          customer.address.contains(query);
    }).toList();

    setState(() => _filteredCustomers = results);
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

    try {
      await customerController.add(customer);

      if (!mounted) return;
      AppNotifier.success(context, "مشتری با موفقیت ثبت شد.");

      await _loadCustomers();
    } catch (e) {
      if (!mounted) return;
      AppNotifier.error(
        context,
        "ثبت مشتری با خطا مواجه شد. دوباره تلاش کنید.",
      );
    }
  }

  Future<void> _editCustomer(int index) async {
    final customer = _filteredCustomers[index];

    final updatedCustomer = await CustomerDialog.show(
      context,
      customer: customer,
    );

    if (updatedCustomer == null) return;

    try {
      await customerController.update(updatedCustomer);

      if (!mounted) return;
      AppNotifier.success(context, "اطلاعات مشتری با موفقیت ویرایش شد.");

      await _loadCustomers();
    } catch (e) {
      if (!mounted) return;
      AppNotifier.error(
        context,
        "ویرایش مشتری با خطا مواجه شد. دوباره تلاش کنید.",
      );
    }
  }

  Future<void> _deleteCustomer(int index) async {
    final customer = _filteredCustomers[index];

    final confirmed = await CustomerDeleteDialog.show(context);

    if (!confirmed) return;

    try {
      await customerController.remove(customer);

      if (!mounted) return;
      AppNotifier.success(context, "مشتری با موفقیت حذف شد.");

      await _loadCustomers();
    } catch (e) {
      if (!mounted) return;
      AppNotifier.error(
        context,
        "حذف مشتری با خطا مواجه شد. دوباره تلاش کنید.",
      );
    }
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
            onRefreshPressed: _loadCustomers,

            onSearchChanged: _applyFilter,
          ),

          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : AppTable(
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
