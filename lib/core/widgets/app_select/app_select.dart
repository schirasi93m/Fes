import 'package:flutter/material.dart';
import 'package:new_project_fes/core/theme/app_icons.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_sizes.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_style.dart';
import '../app_button.dart';
import 'app_select_dialog.dart';
import 'app_select_item.dart';

class AppSelect<T> extends StatelessWidget {
  final String? label;
  final String? hint;

  final T? value;

  final List<AppSelectItem<T>> items;

  final ValueChanged<T?>? onChanged;

  final Widget? prefixIcon;

  final bool enabled;

  final String dialogTitle;

  // Buttons
  final bool showAddButton;
  final bool showEditButton;

  final VoidCallback? onAddPressed;
  final VoidCallback? onEditPressed;

  const AppSelect({
    super.key,
    this.label,
    this.hint,
    this.value,
    required this.items,
    required this.onChanged,
    this.prefixIcon,
    this.enabled = true,
    this.dialogTitle = "انتخاب",
    this.showAddButton = false,
    this.showEditButton = false,
    this.onAddPressed,
    this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    final AppSelectItem<T>? selectedItem =
        items.where((e) => e.value == value).isNotEmpty
        ? items.firstWhere((e) => e.value == value)
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: AppTextStyles.bodyMedium),
          const SizedBox(height: AppSpacing.sm),
        ],

        Row(
          children: [
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(AppRadius.textField),

                onTap: enabled
                    ? () async {
                        final result = await AppSelectDialog.show<T>(
                          context: context,
                          title: dialogTitle,
                          items: items,
                        );

                        if (result != null) {
                          onChanged?.call(result);
                        }
                      }
                    : null,

                child: Ink(
                  height: AppSizes.textFieldHeight,

                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),

                  decoration: BoxDecoration(
                    color: enabled ? AppColors.surface : AppColors.disabled,

                    borderRadius: BorderRadius.circular(AppRadius.textField),

                    border: Border.all(color: AppColors.border),
                  ),

                  child: Row(
                    children: [
                      if (prefixIcon != null) ...[
                        prefixIcon!,
                        const SizedBox(width: AppSpacing.md),
                      ],

                      Expanded(
                        child: Text(
                          selectedItem?.title ?? hint ?? "",

                          overflow: TextOverflow.ellipsis,

                          style: selectedItem == null
                              ? AppTextStyles.bodyMedium.copyWith(
                                  color: Colors.grey,
                                )
                              : AppTextStyles.bodyMedium,
                        ),
                      ),

                      Icon(AppIcons.arrowDown, size: AppSizes.iconMd),
                    ],
                  ),
                ),
              ),
            ),

            if (showAddButton) ...[
              const SizedBox(width: AppSpacing.sm),

              SizedBox(
                width: AppSizes.iconButtonSize,
                height: AppSizes.iconButtonSize,

                child: AppButton(
                  icon: AppIcons.add,
                  onPressed: enabled ? onAddPressed : null,
                ),
              ),
            ],

            if (showEditButton) ...[
              const SizedBox(width: AppSpacing.sm),

              SizedBox(
                width: AppSizes.iconButtonSize,
                height: AppSizes.iconButtonSize,

                child: AppButton(
                  icon: AppIcons.edit,
                  type: AppButtonType.outlined,
                  onPressed: enabled ? onEditPressed : null,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
