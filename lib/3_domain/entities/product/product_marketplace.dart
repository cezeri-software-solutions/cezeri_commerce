import 'package:json_annotation/json_annotation.dart';

import '../../entities_presta/product_presta.dart';
import '../marketplace/marketplace.dart';
import 'product_associations.dart';
import 'product_associations_product_bundle.dart';
import 'product_associations_product_features.dart';
import 'product_associations_stock_availables.dart';
import 'product_language.dart';

part 'product_marketplace.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductMarketplace {
  final String? idMarketplace; // id der class Marketplace
  final String? nameMarketplace; // name der class Marketplace
  final String? shortNameMarketplace; // short name der class Marketplace
  final int? idProduct; // id des Artikels im Marketplace
  final int? idManufacturer;
  final int? idSupplier;
  final int? idCategoryDefault;
  final bool? isNew;
  final bool? cacheDefaultAttribute;
  final int? idDefaultImage;
  final int? idDefaultCombination;
  final int? idTaxRulesGroup;
  final int? positionInCategory;
  final String? manufacturerName;
  final String? type; // kann nur { simple, pack } sein / pack für Bündelartikel
  final int? idShopDefault;
  final String? location;
  final bool? quantityDiscount;
  final String? isbn;
  final String? upc;
  final String? mpn;
  final bool? cacheIsPack;
  final bool? cacheHasAttachments;
  final int? state;
  final int? additionalDeliveryTimes;
  final String? deliveryInStock;
  final String? deliveryOutStock;
  final bool? onSale;
  final bool? onlineOnly;
  final double? ecotax;
  final int? minimalQuantity;
  final int? lowStockThreshold;
  final bool? lowStockAlert;
  final double? price;
  final double? wholesalePrice;
  final String? unity;
  final double? unitPriceRatio;
  final double? additionalShippingCost;
  final int? customizable;
  final int? textFields;
  final int? uploadableFiles;
  final bool? active;
  final String? redirectType;
  final int? idTypeRedirected;
  final bool? availableForOrder;
  final DateTime? availableDate;
  final bool? showCondition;
  final String? condition;
  final bool? showPrice;
  final bool? indexed;
  final String? visibility;
  final bool? advancedStockManagement;
  final DateTime? dateAdd;
  final DateTime? dateUpd;
  final int? packStockType;
  final String? metaDescription;
  final List<ProductLanguage>? listOfMetaDescription;
  final String? metaKeywords;
  final List<ProductLanguage>? listOfMetaKeywords;
  final String? metaTitle;
  final List<ProductLanguage>? listOfMetaTitle;
  final String? linkRewrite;
  final List<ProductLanguage>? listOfLinkRewrite;
  final String? name;
  final List<ProductLanguage>? listOfName;
  final String? description;
  final List<ProductLanguage>? listOfDescription;
  final String? descriptionShort;
  final List<ProductLanguage>? listOfDescriptionShort;
  final String? availableNow;
  final String? availableLater;
  final List<ProductAssociations>? categories;
  final List<ProductAssociations>? images;
  final List<ProductAssociations>? combinations;
  final List<ProductAssociations>? productOptionValues;
  final List<ProductAssociationsProductFeatures>? productFeatures;
  final List<ProductAssociations>? tags;
  final List<ProductAssociationsStockAvailables>? stockAvailables;
  final List<String?>? accessories;
  final List<ProductAssociationsProductBundle>? productBundle;

  ProductMarketplace({
    required this.idMarketplace,
    required this.nameMarketplace,
    required this.shortNameMarketplace,
    required this.idProduct,
    required this.idManufacturer,
    required this.idSupplier,
    required this.idCategoryDefault,
    required this.isNew,
    required this.cacheDefaultAttribute,
    required this.idDefaultImage,
    required this.idDefaultCombination,
    required this.idTaxRulesGroup,
    required this.positionInCategory,
    required this.manufacturerName,
    required this.type,
    required this.idShopDefault,
    required this.location,
    required this.quantityDiscount,
    required this.isbn,
    required this.upc,
    required this.mpn,
    required this.cacheIsPack,
    required this.cacheHasAttachments,
    required this.state,
    required this.additionalDeliveryTimes,
    required this.deliveryInStock,
    required this.deliveryOutStock,
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
    required this.listOfMetaDescription,
    required this.metaKeywords,
    required this.listOfMetaKeywords,
    required this.metaTitle,
    required this.listOfMetaTitle,
    required this.linkRewrite,
    required this.listOfLinkRewrite,
    required this.name,
    required this.listOfName,
    required this.description,
    required this.listOfDescription,
    required this.descriptionShort,
    required this.listOfDescriptionShort,
    required this.availableNow,
    required this.availableLater,
    required this.categories,
    required this.images,
    required this.combinations,
    required this.productOptionValues,
    required this.productFeatures,
    required this.tags,
    required this.stockAvailables,
    required this.accessories,
    required this.productBundle,
  });

  factory ProductMarketplace.empty() {
    return ProductMarketplace(
      idMarketplace: null,
      nameMarketplace: null,
      shortNameMarketplace: null,
      idProduct: null,
      idManufacturer: null,
      idSupplier: null,
      idCategoryDefault: null,
      isNew: null,
      cacheDefaultAttribute: null,
      idDefaultImage: null,
      idDefaultCombination: null,
      idTaxRulesGroup: null,
      positionInCategory: null,
      manufacturerName: null,
      type: null,
      idShopDefault: null,
      location: null,
      quantityDiscount: null,
      isbn: null,
      upc: null,
      mpn: null,
      cacheIsPack: null,
      cacheHasAttachments: null,
      state: null,
      additionalDeliveryTimes: null,
      deliveryInStock: null,
      deliveryOutStock: null,
      onSale: null,
      onlineOnly: null,
      ecotax: null,
      minimalQuantity: null,
      lowStockThreshold: null,
      lowStockAlert: null,
      price: null,
      wholesalePrice: null,
      unity: null,
      unitPriceRatio: null,
      additionalShippingCost: null,
      customizable: null,
      textFields: null,
      uploadableFiles: null,
      active: null,
      redirectType: null,
      idTypeRedirected: null,
      availableForOrder: null,
      availableDate: null,
      showCondition: null,
      condition: null,
      showPrice: null,
      indexed: null,
      visibility: null,
      advancedStockManagement: null,
      dateAdd: null,
      dateUpd: null,
      packStockType: null,
      metaDescription: null,
      listOfMetaDescription: null,
      metaKeywords: null,
      listOfMetaKeywords: null,
      metaTitle: null,
      listOfMetaTitle: null,
      linkRewrite: null,
      listOfLinkRewrite: null,
      name: null,
      listOfName: null,
      description: null,
      listOfDescription: null,
      descriptionShort: null,
      listOfDescriptionShort: null,
      availableNow: null,
      availableLater: null,
      categories: null,
      images: null,
      combinations: null,
      productOptionValues: null,
      productFeatures: null,
      tags: null,
      stockAvailables: null,
      accessories: null,
      productBundle: null,
    );
  }

  factory ProductMarketplace.fromProductPresta(ProductPresta pp, Marketplace marketplace) {
    return ProductMarketplace(
      idMarketplace: marketplace.id,
      nameMarketplace: marketplace.name,
      shortNameMarketplace: marketplace.shortName,
      idProduct: pp.id,
      idManufacturer: pp.idManufacturer,
      idSupplier: pp.idSupplier,
      idCategoryDefault: pp.idCategoryDefault,
      isNew: pp.isNew,
      cacheDefaultAttribute: pp.cacheDefaultAttribute,
      idDefaultImage: pp.idDefaultImage,
      idDefaultCombination: pp.idDefaultCombination,
      idTaxRulesGroup: pp.idTaxRulesGroup,
      positionInCategory: pp.positionInCategory,
      manufacturerName: pp.manufacturerName,
      type: pp.type,
      idShopDefault: pp.idShopDefault,
      location: pp.location,
      quantityDiscount: pp.quantityDiscount,
      isbn: pp.isbn,
      upc: pp.upc,
      mpn: pp.mpn,
      cacheIsPack: pp.cacheIsPack,
      cacheHasAttachments: pp.cacheHasAttachments,
      state: pp.state,
      additionalDeliveryTimes: pp.additionalDeliveryTimes,
      deliveryInStock: pp.deliveryInStock,
      deliveryOutStock: pp.deliveryOutStock,
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
      listOfMetaDescription: pp.listOfMetaDescription,
      metaKeywords: pp.metaKeywords,
      listOfMetaKeywords: pp.listOfMetaKeywords,
      metaTitle: pp.metaTitle,
      listOfMetaTitle: pp.listOfMetaTitle,
      linkRewrite: pp.linkRewrite,
      listOfLinkRewrite: pp.listOfLinkRewrite,
      name: pp.name,
      listOfName: pp.listOfName,
      description: pp.description,
      listOfDescription: pp.listOfDescription,
      descriptionShort: pp.descriptionShort,
      listOfDescriptionShort: pp.listOfDescriptionShort,
      availableNow: pp.availableNow,
      availableLater: pp.availableLater,
      categories: pp.categories,
      images: pp.images,
      combinations: pp.combinations,
      productOptionValues: pp.productOptionValues,
      productFeatures: pp.productFeatures,
      tags: pp.tags,
      stockAvailables: pp.stockAvailables,
      accessories: pp.accessories,
      productBundle: pp.productBundle,
    );
  }

  factory ProductMarketplace.fromJson(Map<String, dynamic> json) => _$ProductMarketplaceFromJson(json);

  Map<String, dynamic> toJson() => _$ProductMarketplaceToJson(this);

  @override
  String toString() {
    return 'ProductMarketplace(idMarketplace: $idMarketplace, nameMarketplace: $nameMarketplace, shortNameMarketplace: $shortNameMarketplace, idProduct: $idProduct, idManufacturer: $idManufacturer, idSupplier: $idSupplier, idCategoryDefault: $idCategoryDefault, isNew: $isNew, cacheDefaultAttribute: $cacheDefaultAttribute, idDefaultImage: $idDefaultImage, idDefaultCombination: $idDefaultCombination, idTaxRulesGroup: $idTaxRulesGroup, positionInCategory: $positionInCategory, manufacturerName: $manufacturerName, idShopDefault: $idShopDefault, location: $location, quantityDiscount: $quantityDiscount, isbn: $isbn, upc: $upc, mpn: $mpn, cacheIsPack: $cacheIsPack, cacheHasAttachments: $cacheHasAttachments, state: $state, additionalDeliveryTimes: $additionalDeliveryTimes, deliveryInStock: $deliveryInStock, deliveryOutStock: $deliveryOutStock, onSale: $onSale, onlineOnly: $onlineOnly, ecotax: $ecotax, minimalQuantity: $minimalQuantity, lowStockThreshold: $lowStockThreshold, lowStockAlert: $lowStockAlert, price: $price, wholesalePrice: $wholesalePrice, unity: $unity, unitPriceRatio: $unitPriceRatio, additionalShippingCost: $additionalShippingCost, customizable: $customizable, textFields: $textFields, uploadableFiles: $uploadableFiles, active: $active, redirectType: $redirectType, idTypeRedirected: $idTypeRedirected, availableForOrder: $availableForOrder, availableDate: $availableDate, showCondition: $showCondition, condition: $condition, showPrice: $showPrice, indexed: $indexed, visibility: $visibility, advancedStockManagement: $advancedStockManagement, dateAdd: $dateAdd, dateUpd: $dateUpd, packStockType: $packStockType, metaDescription: $metaDescription, listOfMetaDescription: $listOfMetaDescription, metaKeywords: $metaKeywords, listOfMetaKeywords: $listOfMetaKeywords, metaTitle: $metaTitle, listOfMetaTitle: $listOfMetaTitle, linkRewrite: $linkRewrite, listOfLinkRewrite: $listOfLinkRewrite, name: $name, listOfName: $listOfName, description: $description, listOfDescription: $listOfDescription, descriptionShort: $descriptionShort, listOfDescriptionShort: $listOfDescriptionShort, availableNow: $availableNow, availableLater: $availableLater, categories: $categories, images: $images, combinations: $combinations, productOptionValues: $productOptionValues, productFeatures: $productFeatures, tags: $tags, stockAvailables: $stockAvailables, accessories: $accessories, productBundle: $productBundle)';
  }

  ProductMarketplace copyWith({
    String? idMarketplace,
    String? nameMarketplace,
    String? shortNameMarketplace,
    int? idProduct,
    int? idManufacturer,
    int? idSupplier,
    int? idCategoryDefault,
    bool? isNew,
    bool? cacheDefaultAttribute,
    int? idDefaultImage,
    int? idDefaultCombination,
    int? idTaxRulesGroup,
    int? positionInCategory,
    String? manufacturerName,
    String? type,
    int? idShopDefault,
    String? location,
    bool? quantityDiscount,
    String? isbn,
    String? upc,
    String? mpn,
    bool? cacheIsPack,
    bool? cacheHasAttachments,
    int? state,
    int? additionalDeliveryTimes,
    String? deliveryInStock,
    String? deliveryOutStock,
    bool? onSale,
    bool? onlineOnly,
    double? ecotax,
    int? minimalQuantity,
    int? lowStockThreshold,
    bool? lowStockAlert,
    double? price,
    double? wholesalePrice,
    String? unity,
    double? unitPriceRatio,
    double? additionalShippingCost,
    int? customizable,
    int? textFields,
    int? uploadableFiles,
    bool? active,
    String? redirectType,
    int? idTypeRedirected,
    bool? availableForOrder,
    DateTime? availableDate,
    bool? showCondition,
    String? condition,
    bool? showPrice,
    bool? indexed,
    String? visibility,
    bool? advancedStockManagement,
    DateTime? dateAdd,
    DateTime? dateUpd,
    int? packStockType,
    String? metaDescription,
    List<ProductLanguage>? listOfMetaDescription,
    String? metaKeywords,
    List<ProductLanguage>? listOfMetaKeywords,
    String? metaTitle,
    List<ProductLanguage>? listOfMetaTitle,
    String? linkRewrite,
    List<ProductLanguage>? listOfLinkRewrite,
    String? name,
    List<ProductLanguage>? listOfName,
    String? description,
    List<ProductLanguage>? listOfDescription,
    String? descriptionShort,
    List<ProductLanguage>? listOfDescriptionShort,
    String? availableNow,
    String? availableLater,
    List<ProductAssociations>? categories,
    List<ProductAssociations>? images,
    List<ProductAssociations>? combinations,
    List<ProductAssociations>? productOptionValues,
    List<ProductAssociationsProductFeatures>? productFeatures,
    List<ProductAssociations>? tags,
    List<ProductAssociationsStockAvailables>? stockAvailables,
    List<String?>? accessories,
    List<ProductAssociationsProductBundle>? productBundle,
  }) {
    return ProductMarketplace(
      idMarketplace: idMarketplace ?? this.idMarketplace,
      nameMarketplace: nameMarketplace ?? this.nameMarketplace,
      shortNameMarketplace: shortNameMarketplace ?? this.shortNameMarketplace,
      idProduct: idProduct ?? this.idProduct,
      idManufacturer: idManufacturer ?? this.idManufacturer,
      idSupplier: idSupplier ?? this.idSupplier,
      idCategoryDefault: idCategoryDefault ?? this.idCategoryDefault,
      isNew: isNew ?? this.isNew,
      cacheDefaultAttribute: cacheDefaultAttribute ?? this.cacheDefaultAttribute,
      idDefaultImage: idDefaultImage ?? this.idDefaultImage,
      idDefaultCombination: idDefaultCombination ?? this.idDefaultCombination,
      idTaxRulesGroup: idTaxRulesGroup ?? this.idTaxRulesGroup,
      positionInCategory: positionInCategory ?? this.positionInCategory,
      manufacturerName: manufacturerName ?? this.manufacturerName,
      type: type ?? this.type,
      idShopDefault: idShopDefault ?? this.idShopDefault,
      location: location ?? this.location,
      quantityDiscount: quantityDiscount ?? this.quantityDiscount,
      isbn: isbn ?? this.isbn,
      upc: upc ?? this.upc,
      mpn: mpn ?? this.mpn,
      cacheIsPack: cacheIsPack ?? this.cacheIsPack,
      cacheHasAttachments: cacheHasAttachments ?? this.cacheHasAttachments,
      state: state ?? this.state,
      additionalDeliveryTimes: additionalDeliveryTimes ?? this.additionalDeliveryTimes,
      deliveryInStock: deliveryInStock ?? this.deliveryInStock,
      deliveryOutStock: deliveryOutStock ?? this.deliveryOutStock,
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
      listOfMetaDescription: listOfMetaDescription ?? this.listOfMetaDescription,
      metaKeywords: metaKeywords ?? this.metaKeywords,
      listOfMetaKeywords: listOfMetaKeywords ?? this.listOfMetaKeywords,
      metaTitle: metaTitle ?? this.metaTitle,
      listOfMetaTitle: listOfMetaTitle ?? this.listOfMetaTitle,
      linkRewrite: linkRewrite ?? this.linkRewrite,
      listOfLinkRewrite: listOfLinkRewrite ?? this.listOfLinkRewrite,
      name: name ?? this.name,
      listOfName: listOfName ?? this.listOfName,
      description: description ?? this.description,
      listOfDescription: listOfDescription ?? this.listOfDescription,
      descriptionShort: descriptionShort ?? this.descriptionShort,
      listOfDescriptionShort: listOfDescriptionShort ?? this.listOfDescriptionShort,
      availableNow: availableNow ?? this.availableNow,
      availableLater: availableLater ?? this.availableLater,
      categories: categories ?? this.categories,
      images: images ?? this.images,
      combinations: combinations ?? this.combinations,
      productOptionValues: productOptionValues ?? this.productOptionValues,
      productFeatures: productFeatures ?? this.productFeatures,
      tags: tags ?? this.tags,
      stockAvailables: stockAvailables ?? this.stockAvailables,
      accessories: accessories ?? this.accessories,
      productBundle: productBundle ?? this.productBundle,
    );
  }
}
