import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'language_presta.dart';
import 'product_presta_image.dart';

part 'product_raw_presta.g.dart';

@JsonSerializable()
class ProductsPresta {
  static const _encoder = JsonEncoder.withIndent('  ');

  @JsonKey(name: 'products')
  final List<ProductRawPresta> items;

  const ProductsPresta({required this.items});

  factory ProductsPresta.fromJson(Map<String, dynamic> json) => _$ProductsPrestaFromJson(json);
  Map<String, dynamic> toJson() => _$ProductsPrestaToJson(this);

  @override
  String toString() => _encoder.convert(toJson());
}

@JsonSerializable(explicitToJson: true)
class ProductRawPresta {
  static const _encoder = JsonEncoder.withIndent('  ');

  final int id;
  final String idManufacturer;
  final String idSupplier;
  final String idCategoryDefault;
  final String? newProduct;
  final String cacheDefaultAttribute;
  final String idDefaultImage;
  final String idDefaultCombination;
  final String idTaxRulesGroup;
  final String positionInCategory;
  final String manufacturerName;
  final String quantity;
  final String type;
  final String idShopDefault;
  final String reference;
  final String supplierReference;
  final String location;
  final String width;
  final String height;
  final String depth;
  final String weight;
  final String quantityDiscount;
  final String ean13;
  final String isbn;
  final String upc;
  final String mpn;
  final String cacheIsPack;
  final String cacheHasAttachments;
  final String isVirtual;
  final String state;
  final String additionalDeliveryTimes;
  final String? deliveryInStock;
  final List<Multilanguage>? deliveryInStockMultilanguage;
  final String? deliveryOutStock;
  final List<Multilanguage>? deliveryOutStockMultilanguage;
  final String onSale;
  final String onlineOnly;
  final String ecotax;
  final String minimalQuantity;
  final String? lowStockThreshold;
  final String lowStockAlert;
  final String price;
  final String wholesalePrice;
  final String unity;
  final String unitPriceRatio;
  final String additionalShippingCost;
  final String customizable;
  final String textFields;
  final String uploadableFiles;
  final String active;
  final String redirectType;
  final String idTypeRedirected;
  final String availableForOrder;
  final String availableDate;
  final String showCondition;
  final String condition;
  final String showPrice;
  final String indexed;
  final String visibility;
  final String advancedStockManagement;
  final String dateAdd;
  final String dateUpd;
  final String packStockType;
  final String? metaDescription;
  final List<Multilanguage>? metaDescriptionMultilanguage;
  final String? metaKeywords;
  final List<Multilanguage>? metaKeywordsMultilanguage;
  final String? metaTitle;
  final List<Multilanguage>? metaTitleMultilanguage;
  final String? linkRewrite;
  final List<Multilanguage>? linkRewriteMultilanguage;
  final String? name;
  final List<Multilanguage>? nameMultilanguage;
  final String? description;
  final List<Multilanguage>? descriptionMultilanguage;
  final String? descriptionShort;
  final List<Multilanguage>? descriptionShortMultilanguage;
  final String? availableNow;
  final List<Multilanguage>? availableNowMultilanguage;
  final String? availableLater;
  final List<Multilanguage>? availableLaterMultilanguage;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final List<ProductPrestaImage>? imageFiles;
  final List<LanguagePresta>? marketplaceLanguages;
  final Associations associations;

