import 'package:logger/logger.dart';
import 'package:xml/xml.dart';

import '../../../3_domain/entities/product/marketplace_product_presta.dart';
import '../../../3_domain/entities/product/product.dart';
import '../../../3_domain/entities/product/product_language.dart';
import '../../../3_domain/entities/product/product_marketplace.dart';
import '../../../3_domain/entities_presta/product_presta.dart';

XmlBuilder stockAvailableBuilder(String id, int quantity) {
  final builder = XmlBuilder();
  builder.processing('xml', 'version="1.0" encoding="UTF-8"');
  builder.element('prestashop', attributes: {'xmlns:xlink': 'http://www.w3.org/1999/xlink'}, nest: () {
    builder.element('stock_available', nest: () {
      builder.element('id', nest: id);
      builder.element('quantity', nest: quantity);
    });
  });
  return builder;
}

XmlBuilder? productBuilder({
  required int id,
  required Product product,
  required ProductMarketplace productMarketplace,
  required ProductPresta productPresta,
}) {
  final logger = Logger();
  // int boolToInt(bool bool) => switch (bool) {
  //       true => 1,
  //       false => 0,
  //     };
  final builder = XmlBuilder();
  bool isAnyFailure = false;
  final marketplaceProductPresta = productMarketplace.marketplaceProduct as MarketplaceProductPresta;
  final marketplaceLanguages = productPresta.marketplaceLanguages;
  void valueBuilder(String? value, List<Multilanguage>? valuesMultilanguage, List<ProductLanguage> listOfProductLanguages) {
    if (valuesMultilanguage != null && valuesMultilanguage.isNotEmpty) {
      if (marketplaceLanguages != null && marketplaceLanguages.isNotEmpty) {
        builder.element('name', nest: () {
          for (final valueLanguage in valuesMultilanguage) {
            final languagePresta = marketplaceLanguages.where((lang) => lang.id.toString() == valueLanguage.id).firstOrNull;
            if (languagePresta != null) {
              final productLanguage =
                  listOfProductLanguages.where((e) => e.isoCode.toUpperCase() == languagePresta.isoCode.toUpperCase()).firstOrNull;
              if (productLanguage != null) {
                final newValue = languagePresta.isoCode.toUpperCase() == 'DE' && value != null ? value : productLanguage.value;
                builder.element('language', attributes: {'id': languagePresta.id.toString()}, nest: newValue);
              } else {
                builder.element('language', attributes: {'id': languagePresta.id.toString()}, nest: valueLanguage.value);
              }
            }
          }
        });
      }
    } else {
      if (value == null) isAnyFailure = true;
      return builder.element('name', nest: value);
    }
  }

  builder.processing('xml', 'version="1.0" encoding="UTF-8"');
  builder.element('prestashop', attributes: {'xmlns:xlink': 'http://www.w3.org/1999/xlink'}, nest: () {
    builder.element('product', nest: () {
      builder.element('id', nest: id);
      builder.element('reference', nest: product.articleNumber);
      builder.element('minimal_quantity', nest: '1');
      builder.element('width', nest: product.width);
      builder.element('height', nest: product.height);
      builder.element('depth', nest: product.depth);
      builder.element('weight', nest: product.weight);
      builder.element('ean13', nest: product.ean);
      builder.element('price', nest: product.netPrice);
      builder.element('wholesale_price', nest: product.wholesalePrice);
      builder.element('unity', nest: product.unity);
      builder.element('unit_price_ratio', nest: product.netPrice / product.unitPrice);
      builder.element('active', nest: marketplaceProductPresta.active);
      valueBuilder(product.name, productPresta.nameMultilanguage, product.listOfName);
    });
  });
  if (isAnyFailure) return null;
  return builder;
}
