import 'package:flutter/material.dart';
import 'package:new_project_fes/core/theme/app_icons.dart';

import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';
import '../theme/app_sizes.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_style.dart';
import 'app_button.dart';
import 'api_status_indicator.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onMenuPressed;

  const AppHeader({super.key, required this.title, this.onMenuPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.appBarHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.headerBackground,
        boxShadow: AppShadows.card,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow =
              constraints.maxWidth < AppSizes.headerCompactBreakpoint;

          return Row(
            children: [
          //------------------------
          // Menu
          //------------------------
          AppButton(
            icon: AppIcons.menu,
            onPressed: onMenuPressed,
            type: AppButtonType.text,
          ),

          SizedBox(width: isNarrow ? AppSpacing.sm : AppSpacing.lg),

          //------------------------
          // Title
          //------------------------
          Text(title, style: AppTextStyles.sidebarTitle),

          const Spacer(),

          if (!isNarrow) const ApiStatusIndicator(),

          if (!isNarrow) const SizedBox(width: AppSpacing.md),

          //------------------------
          // Notification
          //------------------------
          AppButton(
            icon: AppIcons.bell,
            onPressed: () {},
            type: AppButtonType.text,
          ),

          //------------------------
          // Center
          //------------------------
          if (!isNarrow) const SizedBox(width: AppSpacing.md),
            ],
          );
        },
      ),
    );
  }
}
