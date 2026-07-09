import 'package:flutter/material.dart';

import 'package:new_project_fes/core/theme/app_colors.dart';
import 'package:new_project_fes/core/theme/app_icons.dart';
import 'package:new_project_fes/core/widgets/app_button.dart';
import 'package:new_project_fes/core/widgets/app_header.dart';
import 'package:new_project_fes/core/widgets/app_sidebar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  bool sidebarExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(
              title: "داشبورد",
            ),

            Expanded(
              child: Row(
                children: [
                  AppSidebar(
                    extended: sidebarExpanded,
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (index) {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(AppIcons.dashboard),
                        selectedIcon: Icon(AppIcons.dashboard),
                        label: Text("داشبورد"),
                      ),
                      NavigationRailDestination(
                        icon: Icon(AppIcons.customer),
                        selectedIcon: Icon(AppIcons.customer),
                        label: Text("مشتریان"),
                      ),
                      NavigationRailDestination(
                        icon: Icon(AppIcons.company),
                        selectedIcon: Icon(AppIcons.company),
                        label: Text("شرکت‌ها"),
                      ),
                      NavigationRailDestination(
                        icon: Icon(AppIcons.service),
                        selectedIcon: Icon(AppIcons.service),
                        label: Text("سرویس‌ها"),
                      ),
                      NavigationRailDestination(
                        icon: Icon(AppIcons.report),
                        selectedIcon: Icon(AppIcons.report),
                        label: Text("گزارشات"),
                      ),
                      NavigationRailDestination(
                        icon: Icon(AppIcons.settings),
                        selectedIcon: Icon(AppIcons.settings),
                        label: Text("تنظیمات"),
                      ),
                    ],
                  ),

                  Expanded(
                    child: Container(
                      color: AppColors.background,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              height: 28,
              color: AppColors.surface,
            ),
          ],
        ),
      ),
    );
  }
}