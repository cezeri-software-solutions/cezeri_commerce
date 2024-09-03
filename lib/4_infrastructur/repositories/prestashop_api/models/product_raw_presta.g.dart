// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_raw_presta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductsPresta _$ProductsPrestaFromJson(Map<String, dynamic> json) =>
    ProductsPresta(
      items: (json['products'] as List<dynamic>)
          .map((e) => ProductRawPresta.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductsPrestaToJson(ProductsPresta instance) =>
    <String, dynamic>{
      'products': instance.items,
    };

ProductRawPresta _$ProductRawPrestaFromJson(Map<String, dynamic> json) =>
    ProductRawPresta(
      id: (json['id'] as num).toInt(),
      idManufacturer: json['idManufacturer'] as String,
      idSupplier: json['idSupplier'] as String,
      idCategoryDefault: json['idCategoryDefault'] as String,
      newProduct: json['newProduct'] as String?,
      cacheDefaultAttribute: json['cacheDefaultAttribute'] as String,
      idDefaultImage: json['idDefaultImage'] as String,
      idDefaultCombination: json['idDefaultCombination'] as String,
      idTaxRulesGroup: json['idTaxRulesGroup'] as String,
      positionInCategory: json['positionInCategory'] as String,
      manufacturerName: json['manufacturerName'] as String,
      quantity: json['quantity'] as String,
      type: json['type'] as String,
      idShopDefault: json['idShopDefault'] as String,
      reference: json['reference'] as String,
      supplierReference: json['supplierReference'] as String,
      location: json['location'] as String,
      width: json['width'] as String,
      height: json['height'] as String,
      depth: json['depth'] as String,
      weight: json['weight'] as String,
      quantityDiscount: json['quantityDiscount'] as String,
      ean13: json['ean13'] as String,
      isbn: json['isbn'] as String,
      upc: json['upc'] as String,
      mpn: json['mpn'] as String,
      cacheIsPack: json['cacheIsPack'] as String,
      cacheHasAttachments: json['cacheHasAttachments'] as String,
      isVirtual: json['isVirtual'] as String,
      state: json['state'] as String,
      additionalDeliveryTimes: json['additionalDeliveryTimes'] as String,
      deliveryInStock: json['deliveryInStock'] as String?,
      deliveryInStockMultilanguage:
          (json['deliveryInStockMultilanguage'] as List<dynamic>?)
              ?.map((e) => Multilanguage.fromJson(e as Map<String, dynamic>))
              .toList(),
      deliveryOutStock: json['deliveryOutStock'] as String?,
      deliveryOutStockMultilanguage:
          (json['deliveryOutStockMultilanguage'] as List<dynamic>?)
              ?.map((e) => Multilanguage.fromJson(e as Map<String, dynamic>))
              .toList(),
      onSale: json['onSale'] as String,
      onlineOnly: json['onlineOnly'] as String,
      ecotax: json['ecotax'] as String,
      minimalQuantity: json['minimalQuantity'] as String,
      lowStockThreshold: json['lowStockThreshold'] as String?,
      lowStockAlert: json['lowStockAlert'] as String,
      price: json['price'] as String,
      wholesalePrice: json['wholesalePrice'] as String,
      unity: json['unity'] as String,
      unitPriceRatio: json['unitPriceRatio'] as String,
      additionalShippingCost: json['additionalShippingCost'] as String,
      customizable: json['customizable'] as String,
      textFields: json['textFields'] as String,
      uploadableFiles: json['uploadableFiles'] as String,
      active: json['active'] as String,
      redirectType: json['redirectType'] as String,
      idTypeRedirected: json['idTypeRedirected'] as String,
      availableForOrder: json['availableForOrder'] as String,
      availableDate: json['availableDate'] as String,
      showCondition: json['showCondition'] as String,
      condition: json['condition'] as String,
      showPrice: json['showPrice'] as String,
      indexed: json['indexed'] as String,
      visibility: json['visibility'] as String,
      advancedStockManagement: json['advancedStockManagement'] as String,
      dateAdd: json['dateAdd'] as String,
      dateUpd: json['dateUpd'] as String,
      packStockType: json['packStockType'] as String,
      metaDescription: json['metaDescription'] as String?,
      metaDescriptionMultilanguage:
          (json['metaDescriptionMultilanguage'] as List<dynamic>?)
              ?.map((e) => Multilanguage.fromJson(e as Map<String, dynamic>))
              .toList(),
      metaKeywords: json['metaKeywords'] as String?,
      metaKeywordsMultilanguage:
          (json['metaKeywordsMultilanguage'] as List<dynamic>?)
              ?.map((e) => Multilanguage.fromJson(e as Map<String, dynamic>))
              .toList(),
      metaTitle: json['metaTitle'] as String?,
      metaTitleMultilanguage: (json['metaTitleMultilanguage'] as List<dynamic>?)
          ?.map((e) => Multilanguage.fromJson(e as Map<String, dynamic>))
          .toList(),
      linkRewrite: json['linkRewrite'] as String?,
      linkRewriteMultilanguage:
          (json['linkRewriteMultilanguage'] as List<dynamic>?)
              ?.map((e) => Multilanguage.fromJson(e as Map<String, dynamic>))
              .toList(),
      name: json['name'] as String?,
      nameMultilanguage: (json['nameMultilanguage'] as List<dynamic>?)
          ?.map((e) => Multilanguage.fromJson(e as Map<String, dynamic>))
          .toList(),
      description: json['description'] as String?,
      descriptionMultilanguage:
          (json['descriptionMultilanguage'] as List<dynamic>?)
              ?.map((e) => Multilanguage.fromJson(e as Map<String, dynamic>))
              .toList(),
      descriptionShort: json['descriptionShort'] as String?,
      descriptionShortMultilanguage:
          (json['descriptionShortMultilanguage'] as List<dynamic>?)
              ?.map((e) => Multilanguage.fromJson(e as Map<String, dynamic>))
              .toList(),
      availableNow: json['availableNow'] as String?,
      availableNowMultilanguage:
          (json['availableNowMultilanguage'] as List<dynamic>?)
              ?.map((e) => Multilanguage.fromJson(e as Map<String, dynamic>))
              .toList(),
      availableLater: json['availableLater'] as String?,
      availableLaterMultilanguage:
          (json['availableLaterMultilanguage'] as List<dynamic>?)
              ?.map((e) => Multilanguage.fromJson(e as Map<String, dynamic>))
              .toList(),
      marketplaceLanguages: (json['marketplaceLanguages'] as List<dynamic>?)
          ?.map((e) => LanguagePresta.fromJson(e as Map<String, dynamic>))
          .toList(),
      associations:
          Associations.fromJson(json['associations'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProductRawPrestaToJson(ProductRawPresta instance) =>
    <String, dynamic>{
      'id': instance.id,
      'idManufacturer': instance.idManufacturer,
      'idSupplier': instance.idSupplier,
      'idCategoryDefault': instance.idCategoryDefault,
      'newProduct': instance.newProduct,
      'cacheDefaultAttribute': instance.cacheDefaultAttribute,
      'idDefaultImage': instance.idDefaultImage,
      'idDefaultCombination': instance.idDefaultCombination,
      'idTaxRulesGroup': instance.idTaxRulesGroup,
      'positionInCategory': instance.positionInCategory,
      'manufacturerName': instance.manufacturerName,
      'quantity': instance.quantity,
      'type': instance.type,
      'idShopDefault': instance.idShopDefault,
      'reference': instance.reference,
      'supplierReference': instance.supplierReference,
      'location': instance.location,
      'width': instance.width,
      'height': instance.height,
      'depth': instance.depth,
      'weight': instance.weight,
      'quantityDiscount': instance.quantityDiscount,
      'ean13': instance.ean13,
      'isbn': instance.isbn,
      'upc': instance.upc,
      'mpn': instance.mpn,
      'cacheIsPack': instance.cacheIsPack,
      'cacheHasAttachments': instance.cacheHasAttachments,
      'isVirtual': instance.isVirtual,
      'state': instance.state,
      'additionalDeliveryTimes': instance.additionalDeliveryTimes,
      'deliveryInStock': instance.deliveryInStock,
      'deliveryInStockMultilanguage': instance.deliveryInStockMultilanguage
          ?.map((e) => e.toJson())
          .toList(),
      'deliveryOutStock': instance.deliveryOutStock,
      'deliveryOutStockMultilanguage': instance.deliveryOutStockMultilanguage
          ?.map((e) => e.toJson())
          .toList(),
      'onSale': instance.onSale,
      'onlineOnly': instance.onlineOnly,
      'ecotax': instance.ecotax,
      'minimalQuantity': instance.minimalQuantity,
      'lowStockThreshold': instance.lowStockThreshold,
      'lowStockAlert': instance.lowStockAlert,
      'price': instance.price,
      'wholesalePrice': instance.wholesalePrice,
      'unity': instance.unity,
      'unitPriceRatio': instance.unitPriceRatio,
      'additionalShippingCost': instance.additionalShippingCost,
      'customizable': instance.customizable,
      'textFields': instance.textFields,
      'uploadableFiles': instance.uploadableFiles,
      'active': instance.active,
      'redirectType': instance.redirectType,
      'idTypeRedirected': instance.idTypeRedirected,
      'availableForOrder': instance.availableForOrder,
      'availableDate': instance.availableDate,
      'showCondition': instance.showCondition,
      'condition': instance.condition,
      'showPrice': instance.showPrice,
      'indexed': instance.indexed,
      'visibility': instance.visibility,
      'advancedStockManagement': instance.advancedStockManagement,
      'dateAdd': instance.dateAdd,
      'dateUpd': instance.dateUpd,
      'packStockType': instance.packStockType,
      'metaDescription': instance.metaDescription,
      'metaDescriptionMultilanguage': instance.metaDescriptionMultilanguage
          ?.map((e) => e.toJson())
          .toList(),
      'metaKeywords': instance.metaKeywords,
      'metaKeywordsMultilanguage':
          instance.metaKeywordsMultilanguage?.map((e) => e.toJson()).toList(),
      'metaTitle': instance.metaTitle,
      'metaTitleMultilanguage':
          instance.metaTitleMultilanguage?.map((e) => e.toJson()).toList(),
      'linkRewrite': instance.linkRewrite,
      'linkRewriteMultilanguage':
          instance.linkRewriteMultilanguage?.map((e) => e.toJson()).toList(),
      'name': instance.name,
      'nameMultilanguage':
          instance.nameMultilanguage?.map((e) => e.toJson()).toList(),
      'description': instance.description,
      'descriptionMultilanguage':
          instance.descriptionMultilanguage?.map((e) => e.toJson()).toList(),
      'descriptionShort': instance.descriptionShort,
      'descriptionShortMultilanguage': instance.descriptionShortMultilanguage
          ?.map((e) => e.toJson())
          .toList(),
      'availableNow': instance.availableNow,
      'availableNowMultilanguage':
          instance.availableNowMultilanguage?.map((e) => e.toJson()).toList(),
      'availableLater': instance.availableLater,
      'availableLaterMultilanguage':
          instance.availableLaterMultilanguage?.map((e) => e.toJson()).toList(),
      'marketplaceLanguages':
          instance.marketplaceLanguages?.map((e) => e.toJson()).toList(),
      'associations': instance.associations.toJson(),
    };

Multilanguage _$MultilanguageFromJson(Map<String, dynamic> json) =>
    Multilanguage(
      id: json['id'] as String,
      value: json['value'] as String,
    );

Map<String, dynamic> _$MultilanguageToJson(Multilanguage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'value': instance.value,
    };

Associations _$AssociationsFromJson(Map<String, dynamic> json) => Associations(
      associationsCategories: (json['categories'] as List<dynamic>?)
          ?.map((e) => AssociationsCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
      associationsImages: (json['images'] as List<dynamic>?)
          ?.map((e) => AssociationsImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      associationsCombinations: (json['combinations'] as List<dynamic>?)
          ?.map((e) =>
              AssociationsCombination.fromJson(e as Map<String, dynamic>))
          .toList(),
      associationsProductOptionValues:
          (json['product_option_values'] as List<dynamic>?)
              ?.map((e) => AssociationsProductOptionValue.fromJson(
                  e as Map<String, dynamic>))
              .toList(),
      associationsProductFeatures: (json['product_features'] as List<dynamic>?)
          ?.map((e) =>
              AssociationsProductFeature.fromJson(e as Map<String, dynamic>))
          .toList(),
      associationsStockAvailables: (json['stock_availables'] as List<dynamic>?)
          ?.map((e) =>
              AssociationsStockAvailable.fromJson(e as Map<String, dynamic>))
          .toList(),
      associationsAccessories: (json['accessories'] as List<dynamic>?)
          ?.map(
              (e) => AssociationsAccessory.fromJson(e as Map<String, dynamic>))
          .toList(),
      associationsProductBundle: (json['product_bundle'] as List<dynamic>?)
          ?.map((e) =>
              AssociationsProductBundle.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AssociationsToJson(Associations instance) =>
    <String, dynamic>{
      'categories':
          instance.associationsCategories?.map((e) => e.toJson()).toList(),
      'images': instance.associationsImages?.map((e) => e.toJson()).toList(),
      'combinations':
          instance.associationsCombinations?.map((e) => e.toJson()).toList(),
      'product_option_values': instance.associationsProductOptionValues
          ?.map((e) => e.toJson())
          .toList(),
      'product_features':
          instance.associationsProductFeatures?.map((e) => e.toJson()).toList(),
      'stock_availables':
          instance.associationsStockAvailables?.map((e) => e.toJson()).toList(),
      'accessories':
          instance.associationsAccessories?.map((e) => e.toJson()).toList(),
      'product_bundle':
          instance.associationsProductBundle?.map((e) => e.toJson()).toList(),
    };

AssociationsCategory _$AssociationsCategoryFromJson(
        Map<String, dynamic> json) =>
    AssociationsCategory(
      id: json['id'] as String,
    );

Map<String, dynamic> _$AssociationsCategoryToJson(
        AssociationsCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

AssociationsImage _$AssociationsImageFromJson(Map<String, dynamic> json) =>
    AssociationsImage(
      id: json['id'] as String,
    );

Map<String, dynamic> _$AssociationsImageToJson(AssociationsImage instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

AssociationsCombination _$AssociationsCombinationFromJson(
        Map<String, dynamic> json) =>
    AssociationsCombination(
      id: json['id'] as String,
    );

Map<String, dynamic> _$AssociationsCombinationToJson(
        AssociationsCombination instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

AssociationsProductOptionValue _$AssociationsProductOptionValueFromJson(
        Map<String, dynamic> json) =>
    AssociationsProductOptionValue(
      id: json['id'] as String,
    );

Map<String, dynamic> _$AssociationsProductOptionValueToJson(
        AssociationsProductOptionValue instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

AssociationsProductFeature _$AssociationsProductFeatureFromJson(
        Map<String, dynamic> json) =>
    AssociationsProductFeature(
      id: json['id'] as String,
      idFeatureValue: json['id_feature_value'] as String,
    );

Map<String, dynamic> _$AssociationsProductFeatureToJson(
        AssociationsProductFeature instance) =>
    <String, dynamic>{
      'id': instance.id,
      'id_feature_value': instance.idFeatureValue,
    };

AssociationsStockAvailable _$AssociationsStockAvailableFromJson(
        Map<String, dynamic> json) =>
    AssociationsStockAvailable(
      id: json['id'] as String,
      idProductAttribute: json['id_product_attribute'] as String,
    );

Map<String, dynamic> _$AssociationsStockAvailableToJson(
        AssociationsStockAvailable instance) =>
    <String, dynamic>{
      'id': instance.id,
      'id_product_attribute': instance.idProductAttribute,
    };

AssociationsAccessory _$AssociationsAccessoryFromJson(
        Map<String, dynamic> json) =>
    AssociationsAccessory(
      id: json['id'] as String,
    );

Map<String, dynamic> _$AssociationsAccessoryToJson(
        AssociationsAccessory instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

AssociationsProductBundle _$AssociationsProductBundleFromJson(
        Map<String, dynamic> json) =>
    AssociationsProductBundle(
      id: json['id'] as String,
      idProductAttribute: json['id_product_attribute'] as String,
      quantity: json['quantity'] as String,
    );

Map<String, dynamic> _$AssociationsProductBundleToJson(
        AssociationsProductBundle instance) =>
    <String, dynamic>{
      'id': instance.id,
      'id_product_attribute': instance.idProductAttribute,
      'quantity': instance.quantity,
    };
