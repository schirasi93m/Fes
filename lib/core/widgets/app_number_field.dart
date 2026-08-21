import 'package:flutter/material.dart';
import 'package:new_project_fes/core/theme/app_radius.dart';

import '../theme/app_colors.dart';
import '../theme/app_sizes.dart';
import '../theme/app_spacing.dart';

class AppNumberField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final double min;
  final double? max;
  final double step;
  final int decimalDigits;
  final ValueChanged<double>? onChanged;

  const AppNumberField({
    super.key,
    required this.controller,
    required this.label,
    this.min = 0,
    this.max,
    this.step = 1,
    this.decimalDigits = 0,
    this.onChanged,
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
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,

        filled: true,
        fillColor: AppColors.surface,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),

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

        suffixIcon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                _setValue(_currentValue() + step);
              },
              child: SizedBox(
                width: AppSizes.iconLg,
                height: AppSizes.iconLg,
                child: const Icon(Icons.keyboard_arrow_up_rounded),
              ),
            ),
            InkWell(
              onTap: () {
                _setValue(_currentValue() - step);
              },
              child: SizedBox(
                width: AppSizes.iconLg,
                height: AppSizes.iconLg,
                child: const Icon(Icons.keyboard_arrow_down_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
