import 'package:flutter/material.dart';
import 'package:new_project_fes/core/models/app_table_column.dart';
import 'package:new_project_fes/core/widgets/app_table/app_table.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_page_toolbar.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
            showExcel: false,

            primaryButtonText: "مشتری جدید",

            onPrimaryPressed: () {},

            onSearchChanged: (value) {},
          ),

          Expanded(
            child: AppTable(
              columns: [
                AppTableColumn(title: "نام مشتری", width: 220),
                AppTableColumn(title: "موبایل", width: 180),
                AppTableColumn(title: "شرکت", width: 220),
                AppTableColumn(title: "وضعیت", width: 120),
                AppTableColumn(title: "عملیات", width: 150),
              ],
              rows: [
                [
                  const Text("مصطفی شیرازی"),
                  const Text("09121234567"),
                  const Text("ایمن شهر"),
                  const Text("فعال"),
                  const Text("✏️"),
                ],
                [
                  const Text("علی رضایی"),
                  const Text("09123334444"),
                  const Text("شرکت آلفا"),
                  const Text("غیرفعال"),
                  const Text("✏️"),
                ],
                [
                  const Text("رضا محمدی"),
                  const Text("09125556666"),
                  const Text("شرکت بتا"),
                  const Text("فعال"),
                  const Text("✏️"),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
