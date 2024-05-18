import 'dart:typed_data';

import 'package:http/http.dart' as http;

Future<Uint8List?> loadFileFromStorage(String url) async {
  try {
    // PDF-Datei von der Download-URL herunterladen
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Die heruntergeladene Datei als Uint8List speichern
      Uint8List pdfBytes = response.bodyBytes;
      return pdfBytes;
      // Hier kannst du die pdfBytes weiterverarbeiten, z.B. speichern oder anzeigen
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
}
