import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/3_domain/entities/marketplace/abstract_marketplace.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../../../../3_domain/entities/reorder/reorder.dart';
import '../../../../3_domain/pdf/pdf_api_mobile.dart';
import '../../../../3_domain/pdf/pdf_api_web.dart';
import '../../../../3_domain/pdf/pdf_reorder_generator.dart';

Future<void> onPdfPressed({required BuildContext context, required Reorder reorder, required List<AbstractMarketplace> marketplaces}) async {
  AbstractMarketplace? selectedMarketplace;

  await showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: SizedBox(
          width: 400,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: marketplaces.length,
              itemBuilder: (context, index) {
                final marketplace = marketplaces[index];
                return ListTile(
                  title: Text(marketplace.name),
                  onTap: () {
                    selectedMarketplace = marketplace;
                    context.maybePop();
                  },
                );
              },
            ),
          ),
        ),
      );
    },
  );

  if (selectedMarketplace == null) return;

  final reorderName = reorder.reorderNumber.toString();
  final generatedPdf = await PdfReorderGenerator.generate(reorder: reorder, marketplace: selectedMarketplace!);

  if (context.mounted) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: SizedBox(
          width: 400,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.open_in_browser),
                  title: const Text(kIsWeb ? 'Im Browser öffnen' : 'Öffnen'),
                  onTap: () async {
                    if (kIsWeb) {
                      await PdfApiWeb.openPdf(name: '$reorderName.pdf', byteList: generatedPdf, showInBrowser: true);
                    } else {
                      await PdfApiMobile.openPdf(name: '$reorderName.pdf', byteList: generatedPdf);
                    }
                    if (context.mounted) context.router.maybePop();
                  },
                ),
                if (kIsWeb)
                  ListTile(
                    leading: const Icon(Icons.download),
                    title: const Text('Herunterladen'),
                    onTap: () async {
                      await PdfApiWeb.openPdf(name: '$reorderName.pdf', byteList: generatedPdf, showInBrowser: false);
                      if (context.mounted) context.router.maybePop();
                    },
                  ),
                ListTile(
                  leading: const Icon(Icons.print),
                  title: const Text('Drucken'),
                  onTap: () async {
                    await Printing.layoutPdf(onLayout: (_) => generatedPdf);
                    if (context.mounted) context.router.maybePop();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
