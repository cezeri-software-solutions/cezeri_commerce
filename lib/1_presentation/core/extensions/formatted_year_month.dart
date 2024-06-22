//* Formatiert eine DateTime in einen String im folgenden Format: z.B. 2024-05
extension FormattedYearMonth on DateTime {
  String toFormattedYearMonth() {
    final formattedMonth = month.toString().padLeft(2, '0');
    return '$year-$formattedMonth';
  }
}

//* Formatiert eine DateTime in einen String im folgenden Format: z.B. 2024-05-28
extension FormattedYearMonthDay on DateTime {
  String toFormattedYearMonthDay() {
    final formattedMonth = month.toString().padLeft(2, '0');
    final formattedDay = day.toString().padLeft(2, '0');
    return '$year-$formattedMonth-$formattedDay';
  }
}
