import 'package:flutter/material.dart';
import 'package:new_project_fes/core/theme/app_colors.dart';

import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';

class CustomerDialog extends StatelessWidget {
  const CustomerDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const CustomerDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: const Text("مشتری جدید"),
      content: SizedBox(
        width: AppSizes.dialogWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(
              label: "نام کامل",
            ),

            SizedBox(height: AppSpacing.md),

            AppTextField(
              label: "شماره تماس",
            ),

            SizedBox(height: AppSpacing.md),

            AppTextField(
              label: "آدرس",
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        AppButton(
          text: "انصراف",
          type: AppButtonType.filled,
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        AppButton(
          text: "ثبت",
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}