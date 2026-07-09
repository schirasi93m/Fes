import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_shadows.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_style.dart';

class AppCard extends StatelessWidget {
  final String title;
  final String value;
  final Widget? icon;
  final Widget? footer;
  final VoidCallback? onTap;
  final Color? color;

  const AppCard({
    super.key,
    required this.title,
    required this.value,
    this.icon,
    this.footer,
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Ink(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: color ?? AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.card),
            boxShadow: AppShadows.card,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (icon != null) icon!,
                  const Spacer(),
                  Text(title, style: AppTextStyles.titleMedium),
                ],
              ),

              const SizedBox(height: AppSpacing.lg),

              Text(value, style: AppTextStyles.titleLarge),

              if (footer != null) ...[
                const SizedBox(height: AppSpacing.md),
                footer!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
