import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../../../3_domain/entities/marketplace/abstract_marketplace.dart';
import '../../../3_domain/entities/receipt/receipt.dart';
import '../../../3_domain/pdf/pdf_api_mobile.dart';
import '../../../3_domain/pdf/pdf_api_web.dart';
import '../../../3_domain/pdf/pdf_receipt_generator.dart';
import '../../core/core.dart';

Future<void> onGeneratePdfFromReceipt({required BuildContext context, required Receipt receipt, required AbstractMarketplace marketplace}) async {
  showMyDialogLoading(context: context, text: 'PDF wird erstellt...', canPop: true);

  final receiptName = switch (receipt.receiptTyp) {
    ReceiptType.offer => receipt.offerNumberAsString,
    ReceiptType.appointment => receipt.appointmentNumberAsString,
    ReceiptType.deliveryNote => receipt.deliveryNoteNumberAsString,
    ReceiptType.invoice || ReceiptType.credit => receipt.invoiceNumberAsString,
  };
  final generatedPdf = await PdfReceiptGenerator.generate(receipt: receipt, logoUrl: marketplace.logoUrl);

  if (context.mounted) Navigator.of(context).pop();

  if (!context.mounted) return;
  showDialog(
    context: context,
    builder: (context) => Dialog(
      child: SizedBox(
        width: 400,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.open_in_browser),
                title: const Text(kIsWeb ? 'Im Browser öffnen' : 'Öffnen'),
                onTap: () async {
                  if (context.mounted) context.router.maybePop();
                  if (kIsWeb) {
                    await PdfApiWeb.openPdf(name: '$receiptName.pdf', byteList: generatedPdf, showInBrowser: true);
                  } else {
                    await PdfApiMobile.openPdf(name: '$receiptName.pdf', byteList: generatedPdf);
                  }
                },
              ),
              if (kIsWeb)
                ListTile(
                  leading: const Icon(Icons.download),
                  title: const Text('Herunterladen'),
                  onTap: () async {
                    if (context.mounted) context.router.maybePop();
                    await PdfApiWeb.openPdf(name: '$receiptName.pdf', byteList: generatedPdf, showInBrowser: false);
                  },
                ),
              ListTile(
                leading: const Icon(Icons.print),
                title: const Text('Drucken'),
                onTap: () async {
                  if (context.mounted) context.router.maybePop();
                  await Printing.layoutPdf(onLayout: (_) => generatedPdf);
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
