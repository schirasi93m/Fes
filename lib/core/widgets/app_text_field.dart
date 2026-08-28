import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import '../theme/app_radius.dart';
import 'app_field_base.dart';

class AppTextField extends AppFieldBase {
  final TextEditingController? controller;
  final bool obscureText;
  final int maxLines;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;

  const AppTextField({
    super.key,
    this.controller,
    super.label,
    super.requiredField,
    super.hint,
    super.prefixIcon,
    super.suffixIcon,
    this.obscureText = false,
    super.readOnly,
    super.enabled,
    super.autofocus,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    super.focusNode,
    this.onChanged,
    super.onTap,
    super.validator,
    super.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveController = controller ?? TextEditingController();

    return _TextFieldWithClear(
      controller: effectiveController,
      enabled: enabled,
      readOnly: readOnly,
      obscureText: obscureText,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      focusNode: focusNode,
      onChanged: onChanged,
      onTap: onTap,
      validator: validator,
      label: label,
      requiredField: requiredField,
      hint: hint,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
    );
  }
}

class _TextFieldWithClear extends StatefulWidget {
  final TextEditingController controller;
  final bool enabled;
  final bool readOnly;
  final bool obscureText;
  final int maxLines;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? validator;
  final String? label;
  final bool requiredField;
  final String? hint;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const _TextFieldWithClear({
    required this.controller,
    required this.enabled,
    required this.readOnly,
    required this.obscureText,
    required this.maxLines,
    required this.keyboardType,
    this.inputFormatters,
    this.focusNode,
    this.onChanged,
    this.onTap,
    this.validator,
    this.label,
    required this.requiredField,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  State<_TextFieldWithClear> createState() => _TextFieldWithClearState();
}

class _TextFieldWithClearState extends State<_TextFieldWithClear> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(covariant _TextFieldWithClear oldWidget) {
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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final hasText = widget.controller.text.isNotEmpty;

    return TextFormField(
      controller: widget.controller,
      obscureText: widget.obscureText,
      readOnly: widget.readOnly,
      enabled: widget.enabled,
      maxLines: widget.maxLines,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      focusNode: widget.focusNode,
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      validator: widget.validator,
      decoration: InputDecoration(
        label: widget.label == null
            ? null
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(widget.label!),
                  if (widget.requiredField)
                    const Text(
                      ' *',
                      style: TextStyle(color: AppColors.danger),
                    ),
                ],
              ),
        hintText: widget.hint,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon ??
            (hasText && widget.enabled && !widget.readOnly
                ? IconButton(
                    onPressed: () {
                      widget.controller.clear();
                      widget.onChanged?.call('');
                    },
                    splashRadius: 18,
                    tooltip: 'پاک کردن مقدار',
                    icon: Icon(
                      AppIcons.close,
                      color: AppColors.textSecondary,
                    ),
                  )
                : null),
        enabled: widget.enabled,
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.textField),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.textField),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.textField),
          borderSide: BorderSide(color: AppColors.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.textField),
          borderSide: BorderSide(color: AppColors.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.textField),
          borderSide: BorderSide(color: AppColors.danger),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.textField),
          borderSide: BorderSide(color: AppColors.border),
        ),
      ),
    );
  }
}
