import 'package:xml/xml.dart';

import '../../../1_presentation/core/functions/mixed_functions.dart';
import '../../../3_domain/entities/product/product.dart';
import '../../../3_domain/entities/product/product_marketplace.dart';
import '../../../3_domain/entities/product/product_presta.dart';
import 'models/product_raw_presta.dart';

XmlBuilder? postProductBuilderOriginal({
  required Product product,
  required ProductMarketplace productMarketplace,
}) {
  // int boolToInt(bool bool) => switch (bool) {
  //       true => 1,
  //       false => 0,
  //     };
  final builder = XmlBuilder();
  // bool isAnyFailure = false;
  final marketplaceProductPresta = productMarketplace.marketplaceProduct as ProductPresta;
  // final marketplaceLanguages = productPresta.marketplaceLanguages;
  // void valueBuilder(String? value, List<Multilanguage>? valuesMultilanguage, List<FieldLanguage> listOfProductLanguages, String fieldName) {
  //   if (valuesMultilanguage != null && valuesMultilanguage.isNotEmpty) {
  //     if (marketplaceLanguages != null && marketplaceLanguages.isNotEmpty) {
  //       builder.element(fieldName, nest: () {
  //         for (final valueLanguage in valuesMultilanguage) {
  //           final languagePresta = marketplaceLanguages.where((lang) => lang.id.toString() == valueLanguage.id).firstOrNull;
  //           if (languagePresta != null) {
  //             final productLanguage =
  //                 listOfProductLanguages.where((e) => e.isoCode.toUpperCase() == languagePresta.isoCode.toUpperCase()).firstOrNull;
  //             if (productLanguage != null) {
  //               final newValue = languagePresta.isoCode.toUpperCase() == 'DE' && value != null ? value : productLanguage.value;
  //               builder.element('language', attributes: {'id': languagePresta.id.toString()}, nest: newValue);
  //             } else {
  //               builder.element('language', attributes: {'id': languagePresta.id.toString()}, nest: valueLanguage.value);
  //             }
  //           }
  //         }
  //       });
  //     }
  //   } else {
  //     if (value == null) isAnyFailure = true;
  //     return builder.element(fieldName, nest: value);
  //   }
  // }

  builder.processing('xml', 'version="1.0" encoding="UTF-8"');
  builder.element('prestashop', attributes: {'xmlns:xlink': 'http://www.w3.org/1999/xlink'}, nest: () {
    builder.element('product', nest: () {
      // builder.element('id', nest: id);
      builder.element('id_manufacturer', nest: 1);
      builder.element('id_supplier', nest: 0);
      builder.element('id_category_default', nest: marketplaceProductPresta.idCategoryDefault);
      builder.element('id_default_combination', nest: 0);
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
      builder.element('name', nest: product.name);
      builder.element('description', nest: product.description);
      builder.element('description_short', nest: product.descriptionShort);
      // valueBuilder(product.name, productPresta.nameMultilanguage, product.listOfName, 'name');
      // valueBuilder(product.description, productPresta.descriptionMultilanguage, product.listOfDescription, 'description');
      // valueBuilder(product.descriptionShort, productPresta.descriptionShortMultilanguage, product.listOfDescriptionShort, 'description_short');
      if (marketplaceProductPresta.associations != null) {
        builder.element('associations', nest: () {
          if (marketplaceProductPresta.associations!.associationsCategories != null) {
            builder.element('categories', nest: () {
              for (final category in marketplaceProductPresta.associations!.associationsCategories!) {
                builder.element('category', nest: () {
                  builder.element('id', nest: category.id);
                });
              }
            });
          }
        });
      }
    });
  });
  // if (isAnyFailure) return null;
  return builder;
}

