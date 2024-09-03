//* Formatiert eine DateTime in einen String im folgenden Format: z.B. 2024-05
import 'package:intl/intl.dart';

extension ConvertedYearMonth on DateTime {
  String toConvertedYearMonth() {
    final formattedMonth = month.toString().padLeft(2, '0');
    return '$year-$formattedMonth';
  }
}

//* Formatiert eine DateTime in einen String im folgenden Format: z.B. 2024-05-28
extension ConvertedYearMonthDay on DateTime {
  String toConvertedYearMonthDay() {
    final formattedMonth = month.toString().padLeft(2, '0');
    final formattedDay = day.toString().padLeft(2, '0');
    return '$year-$formattedMonth-$formattedDay';
  }
}

//* Formatiert eine DateTime in einen String im folgenden Format: z.B. 01.12.1991
extension FormattedDayMonthYear on DateTime {
  String toFormattedDayMonthYear() => DateFormat('dd.MM.yyy', 'de').format(this);
}

//* Formatiert eine DateTime in einen String im folgenden Format: z.B. 01.12.1991 - 23:59:59
extension FormattedDayMonthYearHour on DateTime {
  String toFormattedDayMonthYearHour() => DateFormat('dd.MM.yyy - HH:mm:ss', 'de').format(this);
}
