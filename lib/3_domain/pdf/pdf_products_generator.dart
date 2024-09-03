import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../constants.dart';
import '../entities/product/product.dart';
import 'widgets/pdf_text.dart';

class PdfProductsGenerator {
  static Future<Uint8List> generate({required List<Product> listOfProducts}) async {
    final myTheme = pw.ThemeData.withFont(
      base: pw.Font.ttf(await rootBundle.load('assets/font/Roboto-Regular.ttf')),
      bold: pw.Font.ttf(await rootBundle.load('assets/font/Roboto-Bold.ttf')),
    );

    final pdf = pw.Document(theme: myTheme);

    int i = 0;
    List<pw.MemoryImage?> listOfImages = [];
    for (final product in listOfProducts) {
      if (product.listOfProductImages.isEmpty) {
        listOfImages.add(null);
        continue;
      }

      final url = product.listOfProductImages.where((e) => e.isDefault).firstOrNull;
      if (url == null) {
        listOfImages.add(null);
        continue;
      }

      try {
        final response = await http.get(Uri.parse(url.fileUrl));
        if (response.statusCode == 200) {
          Uint8List imageBytes = Uint8List.fromList(response.bodyBytes);
          listOfImages.add(pw.MemoryImage(imageBytes));
        } else {
          listOfImages.add(null);
        }
      } catch (e) {
        logger.e(e);
      }
      logger.i(i);
      i++;
    }

    pdf.addPage(
      pw.MultiPage(
        header: (context) => pw.Column(children: [
          PdfText('Artikelliste', style: const pw.TextStyle(fontSize: 22)),
          pw.SizedBox(height: 10),
        ]),
        build: (context) {
          return [
            _buildPositions(listOfProducts, listOfImages),
          ];
        },
        footer: (context) {
          final text = 'Seite ${context.pageNumber} von ${context.pagesCount}';
          return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
            child: pw.Text(text, style: const pw.TextStyle(fontSize: 12)),
          );
        },
        maxPages: 200,
        margin: const pw.EdgeInsets.only(top: 30, left: 30, right: 30, bottom: 20),
      ),
    );
    return pdf.save();
  }

  static pw.Widget _buildPositions(List<Product> listOfProducts, List<pw.MemoryImage?> listOfUrl) {
    final headerTitles = [
      '',
      'Pos.',
      'Bild',
      'Artikelnummer / Bezeichnung',
      'VB',
      'LB',
    ];

    final data = [[]];
    int pos = 1;
    for (int i = 0; i < listOfProducts.length; i++) {
      final product = listOfProducts[i];
      final availableStock = product.availableStock;
      final availableColor = switch (availableStock) {
        0 => PdfColors.red,
        _ => PdfColors.black,
      };
      final warehouseStock = product.warehouseStock;
      final warehouseColor = switch (warehouseStock) {
        0 => PdfColors.red,
        _ => PdfColors.black,
      };
      final entry = [
        pw.Checkbox(value: false, name: 'Hallo'),
        pos,
        pw.SizedBox(height: 30, width: 30, child: listOfUrl[i] != null ? pw.Image(listOfUrl[i]!) : null),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.Row(
              children: [
                pw.Text(product.articleNumber, style: const pw.TextStyle(fontSize: 8)),
                if (!product.isActive) ...[
                  pw.SizedBox(width: 8),
                  pw.Text('Inaktiv', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: PdfColors.red)),
                ],
              ],
            ),
            pw.Text(product.name, style: const pw.TextStyle(fontSize: 8)),
          ],
        ),
        pw.Text('$availableStock', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: availableColor)),
        pw.Text('$warehouseStock', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: warehouseColor)),
      ];

      pos += 1;
      data.add(entry);
    }

    return pw.TableHelper.fromTextArray(
      headers: headerTitles,
      data: data,
      border: null,
      headerStyle: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      headerAlignment: pw.Alignment.centerLeft,
      cellStyle: const pw.TextStyle(fontSize: 8),
      columnWidths: {
        0: const pw.FlexColumnWidth(4),
        1: const pw.FlexColumnWidth(5),
        2: const pw.FlexColumnWidth(8),
        3: const pw.FlexColumnWidth(50),
        4: const pw.FlexColumnWidth(5),
        5: const pw.FlexColumnWidth(5),
      },
      headerAlignments: {
        0: pw.Alignment.topLeft,
        1: pw.Alignment.topLeft,
        2: pw.Alignment.topLeft,
        3: pw.Alignment.topLeft,
        4: pw.Alignment.topRight,
        5: pw.Alignment.topRight,
      },
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerLeft,
        3: pw.Alignment.centerLeft,
        4: pw.Alignment.centerRight,
        5: pw.Alignment.centerRight,
      },
    );
  }
}
