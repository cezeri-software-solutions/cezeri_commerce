// import 'package:xml/xml.dart';

// import '../entities/language.dart';
// import '../entities/product/product_associations.dart';
// import '../entities/product/product_associations_product_bundle.dart';
// import '../entities/product/product_associations_product_features.dart';
// import '../entities/product/product_associations_stock_availables.dart';
// import '../entities/product/product_language.dart';
// import 'product_presta_image.dart';

// class ProductPrestaOld {
//   int id;
//   int? idManufacturer;
//   int? idSupplier;
//   int? idCategoryDefault;
//   bool? isNew;
//   bool? cacheDefaultAttribute;
//   int? idDefaultImage;
//   int? idDefaultCombination;
//   int? idTaxRulesGroup;
//   int? positionInCategory;
//   String? manufacturerName;
//   int? quantity;
//   String? type;
//   int? idShopDefault;
//   String? reference;
//   String? supplierReference;
//   String? location;
//   double? width;
//   double? height;
//   double? depth;
//   double? weight;
//   bool? quantityDiscount;
//   String? ean13;
//   String? isbn;
//   String? upc;
//   String? mpn;
//   bool? cacheIsPack;
//   bool? cacheHasAttachments;
//   bool? isVirtual;
//   int? state;
//   int? additionalDeliveryTimes;
//   String? deliveryInStock;
//   String? deliveryOutStock;
//   bool? onSale;
//   bool? onlineOnly;
//   double? ecotax;
//   int? minimalQuantity;
//   int? lowStockThreshold;
//   bool? lowStockAlert;
//   double? price;
//   double? wholesalePrice;
//   String? unity;
//   double? unitPriceRatio;
//   double? additionalShippingCost;
//   int? customizable;
//   int? textFields;
//   int? uploadableFiles;
//   bool? active;
//   String? redirectType;
//   int? idTypeRedirected;
//   bool? availableForOrder;
//   DateTime? availableDate;
//   bool? showCondition;
//   String? condition;
//   bool? showPrice;
//   bool? indexed;
//   String? visibility;
//   bool? advancedStockManagement;
//   DateTime? dateAdd;
//   DateTime? dateUpd;
//   int? packStockType;
//   String? metaDescription;
//   List<ProductLanguage>? listOfMetaDescription;
//   String? metaKeywords;
//   List<ProductLanguage>? listOfMetaKeywords;
//   String? metaTitle;
//   List<ProductLanguage>? listOfMetaTitle;
//   String? linkRewrite;
//   List<ProductLanguage>? listOfLinkRewrite;
//   String? name;
//   List<ProductLanguage>? listOfName;
//   String? description;
//   List<ProductLanguage>? listOfDescription;
//   String? descriptionShort;
//   List<ProductLanguage>? listOfDescriptionShort;
//   String? availableNow;
//   String? availableLater;
//   List<int?>? categoryIds;
//   List<int?>? imageIds;
//   List<ProductPrestaImage?>? imageFiles;
//   List<ProductAssociations>? categories;
//   List<ProductAssociations>? images;
//   List<ProductAssociations>? combinations;
//   List<ProductAssociations>? productOptionValues;
//   List<ProductAssociationsProductFeatures>? productFeatures;
//   List<ProductAssociations>? tags;
//   List<ProductAssociationsStockAvailables>? stockAvailables;
//   List<String>? accessories; // ids as String der ähnlichen Produkte in Prestashop, die unten aufgeführt werden.
//   List<ProductAssociationsProductBundle>? productBundle; // Wenn Produktbündel

