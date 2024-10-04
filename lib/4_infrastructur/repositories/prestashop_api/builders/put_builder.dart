import 'package:xml/xml.dart';

import '../../../../1_presentation/core/core.dart';
import '../../../../3_domain/entities/product/field_language.dart';
import '../../../../3_domain/entities/product/product.dart';
import '../../../../3_domain/entities/product/product_marketplace.dart';
import '../../../../3_domain/entities/product/product_presta.dart';
import '../models/language_presta.dart';
import '../models/product_raw_presta.dart';

//* Order
XmlDocument orderStatusUpdater(XmlDocument document, int statusId) {
  var toUpdateDocument = document;
  var currentStateElement = toUpdateDocument.findAllElements('order').first;
  currentStateElement.findElements('current_state').first.innerText = statusId.toString();

  return toUpdateDocument;
}

//* Product
XmlDocument stockAvailableUpdater(XmlDocument document, int quantity) {
  var toUpdateDocument = document;
  var stockAvailableElement = toUpdateDocument.findAllElements('stock_available').first;
  stockAvailableElement.findElements('quantity').first.innerText = quantity.toString();

  return toUpdateDocument;
}

XmlDocument productUpdater({
  required XmlDocument document,
  required Product product,
  required ProductMarketplace productMarketplace,
  required ProductRawPresta productPresta,
  List<ProductRawPresta>? listOfPartProductsPresta,
}) {
  final marketplaceProductPresta = productMarketplace.marketplaceProduct as ProductPresta;
  final List<LanguagePresta>? marketplaceLanguages = productPresta.marketplaceLanguages;

  var toUpdateDocument = document;
  var productElement = toUpdateDocument.findAllElements('product').first;
  //****************************************************************
  // var idCategoryDefaultElement = productElement.findElements('id_category_default').firstOrNull;
  // if (idCategoryDefaultElement != null) {
  //   idCategoryDefaultElement.attributes.clear();
  //   idCategoryDefaultElement.innerText = marketplaceProductPresta.idCategoryDefault.toString();
  // }
  //****************************************************************
  productElement.findAllElements('id_category_default').first.innerText = marketplaceProductPresta.idCategoryDefault;
  productElement.findAllElements('reference').first.innerText = product.articleNumber;
  productElement.findAllElements('minimal_quantity').first.innerText = '1';
  productElement.findAllElements('width').first.innerText = product.width.toMyXmlString();
  productElement.findAllElements('height').first.innerText = product.height.toMyXmlString();
  productElement.findAllElements('depth').first.innerText = product.depth.toMyXmlString();
  productElement.findAllElements('weight').first.innerText = product.weight.toMyXmlString();
  productElement.findAllElements('ean13').first.innerText = product.ean;
  productElement.findAllElements('price').first.innerText = product.netPrice.toMyXmlString();
  productElement.findAllElements('wholesale_price').first.innerText = product.wholesalePrice.toMyXmlString();
  productElement.findAllElements('unity').first.innerText = product.unity;
  //productElement.findAllElements('unit_price_ratio').first.innerText = (product.netPrice / product.unitPrice).toMyXmlString();
  productElement.findAllElements('active').first.innerText = marketplaceProductPresta.active;
  productElement.findAllElements('meta_description').first.innerText = convertHtmlToString(product.descriptionShort);
  productElement.findAllElements('link_rewrite').first.innerText = generateFriendlyUrl(product.name);
  final List<Multilanguage>? nameMultilanguage = productPresta.nameMultilanguage;
  final List<FieldLanguage> listOfName = product.listOfName;
  final String? name = productPresta.name;
  var nameElement = productElement.findAllElements('name').first;
  if (nameMultilanguage != null && nameMultilanguage.isNotEmpty) {
    if (marketplaceLanguages != null && marketplaceLanguages.isNotEmpty) {
      for (final valueLanguage in nameMultilanguage) {
        final languagePresta = marketplaceLanguages.where((lang) => lang.id.toString() == valueLanguage.id).firstOrNull;
        if (languagePresta != null) {
          final productLanguage = listOfName.where((e) => e.isoCode.toUpperCase() == languagePresta.isoCode.toUpperCase()).firstOrNull;
          if (productLanguage != null) {
            var languageElement =
                nameElement.findElements('language').where((element) => element.getAttribute('id') == languagePresta.id.toString()).firstOrNull;
            if (languageElement != null) {
              final value = languagePresta.isoCode.toUpperCase() == 'DE' ? product.name : productLanguage.value;
              languageElement.innerText = value;
            }
          } else {
            if (languagePresta.isoCode.toUpperCase() == 'DE') {
              var languageElement =
                  nameElement.findElements('language').where((element) => element.getAttribute('id') == languagePresta.id.toString()).firstOrNull;
              if (languageElement != null) languageElement.innerText = product.name;
            }
          }
        }
      }
    }
  } else {
    if (name != null) nameElement.findAllElements('language').first.innerText = product.name;
  }
  final List<Multilanguage>? descriptionMultilanguage = productPresta.descriptionMultilanguage;
  final List<FieldLanguage> listOfDescription = product.listOfDescription;
  final String? description = productPresta.description;
  var descriptionElement = productElement.findAllElements('description').first;
  if (descriptionMultilanguage != null && descriptionMultilanguage.isNotEmpty) {
    if (marketplaceLanguages != null && marketplaceLanguages.isNotEmpty) {
      for (final valueLanguage in descriptionMultilanguage) {
        final languagePresta = marketplaceLanguages.where((lang) => lang.id.toString() == valueLanguage.id).firstOrNull;
        if (languagePresta != null) {
          final productLanguage = listOfDescription.where((e) => e.isoCode.toUpperCase() == languagePresta.isoCode.toUpperCase()).firstOrNull;
          if (productLanguage != null) {
            var languageElement = descriptionElement
                .findElements('language')
                .where((element) => element.getAttribute('id') == languagePresta.id.toString())
                .firstOrNull;
            if (languageElement != null) {
              final value = languagePresta.isoCode.toUpperCase() == 'DE' ? product.description : productLanguage.value;
              languageElement.innerText = value;
            }
          } else {
            if (languagePresta.isoCode.toUpperCase() == 'DE') {
              var languageElement = descriptionElement
                  .findElements('language')
                  .where((element) => element.getAttribute('id') == languagePresta.id.toString())
                  .firstOrNull;
              if (languageElement != null) languageElement.innerText = product.description;
            }
          }
        }
      }
    }
  } else {
    if (description != null) descriptionElement.findAllElements('language').first.innerText = product.description;
  }
  final List<Multilanguage>? descriptionShortMultilanguage = productPresta.descriptionShortMultilanguage;
  final List<FieldLanguage> listOfDescriptionShort = product.listOfDescriptionShort;
  final String? descriptionShort = productPresta.descriptionShort;
  var descriptionShortElement = productElement.findAllElements('description_short').first;
  if (descriptionShortMultilanguage != null && descriptionShortMultilanguage.isNotEmpty) {
    if (marketplaceLanguages != null && marketplaceLanguages.isNotEmpty) {
      for (final valueLanguage in descriptionShortMultilanguage) {
        final languagePresta = marketplaceLanguages.where((lang) => lang.id.toString() == valueLanguage.id).firstOrNull;
        if (languagePresta != null) {
          final productLanguage = listOfDescriptionShort.where((e) => e.isoCode.toUpperCase() == languagePresta.isoCode.toUpperCase()).firstOrNull;
          if (productLanguage != null) {
            var languageElement = descriptionShortElement
                .findElements('language')
                .where((element) => element.getAttribute('id') == languagePresta.id.toString())
                .firstOrNull;
            if (languageElement != null) {
              final value = languagePresta.isoCode.toUpperCase() == 'DE' ? product.descriptionShort : productLanguage.value;
              languageElement.innerText = value;
            }
          } else {
            if (languagePresta.isoCode.toUpperCase() == 'DE') {
              var languageElement = descriptionShortElement
                  .findElements('language')
                  .where((element) => element.getAttribute('id') == languagePresta.id.toString())
                  .firstOrNull;
              if (languageElement != null) languageElement.innerText = product.descriptionShort;
            }
          }
        }
      }
    }
  } else {
    if (descriptionShort != null) descriptionShortElement.findAllElements('language').first.innerText = product.descriptionShort;
  }
  var associationsElement = productElement.findElements('associations').firstOrNull;
  if (associationsElement != null &&
      marketplaceProductPresta.associations != null &&
      marketplaceProductPresta.associations!.associationsCategories != null) {
    var categoriesElement = associationsElement.findElements('categories').firstOrNull;
    if (categoriesElement != null) {
      categoriesElement.children.clear();
      for (final category in marketplaceProductPresta.associations!.associationsCategories!) {
        categoriesElement.children.add(XmlElement(XmlName('category'), [], [
          XmlElement(XmlName('id'), [], [XmlText(category.id.toString())])
        ]));
      }
    }
    if (listOfPartProductsPresta != null) {
      var productBundleElement = associationsElement.findElements('product_bundle').firstOrNull;
      if (productBundleElement != null) {
        productBundleElement.children.clear();
        for (final partOfSetProductPresta in listOfPartProductsPresta) {
          productBundleElement.children.add(XmlElement(XmlName('product'), [], [
            XmlElement(XmlName('id'), [], [XmlText(partOfSetProductPresta.id.toString())]),
            XmlElement(XmlName('quantity'), [], [XmlText(partOfSetProductPresta.quantity)]),
          ]));
        }
      } else {
        associationsElement.children.add(XmlElement(XmlName('product_bundle'), [], []));
        productBundleElement = associationsElement.findElements('product_bundle').first;
        for (final partOfSetProductPresta in listOfPartProductsPresta) {
          productBundleElement.children.add(XmlElement(XmlName('product'), [], [
            XmlElement(XmlName('id'), [], [XmlText(partOfSetProductPresta.id.toString())]),
            XmlElement(XmlName('quantity'), [], [XmlText(partOfSetProductPresta.quantity)]),
          ]));
        }
      }
    }
  }

  //* #################################################################
  //* Elements to be removed
  var manufacturerNameElement = productElement.findElements('manufacturer_name').firstOrNull;
  if (manufacturerNameElement != null) {
    manufacturerNameElement.parent!.children.remove(manufacturerNameElement);
  }
  var quantityNameElement = productElement.findElements('quantity').firstOrNull;
  if (quantityNameElement != null) {
    quantityNameElement.parent!.children.remove(quantityNameElement);
  }
  var positionInCategoryNameElement = productElement.findElements('position_in_category').firstOrNull;
  if (positionInCategoryNameElement != null) {
    positionInCategoryNameElement.parent!.children.remove(positionInCategoryNameElement);
  }
  print(toUpdateDocument.toXmlString());

  return toUpdateDocument;
}