  ProductRawPresta({
    required this.id,
    required this.idManufacturer,
    required this.idSupplier,
    required this.idCategoryDefault,
    this.newProduct,
    required this.cacheDefaultAttribute,
    required this.idDefaultImage,
    required this.idDefaultCombination,
    required this.idTaxRulesGroup,
    required this.positionInCategory,
    required this.manufacturerName,
    required this.quantity,
    required this.type,
    required this.idShopDefault,
    required this.reference,
    required this.supplierReference,
    required this.location,
    required this.width,
    required this.height,
    required this.depth,
    required this.weight,
    required this.quantityDiscount,
    required this.ean13,
    required this.isbn,
    required this.upc,
    required this.mpn,
    required this.cacheIsPack,
    required this.cacheHasAttachments,
    required this.isVirtual,
    required this.state,
    required this.additionalDeliveryTimes,
    required this.deliveryInStock,
    required this.deliveryInStockMultilanguage,
    required this.deliveryOutStock,
    required this.deliveryOutStockMultilanguage,
    required this.onSale,
    required this.onlineOnly,
    required this.ecotax,
    required this.minimalQuantity,
    this.lowStockThreshold,
    required this.lowStockAlert,
    required this.price,
    required this.wholesalePrice,
    required this.unity,
    required this.unitPriceRatio,
    required this.additionalShippingCost,
    required this.customizable,
    required this.textFields,
    required this.uploadableFiles,
    required this.active,
    required this.redirectType,
    required this.idTypeRedirected,
    required this.availableForOrder,
    required this.availableDate,
    required this.showCondition,
    required this.condition,
    required this.showPrice,
    required this.indexed,
    required this.visibility,
    required this.advancedStockManagement,
    required this.dateAdd,
    required this.dateUpd,
    required this.packStockType,
    required this.metaDescription,
    required this.metaDescriptionMultilanguage,
    required this.metaKeywords,
    this.metaKeywordsMultilanguage,
    required this.metaTitle,
    this.metaTitleMultilanguage,
    required this.linkRewrite,
    this.linkRewriteMultilanguage,
    required this.name,
    this.nameMultilanguage,
    required this.description,
    this.descriptionMultilanguage,
    required this.descriptionShort,
    this.descriptionShortMultilanguage,
    required this.availableNow,
    this.availableNowMultilanguage,
    required this.availableLater,
    this.availableLaterMultilanguage,
    this.imageFiles,
    this.marketplaceLanguages,
    required this.associations,
  });