//   ProductPrestaOld({
//     required this.id,
//     this.idManufacturer,
//     this.idSupplier,
//     this.idCategoryDefault,
//     this.isNew,
//     this.cacheDefaultAttribute,
//     this.idDefaultImage,
//     this.idDefaultCombination,
//     this.idTaxRulesGroup,
//     this.positionInCategory,
//     this.manufacturerName,
//     this.quantity,
//     this.type,
//     this.idShopDefault,
//     this.reference,
//     this.supplierReference,
//     this.location,
//     this.width,
//     this.height,
//     this.depth,
//     this.weight,
//     this.quantityDiscount,
//     this.ean13,
//     this.isbn,
//     this.upc,
//     this.mpn,
//     this.cacheIsPack,
//     this.cacheHasAttachments,
//     this.isVirtual,
//     this.state,
//     this.additionalDeliveryTimes,
//     this.deliveryInStock,
//     this.deliveryOutStock,
//     this.onSale,
//     this.onlineOnly,
//     this.ecotax,
//     this.minimalQuantity,
//     this.lowStockThreshold,
//     this.lowStockAlert,
//     this.price,
//     this.wholesalePrice,
//     this.unity,
//     this.unitPriceRatio,
//     this.additionalShippingCost,
//     this.customizable,
//     this.textFields,
//     this.uploadableFiles,
//     this.active,
//     this.redirectType,
//     this.idTypeRedirected,
//     this.availableForOrder,
//     this.availableDate,
//     this.showCondition,
//     this.condition,
//     this.showPrice,
//     this.indexed,
//     this.visibility,
//     this.advancedStockManagement,
//     this.dateAdd,
//     this.dateUpd,
//     this.packStockType,
//     this.metaDescription,
//     this.listOfMetaDescription,
//     this.metaKeywords,
//     this.listOfMetaKeywords,
//     this.metaTitle,
//     this.listOfMetaTitle,
//     this.linkRewrite,
//     this.listOfLinkRewrite,
//     this.name,
//     this.listOfName,
//     this.description,
//     this.listOfDescription,
//     this.descriptionShort,
//     this.listOfDescriptionShort,
//     this.availableNow,
//     this.availableLater,
//     this.categoryIds,
//     this.imageIds,
//     this.imageFiles,
//     this.categories,
//     this.images,
//     this.combinations,
//     this.productOptionValues,
//     this.productFeatures,
//     this.tags,
//     this.stockAvailables,
//     this.accessories,
//     this.productBundle,
//   });

//   factory ProductPrestaOld.fromXml(XmlDocument document, List<Language> marketplaceLanguages) {
//     bool parseBool(String? value) {
//       if (value == null) {
//         return false;
//       }
//       return value.toLowerCase() == 'true' || value == '1';
//     }

//     final isMultiLanguage = document.findAllElements('name').expand((e) => e.findElements('language')).skip(1).isNotEmpty;

//     // TODO: get from Settings
//     final myLanguages = [Language.emptyDe(), Language.emptyEn(), Language.emptyIt()];

//     final listOfMetaDescription = document.findAllElements('meta_description').expand((e) => e.findElements('language')).map((e) {
//       final iso = marketplaceLanguages.where((element) => element.id == int.parse(e.getAttribute('id')!)).first.isoCode;
//       return ProductLanguage(
//         id: myLanguages.where((element) => element.isoCode == iso).first.id,
//         description: e.text,
//         isoCode: iso,
//       );
//     }).toList();

//     final listOfMetaKeywords = document.findAllElements('meta_keywords').expand((e) => e.findElements('language')).map((e) {
//       final iso = marketplaceLanguages.where((element) => element.id == int.parse(e.getAttribute('id')!)).first.isoCode;
//       return ProductLanguage(
//         id: myLanguages.where((element) => element.isoCode == iso).first.id,
//         description: e.text,
//         isoCode: iso,
//       );
//     }).toList();

//     final listOfMetaTitle = document.findAllElements('meta_title').expand((e) => e.findElements('language')).map((e) {
//       final iso = marketplaceLanguages.where((element) => element.id == int.parse(e.getAttribute('id')!)).first.isoCode;
//       return ProductLanguage(
//         id: myLanguages.where((element) => element.isoCode == iso).first.id,
//         description: e.text,
//         isoCode: iso,
//       );
//     }).toList();

