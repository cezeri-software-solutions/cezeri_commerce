extension FormattedYearMonth on DateTime {
  String toFormattedYearMonth() {
    final formattedMonth = month.toString().padLeft(2, '0');
    return '$year-$formattedMonth';
  }
}

extension FormattedYearMonthDay on DateTime {
  String toFormattedYearMonthDay() {
    final formattedMonth = month.toString().padLeft(2, '0');
    final formattedDay = day.toString().padLeft(2, '0');
    return '$year-$formattedMonth-$formattedDay';
  }
}
