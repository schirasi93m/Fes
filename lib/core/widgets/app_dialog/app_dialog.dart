import 'package:flutter/material.dart';

class AppDialog {
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: title != null ? Text(title) : null,
          content: child,
        );
      },
    );
  }
}