import 'package:xml/xml.dart';

import '../../../1_presentation/core/core.dart';
import '../../../3_domain/entities/product/field_language.dart';
import '../../../3_domain/entities/product/product.dart';
import '../../../3_domain/entities/product/product_marketplace.dart';
import '../../../3_domain/entities/product/product_presta.dart';
import 'models/product_raw_presta.dart';

//* Order
XmlBuilder patchOrderStatusBuilder(final int orderId, final int statusId) {
  final builder = XmlBuilder();
  builder.processing('xml', 'version="1.0" encoding="UTF-8"');
  builder.element('prestashop', attributes: {'xmlns:xlink': 'http://www.w3.org/1999/xlink'}, nest: () {
    builder.element('order', nest: () {
      builder.element('id', nest: orderId);
      builder.element('current_state', nest: statusId);
    });
  });
  return builder;
}

//* Product
XmlBuilder patchStockAvailableBuilder(String id, int quantity) {
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

XmlBuilder? patchProductCategoriesBuilder({
  required int id,
  required Product product,
  required ProductMarketplace productMarketplace,
}) {
  final builder = XmlBuilder();
  // bool isAnyFailure = false;
  final marketplaceProductPresta = productMarketplace.marketplaceProduct as ProductPresta;

  builder.processing('xml', 'version="1.0" encoding="UTF-8"');
  builder.element('prestashop', attributes: {'xmlns:xlink': 'http://www.w3.org/1999/xlink'}, nest: () {
    builder.element('product', nest: () {
      builder.element('id', nest: id);
      // builder.element('id_category_default', nest: marketplaceProductPresta.idCategoryDefault);
      // builder.element('reference', nest: product.articleNumber);
      // builder.element('minimal_quantity', nest: '1');
      // builder.element('width', nest: product.width);
      // builder.element('height', nest: product.height);
      // builder.element('depth', nest: product.depth);
      // builder.element('weight', nest: product.weight);
      // builder.element('ean13', nest: product.ean);
      builder.element('price', nest: product.netPrice.toMyRoundedDouble());
      // builder.element('wholesale_price', nest: product.wholesalePrice);
      // builder.element('unity', nest: product.unity);
      // builder.element('unit_price_ratio', nest: product.netPrice / product.unitPrice);
      // builder.element('active', nest: marketplaceProductPresta.active);
      // builder.element('meta_description', nest: convertHtmlToString(product.descriptionShort));
      // builder.element('link_rewrite', nest: generateFriendlyUrl(product.name));
      builder.element('associations', nest: () {
        if (marketplaceProductPresta.associations != null && marketplaceProductPresta.associations!.associationsCategories != null) {
          builder.element('categories', nest: () {
            for (final category in marketplaceProductPresta.associations!.associationsCategories!) {
              builder.element('category', nest: () {
                builder.element('id', nest: category.id);
              });
            }
          });
        }
      });
    });
  });
  // print('#############################################################################################################');
  // print('##############################################################################################################');
  // print('###############################################################################################################');
  // final xmlDocument = builder.buildDocument();
  // final xmlString = xmlDocument.toXmlString(pretty: true);
  // print(xmlString);
  // print('###############################################################################################################');
  // print('##############################################################################################################');
  // print('#############################################################################################################');
  
  // if (isAnyFailure) return null;

  return builder;
}

XmlBuilder? patchProductBuilder({
  required int id,
  required Product product,
  required ProductMarketplace productMarketplace,
  required ProductRawPresta productPresta,
  List<ProductRawPresta>? listOfPartProductsPresta,
}) {
  // int boolToInt(bool bool) => switch (bool) {
  //       true => 1,
  //       false => 0,
  //     };
  final builder = XmlBuilder();
  bool isAnyFailure = false;
  final marketplaceProductPresta = productMarketplace.marketplaceProduct as ProductPresta;
  final marketplaceLanguages = productPresta.marketplaceLanguages;
  void valueBuilder(String? value, List<Multilanguage>? valuesMultilanguage, List<FieldLanguage> listOfProductLanguages, String fieldName) {
    if (valuesMultilanguage != null && valuesMultilanguage.isNotEmpty) {
      if (marketplaceLanguages != null && marketplaceLanguages.isNotEmpty) {
        builder.element(fieldName, nest: () {
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
      return builder.element(fieldName, nest: value);
    }
  }

  builder.processing('xml', 'version="1.0" encoding="UTF-8"');
  builder.element('prestashop', attributes: {'xmlns:xlink': 'http://www.w3.org/1999/xlink'}, nest: () {
    builder.element('product', nest: () {
      builder.element('id', nest: id);
      builder.element('id_category_default', nest: marketplaceProductPresta.idCategoryDefault);
      builder.element('reference', nest: product.articleNumber);
      if (listOfPartProductsPresta != null) builder.element('type', nest: 'pack');
      builder.element('minimal_quantity', nest: '1');
      builder.element('width', nest: product.width);
      builder.element('height', nest: product.height);
      builder.element('depth', nest: product.depth);
      builder.element('weight', nest: product.weight);
      builder.element('ean13', nest: product.ean);
      builder.element('price', nest: product.netPrice.toMyRoundedDouble());
      builder.element('wholesale_price', nest: product.wholesalePrice);
      builder.element('unity', nest: product.unity);
      builder.element('unit_price_ratio', nest: product.netPrice / product.unitPrice);
      builder.element('active', nest: marketplaceProductPresta.active);
      valueBuilder(product.name, productPresta.nameMultilanguage, product.listOfName, 'name');
      valueBuilder(product.description, productPresta.descriptionMultilanguage, product.listOfDescription, 'description');
      valueBuilder(product.descriptionShort, productPresta.descriptionShortMultilanguage, product.listOfDescriptionShort, 'description_short');
      builder.element('meta_description', nest: convertHtmlToString(product.descriptionShort));
      builder.element('link_rewrite', nest: generateFriendlyUrl(product.name));
      builder.element('associations', nest: () {
        if (marketplaceProductPresta.associations != null && marketplaceProductPresta.associations!.associationsCategories != null) {
          builder.element('categories', nest: () {
            for (final category in marketplaceProductPresta.associations!.associationsCategories!) {
              builder.element('category', nest: () {
                builder.element('id', nest: category.id);
              });
            }
          });
          if (listOfPartProductsPresta != null) {
            builder.element('product_bundle', nest: () {
              for (final partOfSetProductPresta in listOfPartProductsPresta) {
                builder.element('product', nest: () {
                  builder.element('id', nest: partOfSetProductPresta.id);
                  builder.element('quantity', nest: partOfSetProductPresta.quantity);
                });
              }
            });
          }
        }
      });
    });
  });
  // print('#############################################################################################################');
  // print('##############################################################################################################');
  // print('###############################################################################################################');
  // final xmlDocument = builder.buildDocument();
  // final xmlString = xmlDocument.toXmlString(pretty: true);
  // print(xmlString);
  // print('###############################################################################################################');
  // print('##############################################################################################################');
  // print('#############################################################################################################');
  if (isAnyFailure) return null;

  return builder;
}
