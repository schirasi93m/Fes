import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_page_toolbar.dart';

class CustomersPage extends StatelessWidget {
  const CustomersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Column(
        children: [
          PageToolbar(primaryButtonText: "مشتری جدید", onPrimaryPressed: () {}),
          const Expanded(child: Center(child: Text("جدول مشتریان"))),
        ],
      ),
    );
  }
}
