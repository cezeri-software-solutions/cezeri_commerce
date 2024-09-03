import 'package:pdf/widgets.dart' as pw;

class PdfText extends pw.Text {
  PdfText(
    String data, {
    pw.TextStyle? style,
    pw.TextAlign? textAlign,
    int? maxLines,
    pw.TextOverflow? overflow,
    pw.TextDirection? textDirection,
    bool softWrap = true,
  }) : super(
          data,
          style: style ?? const pw.TextStyle(fontSize: 8),
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
          textDirection: textDirection,
          softWrap: softWrap,
        );
}
