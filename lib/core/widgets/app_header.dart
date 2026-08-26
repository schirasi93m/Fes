import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:new_project_fes/core/theme/app_icons.dart';

import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';
import '../theme/app_sizes.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_style.dart';
import 'api_status_indicator.dart';
import 'app_button.dart';

class AppHeader extends StatefulWidget {
  final String title;
  final VoidCallback? onMenuPressed;

  const AppHeader({
    super.key,
    required this.title,
    this.onMenuPressed,
  });

  @override
  State<AppHeader> createState() => _AppHeaderState();
}

class _AppHeaderState extends State<AppHeader> {
  late DateTime _currentDateTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _currentDateTime = DateTime.now();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _updateDateTime(),
    );
  }

  void _updateDateTime() {
    if (!mounted) {
      return;
    }

    setState(() {
      _currentDateTime = DateTime.now();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(DateTime dateTime) {
    return intl.DateFormat.Hms().format(dateTime);
  }

  String _formatDate(DateTime dateTime) {
    return intl.DateFormat.yMd().format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: AppSizes.appBarHeight,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
        ),
        decoration: BoxDecoration(
          color: AppColors.headerBackground,
          boxShadow: AppShadows.card,
        ),
        child: Row(
          children: [
            // -----------------------------------------------------------------
            // Title
            // -----------------------------------------------------------------

            Text(
              widget.title,
              style: AppTextStyles.sidebarTitle,
            ),

            const SizedBox(width: AppSpacing.lg),

            // -----------------------------------------------------------------
            // Menu
            // -----------------------------------------------------------------

            AppButton(
              icon: AppIcons.menu,
              onPressed: widget.onMenuPressed,
              type: AppButtonType.text,
            ),

            const Spacer(),

            // -----------------------------------------------------------------
            // Date & Time
            // -----------------------------------------------------------------

            _buildDateTime(),

            const SizedBox(width: AppSpacing.lg),

            // -----------------------------------------------------------------
            // API Status
            // -----------------------------------------------------------------

            const ApiStatusIndicator(),

            const SizedBox(width: AppSpacing.md),

            // -----------------------------------------------------------------
            // Notification
            // -----------------------------------------------------------------

            AppButton(
              icon: AppIcons.bell,
              onPressed: () {},
              type: AppButtonType.text,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTime() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _formatTime(_currentDateTime),
            textDirection: TextDirection.ltr,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.onPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            _formatDate(_currentDateTime),
            textDirection: TextDirection.ltr,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.sidebarTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}