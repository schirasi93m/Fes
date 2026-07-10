import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import '../theme/app_spacing.dart';
import 'app_button.dart';

class PageToolbar extends StatelessWidget {
  final String? primaryButtonText;

  final IconData? primaryButtonIcon;

  final VoidCallback? onPrimaryPressed;

  const PageToolbar({
    super.key,
    this.primaryButtonText,
    this.primaryButtonIcon,
    this.onPrimaryPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          if (primaryButtonText != null)
            AppButton(
              text: primaryButtonText!,
              icon: primaryButtonIcon ?? AppIcons.add,
              onPressed: onPrimaryPressed,
            ),
        ],
      ),
    );
  }
}