//     final listOfLinkRewrite = document.findAllElements('link_rewrite').expand((e) => e.findElements('language')).map((e) {
//       final iso = marketplaceLanguages.where((element) => element.id == int.parse(e.getAttribute('id')!)).first.isoCode;
//       return ProductLanguage(
//         id: myLanguages.where((element) => element.isoCode == iso).first.id,
//         description: e.text,
//         isoCode: iso,
//       );
//     }).toList();

//     final listOfName = document.findAllElements('name').expand((e) => e.findElements('language')).map((e) {
//       final iso = marketplaceLanguages.where((element) => element.id == int.parse(e.getAttribute('id')!)).first.isoCode;
//       return ProductLanguage(
//         id: myLanguages.where((element) => element.isoCode == iso).first.id,
//         description: e.text,
//         isoCode: iso,
//       );
//     }).toList();

//     final listOfDescription = document.findAllElements('description').expand((e) => e.findElements('language')).map((e) {
//       final iso = marketplaceLanguages.where((element) => element.id == int.parse(e.getAttribute('id')!)).first.isoCode;
//       return ProductLanguage(
//         id: myLanguages.where((element) => element.isoCode == iso).first.id,
//         description: e.text,
//         isoCode: iso,
//       );
//     }).toList();

//     final listOfDescriptionShort = document.findAllElements('description_short').expand((e) => e.findElements('language')).map((e) {
//       final iso = marketplaceLanguages.where((element) => element.id == int.parse(e.getAttribute('id')!)).first.isoCode;
//       return ProductLanguage(
//         id: myLanguages.where((element) => element.isoCode == iso).first.id,
//         description: e.text,
//         isoCode: iso,
//       );
//     }).toList();

