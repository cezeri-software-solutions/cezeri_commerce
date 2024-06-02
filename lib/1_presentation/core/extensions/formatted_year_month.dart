extension FormattedYearMonth on DateTime {
  String toFormattedYearMonth() {
    final formattedMonth = month.toString().padLeft(2, '0');
    return '$year-$formattedMonth';
  }
}
