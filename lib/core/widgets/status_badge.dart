import 'package:flutter/material.dart';
import 'package:new_project_fes/core/theme/app_colors.dart';
import 'package:new_project_fes/core/theme/app_radius.dart';
import 'package:new_project_fes/core/theme/app_spacing.dart';
import 'package:new_project_fes/core/theme/app_text_style.dart';

enum StatusBadgeType {
  success,
  warning,
  error,
  info,
}

class StatusBadge extends StatelessWidget {
  final String text;
  final StatusBadgeType type;
  final IconData? icon;

  const StatusBadge({
    super.key,
    required this.text,
    required this.type,
    this.icon,
  });

  Color get _backgroundColor {
    switch (type) {
      case StatusBadgeType.success:
        return AppColors.successBackground;

      case StatusBadgeType.warning:
        return AppColors.warningBackground;

      case StatusBadgeType.error:
        return AppColors.dangerBackground;

      case StatusBadgeType.info:
        return AppColors.infoBackground;
    }
  }

  Color get _foregroundColor {
    switch (type) {
      case StatusBadgeType.success:
        return AppColors.success;

      case StatusBadgeType.warning:
        return AppColors.warning;

      case StatusBadgeType.error:
        return AppColors.danger;

      case StatusBadgeType.info:
        return AppColors.info;
    }
  }

  IconData get _defaultIcon {
    switch (type) {
      case StatusBadgeType.success:
        return Icons.check_circle;

      case StatusBadgeType.warning:
        return Icons.warning_rounded;

      case StatusBadgeType.error:
        return Icons.cancel;

      case StatusBadgeType.info:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.badge),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon ?? _defaultIcon,
            color: _foregroundColor,
            size: 16,
          ),

          const SizedBox(width: AppSpacing.sm),

          Text(
            text,
            style: AppTextStyles.body.copyWith(
              color: _foregroundColor,
            ),
          ),
        ],
      ),
    );
  }
}