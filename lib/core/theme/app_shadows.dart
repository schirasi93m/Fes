import 'package:flutter/material.dart';
import 'package:new_project_fes/core/theme/app_colors.dart';
import 'package:new_project_fes/core/theme/app_offsets.dart';
import 'package:new_project_fes/core/theme/app_sizes.dart';

class AppShadows {
  AppShadows._();

  /// کارت‌های معمولی
  static const List<BoxShadow> card = [
    BoxShadow(
      color: AppColors.shadowLight,
      blurRadius: AppSizes.shadowBlurLg,
      offset: AppOffsets.cardShadow
    ),
  ];

  /// پنجره‌ها و Dialog
  static const List<BoxShadow> dialog = [
    BoxShadow(
      color: AppColors.shadowMedium,
      blurRadius: AppSizes.shadowBlurLg,
      offset: AppOffsets.dialogShadow
    ),
  ];

  /// دکمه‌ها
  static const List<BoxShadow> button = [
    BoxShadow(
      color: AppColors.shadowDark, //Color(0x19000000),
      blurRadius: AppSizes.shadowBlurSm,
      offset: AppOffsets.buttonShadow,
    ),
  ];

  /// منوها و Popup
  static const List<BoxShadow> popup = [
    BoxShadow(
      color:AppColors.shadowDark,
      blurRadius: AppSizes.shadowBlurMd,
      offset: AppOffsets.popupMenu,
    ),
  ];
}