//     return ProductPrestaOld(
//       id: int.parse(document.findAllElements('id').first.text),
//       idManufacturer: int.tryParse(document.findAllElements('id_manufacturer').first.text),
//       idSupplier: int.tryParse(document.findAllElements('id_supplier').first.text),
//       idCategoryDefault: int.tryParse(document.findAllElements('id_category_default').first.text),
//       isNew: parseBool(document.findAllElements('new').first.text),
//       cacheDefaultAttribute: parseBool(document.findAllElements('cache_default_attribute').first.text),
//       idDefaultImage: int.tryParse(document.findAllElements('id_default_image').first.text),
//       idDefaultCombination: int.tryParse(document.findAllElements('id_default_combination').first.text),
//       idTaxRulesGroup: int.tryParse(document.findAllElements('id_tax_rules_group').first.text),
//       positionInCategory: int.tryParse(document.findAllElements('position_in_category').first.text),
//       manufacturerName: document.findAllElements('manufacturer_name').first.text,
//       quantity: int.tryParse(document.findAllElements('quantity').first.text),
//       type: document.findAllElements('type').first.text,
//       idShopDefault: int.tryParse(document.findAllElements('id_shop_default').first.text),
//       reference: document.findAllElements('reference').first.text,
//       supplierReference: document.findAllElements('supplier_reference').first.text,
//       location: document.findAllElements('location').first.text,
//       width: double.tryParse(document.findAllElements('width').first.text),
//       height: double.tryParse(document.findAllElements('height').first.text),
//       depth: double.tryParse(document.findAllElements('depth').first.text),
//       weight: double.tryParse(document.findAllElements('weight').first.text),
//       quantityDiscount: parseBool(document.findAllElements('quantity_discount').first.text),
//       ean13: document.findAllElements('ean13').first.text,
//       isbn: document.findAllElements('isbn').first.text,
//       upc: document.findAllElements('upc').first.text,
//       mpn: document.findAllElements('mpn').first.text,
//       cacheIsPack: parseBool(document.findAllElements('cache_is_pack').first.text),
//       cacheHasAttachments: parseBool(document.findAllElements('cache_has_attachments').first.text),
//       isVirtual: parseBool(document.findAllElements('is_virtual').first.text),
//       state: int.tryParse(document.findAllElements('state').first.text),
//       additionalDeliveryTimes: int.tryParse(document.findAllElements('additional_delivery_times').first.text),
//       deliveryInStock: document.findAllElements('delivery_in_stock').first.text,
//       deliveryOutStock: document.findAllElements('delivery_out_stock').first.text,
//       onSale: parseBool(document.findAllElements('on_sale').first.text),
//       onlineOnly: parseBool(document.findAllElements('online_only').first.text),
//       ecotax: double.tryParse(document.findAllElements('ecotax').first.text),
//       minimalQuantity: int.tryParse(document.findAllElements('minimal_quantity').first.text),
//       lowStockThreshold: int.tryParse(document.findAllElements('low_stock_threshold').first.text),
//       lowStockAlert: parseBool(document.findAllElements('low_stock_alert').first.text),
//       price: double.tryParse(document.findAllElements('price').first.text),
//       wholesalePrice: double.tryParse(document.findAllElements('wholesale_price').first.text),
//       unity: document.findAllElements('unity').first.text,
//       unitPriceRatio: double.tryParse(document.findAllElements('unit_price_ratio').first.text),
//       additionalShippingCost: double.tryParse(document.findAllElements('additional_shipping_cost').first.text),
//       customizable: int.tryParse(document.findAllElements('customizable').first.text),
//       textFields: int.tryParse(document.findAllElements('text_fields').first.text),
//       uploadableFiles: int.tryParse(document.findAllElements('uploadable_files').first.text),
//       active: parseBool(document.findAllElements('active').first.text),
//       redirectType: document.findAllElements('redirect_type').first.text,
//       idTypeRedirected: int.tryParse(document.findAllElements('id_type_redirected').first.text),
//       availableForOrder: parseBool(document.findAllElements('available_for_order').first.text),
//       availableDate: DateTime.tryParse(document.findAllElements('available_date').first.text),
//       showCondition: parseBool(document.findAllElements('show_condition').first.text),
//       condition: document.findAllElements('condition').first.text,
//       showPrice: parseBool(document.findAllElements('show_price').first.text),
//       indexed: parseBool(document.findAllElements('indexed').first.text),
//       visibility: document.findAllElements('visibility').first.text,
//       advancedStockManagement: parseBool(document.findAllElements('advanced_stock_management').first.text),
//       dateAdd: DateTime.tryParse(document.findAllElements('date_add').first.text),
//       dateUpd: DateTime.tryParse(document.findAllElements('date_upd').first.text),
//       packStockType: int.tryParse(document.findAllElements('pack_stock_type').first.text),
//       metaDescription: !isMultiLanguage
//           ? document.findAllElements('meta_description').first.text
//           : listOfMetaDescription.where((element) => element.isoCode == 'de').first.description,
//       listOfMetaDescription: listOfMetaDescription,
//       metaKeywords: !isMultiLanguage
//           ? document.findAllElements('meta_keywords').first.text
//           : listOfMetaKeywords.where((element) => element.isoCode == 'de').first.description,
//       listOfMetaKeywords: listOfMetaKeywords,
//       metaTitle: !isMultiLanguage
//           ? document.findAllElements('meta_title').first.text
//           : listOfMetaTitle.where((element) => element.isoCode == 'de').first.description,
//       listOfMetaTitle: listOfMetaTitle,
//       linkRewrite: !isMultiLanguage
//           ? document.findAllElements('link_rewrite').first.text
//           : listOfLinkRewrite.where((element) => element.isoCode == 'de').first.description,
//       listOfLinkRewrite: listOfLinkRewrite,
//       name: !isMultiLanguage ? document.findAllElements('name').first.text : listOfName.where((element) => element.isoCode == 'de').first.description,
//       listOfName: listOfName,
//       description: !isMultiLanguage
//           ? document.findAllElements('description').first.text
//           : listOfDescription.where((element) => element.isoCode == 'de').first.description,
//       listOfDescription: listOfDescription,
//       descriptionShort: !isMultiLanguage
//           ? document.findAllElements('description_short').first.text
//           : listOfDescriptionShort.where((element) => element.isoCode == 'de').first.description,
//       listOfDescriptionShort: listOfDescriptionShort,
//       availableNow: document.findAllElements('available_now').first.text,
//       availableLater: document.findAllElements('available_later').first.text,
//       categoryIds: document.findAllElements('category').map((e) => int.tryParse(e.findAllElements('id').first.text)).toList(),
//       imageIds: document.findAllElements('image').map((e) => int.tryParse(e.findAllElements('id').first.text)).toList(),
//       categories: document
//           .findAllElements('categories')
//           .expand((e) => e.findElements('category'))
//           .map((e) => ProductAssociations(
//                 href: e.getAttribute('xlink:href'),
//                 id: (e.findElements('id').isNotEmpty) ? int.tryParse(e.findElements('id').first.text) : null,
//               ))
//           .toList(),
//       images: document
//           .findAllElements('images')
//           .expand((e) => e.findElements('image'))
//           .map((e) => ProductAssociations(
//                 href: e.getAttribute('xlink:href'),
//                 id: (e.findElements('id').isNotEmpty) ? int.tryParse(e.findElements('id').first.text) : null,
//               ))
//           .toList(),
//       combinations: document
//           .findAllElements('combinations')
//           .expand((e) => e.findElements('combination'))
//           .map((e) => ProductAssociations(
//                 href: e.getAttribute('xlink:href'),
//                 id: (e.findElements('id').isNotEmpty) ? int.tryParse(e.findElements('id').first.text) : null,
//               ))
//           .toList(),
//       productOptionValues: document
//           .findAllElements('product_option_values')
//           .expand((e) => e.findElements('product_option_value'))
//           .map((e) => ProductAssociations(
//                 href: e.getAttribute('xlink:href'),
//                 id: (e.findElements('id').isNotEmpty) ? int.tryParse(e.findElements('id').first.text) : null,
//               ))
//           .toList(),
//       productFeatures: document
//           .findAllElements('product_features')
//           .expand((e) => e.findElements('product_feature'))
//           .map((e) => ProductAssociationsProductFeatures(
//                 href: e.getAttribute('xlink:href'),
//                 id: (e.findElements('id').isNotEmpty) ? int.tryParse(e.findElements('id').first.text) : null,
//                 idFeatureValue: e.findElements('id_feature_value').firstOrNull?.getAttribute('xlink:href'),
//               ))
//           .toList(),
//       tags: document
//           .findAllElements('tags')
//           .expand((e) => e.findElements('tag'))
//           .map((e) => ProductAssociations(
//                 href: e.getAttribute('xlink:href'),
//                 id: (e.findElements('id').isNotEmpty) ? int.tryParse(e.findElements('id').first.text) : null,
//               ))
//           .toList(),
//       stockAvailables: document
//           .findAllElements('stock_availables')
//           .expand((e) => e.findElements('stock_available'))
//           .map((e) => ProductAssociationsStockAvailables(
//                 href: e.getAttribute('xlink:href'),
//                 id: (e.findElements('id').isNotEmpty) ? int.tryParse(e.findElements('id').first.text) : null,
//                 idProductAttribute:
//                     (e.findElements('id_product_attribute').isNotEmpty) ? int.tryParse(e.findElements('id_product_attribute').first.text) : null,
//               ))
//           .toList(),
//       accessories: document
//           .findAllElements('accessories')
//           .expand((e) => e.findElements('product'))
//           .map((e) => (e.findElements('id').firstOrNull) != null ? e.findElements('id').first.getAttribute('xlink:href')! : '')
//           .toList(),
//       productBundle: document
//           .findAllElements('product_bundle')
//           .expand((e) => e.findElements('product'))
//           .map((e) => ProductAssociationsProductBundle(
//                 id: (e.findElements('id').isNotEmpty) ? int.tryParse(e.findElements('id').first.text) : null,
//                 idProductAttribute:
//                     (e.findElements('id_product_attribute').isNotEmpty) ? int.tryParse(e.findElements('id_product_attribute').first.text) : null,
//                 quantity: (e.findElements('quantity').isNotEmpty) ? int.tryParse(e.findElements('quantity').first.text) : null,
//               ))
//           .toList(),
//     );
//   }

