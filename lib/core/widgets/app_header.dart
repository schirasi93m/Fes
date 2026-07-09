import 'package:flutter/material.dart';
import 'package:new_project_fes/core/theme/app_icons.dart';

import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';
import '../theme/app_sizes.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_style.dart';
import 'app_button.dart';

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
        color: AppColors.surface,
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          //------------------------
          // Menu
          //------------------------
          AppButton(
            icon: AppIcons.menu,
            onPressed: onMenuPressed,
            type: AppButtonType.text,
          ),

          const SizedBox(width: AppSpacing.lg),

          //------------------------
          // Title
          //------------------------
          Text(title, style: AppTextStyles.sidebarTitle),

          //------------------------
          // Center
          //------------------------
          const Spacer(),

          //------------------------
          // Notification
          //------------------------
          AppButton(
            icon: AppIcons.bell,
            onPressed: () {},
            type: AppButtonType.text,
          ),

          const SizedBox(width: AppSpacing.sm),

          //------------------------
          // User
          //------------------------
          Row(
            children: [
              const CircleAvatar(
                radius: 16,
                child: Icon(AppIcons.user, size: AppSizes.iconMd),
              ),

              const SizedBox(width: AppSpacing.sm),

              Text("مصطفی شیرازی", style: AppTextStyles.bodyLarge
),
            ],
          ),

          const SizedBox(width: AppSpacing.md),

          //------------------------
          // Logout
          //------------------------
          AppButton(
            icon: AppIcons.logout,
            onPressed: () {},
            type: AppButtonType.text,
          ),
        ],
      ),
    );
  }
}
