import 'package:xml/xml.dart';

import '../../../3_domain/entities/product/product.dart';
import '../../../3_domain/entities/product/product_marketplace.dart';
import '../../../3_domain/entities_presta/language_presta.dart';

XmlBuilder productQuantityBuilder(int id, int quantity) {
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

XmlBuilder productBuilder(int id, Product product, ProductMarketplace productMarketplace, List<LanguagePresta> languages) {
  int boolToInt(bool bool) => switch (bool) {
        true => 1,
        false => 0,
      };
  final builder = XmlBuilder();
  builder.processing('xml', 'version="1.0" encoding="UTF-8"');
  builder.element('prestashop', attributes: {'xmlns:xlink': 'http://www.w3.org/1999/xlink'}, nest: () {
    builder.element('product', nest: () {
      builder.element('id', nest: id);
      builder.element('reference', nest: product.articleNumber);
      builder.element('width', nest: product.width);
      builder.element('height', nest: product.height);
      builder.element('depth', nest: product.depth);
      builder.element('weight', nest: product.weight);
      builder.element('ean13', nest: product.ean);
      builder.element('price', nest: product.netPrice);
      builder.element('wholesale_price', nest: product.wholesalePrice);
      builder.element('unity', nest: product.unity);
      builder.element('unit_price_ratio', nest: product.netPrice / product.unitPrice);
      builder.element('active', nest: boolToInt(productMarketplace.active!).toString());
      builder.element('name', nest: () {
        for (final name in product.listOfName) {
          final id = languages.where((e) => e.isoCode == name.isoCode).first.id;
          builder.element('language', attributes: {'id': id.toString()}, nest: name.description
          );
        }
      });
    });
  });
  return builder;
}
