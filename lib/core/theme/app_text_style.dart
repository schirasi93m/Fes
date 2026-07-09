import 'package:flutter/material.dart';
import 'package:new_project_fes/core/theme/app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // =========================
  // App
  // =========================

  static const TextStyle appName = TextStyle(
    fontFamily: 'BTitr',
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle companyName = TextStyle(
    fontFamily: 'BTitr',
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: AppColors.companyName,
  );

  static const TextStyle logo = TextStyle(
    fontSize: 40,
  );

  // =========================
  // Sidebar
  // =========================

  static const TextStyle sidebarTitle = TextStyle(
    fontFamily: 'BTitr',
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.appBarTitle,
  );

  static const TextStyle sidebarItem = TextStyle(
    fontFamily: 'Vazirmatn',
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.sidebarItem,
  );

  // =========================
  // Pages
  // =========================

  static const TextStyle pageTitle = TextStyle(
    fontFamily: 'Vazirmatn',
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );

  // =========================
  // Titles
  // =========================

  static const TextStyle titleLarge = TextStyle(
    fontFamily: 'Vazirmatn',
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: 'Vazirmatn',
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: 'Vazirmatn',
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  // =========================
  // Body
  // =========================

  // قدیمی (فعلاً حذف نشود)
  static const TextStyle body = TextStyle(
    fontFamily: 'Vazirmatn',
    fontSize: 14,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'Vazirmatn',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'Vazirmatn',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: 'Vazirmatn',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // =========================
  // Buttons
  // =========================

  static const TextStyle button = TextStyle(
    fontFamily: 'Vazirmatn',
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.onPrimary,
  );
}