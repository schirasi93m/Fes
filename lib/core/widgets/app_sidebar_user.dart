import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import '../theme/app_radius.dart';
import '../theme/app_sizes.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_style.dart';

class AppSidebarUser extends StatelessWidget {
  final String fullName;
  final String role;
  final VoidCallback? onTap;
  final bool expanded;

  const AppSidebarUser({
    super.key,
    required this.fullName,
    required this.role,
    required this.expanded,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (!expanded) {
      return Center(
        child: CircleAvatar(
          radius: AppSizes.avatarRadius,
          backgroundColor: AppColors.primary,
          child: Icon(
            AppIcons.user,
            color: AppColors.onPrimary,
            size: AppSizes.iconMd,
          ),
        ),
      );
    }
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.sidebarItemBackground,
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: AppSizes.avatarRadius,
              backgroundColor: AppColors.primary,
              child: Icon(
                AppIcons.user,
                color: AppColors.onPrimary,
                size: AppSizes.iconMd,
              ),
            ),

            const SizedBox(width: AppSpacing.md),
            if (expanded) ...[
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.sidebarItem,
                    ),

                    const SizedBox(height: AppSpacing.xs),

                    Text(
                      role,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.sidebarTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
