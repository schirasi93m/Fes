import 'package:flutter/material.dart';

import 'app_button.dart';

class AppFormActions extends StatelessWidget {
  final VoidCallback? onCancel;
  final VoidCallback? onSubmit;

  final String cancelText;
  final String submitText;

  final bool isSubmitting;

  const AppFormActions({
    super.key,
    this.onCancel,
    this.onSubmit,
    this.cancelText = 'انصراف',
    this.submitText = 'ثبت',
    this.isSubmitting = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AppButton(
          text: cancelText,
          type: AppButtonType.filled,
          onPressed: isSubmitting ? null : onCancel,
        ),
        const SizedBox(width: 8),
        AppButton(text: submitText, onPressed: isSubmitting ? null : onSubmit),
      ],
    );
  }
}
