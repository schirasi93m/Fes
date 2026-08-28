import 'package:shamsi_date/shamsi_date.dart' as shamsi;

class AppDateUtils {
  AppDateUtils._();

  /// میلادی DateTime → تاریخ شمسی برای نمایش
  static String toPersianDate(DateTime? date) {
    if (date == null) return '-';

    final jalali = shamsi.Jalali.fromDateTime(date);

    return '${jalali.year.toString().padLeft(4, '0')}/'
        '${jalali.month.toString().padLeft(2, '0')}/'
        '${jalali.day.toString().padLeft(2, '0')}';
  }

  /// میلادی DateTime → فرمت قابل ارسال به API
  /// خروجی: 2026-08-27
  static String toApiDate(DateTime? date) {
    if (date == null) return '';

    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  /// تاریخ API مثل 2026-08-27 → DateTime
  static DateTime? fromApiDate(dynamic value) {
    if (value == null || value.toString().isEmpty) {
      return null;
    }

    final text = value.toString();

    return DateTime.tryParse(text);
  }
}
