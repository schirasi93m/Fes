import 'package:flutter/material.dart';

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

            onSearchChanged: (value) {
         
            },
          ),

          const Expanded(child: Center(child: Text("جدول مشتریان"))),
        ],
      ),
    );
  }
}
