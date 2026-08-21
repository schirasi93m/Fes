import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_sizes.dart';
import '../theme/app_spacing.dart';

class AppSelector<T> extends StatelessWidget {
  final String label;
  final String hint;
  final T? value;
  final List<T> items;
  final String Function(T item) itemLabel;
  final ValueChanged<T?> onChanged;
  final bool enabled;

  const AppSelector({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    this.enabled = true,
  });

  Future<void> _showItems(BuildContext context) async {
    if (!enabled) {
      return;
    }

    final selected = await showDialog<T>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text(label),
          contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          content: SizedBox(
            width: AppSizes.dialogWidth,
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: items.length,
              separatorBuilder: (_, _) =>
                  Divider(color: AppColors.border, height: 1),
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = item == value;

                return ListTile(
                  title: Text(itemLabel(item), overflow: TextOverflow.ellipsis),
                  trailing: isSelected
                      ? Icon(Icons.check_rounded, color: AppColors.primary)
                      : null,
                  onTap: () {
                    Navigator.of(context).pop(item);
                  },
                );
              },
            ),
          ),
        );
      },
    );

    if (selected != null) {
      onChanged(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayValue = value == null ? hint : itemLabel(value as T);

    return InkWell(
      onTap: enabled ? () => _showItems(context) : null,
      borderRadius: BorderRadius.circular(AppRadius.textField),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          enabled: enabled,
          filled: true,
          fillColor: AppColors.surface,
          suffixIcon: Icon(
            Icons.keyboard_arrow_down_rounded,
            size: AppSizes.iconMd,
            color: enabled ? AppColors.textSecondary : AppColors.textDisabled,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.textField),
            borderSide: BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.textField),
            borderSide: BorderSide(color: AppColors.border),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.textField),
            borderSide: BorderSide(color: AppColors.border),
          ),
        ),
        child: Text(
          displayValue,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: value == null
                ? AppColors.textSecondary
                : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
