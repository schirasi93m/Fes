import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'app_button.dart';

class AppDeleteDialog extends StatelessWidget {
  final String title;
  final String message;
  final String deleteText;
  final String cancelText;

  const AppDeleteDialog({
    super.key,
    required this.title,
    required this.message,
    this.deleteText = 'حذف',
    this.cancelText = 'انصراف',
  });

  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    String deleteText = 'حذف',
    String cancelText = 'انصراف',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AppDeleteDialog(
        title: title,
        message: message,
        deleteText: deleteText,
        cancelText: cancelText,
      ),
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: Center(child: Text(title)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, textAlign: TextAlign.center),

          const SizedBox(height: AppSpacing.lg),

          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppButton(
                text: deleteText,
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),

              const SizedBox(width: AppSpacing.sm),

              AppButton(
                text: cancelText,
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
