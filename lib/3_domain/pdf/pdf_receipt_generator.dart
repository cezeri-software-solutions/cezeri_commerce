import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '/1_presentation/core/core.dart';
import '../../constants.dart';
import '../entities/receipt/receipt.dart';
import 'widgets/pdf_text.dart';

class PdfReceiptGenerator {
  static Future<Uint8List> generate({
    required Receipt receipt,
    required String logoUrl,
  }) async {
    final myTheme = pw.ThemeData.withFont(
      base: pw.Font.ttf(await rootBundle.load('assets/font/Roboto-Regular.ttf')),
      bold: pw.Font.ttf(await rootBundle.load('assets/font/Roboto-Bold.ttf')),
    );

    final pdf = pw.Document(theme: myTheme);

    pw.MemoryImage? logoImage;
    bool isUrlValid = false;

    try {
      final response = await http.get(Uri.parse(logoUrl));
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
              children: [buildTitle(receipt), isUrlValid ? buildBranchLogo(logoImage!) : pw.SizedBox(height: 100, width: 200)],
            ),
            pw.SizedBox(height: 40),
          ],
        ),
        build: (context) {
          return [
            pw.Row(children: [
              pw.Expanded(flex: 6, child: buildBranchAndCustomerAddress(receipt)),
              pw.Expanded(flex: 4, child: buildCustomerDeliveryAddress(receipt)),
            ]),
            pw.SizedBox(height: 10),
            buildAppointmentInformations(receipt),
            pw.SizedBox(height: 30),
            buildPositions(receipt),
            if (receipt.receiptTyp != ReceiptType.deliveryNote) ...[
              pw.Divider(thickness: 0.5),
              buildTotalAmount(receipt),
              pw.SizedBox(height: 10),
              buildPaymentTermText(receipt),
              if (receipt.isSmallBusiness) ...[
                pw.SizedBox(height: 10),
                buildSmallBusinessText(),
              ],
            ],
            pw.SizedBox(height: 10),
            buildDocumentText(receipt),
            //pw.Expanded(child: pw.Container()),
          ];
        },
        footer: (context) => buildFooter(receipt),
        margin: const pw.EdgeInsets.only(left: 55, right: 55, top: 55, bottom: 20),
      ),
    );
    return pdf.save();
  }

  static pw.Widget buildTitle(Receipt receipt) {
    final style = pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold);
    return switch (receipt.receiptTyp) {
      ReceiptType.offer => PdfText('Angebot', style: style),
      ReceiptType.appointment => PdfText('Auftrag', style: style),
      ReceiptType.deliveryNote => PdfText('Lieferschein', style: style),
      ReceiptType.invoice => PdfText('Rechnung', style: style),
      ReceiptType.credit => PdfText('Rechnungskorrektur', style: style),
    };
  }

  static pw.Widget buildBranchLogo(pw.MemoryImage url) => pw.SizedBox(height: 80, width: 160, child: pw.Image(url));

  static pw.Widget buildBranchAndCustomerAddress(Receipt receipt) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        PdfText(
            '${receipt.receiptMarketplace.address.companyName} | ${receipt.receiptMarketplace.address.name} | ${receipt.receiptMarketplace.address.street} | ${receipt.receiptMarketplace.address.postcode} ${receipt.receiptMarketplace.address.city}',
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
        pw.SizedBox(height: 6),
        if (receipt.addressInvoice.companyName != '') PdfText(receipt.addressInvoice.companyName),
        if (receipt.addressInvoice.companyName != '') pw.SizedBox(height: 2),
        PdfText(receipt.addressInvoice.name),
        pw.SizedBox(height: 2),
        PdfText(receipt.addressInvoice.street),
        pw.SizedBox(height: 2),
        PdfText('${receipt.addressInvoice.postcode} ${receipt.addressInvoice.city}'),
        pw.SizedBox(height: 2),
        PdfText(receipt.addressInvoice.country.name)
      ],
    );
  }

  static pw.Widget buildCustomerDeliveryAddress(Receipt receipt) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        PdfText('Lieferadresse:', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600, decoration: pw.TextDecoration.underline)),
        pw.SizedBox(height: 6),
        if (receipt.addressDelivery.companyName != '') PdfText(receipt.addressDelivery.companyName),
        if (receipt.addressDelivery.companyName != '') pw.SizedBox(height: 2),
        PdfText(receipt.addressDelivery.name),
        pw.SizedBox(height: 2),
        PdfText(receipt.addressDelivery.street),
        pw.SizedBox(height: 2),
        PdfText('${receipt.addressDelivery.postcode} ${receipt.addressDelivery.city}'),
        pw.SizedBox(height: 2),
        PdfText(receipt.addressDelivery.country.name)
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
                pw.Divider(color: PdfColors.grey400, thickness: 0.5),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    PdfText('Beleg Datum:'),
                    PdfText(
                      DateFormat('dd.MM.yyy', 'de').format((receipt.creationDate)),
                    ),
                  ],
                ),
                pw.SizedBox(height: 2),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    PdfText('Beleg Nr.:'),
                    switch (receipt.receiptTyp) {
                      ReceiptType.offer => PdfText(receipt.offerNumberAsString),
                      ReceiptType.appointment => PdfText(receipt.appointmentNumberAsString),
                      ReceiptType.deliveryNote => PdfText(receipt.deliveryNoteNumberAsString),
                      ReceiptType.invoice || ReceiptType.credit => PdfText(receipt.invoiceNumberAsString),
                    },
                  ],
                ),
                pw.SizedBox(height: 2),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    PdfText('Kundennummer:'),
                    PdfText(receipt.receiptCustomer.customerNumber.toString()),
                  ],
                ),
              ],
            ),
          ),
        ],
      );

  static pw.Widget buildPositions(Receipt receipt) {
    final headers = switch (receipt.receiptTyp) {
      ReceiptType.deliveryNote => [
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
          'Brutto Ges.',
        ],
    };

    final data = [[]];
    int pos = 1;
    for (int i = 0; i < receipt.listOfReceiptProduct.length; i++) {
      final entry = switch (receipt.receiptTyp) {
        ReceiptType.deliveryNote => [
            pos,
            '${receipt.listOfReceiptProduct[i].articleNumber}\n${receipt.listOfReceiptProduct[i].name}',
            '${receipt.listOfReceiptProduct[i].quantity} Stk.',
          ],
        _ => [
            pos,
            '${receipt.listOfReceiptProduct[i].articleNumber}\n${receipt.listOfReceiptProduct[i].name}',
            '${receipt.listOfReceiptProduct[i].tax.taxRate}%',
            '${receipt.listOfReceiptProduct[i].quantity} Stk.',
            '${receipt.listOfReceiptProduct[i].unitPriceNet.toMyCurrencyStringToShow()}${receipt.currency}',
            '${receipt.listOfReceiptProduct[i].unitPriceGross.toMyCurrencyStringToShow()}${receipt.currency}',
            '${(receipt.listOfReceiptProduct[i].quantity * receipt.listOfReceiptProduct[i].unitPriceGross).toMyCurrencyStringToShow()}${receipt.currency}',
          ],
      };
      pos = pos + 1;
      data.add(entry);
    }

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      headerAlignment: pw.Alignment.centerLeft,
      cellStyle: const pw.TextStyle(fontSize: 8),
      columnWidths: switch (receipt.receiptTyp) {
        ReceiptType.deliveryNote => {
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
      headerAlignments: switch (receipt.receiptTyp) {
        ReceiptType.deliveryNote => {
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
      cellAlignments: switch (receipt.receiptTyp) {
        ReceiptType.deliveryNote => {
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

  static pw.Widget buildTotalAmount(Receipt receipt) {
    final subTotalNet = receipt.subTotalNet;
    final subTotalGross = receipt.subTotalGross;
    final posDiscountPercentAmountGross = receipt.posDiscountPercentAmountGross;
    final discountPercentAmountGross = receipt.discountPercentAmountGross;
    final discountGross = receipt.discountGross;
    final additionalAmountGross = receipt.additionalAmountGross;
    final totalShippingGross = receipt.totalShippingGross;

    final totalNet = receipt.totalNet.toMyCurrencyStringToShow();
    final taxRate = receipt.tax.taxRate.toStringAsFixed(0);
    final totalTax = receipt.totalTax.toMyCurrencyStringToShow();
    final totalGross = receipt.totalGross.toMyCurrencyStringToShow();

    final isPosDiscountPercentAmountGross = posDiscountPercentAmountGross > 0;
    final isDiscountPercentAmountGross = discountPercentAmountGross > 0;
    final isDiscountGross = discountGross > 0;
    final isAdditionalAmountGross = additionalAmountGross > 0;
    final isTotalShippingGross = totalShippingGross > 0;

    final showSubAmounts =
        isPosDiscountPercentAmountGross || isDiscountPercentAmountGross || isDiscountGross || isAdditionalAmountGross || isTotalShippingGross;

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
                if (showSubAmounts)
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      PdfText('Zwischensumme Netto'),
                      pw.Row(
                        children: [
                          PdfText(subTotalNet.toMyCurrencyStringToShow()),
                          PdfText(' ${receipt.currency}'),
                        ],
                      ),
                    ],
                  ),
                if (showSubAmounts)
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      PdfText('Zwischensumme Brutto'),
                      pw.Row(
                        children: [
                          PdfText(subTotalGross.toMyCurrencyStringToShow()),
                          PdfText(' ${receipt.currency}'),
                        ],
                      ),
                    ],
                  ),
                if (isPosDiscountPercentAmountGross)
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      PdfText('Pos. % Rabatt'),
                      pw.Row(
                        children: [
                          PdfText(posDiscountPercentAmountGross.toMyCurrencyStringToShow()),
                          PdfText(' ${receipt.currency}'),
                        ],
                      ),
                    ],
                  ),
                if (isDiscountPercentAmountGross)
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      PdfText('% Rabatt'),
                      pw.Row(
                        children: [
                          PdfText(discountPercentAmountGross.toMyCurrencyStringToShow()),
                          PdfText(' ${receipt.currency}'),
                        ],
                      ),
                    ],
                  ),
                if (isDiscountGross)
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      PdfText('${receipt.currency} Rabatt'),
                      pw.Row(
                        children: [
                          PdfText(discountGross.toMyCurrencyStringToShow()),
                          PdfText(' ${receipt.currency}'),
                        ],
                      ),
                    ],
                  ),
                if (isAdditionalAmountGross)
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      PdfText('Zuschlag'),
                      pw.Row(
                        children: [
                          PdfText(additionalAmountGross.toMyCurrencyStringToShow()),
                          PdfText(' ${receipt.currency}'),
                        ],
                      ),
                    ],
                  ),
                if (isTotalShippingGross)
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      PdfText('Versandkosten'),
                      pw.Row(
                        children: [
                          PdfText(totalShippingGross.toMyCurrencyStringToShow()),
                          PdfText(' ${receipt.currency}'),
                        ],
                      ),
                    ],
                  ),
                if (showSubAmounts) pw.Divider(color: PdfColors.grey400, thickness: 0.5, height: 3),
                if (!receipt.isSmallBusiness) ...[
                  pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                    PdfText('Gesamtbetrag Netto'),
                    pw.Row(
                      children: [
                        PdfText(totalNet),
                        PdfText(' ${receipt.currency}'),
                      ],
                    ),
                  ]),
                  pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                    PdfText('USt. $taxRate%'),
                    pw.Row(
                      children: [
                        PdfText(totalTax),
                        PdfText(' ${receipt.currency}'),
                      ],
                    ),
                  ]),
                ],
                pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                  PdfText('Gesamtbetrag Brutto', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                  pw.Row(
                    children: [
                      PdfText(totalGross, style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                      PdfText(' ${receipt.currency}'),
                    ],
                  ),
                ]),
                pw.Divider(thickness: 0.5, color: PdfColors.grey400, height: 2.5),
                pw.Divider(thickness: 0.5, color: PdfColors.grey400, height: 2.5),
              ],
            ),
          )
        ],
      ),
    );
  }

  static pw.Widget buildPaymentTermText(Receipt appointment) {
    String generatePaymentText(Receipt receipt) {
      if (receipt.paymentStatus != PaymentStatus.paid && receipt.paymentMethod.name == 'Kauf auf Rechnung') {
        return ' ab Belegdatum, ${receipt.termOfPayment.toString()} Tage netto.';
      } else if (receipt.paymentStatus != PaymentStatus.paid && receipt.paymentMethod.name == 'Vorkasse') {
        return ' Bitte begleichen Sie den Rechnungsbetrag vorab innerhalb von 14 Tagen nach Erhalt dieses Beleges. Die Lieferung erfolgt nach Eingang Ihrer Zahlung.';
      } else {
        return ' vollständig bezahlt.';
      }
    }

    return pw.RichText(
      text: pw.TextSpan(
        text: 'Zahlungsziel: ',
        style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
        children: [
          pw.TextSpan(
            text: generatePaymentText(appointment),
            style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.normal),
          ),
        ],
      ),
    );
  }

  static pw.Widget buildSmallBusinessText() {
    return PdfText('Hinweis: Umsatzsteuerbefreit - Kleinunternehmer gem. § 6 Abs. 1 Z 27 UStG');
  }

  static pw.Widget buildDocumentText(Receipt receipt) {
    return PdfText(receipt.receiptDocumentText);
  }

  static pw.Widget buildFooter(Receipt receipt) {
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
                    receipt.receiptMarketplace.address.companyName,
                    style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
                  ),
                  PdfText(receipt.receiptMarketplace.address.name),
                  PdfText(receipt.receiptMarketplace.address.street),
                  PdfText('${receipt.receiptMarketplace.address.postcode} ${receipt.receiptMarketplace.address.city}'),
                  PdfText(receipt.receiptMarketplace.address.country.name),
                  // TODO: UID-Nummer muss in marketplace gespeichert werden.
                  //if (receipt.receiptMarketplace.address. != '') PdfText(receipt.receiptMarketplace.address.uidNumber),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  PdfText(
                    receipt.receiptMarketplace.bankDetails.bankName,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  PdfText('BIC: ${receipt.receiptMarketplace.bankDetails.bankBic}'),
                  PdfText('IBAN: ${receipt.receiptMarketplace.bankDetails.bankIban}'),
                  PdfText('Paypal:', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                  PdfText(receipt.receiptMarketplace.bankDetails.paypalEmail),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  PdfText('Tel. 1: ${receipt.receiptMarketplace.address.phone}'),
                  if (receipt.receiptMarketplace.address.phoneMobile != '') PdfText('Tel. 2: ${receipt.receiptMarketplace.address.phoneMobile}'),
                  PdfText('Homepage:'),
                  PdfText(receipt.receiptMarketplace.url),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