//   ProductPrestaOld copyWith({
//     int? id,
//     int? idManufacturer,
//     int? idSupplier,
//     int? idCategoryDefault,
//     bool? isNew,
//     bool? cacheDefaultAttribute,
//     int? idDefaultImage,
//     int? idDefaultCombination,
//     int? idTaxRulesGroup,
//     int? positionInCategory,
//     String? manufacturerName,
//     int? quantity,
//     String? type,
//     int? idShopDefault,
//     String? reference,
//     String? supplierReference,
//     String? location,
//     double? width,
//     double? height,
//     double? depth,
//     double? weight,
//     bool? quantityDiscount,
//     String? ean13,
//     String? isbn,
//     String? upc,
//     String? mpn,
//     bool? cacheIsPack,
//     bool? cacheHasAttachments,
//     bool? isVirtual,
//     int? state,
//     int? additionalDeliveryTimes,
//     String? deliveryInStock,
//     String? deliveryOutStock,
//     bool? onSale,
//     bool? onlineOnly,
//     double? ecotax,
//     int? minimalQuantity,
//     int? lowStockThreshold,
//     bool? lowStockAlert,
//     double? price,
//     double? wholesalePrice,
//     String? unity,
//     double? unitPriceRatio,
//     double? additionalShippingCost,
//     int? customizable,
//     int? textFields,
//     int? uploadableFiles,
//     bool? active,
//     String? redirectType,
//     int? idTypeRedirected,
//     bool? availableForOrder,
//     DateTime? availableDate,
//     bool? showCondition,
//     String? condition,
//     bool? showPrice,
//     bool? indexed,
//     String? visibility,
//     bool? advancedStockManagement,
//     DateTime? dateAdd,
//     DateTime? dateUpd,
//     int? packStockType,
//     String? metaDescription,
//     List<ProductLanguage>? listOfMetaDescription,
//     String? metaKeywords,
//     List<ProductLanguage>? listOfMetaKeywords,
//     String? metaTitle,
//     List<ProductLanguage>? listOfMetaTitle,
//     String? linkRewrite,
//     List<ProductLanguage>? listOfLinkRewrite,
//     String? name,
//     List<ProductLanguage>? listOfName,
//     String? description,
//     List<ProductLanguage>? listOfDescription,
//     String? descriptionShort,
//     List<ProductLanguage>? listOfDescriptionShort,
//     String? availableNow,
//     String? availableLater,
//     List<int?>? categoryIds,
//     List<int?>? imageIds,
//     List<ProductPrestaImage?>? imageFiles,
//     List<ProductAssociations>? categories,
//     List<ProductAssociations>? images,
//     List<ProductAssociations>? combinations,
//     List<ProductAssociations>? productOptionValues,
//     List<ProductAssociationsProductFeatures>? productFeatures,
//     List<ProductAssociations>? tags,
//     List<ProductAssociationsStockAvailables>? stockAvailables,
//     List<String>? accessories,
//     List<ProductAssociationsProductBundle>? productBundle,
//   }) {
//     return ProductPrestaOld(
//       id: id ?? this.id,
//       idManufacturer: idManufacturer ?? this.idManufacturer,
//       idSupplier: idSupplier ?? this.idSupplier,
//       idCategoryDefault: idCategoryDefault ?? this.idCategoryDefault,
//       isNew: isNew ?? this.isNew,
//       cacheDefaultAttribute: cacheDefaultAttribute ?? this.cacheDefaultAttribute,
//       idDefaultImage: idDefaultImage ?? this.idDefaultImage,
//       idDefaultCombination: idDefaultCombination ?? this.idDefaultCombination,
//       idTaxRulesGroup: idTaxRulesGroup ?? this.idTaxRulesGroup,
//       positionInCategory: positionInCategory ?? this.positionInCategory,
//       manufacturerName: manufacturerName ?? this.manufacturerName,
//       quantity: quantity ?? this.quantity,
//       type: type ?? this.type,
//       idShopDefault: idShopDefault ?? this.idShopDefault,
//       reference: reference ?? this.reference,
//       supplierReference: supplierReference ?? this.supplierReference,
//       location: location ?? this.location,
//       width: width ?? this.width,
//       height: height ?? this.height,
//       depth: depth ?? this.depth,
//       weight: weight ?? this.weight,
//       quantityDiscount: quantityDiscount ?? this.quantityDiscount,
//       ean13: ean13 ?? this.ean13,
//       isbn: isbn ?? this.isbn,
//       upc: upc ?? this.upc,
//       mpn: mpn ?? this.mpn,
//       cacheIsPack: cacheIsPack ?? this.cacheIsPack,
//       cacheHasAttachments: cacheHasAttachments ?? this.cacheHasAttachments,
//       isVirtual: isVirtual ?? this.isVirtual,
//       state: state ?? this.state,
//       additionalDeliveryTimes: additionalDeliveryTimes ?? this.additionalDeliveryTimes,
//       deliveryInStock: deliveryInStock ?? this.deliveryInStock,
//       deliveryOutStock: deliveryOutStock ?? this.deliveryOutStock,
//       onSale: onSale ?? this.onSale,
//       onlineOnly: onlineOnly ?? this.onlineOnly,
//       ecotax: ecotax ?? this.ecotax,
//       minimalQuantity: minimalQuantity ?? this.minimalQuantity,
//       lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
//       lowStockAlert: lowStockAlert ?? this.lowStockAlert,
//       price: price ?? this.price,
//       wholesalePrice: wholesalePrice ?? this.wholesalePrice,
//       unity: unity ?? this.unity,
//       unitPriceRatio: unitPriceRatio ?? this.unitPriceRatio,
//       additionalShippingCost: additionalShippingCost ?? this.additionalShippingCost,
//       customizable: customizable ?? this.customizable,
//       textFields: textFields ?? this.textFields,
//       uploadableFiles: uploadableFiles ?? this.uploadableFiles,
//       active: active ?? this.active,
//       redirectType: redirectType ?? this.redirectType,
//       idTypeRedirected: idTypeRedirected ?? this.idTypeRedirected,
//       availableForOrder: availableForOrder ?? this.availableForOrder,
//       availableDate: availableDate ?? this.availableDate,
//       showCondition: showCondition ?? this.showCondition,
//       condition: condition ?? this.condition,
//       showPrice: showPrice ?? this.showPrice,
//       indexed: indexed ?? this.indexed,
//       visibility: visibility ?? this.visibility,
//       advancedStockManagement: advancedStockManagement ?? this.advancedStockManagement,
//       dateAdd: dateAdd ?? this.dateAdd,
//       dateUpd: dateUpd ?? this.dateUpd,
//       packStockType: packStockType ?? this.packStockType,
//       metaDescription: metaDescription ?? this.metaDescription,
//       listOfMetaDescription: listOfMetaDescription ?? this.listOfMetaDescription,
//       metaKeywords: metaKeywords ?? this.metaKeywords,
//       listOfMetaKeywords: listOfMetaKeywords ?? this.listOfMetaKeywords,
//       metaTitle: metaTitle ?? this.metaTitle,
//       listOfMetaTitle: listOfMetaTitle ?? this.listOfMetaTitle,
//       linkRewrite: linkRewrite ?? this.linkRewrite,
//       listOfLinkRewrite: listOfLinkRewrite ?? this.listOfLinkRewrite,
//       name: name ?? this.name,
//       listOfName: listOfName ?? this.listOfName,
//       description: description ?? this.description,
//       listOfDescription: listOfDescription ?? this.listOfDescription,
//       descriptionShort: descriptionShort ?? this.descriptionShort,
//       listOfDescriptionShort: listOfDescriptionShort ?? this.listOfDescriptionShort,
//       availableNow: availableNow ?? this.availableNow,
//       availableLater: availableLater ?? this.availableLater,
//       categoryIds: categoryIds ?? this.categoryIds,
//       imageIds: imageIds ?? this.imageIds,
//       imageFiles: imageFiles ?? this.imageFiles,
//       categories: categories ?? this.categories,
//       images: images ?? this.images,
//       combinations: combinations ?? this.combinations,
//       productOptionValues: productOptionValues ?? this.productOptionValues,
//       productFeatures: productFeatures ?? this.productFeatures,
//       tags: tags ?? this.tags,
//       stockAvailables: stockAvailables ?? this.stockAvailables,
//       accessories: accessories ?? this.accessories,
//       productBundle: productBundle ?? this.productBundle,
//     );
//   }

