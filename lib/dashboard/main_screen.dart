import 'package:flutter/material.dart';

import 'package:new_project_fes/core/theme/app_colors.dart';
import 'package:new_project_fes/core/theme/app_sizes.dart';
import 'package:new_project_fes/core/widgets/app_footer.dart';
import 'package:new_project_fes/core/widgets/app_header.dart';
import 'package:new_project_fes/core/widgets/app_sidebar.dart';
import 'package:new_project_fes/dashboard/dashboar_page.dart';

import 'package:new_project_fes/features/customers/models/customer_model.dart';
import 'package:new_project_fes/features/customers/pages/customers_page.dart';


import 'package:new_project_fes/features/extinguishers/page/extinguisher_page.dart';

import 'package:new_project_fes/features/services/pages/services_page.dart';
import 'package:new_project_fes/features/users/pages/users_page.dart';
import 'package:new_project_fes/features/auth/pages/login_page.dart';
import 'package:new_project_fes/features/auth/model/login_response_model.dart';

import 'package:new_project_fes/playground/component_playground.dart';

class MainScreen extends StatefulWidget {
  final LoginResponseModel user;

  const MainScreen({super.key, required this.user});

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
  users,
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  bool sidebarExpanded = true;

  CustomerModel? _customerToEdit;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String get pageTitle {
    switch (selectedIndex) {
      case 0:
        return 'داشبورد';

      case 1:
        return 'مشتریان';

      case 2:
        return 'کپسول ها';

      case 3:
        return 'سرویس‌ها';

      case 4:
        return 'گزارشات';

      case 5:
        return 'تنظیمات';

      case 6:
        return 'کاربران';

      case 7:
        return 'کامپونت ها';

      default:
        return '';
    }
  }

  Widget _buildPage() {
    switch (selectedIndex) {
      case 0:
        return const DashboardPage();

      case 1:
        return CustomersPage(
          customerToEdit: _customerToEdit,
          onCustomerEditHandled: () {
            _customerToEdit = null;
          },
        );

      case 2:
        return ExtinguisherPage(
          onCustomersPressed: () {
            setState(() {
              selectedIndex = 1;
            });
          },
          onCustomerEdit: (customer) {
            setState(() {
              _customerToEdit = customer;
              selectedIndex = 1;
            });
          },
        );

      case 3:
        return const ServicesPage();

      case 4:
        return const Center(child: Text('گزارشات'));

      case 5:
        return const Center(child: Text('تنظیمات'));

      case 6:
        return const UsersPage();

      case 7:
        return const ComponentShowcase();

      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final useDrawerNavigation =
                constraints.maxWidth < AppSizes.mobileBreakpoint;
            final useCompactRail =
                constraints.maxWidth < AppSizes.sidebarCompactBreakpoint;

            return Column(
              children: [
                AppHeader(
                  title: pageTitle,
                  onMenuPressed: () {
                    if (useDrawerNavigation) {
                      _scaffoldKey.currentState?.openEndDrawer();
                      return;
                    }

                    setState(() => sidebarExpanded = !sidebarExpanded);
                  },
                ),

                Expanded(
                  child: Row(
                    children: [
                      if (!useDrawerNavigation)
                        AppSidebar(
                          expanded: useCompactRail ? false : sidebarExpanded,
                          selectedIndex: selectedIndex,
                          onItemSelected: _selectPage,
                          onLogout: _logout,
                          user: widget.user,
                        ),

                      Expanded(child: _buildPage()),
                    ],
                  ),
                ),

                const AppFooter(),
              ],
            );
          },
        ),
      ),
      endDrawer: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= AppSizes.mobileBreakpoint) {
            return const SizedBox.shrink();
          }

          return Drawer(
            width: AppSizes.drawerWidth,
            child: AppSidebar(
              expanded: true,
              selectedIndex: selectedIndex,
              onItemSelected: (index) {
                _selectPage(index);
                Navigator.of(context).pop();
              },
              onLogout: _logout,
              user: widget.user,
            ),
          );
        },
      ),
    );
  }

  void _logout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  void _selectPage(int index) {
    setState(() => selectedIndex = index);
  }
}
