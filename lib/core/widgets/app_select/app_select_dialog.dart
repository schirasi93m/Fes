import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';
import '../../theme/app_text_style.dart';
import '../app_dialog.dart';
import 'app_select_item.dart';

class AppSelectDialog {
  AppSelectDialog._();

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required List<AppSelectItem<T>> items,
    double width = 450,
  }) async {
    final visibleItems = items.where((e) => e.visible).toList();

    return AppDialog.show<T>(
      context: context,
      title: title,
      width: width,
      content: SizedBox(
        width: width,
        child: visibleItems.isEmpty
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  child: Text("داده‌ای یافت نشد"),
                ),
              )
            : ListView.separated(
                shrinkWrap: true,
                itemCount: visibleItems.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final item = visibleItems[index];

                  return ListTile(
                    enabled: item.enabled,

                    leading: item.leading,

                    trailing: item.trailing,

                    title: Text(item.title, style: AppTextStyles.bodyMedium),

                    subtitle: item.subtitle == null
                        ? null
                        : Text(item.subtitle!, style: AppTextStyles.bodySmall),

                    onTap: () {
                      Navigator.pop(context, item.value);
                    },
                  );
                },
              ),
      ),
    );
  }
}
