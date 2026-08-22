import 'package:flutter/material.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart' as shamsi;

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_sizes.dart';
import 'app_field_base.dart';

class MyPersianCalendar extends AppFieldBase {
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const MyPersianCalendar({
    super.key,
    required super.label,
    super.requiredField,
    required this.value,
    required this.onChanged,
    this.firstDate,
    this.lastDate,
    super.enabled,
  });

  static const int defaultFirstYear = 1400;
  static const int defaultFirstMonth = 1;

  static const int defaultLastYear = 1450;
  static const int defaultLastMonth = 12;

  static const int weekendDay = 7;

  Future<void> _openPicker(BuildContext context) async {
    if (!enabled) {
      return;
    }

    final currentDate = value != null
        ? shamsi.Jalali.fromDateTime(value!)
        : shamsi.Jalali.now();

    final minimumDate = firstDate != null
        ? shamsi.Jalali.fromDateTime(firstDate!)
        : shamsi.Jalali(defaultFirstYear, defaultFirstMonth);

    final maximumDate = lastDate != null
        ? shamsi.Jalali.fromDateTime(lastDate!)
        : shamsi.Jalali(defaultLastYear, defaultLastMonth);

    final picked = await shamsi.showPersianDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: minimumDate,
      lastDate: maximumDate,
      holidayConfig: const shamsi.PersianHolidayConfig(
        weekendDays: {weekendDay},
      ),
      initialEntryMode: shamsi.PersianDatePickerEntryMode.calendarOnly,
      initialDatePickerMode: shamsi.PersianDatePickerMode.day,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.onPrimary,
              surface: AppColors.surface,
              onSurface: AppColors.onSurface,
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );

    if (picked != null) {
      onChanged(picked.toDateTime());
    }
  }

  String _displayDate() {
    if (value == null) {
      return 'انتخاب تاریخ';
    }

    return shamsi.Jalali.fromDateTime(value!).formatCompactDate();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? () => _openPicker(context) : null,
      borderRadius: BorderRadius.circular(AppRadius.textField),
      child: InputDecorator(
        decoration: fieldDecoration(
          suffixIcon: Icon(
            Icons.edit_calendar_outlined,
            size: AppSizes.iconMd,
            color: enabled ? AppColors.textSecondary : AppColors.textDisabled,
          ),
        ),
        child: Text(
          _displayDate(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
