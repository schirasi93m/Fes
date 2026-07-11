import 'package:flutter/material.dart';
import 'package:new_project_fes/core/widgets/app_sidebar_user.dart';

import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import '../theme/app_radius.dart';
import '../theme/app_sizes.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_style.dart';

class AppSidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final bool expanded;

  const AppSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: expanded ? AppSizes.drawerWidth : AppSizes.navigationRailWidth,
      color: AppColors.sidebarBackground,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.lg),

            //------------------------------------
            // Header
            //------------------------------------
            Icon(
              AppIcons.extinguisher,
              color: AppColors.primary,
              size: AppSizes.logoSize,
            ),

            if (expanded) ...[
              const SizedBox(height: AppSpacing.md),
              Text("ایمن شهر", style: AppTextStyles.sidebarTitle),
              const SizedBox(height: AppSpacing.xs),
              Text(
                "مدیریت تجهیزات ایمنی و آتش‌نشانی",
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.sidebarTextSecondary,
                ),
              ),
            ],

            const SizedBox(height: AppSpacing.lg),

            Divider(color: AppColors.border, height: 1),

            const SizedBox(height: AppSpacing.md),

            //------------------------------------
            // Menu
            //------------------------------------
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                children: [
                  _buildItem(
                    index: 0,
                    title: "داشبورد",
                    icon: AppIcons.dashboard,
                  ),

                  _buildItem(
                    index: 1,
                    title: "مشتریان",
                    icon: AppIcons.customer,
                  ),

                  _buildItem(
                    index: 2,
                    title: "شرکت‌ها",
                    icon: AppIcons.company,
                  ),

                  _buildItem(
                    index: 3,
                    title: "سرویس‌ها",
                    icon: AppIcons.service,
                  ),

                  _buildItem(index: 4, title: "گزارشات", icon: AppIcons.report),

                  _buildItem(
                    index: 5,
                    title: "تنظیمات",
                    icon: AppIcons.settings,
                  ),
                  _buildItem(
                    index: 6,
                    title: "کامپونت هاش",
                    icon: AppIcons.playground,
                  ),

                  AppSidebarUser(
                    expanded: expanded,
                    fullName: "مصطفی شیرازی",
                    role: "مدیر سیستم",
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
              ),
            ),
            //------------------------------------
            // User
            //------------------------------------
            const SizedBox(height: AppSpacing.lg),

            //------------------------------------
            // Footer
            //------------------------------------
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: _buildItem(
                index: 99,
                title: "خروج",
                icon: AppIcons.logout,
                isLogout: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem({
    required int index,
    required String title,
    required IconData icon,
    bool isLogout = false,
  }) {
    final bool selected = selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.button),
        onTap: () => onItemSelected(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: AppSizes.buttonHeightMd,
          decoration: BoxDecoration(
            color: selected ? AppColors.sidebarItemBackground : AppColors.none,
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(width: AppSpacing.md),

              Icon(
                icon,
                size: AppSizes.iconLg,
                color: selected
                    ? Colors.white
                    : (isLogout
                          ? AppColors.primaryDark
                          : AppColors.textSecondary),
              ),

              if (expanded) ...[
                const SizedBox(width: AppSpacing.md),

                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.sidebarItem.copyWith(
                      color: selected
                          ? Colors.white
                          : (isLogout
                                ? AppColors.primaryDark
                                : AppColors.textSecondary),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
