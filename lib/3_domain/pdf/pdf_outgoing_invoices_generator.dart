import 'package:cezeri_commerce/1_presentation/core/extensions/to_my_currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../entities/receipt/receipt.dart';
import 'widgets/pdf_text.dart';

class PdfOutgoingInvoicesGenerator {
  static Future<Uint8List> generate({required List<Receipt> listOfReceipts, DateTimeRange? dateRange}) async {
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
            _buildCountryGroupTitle(),
            pw.SizedBox(height: 10),
            pw.Row(children: [pw.Expanded(child: _buildCountryCounter(listOfReceipts)), pw.Expanded(child: pw.SizedBox())]),
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
        PdfText(receipt.receiptCustomer.company != null && receipt.receiptCustomer.company!.isNotEmpty
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
      border: const pw.TableBorder(
        left: pw.BorderSide(color: PdfColors.grey, width: 0.5),
        right: pw.BorderSide(color: PdfColors.grey, width: 0.5),
        top: pw.BorderSide(color: PdfColors.grey, width: 0.5),
        bottom: pw.BorderSide(color: PdfColors.grey, width: 0.5),
        horizontalInside: pw.BorderSide(color: PdfColors.grey, width: 0.5),
        verticalInside: pw.BorderSide(color: PdfColors.grey, width: 0.5),
      ),
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

  static pw.Widget _buildCountryCounter(List<Receipt> listOfReceipts) {
    final headerTitles = [
      'Pos',
      'Anzahl',
      'Empfängerland',
      'Summe',
    ];

    Map<String, List<Receipt>> groupedReceipts = {};
    for (var receipt in listOfReceipts) {
      var country = receipt.addressDelivery.country.name;
      if (!groupedReceipts.containsKey(country)) {
        groupedReceipts[country] = [];
      }
      groupedReceipts[country]!.add(receipt);
    }

    List<List<dynamic>> countryData = [];
    int pos = 1;
    groupedReceipts.forEach((country, receipts) {
      final totalNetSum = receipts.fold(
        0.0,
        (sum, receipt) => sum + switch (receipt.receiptTyp) { ReceiptType.credit => receipt.totalNet * -1, _ => receipt.totalNet },
      );
      countryData.add([pos++, receipts.length, country, totalNetSum.toMyCurrencyStringToShow()]);
    });

    return pw.TableHelper.fromTextArray(
      headers: headerTitles,
      data: countryData,
      headerStyle: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      cellStyle: const pw.TextStyle(fontSize: 8),
      border: const pw.TableBorder(
        left: pw.BorderSide(color: PdfColors.grey, width: 0.5),
        right: pw.BorderSide(color: PdfColors.grey, width: 0.5),
        top: pw.BorderSide(color: PdfColors.grey, width: 0.5),
        bottom: pw.BorderSide(color: PdfColors.grey, width: 0.5),
        horizontalInside: pw.BorderSide(color: PdfColors.grey, width: 0.5),
        verticalInside: pw.BorderSide(color: PdfColors.grey, width: 0.5),
      ),
      columnWidths: {
        0: const pw.FlexColumnWidth(5),
        1: const pw.FlexColumnWidth(5),
        2: const pw.FlexColumnWidth(10),
        3: const pw.FlexColumnWidth(10),
      },
      headerAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerLeft,
        3: pw.Alignment.centerRight,
      },
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerLeft,
        3: pw.Alignment.centerRight,
      },
    );
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
    return pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
      _errorContainer(),
      object,
    ]);
  }

  return object;
}
