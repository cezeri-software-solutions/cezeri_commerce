import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:html/parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../../3_domain/entities/marketplace/marketplace_presta.dart';
import '../../../../3_domain/entities/product/product.dart';
import '../../../../3_domain/entities/product/product_presta.dart';
import '../../../../3_domain/repositories/database/marketplace_repository.dart';
import '../../../../3_domain/repositories/marketplace/marketplace_import_repository.dart';
import '../../../../4_infrastructur/repositories/prestashop_api/models/category_presta.dart';
import '../../../../constants.dart';
import '../../../core/core.dart';

Future<void> generateTableExportFromProductsOverview(
  BuildContext context,
  GlobalKey<State<StatefulWidget>> iconButtonKey,
  List<Product> selectedProducts,
) async {
  final trailing = IconButton(
    padding: const EdgeInsets.only(right: 24),
    icon: const Icon(Icons.close),
    onPressed: () => context.router.pop(),
  );

  MarketplacePresta? marketplace;
  final fosMarketplace = await GetIt.I.get<MarketplaceRepository>().getMarketplace('Uh2NdcXphcN7ABnSBAGU'); //TODO: make dynamic
  fosMarketplace.fold(
    (l) => null,
    (mp) => marketplace = mp as MarketplacePresta, // TODO: Shopify
  );
  List<CategoryPresta>? categories;
  if (marketplace != null) {
    List<CategoryPresta>? allCategories;
    final fosCategories = await GetIt.I.get<MarketplaceImportRepository>().getAllMarketplaceCategories(marketplace!);
    fosCategories.fold(
      (l) => null,
      (cat) => allCategories = cat as List<CategoryPresta>?, // TODO: Shopify
    );
    if (allCategories != null) categories = allCategories!.where((e) => e.active == '1').toList();
  }

  final rows = _generateRows(selectedProducts, categories);

  if (context.mounted) {
    WoltModalSheet.show(
      context: context,
      useSafeArea: false,
      pageListBuilder: (woltContext) {
        return [
          WoltModalSheetPage(
            hasTopBarLayer: true,
            isTopBarLayerAlwaysVisible: true,
            topBarTitle: const Text('Typ auswählen', style: TextStyles.h3Bold),
            trailingNavBarWidget: trailing,
            child: Column(
              children: [
                ListTile(
                  title: const Text('CSV'),
                  onTap: () {
                    _saveAndShareCsv(rows, iconButtonKey);
                    context.router.pop();
                  },
                ),
                const Divider(),
                ListTile(
                  title: const Text('Excel'),
                  onTap: () {
                    _saveAndShareExcel(context, rows, iconButtonKey);
                    context.router.pop();
                  },
                ),
              ],
            ),
          ),
        ];
      },
    );
  }
}

List<List<dynamic>> _generateRows(List<Product> selectedProducts, List<CategoryPresta>? categories) {
  List<List<dynamic>> rows = [
    [
      'ID',
      'Artikelnummer',
      'Name',
      'Beschreibung',
      'Beschreibung (HTML)',
      'Kurzbeschreibung',
      'Kurzbeschreibung (HTML)',
      'Hersteller',
      'Gewicht in kg',
      'Gewicht in g',
      'Preis Netto',
      'Preis Brutto',
      'Lagerbestand',
      'Verfügbarer Bestand',
      'EAN',
      'Kategorien',
      'SEO URL',
      'Set-Artikel',
      'Aktiv',
    ],
  ];

  int pos = 1;
  for (final product in selectedProducts) {
    final documentDescription = parse(product.description);
    final blancDescription = documentDescription.body!.text;
    final documentDescriptionShort = parse(product.descriptionShort);
    final blancDescriptionShort = documentDescriptionShort.body!.text;

    final categoryNamesString = categories != null ? _getCategories(product, categories) : '';

    final row = [
      pos,
      product.articleNumber,
      product.name,
      product.description,
      blancDescription,
      product.descriptionShort,
      blancDescriptionShort,
      product.manufacturer,
      product.weight,
      (product.weight * 1000).toStringAsFixed(0),
      product.netPrice,
      product.grossPrice,
      product.warehouseStock,
      product.availableStock,
      product.ean,
      categoryNamesString,
      generateFriendlyUrl(product.name),
      product.isSetArticle,
      product.isActive,
    ];
    rows.add(row);
    pos++;
  }
  return rows;
}

String _getCategories(Product product, List<CategoryPresta> categoriesPresta) {
  final index = product.productMarketplaces.indexWhere((e) => e.idMarketplace == 'Uh2NdcXphcN7ABnSBAGU'); //TODO: make dynamic
  if (index == -1) return '';

  final productMarketplace = product.productMarketplaces[index];

  final categories = categoriesPresta
      .where((e) => (productMarketplace.marketplaceProduct as ProductPresta).associations!.associationsCategories!.any((f) => f.id.toMyInt() == e.id))
      .toList();

  if (categories.isEmpty) return '';
  final categoryNames = categories.map((e) => e.name).toList();
  final categoriesString = categoryNames.join('; ');
  return categoriesString;
}

Future<void> _saveAndShareCsv(List<List<dynamic>> rows, GlobalKey<State<StatefulWidget>> iconButtonKey) async {
  final csvString = const ListToCsvConverter().convert(rows);
  final box = iconButtonKey.currentContext!.findRenderObject() as RenderBox;
  final directory = await getApplicationDocumentsDirectory();
  final path = '${directory.path}/Artikel.csv';
  final file = File(path);

  await file.writeAsString(csvString);

  final XFile csvFile = XFile(path);

  Share.shareXFiles([csvFile], sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
}

Future<void> _saveAndShareExcel(BuildContext context, List<List<dynamic>> rows, GlobalKey<State<StatefulWidget>> iconButtonKey) async {
  var excel = Excel.createExcel(); // Erstellt ein neues Excel-Dokument
  Sheet sheetObject = excel['Sheet1']; // Oder erstelle ein neues Blatt mit einem spezifischen Namen

  for (var row in rows) {
    List<CellValue> cellValues = row.map((e) => TextCellValue(e.toString())).toList();
    sheetObject.appendRow(cellValues); // Fügt jede Zeile dem Blatt hinzu, umgewandelt in CellValue
  }

  final directory = await getApplicationDocumentsDirectory(); // Holt das Verzeichnis für Dokumente
  String filePath = "${directory.path}/Artikel.xlsx"; // Pfad für die Excel-Datei
  File(filePath)
    ..createSync(recursive: true)
    ..writeAsBytesSync(excel.save()!); // Speichert das Excel-Dokument in einer Datei

  if (context.mounted) {
    final box = iconButtonKey.currentContext!.findRenderObject() as RenderBox;
    Share.shareXFiles([XFile(filePath)], sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size); // Teilt die Excel-Datei
  }
}
