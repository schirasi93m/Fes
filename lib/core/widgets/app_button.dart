import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_sizes.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_style.dart';

enum AppButtonType { filled, outlined, text, icon }

enum AppButtonSize { small, medium, large }

class AppButton extends StatelessWidget {
  final String? text;
  final IconData? icon;

  final VoidCallback? onPressed;

  final AppButtonType type;
  final AppButtonSize size;

  final bool isLoading;
  final bool enabled;

  final double? width;
  final double? height;

  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? iconColor;
  final Color? textColor;
  final Color? hoverColor;

  final EdgeInsetsGeometry? padding;

  final String? tooltip;

  const AppButton({
    super.key,
    this.text,
    this.icon,
    required this.onPressed,
    this.type = AppButtonType.filled,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.enabled = true,
    this.width,
    this.height,
    this.backgroundColor,
    this.foregroundColor,
    this.iconColor,
    this.textColor,
    this.hoverColor,
    this.padding,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color fgColor;
    BorderSide border;

    switch (type) {
      case AppButtonType.filled:
        bgColor = backgroundColor ?? AppColors.primary;
        fgColor = foregroundColor ?? AppColors.onPrimary;
        border = BorderSide.none;
        break;

      case AppButtonType.outlined:
        bgColor = Colors.transparent;
        fgColor = foregroundColor ?? AppColors.primary;
        border = BorderSide(color: fgColor);
        break;

      case AppButtonType.text:
        bgColor = Colors.transparent;
        fgColor = foregroundColor ?? AppColors.primary;
        border = BorderSide.none;
        break;

      case AppButtonType.icon:
        bgColor = Colors.transparent;
        fgColor = foregroundColor ?? AppColors.primary;
        border = BorderSide.none;
        break;
    }

    double buttonHeight;
    double iconSize;
    double fontSize;
    EdgeInsetsGeometry buttonPadding;

    switch (size) {
      case AppButtonSize.small:
        buttonHeight = AppSizes.buttonHeightSm;
        iconSize = AppSizes.buttonIconSm;
        fontSize = AppSizes.buttonFontSm;
        buttonPadding =
            padding ?? const EdgeInsets.symmetric(horizontal: AppSpacing.md);
        break;

      case AppButtonSize.medium:
        buttonHeight = AppSizes.buttonHeightMd;
        iconSize = AppSizes.buttonIconMd;
        fontSize = AppSizes.buttonFontMd;
        buttonPadding =
            padding ?? const EdgeInsets.symmetric(horizontal: AppSpacing.lg);
        break;

      case AppButtonSize.large:
        buttonHeight = AppSizes.buttonHeightLg;
        iconSize = AppSizes.buttonIconLg;
        fontSize = AppSizes.buttonFontLg;
        buttonPadding =
            padding ?? const EdgeInsets.symmetric(horizontal: AppSpacing.xl);
        break;
    }

    final bool iconOnly =
        type == AppButtonType.icon ||
        (icon != null && (text == null || text!.trim().isEmpty));

    Widget child;

    if (isLoading) {
      child = SizedBox(
        width: AppSizes.progressIndicatorMd,
        height: AppSizes.progressIndicatorMd,
        child: CircularProgressIndicator(
          strokeWidth: AppSizes.progressStrokeWidth,
          color: fgColor,
        ),
      );
    } else if (iconOnly) {
      child = Center(
        child: Icon(icon, size: iconSize, color: iconColor ?? fgColor),
      );
    } else if (icon != null) {
      child = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: iconSize, color: iconColor ?? fgColor),
          const SizedBox(width: AppSpacing.sm),
          Flexible(
            child: Text(
              text ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.button.copyWith(
                fontSize: fontSize,
                color: textColor ?? fgColor,
              ),
            ),
          ),
        ],
      );
    } else {
      child = Text(
        text ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.button.copyWith(
          fontSize: fontSize,
          color: textColor ?? fgColor,
        ),
      );
    }

    Widget button = SizedBox(
      width: width ?? (iconOnly ? AppSizes.iconButtonSize : null),
      height: height ?? (iconOnly ? AppSizes.iconButtonSize : buttonHeight),
      child: ElevatedButton(
        onPressed: (!enabled || isLoading) ? null : onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          alignment: Alignment.center,
          minimumSize: Size.zero,
          padding: iconOnly ? EdgeInsets.zero : buttonPadding,
          backgroundColor: bgColor,
          foregroundColor: fgColor,

          disabledBackgroundColor: AppColors.border,
          disabledForegroundColor: AppColors.disabled,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
            side: border,
          ),
        ),
        child: Directionality(textDirection: TextDirection.ltr, child: child),
      ),
    );

    if (tooltip != null && tooltip!.isNotEmpty) {
      button = Tooltip(message: tooltip!, child: button);
    }

    return button;
  }
}
