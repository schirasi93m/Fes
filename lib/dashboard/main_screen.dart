import 'package:flutter/material.dart';

import 'package:new_project_fes/core/theme/app_colors.dart';
import 'package:new_project_fes/core/widgets/app_footer.dart';
import 'package:new_project_fes/core/widgets/app_header.dart';
import 'package:new_project_fes/core/widgets/app_sidebar.dart';

import 'package:new_project_fes/features/customers/pages/customers_page.dart';
import 'package:new_project_fes/playground/component_playground.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

enum NavigationPage {
  dashboard,
  customers,
  companies,
  services,
  reports,
  settings,
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  bool sidebarExpanded = true;

  String get pageTitle {
    switch (selectedIndex) {
      case 0:
        return "داشبورد";

      case 1:
        return "مشتریان";

      case 2:
        return "شرکت‌ها";

      case 3:
        return "سرویس‌ها";

      case 4:
        return "گزارشات";

      case 5:
        return "تنظیمات";

      case 6:
        return "کامپونت ها ";

      default:
        return "";
    }
  }

  Widget _buildPage() {
    switch (selectedIndex) {
      case 0:
        return const Center(child: Text("داشبورد"));

      case 1:
        return const CustomersPage();

      case 2:
        return const Center(child: Text("شرکت‌ها"));

      case 3:
        return const Center(child: Text("سرویس‌ها"));

      case 4:
        return const Center(child: Text("گزارشات"));

      case 5:
        return const Center(child: Text("تنظیمات"));

        
      case 6:
        return const ComponentShowcase();

      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              title: pageTitle,
              onMenuPressed: () {
                setState(() {
                  sidebarExpanded = !sidebarExpanded;
                });
              },
            ),

            Expanded(
              child: Row(
                children: [
                  AppSidebar(
                    expanded: sidebarExpanded,
                    selectedIndex: selectedIndex,
                    onItemSelected: (index) {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                  ),

                  Expanded(child: _buildPage()),
                ],
              ),
            ),

            const AppFooter(),
          ],
        ),
      ),
    );
  }
}
