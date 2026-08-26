import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_style.dart';

class AppDateTime extends StatefulWidget {
  const AppDateTime({super.key});

  @override
  State<AppDateTime> createState() => _AppDateTimeState();
}

class _AppDateTimeState extends State<AppDateTime> {
  late DateTime _dateTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _dateTime = DateTime.now();

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
      _dateTime = DateTime.now();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _time {
    return intl.DateFormat('HH:mm:ss').format(_dateTime);
  }


  String get _date {
    final jalali = Jalali.fromDateTime(_dateTime);

    return _toPersianDigits(jalali.formatFullDate());
  } 


  String _toPersianDigits(String value) {
    const englishDigits = '0123456789';
    const persianDigits = '۰۱۲۳۴۵۶۷۸۹';

    return value.split('').map((character) {
      final index = englishDigits.indexOf(character);

      if (index == -1) {
        return character;
      }

      return persianDigits[index];
    }).join();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _time,
                textDirection: TextDirection.ltr,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                _date,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.sidebarTextSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
