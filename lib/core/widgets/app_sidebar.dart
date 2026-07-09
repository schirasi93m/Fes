import 'package:flutter/material.dart';
import 'package:new_project_fes/core/theme/app_opacities.dart';

import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import '../theme/app_sizes.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_style.dart';

class AppSidebar extends StatelessWidget {
  final bool extended;

  final int selectedIndex;

  final ValueChanged<int> onDestinationSelected;

  final List<NavigationRailDestination> destinations;

  final Widget? trailing;

  const AppSidebar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
    this.extended = true,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      backgroundColor: AppColors.sidebarBackground,

      extended: extended,

      minWidth: AppSizes.navigationRailWidth,

      minExtendedWidth: AppSizes.drawerWidth,

      selectedIndex: selectedIndex,

      onDestinationSelected: onDestinationSelected,

      labelType: NavigationRailLabelType.none,

      groupAlignment: -1,

      leading: Padding(
        padding: const EdgeInsets.only(
          top: AppSpacing.lg,
          bottom: AppSpacing.lg,
        ),
        child: Column(
          children: [
            Icon(
              AppIcons.extinguisher,
              color: AppColors.primary,
              size: AppSizes.logoSize,
            ),

            if (extended) ...[
              const SizedBox(height: AppSpacing.md),

              Text(
                "ایمن شهر",
                style: AppTextStyles.sidebarTitle,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.xs),

              Text(
                "مدیریت کپسول آتش‌نشانی",
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],

            const SizedBox(height: AppSpacing.lg),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              height: 1,
              color: AppColors.border,
            ),
          ],
        ),
      ),

      trailing: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
        child: trailing,
      ),

      selectedIconTheme: IconThemeData(
        color: AppColors.primary,
        size: AppSizes.iconLg,
      ),

      unselectedIconTheme: IconThemeData(
        color: AppColors.textSecondary,
        size: AppSizes.iconLg,
      ),

      selectedLabelTextStyle: AppTextStyles.sidebarItem.copyWith(
        color: AppColors.primary,
      ),

      unselectedLabelTextStyle: AppTextStyles.sidebarItem.copyWith(
        color: AppColors.textSecondary,
      ),

      indicatorColor: AppColors.primary.withValues(
        alpha: AppOpacities.sidebarIndicator,
      ),

      useIndicator: true,

      destinations: destinations,
    );
  }
}
