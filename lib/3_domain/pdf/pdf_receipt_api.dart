import 'package:cezeri_commerce/1_presentation/core/extensions/to_my_currency.dart';
import 'package:cezeri_commerce/3_domain/entities/marketplace/marketplace.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../entities/receipt/receipt.dart';
import '../entities/receipt/receipt_customer.dart';
import '../entities/settings/main_settings.dart';

class PdfReceiptApi {
  static Future<Uint8List> generate(
      Receipt receipt, MainSettings mainSettings, Marketplace marketplace, ReceiptCustomer customer, String logoUrl) async {
    //final fontRegular = await PdfGoogleFonts.robotoRegular();
    //final fontBold = await PdfGoogleFonts.robotoBold();

    final myTheme = pw.ThemeData.withFont(
      base: pw.Font.ttf(await rootBundle.load('assets/font/Roboto-Regular.ttf')),
      bold: pw.Font.ttf(await rootBundle.load('assets/font/Roboto-Bold.ttf')),
    );

    final pdf = pw.Document(theme: myTheme);

    pw.ImageProvider? url;

    bool isUrlValid = false;

    final String imageUrl = logoUrl;
    try {
      final response = await http.head(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        // imageUrl ist ein gültiger Pfad zu einem Bild
        url = await networkImage(imageUrl);
        isUrlValid = true;
      } else {
        // imageUrl ist kein gültiger Pfad zu einem Bild
        isUrlValid = false;
      }
    } catch (e) {
      // Fehler beim Überprüfen der URL
    }

    pdf.addPage(
      pw.MultiPage(
        header: (context) => pw.Column(
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [buildTitle(receipt), isUrlValid ? buildBranchLogo(receipt, url!) : pw.SizedBox(height: 100, width: 200)],
            ),
            pw.SizedBox(height: 40),
          ],
        ),
        build: (context) {
          print(mainSettings.isSmallBusiness);
          return [
            buildBranchAndCustomerAddress(receipt, marketplace),
            buildAppointmentInformations(receipt),
            pw.SizedBox(height: 40),
            buildPositions(receipt),
            pw.Divider(),
            buildTotalAmount(receipt, mainSettings),
            pw.SizedBox(height: 10),
            buildPaymentTermText(receipt),
            if (mainSettings.isSmallBusiness) ...[
              pw.SizedBox(height: 10),
              buildSmallBusinessText(),
            ],
            pw.SizedBox(height: 10),
            buildDocumentText(receipt),
            //pw.Expanded(child: pw.Container()),
          ];
        },
        footer: (context) => buildFooter(receipt, marketplace),
        margin: const pw.EdgeInsets.only(left: 55, right: 55, top: 55, bottom: 20),
      ),
    );
    return pdf.save();
  }

  static pw.Widget buildTitle(Receipt receipt) {
    final style = pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold);
    return switch (receipt.receiptTyp) {
      ReceiptTyp.offer => pw.Text('Angebot', style: style),
      ReceiptTyp.appointment => pw.Text('Auftrag', style: style),
      ReceiptTyp.invoice => pw.Text('Rechnung', style: style),
      ReceiptTyp.credit => pw.Text('Rechnungskorrektur', style: style),
    };
  }

  static pw.Widget buildBranchLogo(Receipt appointment, pw.ImageProvider url) => pw.SizedBox(height: 100, width: 200, child: pw.Image(url));

  static pw.Widget buildBranchAndCustomerAddress(Receipt receipt, Marketplace marketplace) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
            '${marketplace.address.companyName} | ${marketplace.address.name} | ${marketplace.address.street} | ${marketplace.address.postcode} ${marketplace.address.city}',
            style: const pw.TextStyle(color: PdfColors.grey600, decoration: pw.TextDecoration.underline)),
        pw.SizedBox(height: 10),
        if (receipt.addressInvoice.companyName != '') pw.Text(receipt.addressInvoice.companyName),
        pw.Text(receipt.addressInvoice.name),
        pw.Text(receipt.addressInvoice.street),
        pw.Text('${receipt.addressInvoice.postcode} ${receipt.addressInvoice.city}'),
        pw.Text(receipt.addressInvoice.country.name)
      ],
    );
  }

  static pw.Widget buildAppointmentInformations(Receipt receipt) => pw.Row(
        children: [
          pw.Spacer(flex: 6),
          pw.Expanded(
            flex: 4,
            child: pw.Column(
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Beleg Datum:'),
                    pw.Text(
                      DateFormat('dd.MM.yyy', 'de').format((receipt.creationDate)),
                    ),
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Beleg Nr.:'),
                    switch (receipt.receiptTyp) {
                      ReceiptTyp.offer => pw.Text(receipt.offerNumberAsString),
                      ReceiptTyp.appointment => pw.Text(receipt.appointmentNumberAsString),
                      ReceiptTyp.invoice => pw.Text(receipt.invoiceNumberAsString),
                      ReceiptTyp.credit => pw.Text(receipt.creditNumberAsString),
                    },
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Kundennummer:'),
                    // TODO: customerNumber muss her statt name
                    pw.Text(receipt.receiptCustomer.name.toString()),
                  ],
                ),
              ],
            ),
          ),
        ],
      );

  static pw.Widget buildPositions(Receipt receipt) {
    final headers = [
      'Pos.',
      'Bezeichnung',
      'Menge',
      'Preis',
      'Summe',
    ];

    final data = [[]];
    int pos = 1;
    for (int i = 0; i < receipt.listOfReceiptProduct.length; i++) {
      final entry = [
        pos,
        '${receipt.listOfReceiptProduct[i].articleNumber} | ${receipt.listOfReceiptProduct[i].name}',
        '${receipt.listOfReceiptProduct[i].quantity} Stk.',
        receipt.listOfReceiptProduct[i].unitPriceGross,
        (receipt.listOfReceiptProduct[i].quantity * receipt.listOfReceiptProduct[i].unitPriceGross).toMyCurrencyStringToShow(),
      ];
      pos = pos + 1;
      data.add(entry);
    }

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      headerAlignment: pw.Alignment.centerLeft,
      columnWidths: {
        0: const pw.FlexColumnWidth(8),
        1: const pw.FlexColumnWidth(54),
        2: const pw.FlexColumnWidth(12),
        3: const pw.FlexColumnWidth(13),
        4: const pw.FlexColumnWidth(13),
      },
      cellAlignments: {
        0: pw.Alignment.topCenter,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.topRight,
        3: pw.Alignment.topRight,
        4: pw.Alignment.topRight,
      },
    );
  }

  static pw.Widget buildTotalAmount(Receipt receipt, MainSettings mainSettings) {
    final subTotalAmount = receipt.subTotalGross.toMyCurrencyStringToShow();
    final discountPercentAmount = receipt.discountPercentAmountGross.toMyCurrencyStringToShow();
    final discountPercent = receipt.discountPercent.toStringAsFixed(0);
    final discountAmount = receipt.discountGross.toMyCurrencyStringToShow();

    final totalNetAmount = receipt.totalNet.toMyCurrencyStringToShow();
    final vatPercent = receipt.tax.taxRate.toStringAsFixed(0);
    final totalVatPrice = receipt.totalTax.toMyCurrencyStringToShow();
    final totalGrossAmount = receipt.totalGross.toMyCurrencyStringToShow();

    return pw.Container(
      alignment: pw.Alignment.centerRight,
      child: pw.Row(
        children: [
          pw.Spacer(flex: 6),
          pw.Expanded(
            flex: 4,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                if (double.parse(discountPercent) != 0) ...[
                  pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                    pw.Text('Zwischensumme'),
                    pw.Row(
                      children: [
                        pw.Text(subTotalAmount),
                        pw.Text(' ${receipt.currency}'),
                      ],
                    ),
                  ]),
                  pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                    pw.Text('% Rabatt'),
                    pw.Row(
                      children: [
                        pw.Text(discountPercentAmount),
                        pw.Text(' ${receipt.currency}'),
                      ],
                    ),
                  ]),
                  pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                    pw.Row(
                      children: [
                        pw.Text('${receipt.currency} '),
                        pw.Text('Rabatt'),
                      ],
                    ),
                    pw.Row(
                      children: [
                        pw.Text(discountAmount),
                        pw.Text(' ${receipt.currency}'),
                      ],
                    ),
                  ]),
                  pw.Divider(),
                ],
                if (!mainSettings.isSmallBusiness) ...[
                  pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                    pw.Text('Nettobetrag'),
                    pw.Row(
                      children: [
                        pw.Text(totalNetAmount),
                        pw.Text(' ${receipt.currency}'),
                      ],
                    ),
                  ]),
                  pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                    pw.Text('USt. $vatPercent%'),
                    pw.Row(
                      children: [
                        pw.Text(totalVatPrice),
                        pw.Text(' ${receipt.currency}'),
                      ],
                    ),
                  ]),
                ],
                pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                  pw.Text('Gesamtbetrag', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Row(
                    children: [
                      pw.Text(totalGrossAmount, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text(' ${receipt.currency}'),
                    ],
                  ),
                ]),
                pw.Divider(color: PdfColors.grey400, height: 2.5),
                pw.Divider(color: PdfColors.grey400, height: 2.5),
              ],
            ),
          )
        ],
      ),
    );
  }

  static pw.Widget buildPaymentTermText(Receipt appointment) {
    if (appointment.paymentStatus != PaymentStatus.paid) {
      return pw.RichText(
        text: pw.TextSpan(
          text: 'Zahlungsziel: ',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          children: [
            pw.TextSpan(
              text: ' ab Belegdatum, ${appointment.termOfPayment.toString()} Tage netto.',
              style: pw.TextStyle(fontWeight: pw.FontWeight.normal),
            ),
          ],
        ),
      );
    } else {
      return pw.RichText(
        text: pw.TextSpan(
          text: 'Zahlungsziel: ',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          children: [
            pw.TextSpan(
              text: ' vollständig bezahlt.',
              style: pw.TextStyle(fontWeight: pw.FontWeight.normal),
            ),
          ],
        ),
      );
    }
  }

  static pw.Widget buildSmallBusinessText() {
    return pw.Text('Hinweis: Umsatzsteuerbefreit - Kleinunternehmer gem. § 6 Abs. 1 Z 27 UStG');
  }

  static pw.Widget buildDocumentText(Receipt receipt) {
    return pw.Text(receipt.receiptDocumentText);
  }

  static pw.Widget buildFooter(Receipt receipt, Marketplace marketplace) {
    return pw.Column(
      children: [
        pw.Divider(),
        pw.DefaultTextStyle(
          style: const pw.TextStyle(fontSize: 10),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    marketplace.address.companyName,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(marketplace.address.name),
                  pw.Text(marketplace.address.street),
                  pw.Text('${marketplace.address.postcode} ${marketplace.address.city}'),
                  pw.Text(marketplace.address.country.name),
                  // TODO: UID-Nummer muss in marketplace gespeichert werden.
                  //if (marketplace.address. != '') pw.Text(marketplace.address.uidNumber),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    receipt.bankDetails.bankName,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text('BIC: ${receipt.bankDetails.bankBic}'),
                  pw.Text('IBAN: ${receipt.bankDetails.bankIban}'),
                  pw.Text('Paypal:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(receipt.bankDetails.paypalEmail),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Tel. 1: ${marketplace.address.phone}'),
                  if (marketplace.address.phoneMobile != '') pw.Text('Tel. 2: ${marketplace.address.phoneMobile}'),
                  pw.Text('Homepage:'),
                  pw.Text(marketplace.url),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
