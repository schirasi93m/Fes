import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_sizes.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_style.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.footerHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      color: AppColors.footerBackground,
      child: Row(
        children: [
          Text(
            "نسخه 1.0.0",
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.sidebarTextSecondary,
            ),
          ),

          const Spacer(),

          Text(
            "© Imen Shahr FES",
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.sidebarTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
