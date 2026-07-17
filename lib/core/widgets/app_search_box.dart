import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import '../theme/app_radius.dart';
import '../theme/app_sizes.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_style.dart';

class AppSearchBox extends StatefulWidget {
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
  State<AppSearchBox> createState() => _AppSearchBoxState();
}

class _AppSearchBoxState extends State<AppSearchBox> {
  @override
  void initState() {
    super.initState();
    // با هر تغییر متن (حتی برنامه‌ای، نه فقط تایپ کاربر) دوباره build میشه
    // تا آیکون × همیشه با وضعیت واقعی controller هماهنگ بمونه.
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(covariant AppSearchBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onControllerChanged);
      widget.controller.addListener(_onControllerChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    // فقط برای rebuild کردن خود ویجت لازمه، چیزی داخلش تغییر نمی‌کنه.
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.textFieldHeight,
      child: TextField(
        controller: widget.controller,
        onChanged: widget.onChanged,
        style: AppTextStyles.bodyMedium,
        decoration: InputDecoration(
          hintText: widget.hintText,

          hintStyle: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),

          filled: true,
          fillColor: AppColors.surface,

          prefixIcon: Icon(AppIcons.search, color: AppColors.textSecondary),

          suffixIcon:widget. controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(AppIcons.close, color: AppColors.textSecondary),
                  onPressed: () {
                    widget. controller.clear();

                    if (widget. onClear != null) {
                      widget. onClear!();
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
