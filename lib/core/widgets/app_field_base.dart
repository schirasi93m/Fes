import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';

abstract class AppFieldBase extends StatelessWidget {
  final String? label;
  final bool requiredField;
  final String? hint;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool readOnly;
  final bool enabled;
  final bool autofocus;
  final FocusNode? focusNode;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;

  const AppFieldBase({
    super.key,
    this.label,
    this.requiredField = false,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly = false,
    this.enabled = true,
    this.autofocus = false,
    this.focusNode,
    this.onTap,
    this.validator,
    this.inputFormatters,
  });

  InputDecoration fieldDecoration({
    EdgeInsetsGeometry contentPadding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.md,
    ),
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      label: label == null
          ? null
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label!),
                if (requiredField)
                  const Text(
                    ' *',
                    style: TextStyle(color: AppColors.danger),
                  ),
              ],
            ),
      hintText: hint,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon ?? this.suffixIcon,
      enabled: enabled,
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: contentPadding,
      border: _border(AppColors.border),
      enabledBorder: _border(AppColors.border),
      focusedBorder: _border(AppColors.primary),
      errorBorder: _border(AppColors.danger),
      focusedErrorBorder: _border(AppColors.danger),
      disabledBorder: _border(AppColors.border),
    );
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.textField),
      borderSide: BorderSide(color: color),
    );
  }
}