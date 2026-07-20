import 'package:flutter/material.dart';
import 'package:new_project_fes/core/models/app_table_column.dart';
import 'package:new_project_fes/core/theme/app_icons.dart';
import 'package:new_project_fes/core/theme/app_sizes.dart';
import 'package:new_project_fes/core/widgets/app_button.dart';
import 'package:new_project_fes/core/widgets/app_page_toolbar.dart';
import 'package:new_project_fes/core/widgets/app_table/app_table.dart';
import 'package:new_project_fes/core/widgets/status_badge.dart';

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

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<List<Widget>> _buildRows() {
    return customerController.customers.map((customer) {
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

        AppButton(
          icon: AppIcons.edit,
          type: AppButtonType.icon,
          onPressed: () {},
        ),
      ];
    }).toList();
  }

  Future<void> _addCustomer() async {
    final CustomerModel? customer = await CustomerDialog.show(context);

    if (customer == null) return;

    customerController.add(customer);

    setState(() {});
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

            onSearchChanged: (value) {},
          ),

          Expanded(
            child: AppTable(
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
