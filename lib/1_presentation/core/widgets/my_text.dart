import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  final String data;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;

  // Hier können Sie weitere Eigenschaften des Text-Widgets hinzufügen, falls benötigt.

  const MyText(
    this.data, {
    Key? key,
    this.style,
    this.textAlign,
    this.overflow,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Verwenden Sie die TextStyle.merge()-Methode, um den Standard-fontSize zu setzen,
    // aber überschreiben Sie ihn, wenn ein anderer Style übergeben wird.
    TextStyle effectiveStyle = const TextStyle(fontSize: 12).merge(style);

    return Text(
      data,
      style: effectiveStyle,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }
}
