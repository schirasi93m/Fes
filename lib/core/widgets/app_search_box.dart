import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import '../theme/app_radius.dart';
import '../theme/app_sizes.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_style.dart';

class AppSearchBox extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  const AppSearchBox({
    super.key,
    required this.controller,
    this.hintText = "جستجو...",
    this.onChanged,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.textFieldHeight,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: AppTextStyles.bodyMedium,
        decoration: InputDecoration(
          hintText: hintText,

          hintStyle: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),

          filled: true,
          fillColor: AppColors.surface,

          prefixIcon: Icon(AppIcons.search, color: AppColors.textSecondary),

          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(AppIcons.close, color: AppColors.textSecondary),
                  onPressed: () {
                    controller.clear();

                    if (onClear != null) {
                      onClear!();
                    }
                  },
                )
              : null,

          contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.textField),
            borderSide: BorderSide(color: AppColors.border),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.textField),
            borderSide: BorderSide(color: AppColors.primary),
          ),
        ),
      ),
    );
  }
}
