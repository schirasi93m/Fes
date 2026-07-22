import 'package:flutter/material.dart';
import 'package:new_project_fes/core/theme/app_colors.dart';
import 'package:new_project_fes/core/theme/app_icons.dart';
import 'package:new_project_fes/core/theme/app_radius.dart';
import 'package:new_project_fes/core/theme/app_spacing.dart';
import 'package:new_project_fes/core/theme/app_sizes.dart';
import 'package:new_project_fes/core/theme/app_text_style.dart';

class AppNotifier {
  AppNotifier._();

  static void success(BuildContext context, String message) {
    _show(context, message, AppColors.success, AppIcons.success);
  }

  static void error(BuildContext context, String message) {
    _show(context, message, AppColors.danger, AppIcons.error);
  }

  static void warning(BuildContext context, String message) {
    _show(context, message, AppColors.warning, AppIcons.warning);
  }

  static void info(BuildContext context, String message) {
    _show(context, message, AppColors.primary, AppIcons.info);
  }

  static void _show(
    BuildContext context,
    String message,
    Color color,
    IconData icon,
  ) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        width: AppSizes.notificationWidth,
        elevation: AppSizes.notificationElevation,
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.notifer),
        ),
        content: Row(
          children: [
            Icon(icon, color: AppColors.surface, size: AppSizes.iconMd),

            const SizedBox(width: AppSpacing.md),

            Expanded(
              child: Text(
                message,
                style: AppTextStyles.notification.copyWith(
                  color: AppColors.surface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
