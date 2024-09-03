import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '/1_presentation/core/core.dart';
import '../entities/marketplace/abstract_marketplace.dart';
import '../entities/receipt/receipt.dart';
import 'widgets/pdf_text.dart';

const _borderTabels = pw.TableBorder(
  left: pw.BorderSide(color: PdfColors.grey, width: 0.5),
  right: pw.BorderSide(color: PdfColors.grey, width: 0.5),
  top: pw.BorderSide(color: PdfColors.grey, width: 0.5),
  bottom: pw.BorderSide(color: PdfColors.grey, width: 0.5),
  horizontalInside: pw.BorderSide(color: PdfColors.grey, width: 0.5),
  verticalInside: pw.BorderSide(color: PdfColors.grey, width: 0.5),
);

const _headersGroups = ['Pos', 'Anzahl', 'Anzahl %', 'Land', 'Summe', 'Summe %'];

const _columnWidthsGroups = {
  0: pw.FlexColumnWidth(8),
  1: pw.FlexColumnWidth(12),
  2: pw.FlexColumnWidth(15),
  3: pw.FlexColumnWidth(32),
  4: pw.FlexColumnWidth(18),
  5: pw.FlexColumnWidth(15),
};

const _headerAlignmentsGroups = {
  0: pw.Alignment.centerLeft,
  1: pw.Alignment.centerRight,
  2: pw.Alignment.centerRight,
  3: pw.Alignment.centerLeft,
  4: pw.Alignment.centerRight,
  5: pw.Alignment.centerRight,
};

const _cellAlignmentsGroups = {
  0: pw.Alignment.centerLeft,
  1: pw.Alignment.centerRight,
  2: pw.Alignment.centerRight,
  3: pw.Alignment.centerLeft,
  4: pw.Alignment.centerRight,
  5: pw.Alignment.centerRight,
};

pw.Table _tableHelperGroups(List<List<dynamic>> data) {
  return pw.TableHelper.fromTextArray(
    headers: _headersGroups,
    data: data,
    headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
    headerStyle: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
    cellStyle: const pw.TextStyle(fontSize: 8),
    border: _borderTabels,
    columnWidths: _columnWidthsGroups,
    headerAlignments: _headerAlignmentsGroups,
    cellAlignments: _cellAlignmentsGroups,
  );
}

