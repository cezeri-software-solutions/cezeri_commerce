import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../../2_application/database/product/product_bloc.dart';
import '../../../../3_domain/entities/product/product.dart';
import '../../../../3_domain/pdf/pdf_api_mobile.dart';
import '../../../../3_domain/pdf/pdf_api_web.dart';
import '../../../../3_domain/pdf/pdf_products_generator.dart';
import '../../../../constants.dart';
import '../../../../routes/router.gr.dart';
import '../../../core/core.dart';
import '../functions/products_overview_create_export.dart';
import 'product_mass_editing_sheet.dart';

void showProductsOverviewOptions({
  required BuildContext context,
  required ProductBloc productBloc,
  required List<Product> listOfSelectedProducts,
  required GlobalKey<State<StatefulWidget>> iconButtonKey,
}) {
  WoltModalSheet.show(
    context: context,
    useSafeArea: false,
    showDragHandle: false,
    pageListBuilder: (woltContext) {
      return [
        WoltModalSheetPage(
          hasTopBarLayer: false,
          isTopBarLayerAlwaysVisible: false,
          child: ProductOptionsSheet(productBloc: productBloc, products: listOfSelectedProducts, iconButtonKey: iconButtonKey),
        ),
      ];
    },
  );
}

class ProductOptionsSheet extends StatelessWidget {
  final ProductBloc productBloc;
  final List<Product> products;
  final GlobalKey<State<StatefulWidget>> iconButtonKey;

  const ProductOptionsSheet({super.key, required this.productBloc, required this.products, required this.iconButtonKey});

  @override
  Widget build(BuildContext context) {
    final isActive = products.isNotEmpty;

    return Padding(
      padding: EdgeInsets.only(top: 16, bottom: max(MediaQuery.paddingOf(context).bottom, 16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ListTile(
            leading: Icon(Icons.add, color: Colors.green),
            title: Text('Neuer Artikel'),
          ),
          ListTile(
            leading: Icon(Icons.edit_note, color: isActive ? CustomColors.primaryColor : Colors.grey, size: 20),
            title: Text('Massenbearbeitung', style: TextStyle(color: isActive ? null : Colors.grey)),
            onTap: !isActive
                ? null
                : () {
                    Navigator.of(context).pop();
                    showProductMassEditingSheet(context, productBloc);
                  },
          ),
          ListTile(
            leading: Icon(Icons.picture_as_pdf, color: isActive ? Colors.red : Colors.grey),
            title: Text('PDF generieren', style: TextStyle(color: isActive ? null : Colors.grey)),
            onTap: isActive ? () => onGeneratePdfPressed(context, productBloc, products) : null,
          ),
          ListTile(
            leading: Icon(Icons.table_chart_outlined, color: isActive ? CustomColors.primaryColor : Colors.grey),
            title: Text('CSV/Excel Export', style: TextStyle(color: isActive ? null : Colors.grey)),
            onTap: isActive ? () async => await generateTableExportFromProductsOverview(context, iconButtonKey, products) : null,
          ),
          ListTile(
            leading: Icon(Icons.delete, color: isActive ? Colors.red : Colors.grey),
            title: Text('Ausgewählte löschen', style: TextStyle(color: isActive ? null : Colors.grey)),
            onTap: isActive ? () => onRemovePressed(context, productBloc, products) : null,
          ),
        ],
      ),
    );
  }
}

void onRemovePressed(BuildContext context, ProductBloc productBloc, List<Product> selectedProducts) {
  if (selectedProducts.any((e) => e.listOfIsPartOfSetIds.isNotEmpty)) {
    showMyDialogAlert(
        context: context,
        title: 'Achtung!',
        content: 'Ihre Auswahl beinhaltet Artikel, die Bestandteil von Set-Artikel sind.\nDiese müssen zuerst aus den Set-Artikeln entfernt werden.');
    return;
  }

  showMyDialogDelete(
    context: context,
    content: 'Bist du sicher, dass du alle ausgewählten Artikel unwiederruflich löschen willst?',
    onConfirm: () {
      productBloc.add(DeleteSelectedProductsEvent(selectedProducts: selectedProducts));
      context.router.maybePop();
    },
  );
}

Future<void> onGeneratePdfPressed(BuildContext context, ProductBloc productBloc, List<Product> selectedProducts) async {
  showMyDialogLoading(context: context, text: 'PDF wird erstellt...');
  productBloc.add(SetProductIsLoadingPdfEvent(value: true));
  final generatedPdf = await PdfProductsGenerator.generate(listOfProducts: selectedProducts);

  if (context.mounted) context.router.popUntilRouteWithName(ProductsOverviewRoute.name);

  if (kIsWeb) {
    await PdfApiWeb.saveDocument(name: 'Ausgewählte Artikel.pdf', byteList: generatedPdf, showInBrowser: true);
  } else {
    await PdfApiMobile.saveDocument(name: 'Ausgewählte Artikel.pdf', byteList: generatedPdf);
  }

  productBloc.add(SetProductIsLoadingPdfEvent(value: false));
}
