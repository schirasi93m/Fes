import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import '../theme/app_sizes.dart';
import '../theme/app_spacing.dart';
import 'app_field_base.dart';

class AppNumberField extends AppFieldBase {
  final TextEditingController controller;
  final double min;
  final double? max;
  final double step;
  final int decimalDigits;
  final ValueChanged<double>? onChanged;
  final ValueChanged<String>? onTextChanged;

  const AppNumberField({
    super.key,
    required this.controller,
    super.label,
    super.requiredField,
    super.hint,
    super.prefixIcon,
    super.suffixIcon,
    this.min = 0,
    this.max,
    this.step = 1,
    this.decimalDigits = 0,
    super.readOnly,
    super.enabled,
    super.autofocus,
    super.focusNode,
    this.onChanged,
    this.onTextChanged,
    super.onTap,
    super.validator,
    super.inputFormatters,
  });

  double _currentValue() {
    return double.tryParse(controller.text) ?? min;
  }

  void _setValue(double value) {
    final double nextValue = max == null
        ? value.clamp(min, double.infinity).toDouble()
        : value.clamp(min, max!).toDouble();

    final String text = decimalDigits == 0
        ? nextValue.toInt().toString()
        : nextValue.toStringAsFixed(decimalDigits);

    controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );

    onChanged?.call(nextValue);
  }

  @override
  Widget build(BuildContext context) {
    final hasText = controller.text.isNotEmpty;

    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      enabled: enabled,
      autofocus: autofocus,
      focusNode: focusNode,
      onChanged: (value) {
        onTextChanged?.call(value);
      },
      onTap: onTap,
      validator: validator,
      inputFormatters: inputFormatters,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: fieldDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasText && enabled && !readOnly)
              IconButton(
                onPressed: () {
                  controller.clear();
                  onTextChanged?.call('');
                },
                splashRadius: 18,
                tooltip: 'پاک کردن مقدار',
                icon: Icon(AppIcons.close, color: AppColors.textSecondary),
              ),
            suffixIcon ?? const SizedBox.shrink(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: enabled && !readOnly
                      ? () => _setValue(_currentValue() + step)
                      : null,
                  child: SizedBox(
                    width: AppSizes.iconLg,
                    height: AppSizes.iconLg,
                    child: const Icon(Icons.keyboard_arrow_up_rounded),
                  ),
                ),
                InkWell(
                  onTap: enabled && !readOnly
                      ? () => _setValue(_currentValue() - step)
                      : null,
                  child: SizedBox(
                    width: AppSizes.iconLg,
                    height: AppSizes.iconLg,
                    child: const Icon(Icons.keyboard_arrow_down_rounded),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
