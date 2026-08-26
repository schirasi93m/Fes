import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import '../theme/app_colors.dart';
import '../theme/app_durations.dart';
import '../theme/app_icons.dart';
import '../theme/app_shadows.dart';
import '../theme/app_sizes.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_style.dart';
import 'api_status_indicator.dart';
import 'app_button.dart';

class AppHeader extends StatefulWidget {
  final String title;
  final VoidCallback? onMenuPressed;

  const AppHeader({super.key, required this.title, this.onMenuPressed});

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
    _timer = Timer.periodic(AppDurations.clockUpdate, (_) => _updateDateTime());
  }

  void _updateDateTime() {
    if (!mounted) {
      return;
    }

    setState(() => _currentDateTime = DateTime.now());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(DateTime dateTime) => intl.DateFormat.Hms().format(dateTime);

  String _formatDate(DateTime dateTime) => intl.DateFormat.yMd().format(dateTime);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: AppSizes.appBarHeight,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.headerBackground,
          boxShadow: AppShadows.card,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow =
                constraints.maxWidth < AppSizes.headerCompactBreakpoint;

            return Row(
              children: [
                Text(widget.title, style: AppTextStyles.sidebarTitle),
                SizedBox(width: isNarrow ? AppSpacing.sm : AppSpacing.lg),
                AppButton(
                  icon: AppIcons.menu,
                  onPressed: widget.onMenuPressed,
                  type: AppButtonType.text,
                ),
                const Spacer(),
                if (!isNarrow) ...[
                  _buildDateTime(),
                  const SizedBox(width: AppSpacing.lg),
                  const ApiStatusIndicator(),
                  const SizedBox(width: AppSpacing.md),
                ],
                AppButton(
                  icon: AppIcons.bell,
                  onPressed: () {},
                  type: AppButtonType.text,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDateTime() {
    return Column(
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
    );
  }
}
