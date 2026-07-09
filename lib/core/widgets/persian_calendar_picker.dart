

import 'package:flutter/material.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart' as shamsi;

class MyPersianCalendar extends StatefulWidget {
  const MyPersianCalendar({super.key});
  @override
  State<MyPersianCalendar> createState() => _MyPersianCalendar();
}

class _MyPersianCalendar extends State<MyPersianCalendar> {
  String selectedDate = "هنوز تاریخی انتخاب نشده";
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(selectedDate, style: const TextStyle(fontSize: 25)),
        const SizedBox(height: 50),

        ElevatedButton.icon(
          icon: const Icon(Icons.edit_calendar_outlined,size: 50,),
          label: const Text('انتخاب تاریخ شمسی',),
          onPressed: () async {
            shamsi.Jalali? picked = await shamsi.showPersianDatePicker(
              context: context,
              initialDate: shamsi.Jalali.now(),
              firstDate: shamsi.Jalali(1400, 1),
              lastDate: shamsi.Jalali(1405, 12),
              barrierColor: const Color.fromARGB(250, 250, 250, 250),
              holidayConfig: shamsi.PersianHolidayConfig(weekendDays: {7}),
              initialEntryMode: shamsi.PersianDatePickerEntryMode.calendarOnly,
              initialDatePickerMode: shamsi.PersianDatePickerMode.day,
                builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: Colors.red,
                      onPrimary: Colors.white,
                      surface: Colors.white,
                      onSurface: Colors.black
                    ),
                    dialogTheme: const DialogThemeData(
                      backgroundColor: Colors.white,
                    ),
                  ),
                  child: MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      textScaler :  const TextScaler.linear(0.85),
                    ),
                     child: child!));
                }

            );
            if (picked != null) {
                selectedDate = picked.formatFullDate();
                final forMatedDate = picked.formatFullDate();
                final gregorianDate = picked.toGregorian();
                final utcDateTime = picked.toDateTime();
                debugPrint ('تاریخ شمسی  $forMatedDate');
                  debugPrint('تاریخ میلادی: ${gregorianDate.year}/${gregorianDate.month}/${gregorianDate.day}');
                  debugPrint('$utcDateTime');
              setState(() {
                selectedDate = forMatedDate;
              });
            }
          },
        ),
      ],
    );
  }
}
