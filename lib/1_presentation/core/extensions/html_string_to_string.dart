extension HtmlStringToStringExtension on String {
  String get htmlStringToString {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return replaceAll(exp, '').replaceAll('&nbsp;', ' ');
  }
}