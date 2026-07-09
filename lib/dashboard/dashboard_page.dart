/*import 'package:flutter/material.dart';
import 'package:new_project_fes/Core/Theme/app_spacing.dart';
import 'package:new_project_fes/Core/Theme/app_text_style.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:new_project_fes/core/widgets/app_header.dart';
import 'package:new_project_fes/core/widgets/app_sidebar.dart';
import 'package:new_project_fes/core/widgets/status_badge.dart';
import 'package:new_project_fes/dashboard/dashboard_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<String> _titles = ['داشبورد', 'مشتریان', 'کپسول‌ها', 'سرویس‌ها'];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Row(
          children: [
            // === سایدبار ===
            AppSidebar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              leading: const Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  children: [
                    Text('🧯', style: AppTextStyles.logo),
                    Text('FES', style: AppTextStyles.companyName),
                    Text('ایمن شهر کاشان', style: AppTextStyles.companyName),
                  ],
                ),
              ),
              destinations: const [
                NavigationRailDestination(
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedDashboardSquareSetting,
                  ),
                  label: Text('داشبورد', style: AppTextStyles.sidebarItem),
                ),
                NavigationRailDestination(
                  icon: HugeIcon(icon: HugeIcons.strokeRoundedUserGroup03),
                  label: Text('مشتریان', style: AppTextStyles.sidebarItem),
                ),
                NavigationRailDestination(
                  icon: HugeIcon(icon: HugeIcons.strokeRoundedFireExtinguisher),
                  label: Text('کپسول‌ها', style: AppTextStyles.sidebarItem),
                ),
                NavigationRailDestination(
                  icon: HugeIcon(icon: HugeIcons.strokeRoundedSettings01),
                  label: Text('سرویس‌ها', style: AppTextStyles.sidebarItem),
                ),
              ],
            ),

            // === محتوای اصلی ===
            Expanded(
              child: Column(
                children: [
                  AppHeader(
                    title: _titles[_selectedIndex],
                    trailing: const StatusBadge(
                      text: 'متصل',
                      type: StatusBadgeType.success,
                    ),
                  ),

                  // صفحه فعلی
                  Expanded(
                    child: IndexedStack(
                      index: _selectedIndex,
                      children: const [
                        DashboardPage(),
                        Center(child: Text("Customers")),
                        Center(child: Text("Extinguishers")),
                        Center(child: Text("Services")),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /*Widget _buildCurrentPage(int index) {
    switch (index) {
      case 0: return const DashboardPage();
      case 1: return const CustomersPage();
      case 2: return const ExtinguishersPage();
      case 3: return const ServicesPage();
      default: return const DashboardPage();
    }
  }*/
}
*/