XmlBuilder? postProductBuilder({
  required Product product,
  required ProductMarketplace productMarketplace,
  required ProductRawPresta productPrestaWithSameManufacturer,
}) {
  // int boolToInt(bool bool) => switch (bool) {
  //       true => 1,
  //       false => 0,
  //     };
  final builder = XmlBuilder();
  // bool isAnyFailure = false;
  final mpp = productMarketplace.marketplaceProduct as ProductPresta;
  // final marketplaceLanguages = productPresta.marketplaceLanguages;
  // void valueBuilder(String? value, List<Multilanguage>? valuesMultilanguage, List<FieldLanguage> listOfProductLanguages, String fieldName) {
  //   if (valuesMultilanguage != null && valuesMultilanguage.isNotEmpty) {
  //     if (marketplaceLanguages != null && marketplaceLanguages.isNotEmpty) {
  //       builder.element(fieldName, nest: () {
  //         for (final valueLanguage in valuesMultilanguage) {
  //           final languagePresta = marketplaceLanguages.where((lang) => lang.id.toString() == valueLanguage.id).firstOrNull;
  //           if (languagePresta != null) {
  //             final productLanguage =
  //                 listOfProductLanguages.where((e) => e.isoCode.toUpperCase() == languagePresta.isoCode.toUpperCase()).firstOrNull;
  //             if (productLanguage != null) {
  //               final newValue = languagePresta.isoCode.toUpperCase() == 'DE' && value != null ? value : productLanguage.value;
  //               builder.element('language', attributes: {'id': languagePresta.id.toString()}, nest: newValue);
  //             } else {
  //               builder.element('language', attributes: {'id': languagePresta.id.toString()}, nest: valueLanguage.value);
  //             }
  //           }
  //         }
  //       });
  //     }
  //   } else {
  //     if (value == null) isAnyFailure = true;
  //     return builder.element(fieldName, nest: value);
  //   }
  // }

  builder.processing('xml', 'version="1.0" encoding="UTF-8"');
  builder.element('prestashop', attributes: {'xmlns:xlink': 'http://www.w3.org/1999/xlink'}, nest: () {
    builder.element('product', nest: () {
      // builder.element('id', nest: id);
      builder.element('id_manufacturer', nest: productPrestaWithSameManufacturer.idManufacturer);
      builder.element('id_supplier', nest: productPrestaWithSameManufacturer.idSupplier);
      builder.element('id_category_default', nest: mpp.idCategoryDefault);
      builder.element('new', nest: '1');
      builder.element('id_default_combination', nest: 0);
      builder.element('id_tax_rules_group', nest: productPrestaWithSameManufacturer.idTaxRulesGroup);
      builder.element('reference', nest: product.articleNumber);
      builder.element('supplier_reference', nest: product.supplierArticleNumber);
      builder.element('width', nest: product.width);
      builder.element('height', nest: product.height);
      builder.element('depth', nest: product.depth);
      builder.element('weight', nest: product.weight);
      builder.element('ean13', nest: product.ean);
      builder.element('state', nest: '1');
      builder.element('product_type', nest: '');
      builder.element('minimal_quantity', nest: '1');
      builder.element('price', nest: product.netPrice);
      builder.element('wholesale_price', nest: product.wholesalePrice);
      builder.element('active', nest: mpp.active);
      builder.element('redirect_type', nest: productPrestaWithSameManufacturer.redirectType);
      builder.element('available_for_order', nest: '1');
      builder.element('show_price', nest: '1');
      builder.element('visibility', nest: 'both');
      builder.element('meta_description', nest: convertHtmlToString(product.descriptionShort));
      builder.element('meta_keywords', nest: '');
      // builder.element('meta_title', nest: product.name);
      builder.element('link_rewrite', nest: generateFriendlyUrl(product.name));
      builder.element('name', nest: product.name);
      builder.element('description', nest: product.description);
      builder.element('description_short', nest: product.descriptionShort);
      builder.element('unity', nest: product.unity);
      builder.element('unit_price_ratio', nest: product.netPrice / product.unitPrice);

      // valueBuilder(product.name, productPresta.nameMultilanguage, product.listOfName, 'name');
      // valueBuilder(product.description, productPresta.descriptionMultilanguage, product.listOfDescription, 'description');
      // valueBuilder(product.descriptionShort, productPresta.descriptionShortMultilanguage, product.listOfDescriptionShort, 'description_short');
      if (mpp.associations != null) {
        builder.element('associations', nest: () {
          if (mpp.associations!.associationsCategories != null) {
            builder.element('categories', nest: () {
              for (final category in mpp.associations!.associationsCategories!) {
                builder.element('category', nest: () {
                  builder.element('id', nest: category.id);
                });
              }
            });
          }
        });
      }
    });
  });
  // if (isAnyFailure) return null;
  return builder;
}
