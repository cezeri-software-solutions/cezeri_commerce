// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_marketplace.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductMarketplace _$ProductMarketplaceFromJson(Map<String, dynamic> json) =>
    ProductMarketplace(
      idMarketplace: json['idMarketplace'] as String?,
      nameMarketplace: json['nameMarketplace'] as String?,
      shortNameMarketplace: json['shortNameMarketplace'] as String?,
      idProduct: json['idProduct'] as int?,
      idManufacturer: json['idManufacturer'] as int?,
      idSupplier: json['idSupplier'] as int?,
      idCategoryDefault: json['idCategoryDefault'] as int?,
      isNew: json['isNew'] as bool?,
      cacheDefaultAttribute: json['cacheDefaultAttribute'] as bool?,
      idDefaultImage: json['idDefaultImage'] as int?,
      idDefaultCombination: json['idDefaultCombination'] as int?,
      idTaxRulesGroup: json['idTaxRulesGroup'] as int?,
      positionInCategory: json['positionInCategory'] as int?,
      manufacturerName: json['manufacturerName'] as String?,
      type: json['type'] as String?,
      idShopDefault: json['idShopDefault'] as int?,
      location: json['location'] as String?,
      quantityDiscount: json['quantityDiscount'] as bool?,
      isbn: json['isbn'] as String?,
      upc: json['upc'] as String?,
      mpn: json['mpn'] as String?,
      cacheIsPack: json['cacheIsPack'] as bool?,
      cacheHasAttachments: json['cacheHasAttachments'] as bool?,
      state: json['state'] as int?,
      additionalDeliveryTimes: json['additionalDeliveryTimes'] as int?,
      deliveryInStock: json['deliveryInStock'] as String?,
      deliveryOutStock: json['deliveryOutStock'] as String?,
      onSale: json['onSale'] as bool?,
      onlineOnly: json['onlineOnly'] as bool?,
      ecotax: (json['ecotax'] as num?)?.toDouble(),
      minimalQuantity: json['minimalQuantity'] as int?,
      lowStockThreshold: json['lowStockThreshold'] as int?,
      lowStockAlert: json['lowStockAlert'] as bool?,
      price: (json['price'] as num?)?.toDouble(),
      wholesalePrice: (json['wholesalePrice'] as num?)?.toDouble(),
      unity: json['unity'] as String?,
      unitPriceRatio: (json['unitPriceRatio'] as num?)?.toDouble(),
      additionalShippingCost:
          (json['additionalShippingCost'] as num?)?.toDouble(),
      customizable: json['customizable'] as int?,
      textFields: json['textFields'] as int?,
      uploadableFiles: json['uploadableFiles'] as int?,
      active: json['active'] as bool?,
      redirectType: json['redirectType'] as String?,
      idTypeRedirected: json['idTypeRedirected'] as int?,
      availableForOrder: json['availableForOrder'] as bool?,
      availableDate: json['availableDate'] == null
          ? null
          : DateTime.parse(json['availableDate'] as String),
      showCondition: json['showCondition'] as bool?,
      condition: json['condition'] as String?,
      showPrice: json['showPrice'] as bool?,
      indexed: json['indexed'] as bool?,
      visibility: json['visibility'] as String?,
      advancedStockManagement: json['advancedStockManagement'] as bool?,
      dateAdd: json['dateAdd'] == null
          ? null
          : DateTime.parse(json['dateAdd'] as String),
      dateUpd: json['dateUpd'] == null
          ? null
          : DateTime.parse(json['dateUpd'] as String),
      packStockType: json['packStockType'] as int?,
      metaDescription: json['metaDescription'] as String?,
      listOfMetaDescription: (json['listOfMetaDescription'] as List<dynamic>?)
          ?.map((e) => ProductLanguage.fromJson(e as Map<String, dynamic>))
          .toList(),
      metaKeywords: json['metaKeywords'] as String?,
      listOfMetaKeywords: (json['listOfMetaKeywords'] as List<dynamic>?)
          ?.map((e) => ProductLanguage.fromJson(e as Map<String, dynamic>))
          .toList(),
      metaTitle: json['metaTitle'] as String?,
      listOfMetaTitle: (json['listOfMetaTitle'] as List<dynamic>?)
          ?.map((e) => ProductLanguage.fromJson(e as Map<String, dynamic>))
          .toList(),
      linkRewrite: json['linkRewrite'] as String?,
      listOfLinkRewrite: (json['listOfLinkRewrite'] as List<dynamic>?)
          ?.map((e) => ProductLanguage.fromJson(e as Map<String, dynamic>))
          .toList(),
      name: json['name'] as String?,
      listOfName: (json['listOfName'] as List<dynamic>?)
          ?.map((e) => ProductLanguage.fromJson(e as Map<String, dynamic>))
          .toList(),
      description: json['description'] as String?,
      listOfDescription: (json['listOfDescription'] as List<dynamic>?)
          ?.map((e) => ProductLanguage.fromJson(e as Map<String, dynamic>))
          .toList(),
      descriptionShort: json['descriptionShort'] as String?,
      listOfDescriptionShort: (json['listOfDescriptionShort'] as List<dynamic>?)
          ?.map((e) => ProductLanguage.fromJson(e as Map<String, dynamic>))
          .toList(),
      availableNow: json['availableNow'] as String?,
      availableLater: json['availableLater'] as String?,
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => ProductAssociations.fromJson(e as Map<String, dynamic>))
          .toList(),
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => ProductAssociations.fromJson(e as Map<String, dynamic>))
          .toList(),
      combinations: (json['combinations'] as List<dynamic>?)
          ?.map((e) => ProductAssociations.fromJson(e as Map<String, dynamic>))
          .toList(),
      productOptionValues: (json['productOptionValues'] as List<dynamic>?)
          ?.map((e) => ProductAssociations.fromJson(e as Map<String, dynamic>))
          .toList(),
      productFeatures: (json['productFeatures'] as List<dynamic>?)
          ?.map((e) => ProductAssociationsProductFeatures.fromJson(
              e as Map<String, dynamic>))
          .toList(),
      tags: (json['tags'] as List<dynamic>?)
          ?.map((e) => ProductAssociations.fromJson(e as Map<String, dynamic>))
          .toList(),
      stockAvailables: (json['stockAvailables'] as List<dynamic>?)
          ?.map((e) => ProductAssociationsStockAvailables.fromJson(
              e as Map<String, dynamic>))
          .toList(),
      accessories: (json['accessories'] as List<dynamic>?)
          ?.map((e) => e as String?)
          .toList(),
      productBundle: (json['productBundle'] as List<dynamic>?)
          ?.map((e) => ProductAssociationsProductBundle.fromJson(
              e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductMarketplaceToJson(ProductMarketplace instance) =>
    <String, dynamic>{
      'idMarketplace': instance.idMarketplace,
      'nameMarketplace': instance.nameMarketplace,
      'shortNameMarketplace': instance.shortNameMarketplace,
      'idProduct': instance.idProduct,
      'idManufacturer': instance.idManufacturer,
      'idSupplier': instance.idSupplier,
      'idCategoryDefault': instance.idCategoryDefault,
      'isNew': instance.isNew,
      'cacheDefaultAttribute': instance.cacheDefaultAttribute,
      'idDefaultImage': instance.idDefaultImage,
      'idDefaultCombination': instance.idDefaultCombination,
      'idTaxRulesGroup': instance.idTaxRulesGroup,
      'positionInCategory': instance.positionInCategory,
      'manufacturerName': instance.manufacturerName,
      'type': instance.type,
      'idShopDefault': instance.idShopDefault,
      'location': instance.location,
      'quantityDiscount': instance.quantityDiscount,
      'isbn': instance.isbn,
      'upc': instance.upc,
      'mpn': instance.mpn,
      'cacheIsPack': instance.cacheIsPack,
      'cacheHasAttachments': instance.cacheHasAttachments,
      'state': instance.state,
      'additionalDeliveryTimes': instance.additionalDeliveryTimes,
      'deliveryInStock': instance.deliveryInStock,
      'deliveryOutStock': instance.deliveryOutStock,
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
      'availableDate': instance.availableDate?.toIso8601String(),
      'showCondition': instance.showCondition,
      'condition': instance.condition,
      'showPrice': instance.showPrice,
      'indexed': instance.indexed,
      'visibility': instance.visibility,
      'advancedStockManagement': instance.advancedStockManagement,
      'dateAdd': instance.dateAdd?.toIso8601String(),
      'dateUpd': instance.dateUpd?.toIso8601String(),
      'packStockType': instance.packStockType,
      'metaDescription': instance.metaDescription,
      'listOfMetaDescription':
          instance.listOfMetaDescription?.map((e) => e.toJson()).toList(),
      'metaKeywords': instance.metaKeywords,
      'listOfMetaKeywords':
          instance.listOfMetaKeywords?.map((e) => e.toJson()).toList(),
      'metaTitle': instance.metaTitle,
      'listOfMetaTitle':
          instance.listOfMetaTitle?.map((e) => e.toJson()).toList(),
      'linkRewrite': instance.linkRewrite,
      'listOfLinkRewrite':
          instance.listOfLinkRewrite?.map((e) => e.toJson()).toList(),
      'name': instance.name,
      'listOfName': instance.listOfName?.map((e) => e.toJson()).toList(),
      'description': instance.description,
      'listOfDescription':
          instance.listOfDescription?.map((e) => e.toJson()).toList(),
      'descriptionShort': instance.descriptionShort,
      'listOfDescriptionShort':
          instance.listOfDescriptionShort?.map((e) => e.toJson()).toList(),
      'availableNow': instance.availableNow,
      'availableLater': instance.availableLater,
      'categories': instance.categories?.map((e) => e.toJson()).toList(),
      'images': instance.images?.map((e) => e.toJson()).toList(),
      'combinations': instance.combinations?.map((e) => e.toJson()).toList(),
      'productOptionValues':
          instance.productOptionValues?.map((e) => e.toJson()).toList(),
      'productFeatures':
          instance.productFeatures?.map((e) => e.toJson()).toList(),
      'tags': instance.tags?.map((e) => e.toJson()).toList(),
      'stockAvailables':
          instance.stockAvailables?.map((e) => e.toJson()).toList(),
      'accessories': instance.accessories,
      'productBundle': instance.productBundle?.map((e) => e.toJson()).toList(),
    };