//   @override
//   String toString() {
//     return 'ProductPresta(id: $id, idManufacturer: $idManufacturer, idSupplier: $idSupplier, idCategoryDefault: $idCategoryDefault, isNew: $isNew, cacheDefaultAttribute: $cacheDefaultAttribute, idDefaultImage: $idDefaultImage, idDefaultCombination: $idDefaultCombination, idTaxRulesGroup: $idTaxRulesGroup, positionInCategory: $positionInCategory, manufacturerName: $manufacturerName, quantity: $quantity, type: $type, idShopDefault: $idShopDefault, reference: $reference, supplierReference: $supplierReference, location: $location, width: $width, height: $height, depth: $depth, weight: $weight, quantityDiscount: $quantityDiscount, ean13: $ean13, isbn: $isbn, upc: $upc, mpn: $mpn, cacheIsPack: $cacheIsPack, cacheHasAttachments: $cacheHasAttachments, isVirtual: $isVirtual, state: $state, additionalDeliveryTimes: $additionalDeliveryTimes, deliveryInStock: $deliveryInStock, deliveryOutStock: $deliveryOutStock, onSale: $onSale, onlineOnly: $onlineOnly, ecotax: $ecotax, minimalQuantity: $minimalQuantity, lowStockThreshold: $lowStockThreshold, lowStockAlert: $lowStockAlert, price: $price, wholesalePrice: $wholesalePrice, unity: $unity, unitPriceRatio: $unitPriceRatio, additionalShippingCost: $additionalShippingCost, customizable: $customizable, textFields: $textFields, uploadableFiles: $uploadableFiles, active: $active, redirectType: $redirectType, idTypeRedirected: $idTypeRedirected, availableForOrder: $availableForOrder, availableDate: $availableDate, showCondition: $showCondition, condition: $condition, showPrice: $showPrice, indexed: $indexed, visibility: $visibility, advancedStockManagement: $advancedStockManagement, dateAdd: $dateAdd, dateUpd: $dateUpd, packStockType: $packStockType, metaDescription: $metaDescription, listOfMetaDescription: $listOfMetaDescription, metaKeywords: $metaKeywords, listOfMetaKeywords: $listOfMetaKeywords, metaTitle: $metaTitle, listOfMetaTitle: $listOfMetaTitle, linkRewrite: $linkRewrite, listOfLinkRewrite: $listOfLinkRewrite, name: $name, listOfName: $listOfName, description: $description, listOfDescription: $listOfDescription, descriptionShort: $descriptionShort, listOfDescriptionShort: $listOfDescriptionShort, availableNow: $availableNow, availableLater: $availableLater, categoryIds: $categoryIds, imageIds: $imageIds, imageFiles: $imageFiles, categories: $categories, images: $images, combinations: $combinations, productOptionValues: $productOptionValues, productFeatures: $productFeatures, tags: $tags, stockAvailables: $stockAvailables, accessories: $accessories, productBundle: $productBundle)';
//   }
// }
