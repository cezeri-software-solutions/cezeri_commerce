import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '/1_presentation/core/core.dart';
import '../../constants.dart';
import '../entities/marketplace/abstract_marketplace.dart';
import '../entities/reorder/reorder.dart';
import 'widgets/pdf_text.dart';

class PdfReorderGenerator {
  static Future<Uint8List> generate({
    required Reorder reorder,
    required AbstractMarketplace marketplace,
  }) async {
    final myTheme = pw.ThemeData.withFont(
      base: pw.Font.ttf(await rootBundle.load('assets/font/Roboto-Regular.ttf')),
      bold: pw.Font.ttf(await rootBundle.load('assets/font/Roboto-Bold.ttf')),
    );

    final pdf = pw.Document(theme: myTheme);

    pw.MemoryImage? logoImage;
    bool isUrlValid = false;

    try {
      final response = await http.get(Uri.parse(marketplace.logoUrl));
      if (response.statusCode == 200) {
        isUrlValid = true;
        Uint8List imageBytes = Uint8List.fromList(response.bodyBytes);
        logoImage = pw.MemoryImage(imageBytes);
      }
    } catch (e) {
      logger.e(e);
    }

    pdf.addPage(
      pw.MultiPage(
        header: (context) => pw.Column(
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [buildTitle(), isUrlValid ? buildBranchLogo(logoImage!) : pw.SizedBox(height: 100, width: 200)],
            ),
            pw.SizedBox(height: 40),
          ],
        ),
        build: (context) {
          return [
            pw.Row(children: [
              pw.Expanded(flex: 6, child: buildBranchAndCustomerAddress(marketplace, reorder)),
              pw.Expanded(flex: 4, child: pw.SizedBox()),
            ]),
            pw.SizedBox(height: 10),
            buildReorderInformations(reorder),
            pw.SizedBox(height: 30),
            buildPositions(reorder, false),
            // if (receipt.receiptTyp != ReceiptTyp.deliveryNote) ...[
            //   pw.Divider(thickness: 0.5),
            //   buildTotalAmount(receipt),
            //   pw.SizedBox(height: 10),
            //   buildPaymentTermText(receipt),
            //   if (receipt.isSmallBusiness) ...[
            //     pw.SizedBox(height: 10),
            //     buildSmallBusinessText(),
            //   ],
            // ],
            // pw.SizedBox(height: 10),
            // buildDocumentText(receipt),
            //pw.Expanded(child: pw.Container()),
          ];
        },
        footer: (context) => buildFooter(marketplace),
        margin: const pw.EdgeInsets.only(left: 55, right: 55, top: 55, bottom: 20),
      ),
    );
    return pdf.save();
  }

  static pw.Widget buildTitle() {
    final style = pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold);
    return PdfText('Bestellung', style: style);
  }

  static pw.Widget buildBranchLogo(pw.MemoryImage url) => pw.SizedBox(height: 80, width: 160, child: pw.Image(url));

  static pw.Widget buildBranchAndCustomerAddress(AbstractMarketplace marketplace, Reorder reorder) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        PdfText(
            '${marketplace.address.companyName} | ${marketplace.address.name} | ${marketplace.address.street} | ${marketplace.address.postcode} ${marketplace.address.city}',
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
        pw.SizedBox(height: 6),
        PdfText(reorder.reorderSupplier.company),
        pw.SizedBox(height: 2),
        if (reorder.reorderSupplier.name.isNotEmpty) PdfText(reorder.reorderSupplier.name),
        if (reorder.reorderSupplier.name.isNotEmpty) pw.SizedBox(height: 2),
        // if (supplier.street.isNotEmpty) PdfText(supplier.street),
        // if (supplier.street.isNotEmpty) pw.SizedBox(height: 2),
        // if (supplier.postcode.isNotEmpty) PdfText('${supplier.postcode} ${supplier.city}'),
        // if (supplier.postcode.isNotEmpty) pw.SizedBox(height: 2),
        // PdfText(supplier.country.name)
      ],
    );
  }

  static pw.Widget buildReorderInformations(Reorder reorder) => pw.Row(
        children: [
          pw.Spacer(flex: 6),
          pw.Expanded(
            flex: 4,
            child: pw.Column(
              children: [
                pw.Divider(color: PdfColors.grey400, thickness: 0.5),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    PdfText('Beleg Datum:'),
                    PdfText(
                      DateFormat('dd.MM.yyy', 'de').format((reorder.creationDate)),
                    ),
                  ],
                ),
                pw.SizedBox(height: 2),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    PdfText('Beleg Nr.:'),
                    PdfText(reorder.reorderNumber.toString()),
                  ],
                ),
                pw.SizedBox(height: 2),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    PdfText('Lieferanten-Nr.: '),
                    PdfText(reorder.reorderSupplier.supplierNumber.toString()),
                  ],
                ),
              ],
            ),
          ),
        ],
      );

  static pw.Widget buildPositions(Reorder reorder, bool withPrices) {
    final headers = switch (withPrices) {
      false => [
          'Pos.',
          'Artikelnummer / Bezeichnung',
          'Menge',
        ],
      _ => [
          'Pos.',
          'Artikelnummer / Bezeichnung',
          'Steuer',
          'Menge',
          'Netto Stk.',
          'Brutto Stk.',
          'Netto Ges.',
        ],
    };

    final data = [[]];
    int pos = 1;
    for (int i = 0; i < reorder.listOfReorderProducts.length; i++) {
      final entry = switch (withPrices) {
        false => [
            pos,
            '${reorder.listOfReorderProducts[i].articleNumber}\n${reorder.listOfReorderProducts[i].name}',
            '${reorder.listOfReorderProducts[i].quantity} Stk.',
          ],
        _ => [
            pos,
            '${reorder.listOfReorderProducts[i].articleNumber}\n${reorder.listOfReorderProducts[i].name}',
            '${reorder.listOfReorderProducts[i].tax.taxRate}%',
            '${reorder.listOfReorderProducts[i].quantity} Stk.',
            '${reorder.listOfReorderProducts[i].wholesalePriceNet.toMyCurrencyStringToShow()}${reorder.currency}',
            '${reorder.listOfReorderProducts[i].wholesalePriceGross.toMyCurrencyStringToShow()}${reorder.currency}',
            '${(reorder.listOfReorderProducts[i].quantity * reorder.listOfReorderProducts[i].totalPriceNet).toMyCurrencyStringToShow()}${reorder.currency}',
          ],
      };
      pos = pos + 1;
      data.add(entry);
    }

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: data,
      border: const pw.TableBorder(horizontalInside: pw.BorderSide(color: PdfColors.grey300, width: 0.5)),
      headerStyle: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      headerAlignment: pw.Alignment.centerLeft,
      cellStyle: const pw.TextStyle(fontSize: 8),
      columnWidths: switch (withPrices) {
        false => {
            0: const pw.FlexColumnWidth(4),
            1: const pw.FlexColumnWidth(54),
            3: const pw.FlexColumnWidth(10),
          },
        _ => {
            0: const pw.FlexColumnWidth(6),
            1: const pw.FlexColumnWidth(51),
            2: const pw.FlexColumnWidth(8),
            3: const pw.FlexColumnWidth(8),
            4: const pw.FlexColumnWidth(9),
            5: const pw.FlexColumnWidth(9),
            6: const pw.FlexColumnWidth(9),
          },
      },
      headerAlignments: switch (withPrices) {
        false => {
            0: pw.Alignment.topLeft,
            1: pw.Alignment.topLeft,
            3: pw.Alignment.topRight,
          },
        _ => {
            0: pw.Alignment.topCenter,
            1: pw.Alignment.topLeft,
            2: pw.Alignment.topRight,
            3: pw.Alignment.topLeft,
            4: pw.Alignment.topLeft,
            5: pw.Alignment.topLeft,
            6: pw.Alignment.topRight,
          },
      },
      cellAlignments: switch (withPrices) {
        false => {
            0: pw.Alignment.topLeft,
            1: pw.Alignment.topLeft,
            3: pw.Alignment.topRight,
          },
        _ => {
            0: pw.Alignment.topLeft,
            1: pw.Alignment.topLeft,
            2: pw.Alignment.topRight,
            3: pw.Alignment.topRight,
            4: pw.Alignment.topRight,
            5: pw.Alignment.topRight,
            6: pw.Alignment.topRight,
          },
      },
    );
  }

  static pw.Widget buildFooter(AbstractMarketplace marketplace) {
    return pw.Column(
      children: [
        pw.Divider(thickness: 0.5),
        pw.DefaultTextStyle(
          style: const pw.TextStyle(fontSize: 8),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  PdfText(
                    marketplace.address.companyName,
                    style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
                  ),
                  PdfText(marketplace.address.name),
                  PdfText(marketplace.address.street),
                  PdfText('${marketplace.address.postcode} ${marketplace.address.city}'),
                  PdfText(marketplace.address.country.name),
                  // TODO: UID-Nummer muss in marketplace gespeichert werden.
                  //if (receipt.receiptMarketplace.address. != '') PdfText(receipt.receiptMarketplace.address.uidNumber),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  PdfText(
                    marketplace.bankDetails.bankName,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  PdfText('BIC: ${marketplace.bankDetails.bankBic}'),
                  PdfText('IBAN: ${marketplace.bankDetails.bankIban}'),
                  PdfText('Paypal:', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                  PdfText(marketplace.bankDetails.paypalEmail),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  PdfText('Tel. 1: ${marketplace.address.phone}'),
                  if (marketplace.address.phoneMobile != '') PdfText('Tel. 2: ${marketplace.address.phoneMobile}'),
                  PdfText('Homepage:'),
                  PdfText('marketplace.url'), // TODO: Shopify
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
