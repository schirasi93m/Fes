import 'package:flutter/material.dart';
import 'package:new_project_fes/core/theme/app_colors.dart';
import 'package:new_project_fes/core/theme/app_spacing.dart';
import 'package:new_project_fes/core/widgets/app_button.dart';

class CustomerDeleteDialog extends StatelessWidget {
  const CustomerDeleteDialog({super.key});

  static Future<bool> show(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const CustomerDeleteDialog(),
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,

      title: const Center(child: Text("حذف مشتری")),

      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "آیا از حذف این مشتری مطمئن هستید؟",
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSpacing.lg),

          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppButton(
                text: "حذف",
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),

              const SizedBox(width: AppSpacing.sm),

              AppButton(
                text: "انصراف",
                type: AppButtonType.filled,
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