  factory ProductRawPresta.fromJson(Map<String, dynamic> json) {
    String? deliveryInStock;
    List<Multilanguage>? deliveryInStockMultilanguage;
    String? deliveryOutStock;
    List<Multilanguage>? deliveryOutStockMultilanguage;
    String? metaDescription;
    List<Multilanguage>? metaDescriptionMultilanguage;
    String? metaKeywords;
    List<Multilanguage>? metaKeywordsMultilanguage;
    String? metaTitle;
    List<Multilanguage>? metaTitleMultilanguage;
    String? linkRewrite;
    List<Multilanguage>? linkRewriteMultilanguage;
    String? name;
    List<Multilanguage>? nameMultilanguage;
    String? description;
    List<Multilanguage>? descriptionMultilanguage;
    String? descriptionShort;
    List<Multilanguage>? descriptionShortMultilanguage;
    String? availableNow;
    List<Multilanguage>? availableNowMultilanguage;
    String? availableLater;
    List<Multilanguage>? availableLaterMultilanguage;
    if (json['delivery_in_stock'] is String) {
      deliveryInStock = json['delivery_in_stock'] as String;
    } else if (json['delivery_in_stock'] is List) {
      var firstItem = json['delivery_in_stock'][0];
      if (firstItem is Map<String, dynamic> && firstItem['value'] is String) {
        deliveryInStock = firstItem['value'];
      }
      deliveryInStockMultilanguage = (json['delivery_in_stock'] as List).map((e) => Multilanguage.fromJson(e as Map<String, dynamic>)).toList();
    }
    if (json['delivery_out_stock'] is String) {
      deliveryOutStock = json['delivery_out_stock'] as String;
    } else if (json['delivery_out_stock'] is List) {
      var firstItem = json['delivery_out_stock'][0];
      if (firstItem is Map<String, dynamic> && firstItem['value'] is String) {
        deliveryOutStock = firstItem['value'];
      }
      deliveryOutStockMultilanguage = (json['delivery_out_stock'] as List).map((e) => Multilanguage.fromJson(e as Map<String, dynamic>)).toList();
    }
    if (json['meta_description'] is String) {
      metaDescription = json['meta_description'] as String;
    } else if (json['meta_description'] is List) {
      var firstItem = json['meta_description'][0];
      if (firstItem is Map<String, dynamic> && firstItem['value'] is String) {
        metaDescription = firstItem['value'];
      }
      metaDescriptionMultilanguage = (json['meta_description'] as List).map((e) => Multilanguage.fromJson(e as Map<String, dynamic>)).toList();
    }
    if (json['meta_keywords'] is String) {
      metaKeywords = json['meta_keywords'] as String;
    } else if (json['meta_keywords'] is List) {
      var firstItem = json['meta_keywords'][0];
      if (firstItem is Map<String, dynamic> && firstItem['value'] is String) {
        metaKeywords = firstItem['value'];
      }
      metaKeywordsMultilanguage = (json['meta_keywords'] as List).map((e) => Multilanguage.fromJson(e as Map<String, dynamic>)).toList();
    }
    if (json['meta_title'] is String) {
      metaTitle = json['meta_title'] as String;
    } else if (json['meta_title'] is List) {
      var firstItem = json['meta_title'][0];
      if (firstItem is Map<String, dynamic> && firstItem['value'] is String) {
        metaTitle = firstItem['value'];
      }
      metaTitleMultilanguage = (json['meta_title'] as List).map((e) => Multilanguage.fromJson(e as Map<String, dynamic>)).toList();
    }
    if (json['link_rewrite'] is String) {
      linkRewrite = json['link_rewrite'] as String;
    } else if (json['link_rewrite'] is List) {
      var firstItem = json['link_rewrite'][0];
      if (firstItem is Map<String, dynamic> && firstItem['value'] is String) {
        linkRewrite = firstItem['value'];
      }
      linkRewriteMultilanguage = (json['link_rewrite'] as List).map((e) => Multilanguage.fromJson(e as Map<String, dynamic>)).toList();
    }
    if (json['name'] is String) {
      name = json['name'] as String;
    } else if (json['name'] is List) {
      var firstItem = json['name'][0];
      if (firstItem is Map<String, dynamic> && firstItem['value'] is String) {
        name = firstItem['value'];
      }
      nameMultilanguage = (json['name'] as List).map((e) => Multilanguage.fromJson(e as Map<String, dynamic>)).toList();
    }
    if (json['description'] is String) {
      description = json['description'] as String;
    } else if (json['description'] is List) {
      var firstItem = json['description'][0];
      if (firstItem is Map<String, dynamic> && firstItem['value'] is String) {
        description = firstItem['value'];
      }
      descriptionMultilanguage = (json['description'] as List).map((e) => Multilanguage.fromJson(e as Map<String, dynamic>)).toList();
    }
    if (json['description_short'] is String) {
      descriptionShort = json['description_short'] as String;
    } else if (json['description_short'] is List) {
      var firstItem = json['description_short'][0];
      if (firstItem is Map<String, dynamic> && firstItem['value'] is String) {
        descriptionShort = firstItem['value'];
      }
      descriptionShortMultilanguage = (json['description_short'] as List).map((e) => Multilanguage.fromJson(e as Map<String, dynamic>)).toList();
    }
    if (json['available_now'] is String) {
      availableNow = json['available_now'] as String;
    } else if (json['available_now'] is List) {
      var firstItem = json['available_now'][0];
      if (firstItem is Map<String, dynamic> && firstItem['value'] is String) {
        availableNow = firstItem['value'];
      }
      availableNowMultilanguage = (json['available_now'] as List).map((e) => Multilanguage.fromJson(e as Map<String, dynamic>)).toList();
    }
    if (json['available_later'] is String) {
      availableLater = json['available_later'] as String;
    } else if (json['available_later'] is List) {
      var firstItem = json['available_later'][0];
      if (firstItem is Map<String, dynamic> && firstItem['value'] is String) {
        availableLater = firstItem['value'];
      }
      availableLaterMultilanguage = (json['available_later'] as List).map((e) => Multilanguage.fromJson(e as Map<String, dynamic>)).toList();
    }
    if (json['available_later'] is String) {
      availableLater = json['available_later'] as String;
    } else if (json['available_later'] is List) {
      var firstItem = json['available_later'][0];
      if (firstItem is Map<String, dynamic> && firstItem['value'] is String) {
        availableLater = firstItem['value'];
      }
      availableLaterMultilanguage = (json['available_later'] as List).map((e) => Multilanguage.fromJson(e as Map<String, dynamic>)).toList();
    }
    
    return ProductRawPresta(
      id: json['id'] as int,
      idManufacturer: json['id_manufacturer'] as String,
      idSupplier: json['id_supplier'] as String,
      idCategoryDefault: json['id_category_default'] as String,
      newProduct: json['new'] as String?,
      cacheDefaultAttribute: json['cache_default_attribute'] != null ? json['cache_default_attribute'] as String : '',
      idDefaultImage: json['id_default_image'] as String,
      idDefaultCombination: ProductRawPresta._idDefaultCombinationFromJson(json['id_default_combination']),
      idTaxRulesGroup: json['id_tax_rules_group'] as String,
      positionInCategory: json['position_in_category'] as String,
      manufacturerName: json['manufacturer_name'] is String ? json['manufacturer_name'] as String : '',
      quantity: json['quantity'] as String,
      type: json['type'] as String,
      idShopDefault: json['id_shop_default'] as String,
      reference: json['reference'] as String,
      supplierReference: json['supplier_reference'] as String,
      location: json['location'] as String,
      width: json['width'] as String,
      height: json['height'] as String,
      depth: json['depth'] as String,
      weight: json['weight'] as String,
      quantityDiscount: json['quantity_discount'] as String,
      ean13: json['ean13'] as String,
      isbn: json['isbn'] as String,
      upc: json['upc'] as String,
      mpn: json['mpn'] as String,
      cacheIsPack: json['cache_is_pack'] as String,
      cacheHasAttachments: json['cache_has_attachments'] as String,
      isVirtual: json['is_virtual'] as String,
      state: json['state'] as String,
      additionalDeliveryTimes: json['additional_delivery_times'] as String,
      deliveryInStock: deliveryInStock,
      deliveryInStockMultilanguage: deliveryInStockMultilanguage,
      deliveryOutStock: deliveryOutStock,
      deliveryOutStockMultilanguage: deliveryOutStockMultilanguage,
      onSale: json['on_sale'] as String,
      onlineOnly: json['online_only'] as String,
      ecotax: json['ecotax'] as String,
      minimalQuantity: json['minimal_quantity'] as String,
      lowStockThreshold: json['low_stock_threshold'] as String?,
      lowStockAlert: json['low_stock_alert'] as String,
      price: json['price'] as String,
      wholesalePrice: json['wholesale_price'] as String,
      unity: json['unity'] as String,
      unitPriceRatio: json['unit_price_ratio'] is String ? json['unit_price_ratio'] as String : json['unit_price_ratio'].toString(),
      additionalShippingCost: json['additional_shipping_cost'] as String,
      customizable: json['customizable'] as String,
      textFields: json['text_fields'] as String,
      uploadableFiles: json['uploadable_files'] as String,
      active: json['active'] as String,
      redirectType: json['redirect_type'] as String,
      idTypeRedirected: json['id_type_redirected'] as String,
      availableForOrder: json['available_for_order'] as String,
      availableDate: json['available_date'] != null ? json['available_date'] as String : '',
      showCondition: json['show_condition'] as String,
      condition: json['condition'] as String,
      showPrice: json['show_price'] as String,
      indexed: json['indexed'] as String,
      visibility: json['visibility'] as String,
      advancedStockManagement: json['advanced_stock_management'] as String,
      dateAdd: json['date_add'] as String,
      dateUpd: json['date_upd'] as String,
      packStockType: json['pack_stock_type'] as String,
      metaDescription: metaDescription,
      metaDescriptionMultilanguage: metaDescriptionMultilanguage,
      metaKeywords: metaKeywords,
      metaKeywordsMultilanguage: metaKeywordsMultilanguage,
      metaTitle: metaTitle,
      metaTitleMultilanguage: metaTitleMultilanguage,
      linkRewrite: linkRewrite,
      linkRewriteMultilanguage: linkRewriteMultilanguage,
      name: name,
      nameMultilanguage: nameMultilanguage,
      description: description,
      descriptionMultilanguage: descriptionMultilanguage,
      descriptionShort: descriptionShort,
      descriptionShortMultilanguage: descriptionShortMultilanguage,
      availableNow: availableNow,
      availableNowMultilanguage: availableNowMultilanguage,
      availableLater: availableLater,
      availableLaterMultilanguage: availableLaterMultilanguage,
      imageFiles: [],
      associations: Associations.fromJson(json['associations'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => _$ProductRawPrestaToJson(this);

  @override
  String toString() => _encoder.convert(toJson());

  static String _idDefaultCombinationFromJson(dynamic value) {
    if (value is int) return value.toString();
    return value as String;
  }

  // static List<Multilanguage>? _multilanguageFromJson(dynamic value) {
  //   if (value is List) return value.map((e) => Multilanguage.fromJson(e)).toList();
  //   return null;
  // }

  ProductRawPresta copyWith({
    int? id,
    String? idManufacturer,
    String? idSupplier,
    String? idCategoryDefault,
    String? newProduct,
    String? cacheDefaultAttribute,
    String? idDefaultImage,
    String? idDefaultCombination,
    String? idTaxRulesGroup,
    String? positionInCategory,
    String? manufacturerName,
    String? quantity,
    String? type,
    String? idShopDefault,
    String? reference,
    String? supplierReference,
    String? location,
    String? width,
    String? height,
    String? depth,
    String? weight,
    String? quantityDiscount,
    String? ean13,
    String? isbn,
    String? upc,
    String? mpn,
    String? cacheIsPack,
    String? cacheHasAttachments,
    String? isVirtual,
    String? state,
    String? additionalDeliveryTimes,
    String? deliveryInStock,
    List<Multilanguage>? deliveryInStockMultilanguage,
    String? deliveryOutStock,
    List<Multilanguage>? deliveryOutStockMultilanguage,
    String? onSale,
    String? onlineOnly,
    String? ecotax,
    String? minimalQuantity,
    String? lowStockThreshold,
    String? lowStockAlert,
    String? price,
    String? wholesalePrice,
    String? unity,
    String? unitPriceRatio,
    String? additionalShippingCost,
    String? customizable,
    String? textFields,
    String? uploadableFiles,
    String? active,
    String? redirectType,
    String? idTypeRedirected,
    String? availableForOrder,
    String? availableDate,
    String? showCondition,
    String? condition,
    String? showPrice,
    String? indexed,
    String? visibility,
    String? advancedStockManagement,
    String? dateAdd,
    String? dateUpd,
    String? packStockType,
    String? metaDescription,
    List<Multilanguage>? metaDescriptionMultilanguage,
    String? metaKeywords,
    List<Multilanguage>? metaKeywordsMultilanguage,
    String? metaTitle,
    List<Multilanguage>? metaTitleMultilanguage,
    String? linkRewrite,
    List<Multilanguage>? linkRewriteMultilanguage,
    String? name,
    List<Multilanguage>? nameMultilanguage,
    String? description,
    List<Multilanguage>? descriptionMultilanguage,
    String? descriptionShort,
    List<Multilanguage>? descriptionShortMultilanguage,
    String? availableNow,
    List<Multilanguage>? availableNowMultilanguage,
    String? availableLater,
    List<Multilanguage>? availableLaterMultilanguage,
    List<ProductPrestaImage>? imageFiles,
    List<LanguagePresta>? marketplaceLanguages,
    Associations? associations,
  }) {
    return ProductRawPresta(
      id: id ?? this.id,
      idManufacturer: idManufacturer ?? this.idManufacturer,
      idSupplier: idSupplier ?? this.idSupplier,
      idCategoryDefault: idCategoryDefault ?? this.idCategoryDefault,
      newProduct: newProduct ?? this.newProduct,
      cacheDefaultAttribute: cacheDefaultAttribute ?? this.cacheDefaultAttribute,
      idDefaultImage: idDefaultImage ?? this.idDefaultImage,
      idDefaultCombination: idDefaultCombination ?? this.idDefaultCombination,
      idTaxRulesGroup: idTaxRulesGroup ?? this.idTaxRulesGroup,
      positionInCategory: positionInCategory ?? this.positionInCategory,
      manufacturerName: manufacturerName ?? this.manufacturerName,
      quantity: quantity ?? this.quantity,
      type: type ?? this.type,
      idShopDefault: idShopDefault ?? this.idShopDefault,
      reference: reference ?? this.reference,
      supplierReference: supplierReference ?? this.supplierReference,
      location: location ?? this.location,
      width: width ?? this.width,
      height: height ?? this.height,
      depth: depth ?? this.depth,
      weight: weight ?? this.weight,
      quantityDiscount: quantityDiscount ?? this.quantityDiscount,
      ean13: ean13 ?? this.ean13,
      isbn: isbn ?? this.isbn,
      upc: upc ?? this.upc,
      mpn: mpn ?? this.mpn,
      cacheIsPack: cacheIsPack ?? this.cacheIsPack,
      cacheHasAttachments: cacheHasAttachments ?? this.cacheHasAttachments,
      isVirtual: isVirtual ?? this.isVirtual,
      state: state ?? this.state,
      additionalDeliveryTimes: additionalDeliveryTimes ?? this.additionalDeliveryTimes,
      deliveryInStock: deliveryInStock ?? this.deliveryInStock,
      deliveryInStockMultilanguage: deliveryInStockMultilanguage ?? this.deliveryInStockMultilanguage,
      deliveryOutStock: deliveryOutStock ?? this.deliveryOutStock,
      deliveryOutStockMultilanguage: deliveryOutStockMultilanguage ?? this.deliveryOutStockMultilanguage,
      onSale: onSale ?? this.onSale,
      onlineOnly: onlineOnly ?? this.onlineOnly,
      ecotax: ecotax ?? this.ecotax,
      minimalQuantity: minimalQuantity ?? this.minimalQuantity,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      lowStockAlert: lowStockAlert ?? this.lowStockAlert,
      price: price ?? this.price,
      wholesalePrice: wholesalePrice ?? this.wholesalePrice,
      unity: unity ?? this.unity,
      unitPriceRatio: unitPriceRatio ?? this.unitPriceRatio,
      additionalShippingCost: additionalShippingCost ?? this.additionalShippingCost,
      customizable: customizable ?? this.customizable,
      textFields: textFields ?? this.textFields,
      uploadableFiles: uploadableFiles ?? this.uploadableFiles,
      active: active ?? this.active,
      redirectType: redirectType ?? this.redirectType,
      idTypeRedirected: idTypeRedirected ?? this.idTypeRedirected,
      availableForOrder: availableForOrder ?? this.availableForOrder,
      availableDate: availableDate ?? this.availableDate,
      showCondition: showCondition ?? this.showCondition,
      condition: condition ?? this.condition,
      showPrice: showPrice ?? this.showPrice,
      indexed: indexed ?? this.indexed,
      visibility: visibility ?? this.visibility,
      advancedStockManagement: advancedStockManagement ?? this.advancedStockManagement,
      dateAdd: dateAdd ?? this.dateAdd,
      dateUpd: dateUpd ?? this.dateUpd,
      packStockType: packStockType ?? this.packStockType,
      metaDescription: metaDescription ?? this.metaDescription,
      metaDescriptionMultilanguage: metaDescriptionMultilanguage ?? this.metaDescriptionMultilanguage,
      metaKeywords: metaKeywords ?? this.metaKeywords,
      metaKeywordsMultilanguage: metaKeywordsMultilanguage ?? this.metaKeywordsMultilanguage,
      metaTitle: metaTitle ?? this.metaTitle,
      metaTitleMultilanguage: metaTitleMultilanguage ?? this.metaTitleMultilanguage,
      linkRewrite: linkRewrite ?? this.linkRewrite,
      linkRewriteMultilanguage: linkRewriteMultilanguage ?? this.linkRewriteMultilanguage,
      name: name ?? this.name,
      nameMultilanguage: nameMultilanguage ?? this.nameMultilanguage,
      description: description ?? this.description,
      descriptionMultilanguage: descriptionMultilanguage ?? this.descriptionMultilanguage,
      descriptionShort: descriptionShort ?? this.descriptionShort,
      descriptionShortMultilanguage: descriptionShortMultilanguage ?? this.descriptionShortMultilanguage,
      availableNow: availableNow ?? this.availableNow,
      availableNowMultilanguage: availableNowMultilanguage ?? this.availableNowMultilanguage,
      availableLater: availableLater ?? this.availableLater,
      availableLaterMultilanguage: availableLaterMultilanguage ?? this.availableLaterMultilanguage,
      imageFiles: imageFiles ?? this.imageFiles,
      marketplaceLanguages: marketplaceLanguages ?? this.marketplaceLanguages,
      associations: associations ?? this.associations,
    );
  }
}

@JsonSerializable()
class Multilanguage {
  static const _encoder = JsonEncoder.withIndent('  ');

  final String id;
  final String value;

  Multilanguage({required this.id, required this.value});

  factory Multilanguage.fromJson(Map<String, dynamic> json) => _$MultilanguageFromJson(json);
  Map<String, dynamic> toJson() => _$MultilanguageToJson(this);

  @override
  String toString() => _encoder.convert(toJson());
}

@JsonSerializable(explicitToJson: true)
class Associations {
  static const _encoder = JsonEncoder.withIndent('  ');

  @JsonKey(name: 'categories')
  final List<AssociationsCategory>? associationsCategories;
  @JsonKey(name: 'images')
  final List<AssociationsImage>? associationsImages;
  @JsonKey(name: 'combinations')
  final List<AssociationsCombination>? associationsCombinations;
  @JsonKey(name: 'product_option_values')
  final List<AssociationsProductOptionValue>? associationsProductOptionValues;
  @JsonKey(name: 'product_features')
  final List<AssociationsProductFeature>? associationsProductFeatures;
  @JsonKey(name: 'stock_availables')
  final List<AssociationsStockAvailable>? associationsStockAvailables;
  @JsonKey(name: 'accessories')
  final List<AssociationsAccessory>? associationsAccessories;
  @JsonKey(name: 'product_bundle')
  final List<AssociationsProductBundle>? associationsProductBundle;

  Associations({
    required this.associationsCategories,
    required this.associationsImages,
    required this.associationsCombinations,
    required this.associationsProductOptionValues,
    required this.associationsProductFeatures,
    required this.associationsStockAvailables,
    required this.associationsAccessories,
    required this.associationsProductBundle,
  });

  factory Associations.fromJson(Map<String, dynamic> json) => _$AssociationsFromJson(json);
  Map<String, dynamic> toJson() => _$AssociationsToJson(this);

  factory Associations.empty() {
    return Associations(
      associationsCategories: [],
      associationsImages: [],
      associationsCombinations: [],
      associationsProductOptionValues: [],
      associationsProductFeatures: [],
      associationsStockAvailables: [],
      associationsAccessories: [],
      associationsProductBundle: [],
    );
  }

  @override
  String toString() => _encoder.convert(toJson());

  Associations copyWith({
    List<AssociationsCategory>? associationsCategories,
    List<AssociationsImage>? associationsImages,
    List<AssociationsCombination>? associationsCombinations,
    List<AssociationsProductOptionValue>? associationsProductOptionValues,
    List<AssociationsProductFeature>? associationsProductFeatures,
    List<AssociationsStockAvailable>? associationsStockAvailables,
    List<AssociationsAccessory>? associationsAccessories,
    List<AssociationsProductBundle>? associationsProductBundle,
  }) {
    return Associations(
      associationsCategories: associationsCategories ?? this.associationsCategories,
      associationsImages: associationsImages ?? this.associationsImages,
      associationsCombinations: associationsCombinations ?? this.associationsCombinations,
      associationsProductOptionValues: associationsProductOptionValues ?? this.associationsProductOptionValues,
      associationsProductFeatures: associationsProductFeatures ?? this.associationsProductFeatures,
      associationsStockAvailables: associationsStockAvailables ?? this.associationsStockAvailables,
      associationsAccessories: associationsAccessories ?? this.associationsAccessories,
      associationsProductBundle: associationsProductBundle ?? this.associationsProductBundle,
    );
  }
}

@JsonSerializable()
class AssociationsCategory {
  final String id;

  AssociationsCategory({required this.id});

  factory AssociationsCategory.fromJson(Map<String, dynamic> json) => _$AssociationsCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$AssociationsCategoryToJson(this);

  @override
  String toString() => 'AssociationsCategory(id: $id)';
}

@JsonSerializable()
class AssociationsImage {
  final String id;

  AssociationsImage({required this.id});

  factory AssociationsImage.fromJson(Map<String, dynamic> json) => _$AssociationsImageFromJson(json);
  Map<String, dynamic> toJson() => _$AssociationsImageToJson(this);
}

@JsonSerializable()
class AssociationsCombination {
  final String id;

  AssociationsCombination({required this.id});

  factory AssociationsCombination.fromJson(Map<String, dynamic> json) => _$AssociationsCombinationFromJson(json);
  Map<String, dynamic> toJson() => _$AssociationsCombinationToJson(this);
}

@JsonSerializable()
class AssociationsProductOptionValue {
  final String id;

  AssociationsProductOptionValue({required this.id});

  factory AssociationsProductOptionValue.fromJson(Map<String, dynamic> json) => _$AssociationsProductOptionValueFromJson(json);
  Map<String, dynamic> toJson() => _$AssociationsProductOptionValueToJson(this);
}

@JsonSerializable()
class AssociationsProductFeature {
  final String id;
  @JsonKey(name: 'id_feature_value')
  final String idFeatureValue;

  AssociationsProductFeature({required this.id, required this.idFeatureValue});

  factory AssociationsProductFeature.fromJson(Map<String, dynamic> json) => _$AssociationsProductFeatureFromJson(json);
  Map<String, dynamic> toJson() => _$AssociationsProductFeatureToJson(this);
}

@JsonSerializable()
class AssociationsStockAvailable {
  final String id;
  @JsonKey(name: 'id_product_attribute')
  final String idProductAttribute;

  AssociationsStockAvailable({required this.id, required this.idProductAttribute});

  factory AssociationsStockAvailable.fromJson(Map<String, dynamic> json) => _$AssociationsStockAvailableFromJson(json);
  Map<String, dynamic> toJson() => _$AssociationsStockAvailableToJson(this);
}

@JsonSerializable()
class AssociationsAccessory {
  final String id;

  AssociationsAccessory({required this.id});

  factory AssociationsAccessory.fromJson(Map<String, dynamic> json) => _$AssociationsAccessoryFromJson(json);
  Map<String, dynamic> toJson() => _$AssociationsAccessoryToJson(this);
}

@JsonSerializable()
class AssociationsProductBundle {
  final String id;
  @JsonKey(name: 'id_product_attribute')
  final String idProductAttribute;
  final String quantity;

  AssociationsProductBundle({required this.id, required this.idProductAttribute, required this.quantity});

  factory AssociationsProductBundle.fromJson(Map<String, dynamic> json) => _$AssociationsProductBundleFromJson(json);
  Map<String, dynamic> toJson() => _$AssociationsProductBundleToJson(this);
}
