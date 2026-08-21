import 'package:flutter/material.dart';
import 'package:new_project_fes/core/theme/app_opacities.dart';
import 'package:new_project_fes/core/theme/app_radius.dart';
import 'package:new_project_fes/core/theme/app_sizes.dart';
import 'package:new_project_fes/core/theme/app_spacing.dart';
import '../theme/app_colors.dart';

class StatusToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String title;

  const StatusToggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.title = 'وضعیت',
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.stausToggle),
      onTap: () => onChanged(!value),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.stausToggle),
          border: Border.all(
            color: value ? AppColors.primary : AppColors.border,
          ),
          color: value
              ? AppColors.primary.withValues(alpha: AppOpacities.hover)
              : AppColors.surface,
        ),
        child: Row(
          children: [
            Container(
              width: AppSpacing.sm,
              height: AppSpacing.sm,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: value ? AppColors.success : AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Text(
              value ? 'فعال' : 'غیرفعال',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: value ? AppColors.success : AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Icon(
              value ? Icons.toggle_on_rounded : Icons.toggle_off_rounded,
              size: AppSizes.iconXl,
              color: value ? AppColors.success : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
