import 'package:easy_localization/easy_localization.dart';

class MyDateUtils {
  static String formatDate(DateTime? date) {
    if (date == null) {
      return '';
    }
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  static String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) {
      return '';
    }
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}   ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  static String formatDayName(DateTime dateTime, String locale) {
    final DateFormat dayFormatter = DateFormat('EEEE', locale);
    return dayFormatter.format(dateTime);
  }

  static String formatDateTime2(DateTime? dateTime) {
    if (dateTime == null) return '';
    final DateFormat dateFormatter = DateFormat('M-d-yyyy | HH:mm');
    return dateFormatter.format(dateTime);
      // '${formatDayName(dateTime, userLocale.toString())} ${dateFormatter.format(dateTime)}';
  }
}
