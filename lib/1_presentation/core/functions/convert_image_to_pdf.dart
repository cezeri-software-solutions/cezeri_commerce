import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<Uint8List> convertImageToPdf(Uint8List imageData) async {
  // Erstelle ein neues PDF-Dokument
  final pdf = pw.Document();

  // Lade das Bild in das PDF-Dokument
  final image = pw.MemoryImage(imageData);

  // Füge eine Seite mit dem Bild hinzu
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4, // Du kannst die Seitengröße anpassen, z.B. A4 oder Letter
      build: (pw.Context context) {
        return pw.FullPage(
          ignoreMargins: true, // Entfernt Ränder
          child: pw.Image(image, fit: pw.BoxFit.fill), // Das Bild wird gestreckt, um die Seite zu füllen
        );
      },
    ),
  );

  // Konvertiere das PDF-Dokument in Uint8List
  return await pdf.save();
}