class PdfOutgoingInvoicesGenerator {
  static Future<Uint8List> generate({
    required List<Receipt> listOfReceipts,
    List<AbstractMarketplace>? listOfMarketplaces,
    DateTimeRange? dateRange,
  }) async {
    final myTheme = pw.ThemeData.withFont(
      base: pw.Font.ttf(await rootBundle.load('assets/font/Roboto-Regular.ttf')),
      bold: pw.Font.ttf(await rootBundle.load('assets/font/Roboto-Bold.ttf')),
    );

    final pdf = pw.Document(theme: myTheme);
    bool isAnyFailureInConsecutiveInvoiceNumer = false;
    switch (listOfReceipts.first.receiptTyp) {
      case ReceiptType.offer:
        {
          listOfReceipts.sort((a, b) => a.offerId.compareTo(b.offerId));
        }
      case ReceiptType.appointment:
        {
          listOfReceipts.sort((a, b) => a.appointmentId.compareTo(b.appointmentId));
        }
      case ReceiptType.deliveryNote:
        {
          listOfReceipts.sort((a, b) => a.deliveryNoteId.compareTo(b.deliveryNoteId));
        }
      case ReceiptType.invoice || ReceiptType.credit:
        {
          listOfReceipts.sort((a, b) => a.invoiceId.compareTo(b.invoiceId));
        }
    }

    for (int i = 0; i < listOfReceipts.length; i++) {
      if ((listOfReceipts.first.receiptTyp == ReceiptType.invoice || listOfReceipts.first.receiptTyp == ReceiptType.credit) &&
          i > 0 &&
          listOfReceipts[i].invoiceId != listOfReceipts[i - 1].invoiceId + 1) {
        isAnyFailureInConsecutiveInvoiceNumer = true;
      }
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (context) {
          return [
            _buildTitle(listOfReceipts, dateRange),
            pw.SizedBox(height: 10),
            _buildPositions(listOfReceipts),
            pw.SizedBox(height: 20),
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                    child: pw.Column(
                        children: [_buildCountryGroupTitle(), pw.SizedBox(height: 10), _buildCountryGroupSum(listOfReceipts)],
                        crossAxisAlignment: pw.CrossAxisAlignment.start)),
                pw.SizedBox(width: 40),
                listOfMarketplaces != null
                    ? pw.Expanded(
                        child: pw.Column(children: [
                        _buildMarketplaceGroupTitle(),
                        pw.SizedBox(height: 10),
                        _buildMarketplaceGroupSum(listOfReceipts, listOfMarketplaces)
                      ], crossAxisAlignment: pw.CrossAxisAlignment.start))
                    : pw.Expanded(child: pw.SizedBox())
              ],
            ),
            if (listOfMarketplaces != null) ...[
              pw.SizedBox(height: 20),
              _buildMarketplaceCountryGroupTitle(),
              pw.SizedBox(height: 10),
              pw.Wrap(spacing: 40, runSpacing: 10, children: _buildMarketplaceCountryGroupSum(listOfReceipts, listOfMarketplaces)),
            ],
            if (isAnyFailureInConsecutiveInvoiceNumer) ...[
              pw.SizedBox(height: 40),
              _buildConsecutiveInvoiceNumberError(),
            ],
          ];
        },
        footer: (context) {
          final text = 'Seite ${context.pageNumber} von ${context.pagesCount}';
          return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
            child: pw.Text(text, style: const pw.TextStyle(fontSize: 8)),
          );
        },
        maxPages: 200,
        margin: const pw.EdgeInsets.only(top: 30, left: 30, right: 30, bottom: 20),
      ),
    );
    return pdf.save();
  }

  static pw.Widget _buildTitle(List<Receipt> listOfReceipts, DateTimeRange? dateRange) {
    final dateFormat = DateFormat('dd.MM.yyyy', 'de');
    String earliestDateString = '';
    String latestDateString = '';

    if (dateRange != null) {
      earliestDateString = dateFormat.format(dateRange.start);
      latestDateString = dateFormat.format(dateRange.end);
    } else {
      final dateTimes = listOfReceipts.map((e) => e.creationDate).toList();
      dateTimes.sort((a, b) => a.compareTo(b));
      earliestDateString = dateFormat.format(dateTimes.first);
      latestDateString = dateFormat.format(dateTimes.last);
    }

    final title = '$earliestDateString - $latestDateString';

    return pw.Text(title, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold));
  }

  static pw.Widget _buildPositions(List<Receipt> listOfReceipts) {
    final headerTitles = [
      'Pos',
      'Firma / Name',
      'Empfängerland',
      'Belegdatum',
      'Beleg-Nr.',
      'Netto',
      'Steuer',
      'Brutto',
      'Steuer %',
    ];

    final data = [[]];
    int pos = 1;
    for (int i = 0; i < listOfReceipts.length; i++) {
      final receipt = switch (listOfReceipts[i].receiptTyp) {
        ReceiptType.credit => listOfReceipts[i].copyWith(
            totalNet: listOfReceipts[i].totalNet * -1, totalTax: listOfReceipts[i].totalTax * -1, totalGross: listOfReceipts[i].totalGross * -1),
        _ => listOfReceipts[i],
      };
      final style = switch (receipt.receiptTyp) {
        ReceiptType.credit => pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: PdfColors.red),
        _ => const pw.TextStyle(fontSize: 8),
      };
      final entry = [
        pos,
        PdfText(receipt.receiptCustomer.company != null && receipt.receiptCustomer.company!.isNotEmpty && receipt.receiptCustomer.company!.length > 2
            ? receipt.receiptCustomer.company!
            : receipt.receiptCustomer.name),
        receipt.addressDelivery.country.name,
        PdfText(DateFormat('dd.MM.yyyy', 'de').format(receipt.creationDate)),
        _getReceiptNumber(i, receipt, i > 0 ? listOfReceipts[i - 1] : null),
        PdfText(receipt.totalNet.toMyCurrencyStringToShow(), style: style),
        PdfText(receipt.totalTax.toMyCurrencyStringToShow(), style: style),
        PdfText(receipt.totalGross.toMyCurrencyStringToShow(), style: style),
        PdfText('${receipt.tax.taxRate}%'),
      ];

      pos += 1;
      data.add(entry);
    }

    final totalNetSum = listOfReceipts.fold(
      0.0,
      (sum, receipt) => sum + switch (receipt.receiptTyp) { ReceiptType.credit => receipt.totalNet * -1, _ => receipt.totalNet },
    );
    final totalTaxSum = listOfReceipts.fold(
      0.0,
      (sum, receipt) => sum + switch (receipt.receiptTyp) { ReceiptType.credit => receipt.totalTax * -1, _ => receipt.totalTax },
    );
    final totalGrossSum = listOfReceipts.fold(
      0.0,
      (sum, receipt) => sum + switch (receipt.receiptTyp) { ReceiptType.credit => receipt.totalGross * -1, _ => receipt.totalGross },
    );

    data.add([
      '',
      '',
      '',
      '',
      '',
      PdfText(totalNetSum.toMyCurrencyStringToShow(), style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: PdfColors.green)),
      PdfText(totalTaxSum.toMyCurrencyStringToShow(), style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
      PdfText(totalGrossSum.toMyCurrencyStringToShow(), style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
      '',
    ]);

    return pw.TableHelper.fromTextArray(
      headers: headerTitles,
      data: data,
      headerStyle: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      cellDecoration: (row, column, value) {
        if ((row == 2 && column != 'Österreich' && column != '')) return const pw.BoxDecoration(color: PdfColors.yellow);
        if ((row == 5 && column == '')) return const pw.BoxDecoration(color: PdfColors.red);
        return const pw.BoxDecoration();
      },
      headerAlignment: pw.Alignment.centerLeft,
      cellStyle: const pw.TextStyle(fontSize: 8),
      border: _borderTabels,
      columnWidths: {
        0: const pw.FlexColumnWidth(3),
        1: const pw.FlexColumnWidth(30),
        2: const pw.FlexColumnWidth(8),
        3: const pw.FlexColumnWidth(7),
        4: const pw.FlexColumnWidth(7),
        5: const pw.FlexColumnWidth(7),
        6: const pw.FlexColumnWidth(7),
        7: const pw.FlexColumnWidth(7),
        8: const pw.FlexColumnWidth(5),
      },
      headerAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerLeft,
        3: pw.Alignment.centerRight,
        4: pw.Alignment.centerRight,
        5: pw.Alignment.centerRight,
        6: pw.Alignment.centerRight,
        7: pw.Alignment.centerRight,
        8: pw.Alignment.centerRight,
      },
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerLeft,
        3: pw.Alignment.centerRight,
        4: pw.Alignment.centerRight,
        5: pw.Alignment.centerRight,
        6: pw.Alignment.centerRight,
        7: pw.Alignment.centerRight,
        8: pw.Alignment.centerRight,
      },
    );
  }

  static pw.Widget _buildCountryGroupTitle() {
    return pw.Text('Gruppierung nach Empfängerland', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold));
  }

  static pw.Widget _buildCountryGroupSum(List listOfReceipts) {
    Map<String, List<dynamic>> groupedReceipts = {};
    for (final receipt in listOfReceipts) {
      final country = receipt.addressDelivery.country.name;
      if (!groupedReceipts.containsKey(country)) groupedReceipts[country] = [];

      groupedReceipts[country]!.add(receipt);
    }

    // Berechnung der Gesamtanzahl und Gesamtsumme
    int totalReceipts = listOfReceipts.length;
    double totalSum = listOfReceipts.fold(
      0.0,
      (sum, receipt) => sum + switch (receipt.receiptTyp) { ReceiptType.credit => receipt.totalNet * -1, _ => receipt.totalNet },
    );

    List<List<dynamic>> countryData = [];
    int pos = 1;
    groupedReceipts.forEach((country, receipts) {
      final totalNetSum = receipts.fold(
        0.0,
        (sum, receipt) => sum + switch (receipt.receiptTyp) { ReceiptType.credit => receipt.totalNet * -1, _ => receipt.totalNet },
      );

      final percentageCount = (receipts.length / totalReceipts) * 100;
      final percentageSum = (totalNetSum / totalSum) * 100;

      countryData.add([
        pos++,
        receipts.length,
        '${percentageCount.toStringAsFixed(2)}%',
        country,
        totalNetSum.toMyCurrencyStringToShow(),
        '${percentageSum.toStringAsFixed(2)}%'
      ]);
    });

    return _tableHelperGroups(countryData);
  }

  static pw.Widget _buildMarketplaceGroupTitle() {
    return pw.Text('Gruppierung nach Marktplätze', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold));
  }

  static pw.Widget _buildMarketplaceGroupSum(List<Receipt> listOfReceipts, List<AbstractMarketplace> listOfMarketplaces) {
    Map<String, List<Receipt>> groupedMarketplaces = {};
    for (final receipt in listOfReceipts) {
      final phMarketplace = listOfMarketplaces.where((e) => e.id == receipt.marketplaceId).firstOrNull;
      final marketplace = phMarketplace != null ? phMarketplace.name : '';

      if (!groupedMarketplaces.containsKey(marketplace)) groupedMarketplaces[marketplace] = [];

      groupedMarketplaces[marketplace]!.add(receipt);
    }

    // Berechnung der Gesamtanzahl und Gesamtsumme
    int totalReceipts = listOfReceipts.length;
    double totalSum = listOfReceipts.fold(
      0.0,
      (sum, receipt) => sum + switch (receipt.receiptTyp) { ReceiptType.credit => receipt.totalNet * -1, _ => receipt.totalNet },
    );

    List<List<dynamic>> marketplaceData = [];
    int pos = 1;
    groupedMarketplaces.forEach((marketplace, receipts) {
      final totalNetSum = receipts.fold(
        0.0,
        (sum, receipt) => sum + switch (receipt.receiptTyp) { ReceiptType.credit => receipt.totalNet * -1, _ => receipt.totalNet },
      );

      final percentageCount = (receipts.length / totalReceipts) * 100;
      final percentageSum = (totalNetSum / totalSum) * 100;

      marketplaceData.add([
        pos++,
        receipts.length,
        '${percentageCount.toStringAsFixed(2)}%',
        marketplace,
        totalNetSum.toMyCurrencyStringToShow(),
        '${percentageSum.toStringAsFixed(2)}%'
      ]);
    });

    return _tableHelperGroups(marketplaceData);
  }

  static pw.Widget _buildMarketplaceCountryGroupTitle() {
    return pw.Text('Gruppierung nach Marktplätze und Empfängerland', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold));
  }

  static List<pw.Widget> _buildMarketplaceCountryGroupSum(List<Receipt> listOfReceipts, List<AbstractMarketplace> listOfMarketplaces) {
    List<pw.Widget> marketplaceWidgets = [];

    Map<String, Map<String, List<Receipt>>> groupedReceipts = {};
    for (final receipt in listOfReceipts) {
      final phMarketplace = listOfMarketplaces.where((e) => e.id == receipt.marketplaceId).firstOrNull;
      final marketplace = phMarketplace != null ? phMarketplace.name : '';
      final country = receipt.addressDelivery.country.name;

      if (!groupedReceipts.containsKey(marketplace)) {
        groupedReceipts[marketplace] = {};
      }
      if (!groupedReceipts[marketplace]!.containsKey(country)) {
        groupedReceipts[marketplace]![country] = [];
      }

      groupedReceipts[marketplace]![country]!.add(receipt);
    }

    groupedReceipts.forEach((marketplace, countries) {
      // Berechnung der Gesamtanzahl und Gesamtsumme pro Marktplatz
      int totalReceipts = countries.values.fold(0, (sum, receipts) => sum + receipts.length);
      double totalSum = countries.values.fold(
        0.0,
        (sum, receipts) =>
            sum +
            receipts.fold(
              0.0,
              (subSum, receipt) => subSum + switch (receipt.receiptTyp) { ReceiptType.credit => receipt.totalNet * -1, _ => receipt.totalNet },
            ),
      );

      List<List<dynamic>> countryData = [];
      int pos = 1;
      countries.forEach((country, receipts) {
        final totalNetSum = receipts.fold(
          0.0,
          (sum, receipt) => sum + switch (receipt.receiptTyp) { ReceiptType.credit => receipt.totalNet * -1, _ => receipt.totalNet },
        );

        final percentageCount = (receipts.length / totalReceipts) * 100;
        final percentageSum = (totalNetSum / totalSum) * 100;

        countryData.add([
          pos++,
          receipts.length,
          '${percentageCount.toStringAsFixed(2)}%',
          country,
          totalNetSum.toMyCurrencyStringToShow(),
          '${percentageSum.toStringAsFixed(2)}%'
        ]);
      });

      marketplaceWidgets.add(
        pw.Container(
          width: 370, // Anpassen der Breite nach Bedarf
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(marketplace, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColors.blue)),
              pw.SizedBox(height: 5),
              _tableHelperGroups(countryData),
            ],
          ),
        ),
      );
    });

    return marketplaceWidgets;
  }

  static pw.Widget _buildConsecutiveInvoiceNumberError() {
    const text = 'Achtung: Lücke in der fortlaufenden Rechnungsnummer';
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _errorContainer(),
        pw.Text('  $text', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.red)),
      ],
    );
  }
}

pw.Widget _errorContainer() {
  return pw.Container(
    height: 10,
    width: 10,
    decoration: const pw.BoxDecoration(borderRadius: pw.BorderRadius.all(pw.Radius.circular(5)), color: PdfColors.red),
  );
}

Object _getReceiptNumber(int i, Receipt receipt, Receipt? previousReceipt) {
  final object = PdfText(switch (receipt.receiptTyp) {
    ReceiptType.offer => receipt.offerNumberAsString,
    ReceiptType.appointment => receipt.appointmentNumberAsString,
    ReceiptType.deliveryNote => receipt.deliveryNoteNumberAsString,
    ReceiptType.invoice || ReceiptType.credit => receipt.invoiceNumberAsString,
  });

  if (receipt.receiptTyp != ReceiptType.invoice || receipt.receiptTyp != ReceiptType.credit) return object;

  if (i <= 0 || previousReceipt == null) return object;

  if (receipt.invoiceId != previousReceipt.invoiceId + 1) {
    return pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [_errorContainer(), object]);
  }

  return object;
}
