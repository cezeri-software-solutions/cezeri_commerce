import 'package:json_annotation/json_annotation.dart';

import '../../../4_infrastructur/repositories/prestashop_api/models/language_presta.dart';
import '../../../4_infrastructur/repositories/prestashop_api/models/product_presta_image.dart';
import '../../../4_infrastructur/repositories/prestashop_api/models/product_raw_presta.dart';
import '../marketplace/abstract_marketplace.dart';
import 'marketplace_product.dart';

part 'product_presta.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductPresta extends MarketplaceProduct {
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
  final Associations? associations;

  const ProductPresta({
    required this.id,
    required this.idManufacturer,
    required this.idSupplier,
    required this.idCategoryDefault,
    required this.newProduct,
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
    required this.lowStockThreshold,
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
    required this.metaKeywordsMultilanguage,
    required this.metaTitle,
    required this.metaTitleMultilanguage,
    required this.linkRewrite,
    required this.linkRewriteMultilanguage,
    required this.name,
    required this.nameMultilanguage,
    required this.description,
    required this.descriptionMultilanguage,
    required this.descriptionShort,
    required this.descriptionShortMultilanguage,
    required this.availableNow,
    required this.availableNowMultilanguage,
    required this.availableLater,
    required this.availableLaterMultilanguage,
    this.imageFiles,
    this.marketplaceLanguages,
    required this.associations,
  }) : super(MarketplaceType.prestashop);

  factory ProductPresta.fromJson(Map<String, dynamic> json) => _$ProductPrestaFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$ProductPrestaToJson(this);

  factory ProductPresta.empty() {
    return ProductPresta(
      id: 0,
      idManufacturer: '',
      idSupplier: '',
      idCategoryDefault: '',
      newProduct: '',
      cacheDefaultAttribute: '',
      idDefaultImage: '',
      idDefaultCombination: '',
      idTaxRulesGroup: '',
      positionInCategory: '',
      manufacturerName: '',
      quantity: '',
      type: '',
      idShopDefault: '',
      reference: '',
      supplierReference: '',
      location: '',
      width: '',
      height: '',
      depth: '',
      weight: '',
      quantityDiscount: '',
      ean13: '',
      isbn: '',
      upc: '',
      mpn: '',
      cacheIsPack: '',
      cacheHasAttachments: '',
      isVirtual: '',
      state: '',
      additionalDeliveryTimes: '',
      deliveryInStock: '',
      deliveryInStockMultilanguage: const [],
      deliveryOutStock: '',
      deliveryOutStockMultilanguage: const [],
      onSale: '',
      onlineOnly: '',
      ecotax: '',
      minimalQuantity: '',
      lowStockThreshold: '',
      lowStockAlert: '',
      price: '',
      wholesalePrice: '',
      unity: '',
      unitPriceRatio: '',
      additionalShippingCost: '',
      customizable: '',
      textFields: '',
      uploadableFiles: '',
      active: '0',
      redirectType: '',
      idTypeRedirected: '',
      availableForOrder: '',
      availableDate: '',
      showCondition: '',
      condition: '',
      showPrice: '',
      indexed: '',
      visibility: '',
      advancedStockManagement: '',
      dateAdd: '',
      dateUpd: '',
      packStockType: '',
      metaDescription: '',
      metaDescriptionMultilanguage: const [],
      metaKeywords: '',
      metaKeywordsMultilanguage: const [],
      metaTitle: '',
      metaTitleMultilanguage: const [],
      linkRewrite: '',
      linkRewriteMultilanguage: const [],
      name: '',
      nameMultilanguage: const [],
      description: '',
      descriptionMultilanguage: const [],
      descriptionShort: '',
      descriptionShortMultilanguage: const [],
      availableNow: '',
      availableNowMultilanguage: const [],
      availableLater: '',
      availableLaterMultilanguage: const [],
      imageFiles: const [],
      marketplaceLanguages: const [],
      associations: Associations.empty(),
    );
  }

  factory ProductPresta.fromProductRawPresta(ProductRawPresta pp) {
    return ProductPresta(
      id: pp.id,
      idManufacturer: pp.idManufacturer,
      idSupplier: pp.idSupplier,
      idCategoryDefault: pp.idCategoryDefault,
      newProduct: pp.newProduct,
      cacheDefaultAttribute: pp.cacheDefaultAttribute,
      idDefaultImage: pp.idDefaultImage,
      idDefaultCombination: pp.idDefaultCombination,
      idTaxRulesGroup: pp.idTaxRulesGroup,
      positionInCategory: pp.positionInCategory,
      manufacturerName: pp.manufacturerName,
      quantity: pp.quantity,
      type: pp.type,
      idShopDefault: pp.idShopDefault,
      reference: pp.reference,
      supplierReference: pp.supplierReference,
      location: pp.location,
      width: pp.width,
      height: pp.height,
      depth: pp.depth,
      weight: pp.weight,
      quantityDiscount: pp.quantityDiscount,
      ean13: pp.ean13,
      isbn: pp.isbn,
      upc: pp.upc,
      mpn: pp.mpn,
      cacheIsPack: pp.cacheIsPack,
      cacheHasAttachments: pp.cacheHasAttachments,
      isVirtual: pp.isVirtual,
      state: pp.state,
      additionalDeliveryTimes: pp.additionalDeliveryTimes,
      deliveryInStock: pp.deliveryInStock,
      deliveryInStockMultilanguage: pp.deliveryInStockMultilanguage,
      deliveryOutStock: pp.deliveryOutStock,
      deliveryOutStockMultilanguage: pp.deliveryOutStockMultilanguage,
      onSale: pp.onSale,
      onlineOnly: pp.onlineOnly,
      ecotax: pp.ecotax,
      minimalQuantity: pp.minimalQuantity,
      lowStockThreshold: pp.lowStockThreshold,
      lowStockAlert: pp.lowStockAlert,
      price: pp.price,
      wholesalePrice: pp.wholesalePrice,
      unity: pp.unity,
      unitPriceRatio: pp.unitPriceRatio,
      additionalShippingCost: pp.additionalShippingCost,
      customizable: pp.customizable,
      textFields: pp.textFields,
      uploadableFiles: pp.uploadableFiles,
      active: pp.active,
      redirectType: pp.redirectType,
      idTypeRedirected: pp.idTypeRedirected,
      availableForOrder: pp.availableForOrder,
      availableDate: pp.availableDate,
      showCondition: pp.showCondition,
      condition: pp.condition,
      showPrice: pp.showPrice,
      indexed: pp.indexed,
      visibility: pp.visibility,
      advancedStockManagement: pp.advancedStockManagement,
      dateAdd: pp.dateAdd,
      dateUpd: pp.dateUpd,
      packStockType: pp.packStockType,
      metaDescription: pp.metaDescription,
      metaDescriptionMultilanguage: pp.metaDescriptionMultilanguage,
      metaKeywords: pp.metaKeywords,
      metaKeywordsMultilanguage: pp.metaKeywordsMultilanguage,
      metaTitle: pp.metaTitle,
      metaTitleMultilanguage: pp.metaTitleMultilanguage,
      linkRewrite: pp.linkRewrite,
      linkRewriteMultilanguage: pp.linkRewriteMultilanguage,
      name: pp.name,
      nameMultilanguage: pp.nameMultilanguage,
      description: pp.description,
      descriptionMultilanguage: pp.descriptionMultilanguage,
      descriptionShort: pp.descriptionShort,
      descriptionShortMultilanguage: pp.descriptionShortMultilanguage,
      availableNow: pp.availableNow,
      availableNowMultilanguage: pp.availableNowMultilanguage,
      availableLater: pp.availableLater,
      availableLaterMultilanguage: pp.availableLaterMultilanguage,
      imageFiles: pp.imageFiles,
      marketplaceLanguages: pp.marketplaceLanguages,
      associations: pp.associations,
    );
  }

  ProductPresta copyWith({
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
    return ProductPresta(
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

  @override
  List<Object?> get props => [
        id,
        idManufacturer,
        idSupplier,
        idCategoryDefault,
        newProduct,
        cacheDefaultAttribute,
        idDefaultImage,
        idDefaultCombination,
        idTaxRulesGroup,
        positionInCategory,
        manufacturerName,
        quantity,
        type,
        idShopDefault,
        reference,
        supplierReference,
        location,
        width,
        height,
        depth,
        weight,
        quantityDiscount,
        ean13,
        isbn,
        upc,
        mpn,
        cacheIsPack,
        cacheHasAttachments,
        isVirtual,
        state,
        additionalDeliveryTimes,
        deliveryInStock,
        deliveryInStockMultilanguage,
        deliveryOutStock,
        deliveryOutStockMultilanguage,
        onSale,
        onlineOnly,
        ecotax,
        minimalQuantity,
        lowStockThreshold,
        lowStockAlert,
        price,
        wholesalePrice,
        unity,
        unitPriceRatio,
        additionalShippingCost,
        customizable,
        textFields,
        uploadableFiles,
        active,
        redirectType,
        idTypeRedirected,
        availableForOrder,
        availableDate,
        showCondition,
        condition,
        showPrice,
        indexed,
        visibility,
        advancedStockManagement,
        dateAdd,
        dateUpd,
        packStockType,
        metaDescription,
        metaDescriptionMultilanguage,
        metaKeywords,
        metaKeywordsMultilanguage,
        metaTitle,
        metaTitleMultilanguage,
        linkRewrite,
        linkRewriteMultilanguage,
        name,
        nameMultilanguage,
        description,
        descriptionMultilanguage,
        descriptionShort,
        descriptionShortMultilanguage,
        availableNow,
        availableNowMultilanguage,
        availableLater,
        availableLaterMultilanguage,
        imageFiles,
        marketplaceLanguages,
        associations,
      ];

  @override
  bool get stringify => true;
}
