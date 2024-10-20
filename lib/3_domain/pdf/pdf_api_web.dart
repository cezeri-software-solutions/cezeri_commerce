import 'dart:typed_data';

import 'package:universal_html/html.dart' as html;

class PdfApiWeb {
  static Future<void> openPdf({
    required String name,
    required Uint8List byteList,
    required bool showInBrowser,
  }) async {
    if (showInBrowser) {
      final blob = html.Blob([byteList], 'application/pdf');

      final url = html.Url.createObjectUrlFromBlob(blob);

      html.window.open(url, '_blank');

      html.Url.revokeObjectUrl(url);
    } else {
      final blob = html.Blob([byteList]);

      final url = html.Url.createObjectUrlFromBlob(blob);

      html.AnchorElement(href: url)
        ..target = 'blank'
        ..download = name
        ..click();

      html.Url.revokeObjectUrl(url);
    }
  }
}



   // final blob = html.Blob([byteList], 'application/pdf');

    // final url = html.Url.createObjectUrlFromBlob(blob);

    // html.window.open(url, '_blank');

    // html.Url.revokeObjectUrl(url);