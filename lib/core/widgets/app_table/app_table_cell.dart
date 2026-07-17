import 'package:flutter/material.dart';
import '../../theme/app_spacing.dart';

class AppTableCell extends StatelessWidget {
  final double width;
  final Widget child;
  final Alignment alignment;

  const AppTableCell({
    super.key,
    required this.width,
    required this.child,
    this.alignment = Alignment.centerRight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      alignment: alignment,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.lg,
      ),
      child: child,
    );
  }
}