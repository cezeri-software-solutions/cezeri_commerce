import 'package:cezeri_commerce/1_presentation/core/extensions/string_to_int.dart';
import 'package:cezeri_commerce/1_presentation/core/extensions/to_my_currency.dart';
import 'package:cezeri_commerce/3_domain/entities/product/field_language.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../1_presentation/core/functions/mixed_functions.dart';
import '../../../4_infrastructur/repositories/prestashop_api/models/product_raw_presta.dart';
import '../../../4_infrastructur/repositories/shopify_api/shopify.dart';
import '../language.dart';
import '../marketplace/abstract_marketplace.dart';
import '../marketplace/marketplace_presta.dart';
import '../marketplace/marketplace_shopify.dart';
import '../settings/main_settings.dart';
import '../settings/tax.dart';
import 'marketplace_product.dart';
import 'product_id_with_quantity.dart';
import 'product_image.dart';
import 'product_marketplace.dart';
import 'product_presta.dart';
import 'set_product.dart';

part 'product.g.dart';

@JsonSerializable(explicitToJson: true)
class Product extends Equatable {
  final String id;
  final String articleNumber;
  final String supplierArticleNumber; // Lieferanten Artikel-Nr.
  final String supplierNumber; // id des Lieferanten in Firestore
  final String supplier;
  final String sku;
  final String ean;
  final String name;
  final List<FieldLanguage> listOfName;
  final Tax tax; // Steuer Inland
  final List<String> imageUrls;
  final bool isActive;
  final int ordered; // wieviele schon nachbestellt wurden
  final String brandName;
  final String unity; // z.B. pro 1 L
  final double unitPrice; // Preis pro Einheit
  final double width; // Breite
  final double height; // Höhe
  final double depth; // Länge
  final double weight;
  final double netPrice;
  final double grossPrice;
  final double wholesalePrice; // EK-Preis
  final double recommendedRetailPrice;
  final bool haveVariants; // Gibt es eine Variante
  final bool isSetArticle;
  // Wenn Set Artikle && true, dann wird der Bestand unabhängig von seinen Bestandteilen geführt, ansonsten wird der Bestand durch den niedrigsten Besteand der Besandteile ermittelt
  final bool isOutlet;
  final List<String> listOfIsPartOfSetIds; // Im Einzelartikel, von welchem Set dies ein Bestandteil ist
  final List<ProductIdWithQuantity> listOfProductIdWithQuantity; // Von welchem Einzelartikel wieviel im Set enthalten sind
  final bool isSetSelfQuantityManaged;
  final String manufacturerNumber;
  final String manufacturer;
  final int warehouseStock;
  final int availableStock;
  final int minimumStock; // Mindestbestand vor Warnung zur Nachbestellung
  final bool isUnderMinimumStock; // Flag der gesetzt wird, damit nur diese Artikel geladen werden können
  final int minimumReorderQuantity; // Mindestnachbestellmenge
  final int packagingUnitOnReorder; // Verpackungseinheit bei Nachbestellung
  final String description;
  final List<FieldLanguage> listOfDescription;
  final String descriptionShort;
  final List<FieldLanguage> listOfDescriptionShort;
  final String metaTitle;
  final List<FieldLanguage> listOfMetaTitle;
  final String metaDescription;
  final List<FieldLanguage> listOfMetaDescription;
  final double volume; // Volumen in cm3
  final List<ProductImage> listOfProductImages;
  final List<SetProduct> listOfSetProducts;
  final List<ProductMarketplace> productMarketplaces;

  const Product({
    required this.id,
    required this.articleNumber,
    required this.supplierArticleNumber,
    required this.supplierNumber,
    required this.supplier,
    required this.sku,
    required this.ean,
    required this.name,
    required this.listOfName,
    required this.tax,
    required this.imageUrls,
    required this.isActive,
    required this.ordered,
    required this.brandName,
    required this.unity,
    required this.unitPrice,
    required this.width,
    required this.height,
    required this.depth,
    required this.weight,
    required this.netPrice,
    required this.grossPrice,
    required this.wholesalePrice,
    required this.recommendedRetailPrice,
    required this.haveVariants,
    required this.isSetArticle,
    required this.isOutlet,
    required this.listOfIsPartOfSetIds,
    required this.listOfProductIdWithQuantity,
    required this.isSetSelfQuantityManaged,
    required this.manufacturerNumber,
    required this.manufacturer,
    required this.warehouseStock,
    required this.availableStock,
    required this.minimumStock,
    required this.isUnderMinimumStock,
    required this.minimumReorderQuantity,
    required this.packagingUnitOnReorder,
    required this.description,
    required this.listOfDescription,
    required this.descriptionShort,
    required this.listOfDescriptionShort,
    required this.metaTitle,
    required this.listOfMetaTitle,
    required this.metaDescription,
    required this.listOfMetaDescription,
    //required this.volume,
    required this.listOfProductImages,
    required this.listOfSetProducts,
    required this.productMarketplaces,
  }) : volume = width * height * depth;

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);

  factory Product.empty() {
    return Product(
      id: '',
      articleNumber: '',
      supplierArticleNumber: '',
      supplierNumber: '',
      supplier: '',
      sku: '',
      ean: '',
      name: '',
      listOfName: const [],
      tax: Tax.empty(),
      imageUrls: const [],
      isActive: true,
      ordered: 0,
      brandName: '',
      unity: 'pro 1 Stück',
      unitPrice: 0,
      width: 0,
      height: 0,
      depth: 0,
      weight: 0,
      netPrice: 0,
      grossPrice: 0,
      wholesalePrice: 0,
      recommendedRetailPrice: 0,
      haveVariants: false,
      isSetArticle: false,
      isOutlet: false,
      listOfIsPartOfSetIds: const [],
      listOfProductIdWithQuantity: const [],
      isSetSelfQuantityManaged: false,
      manufacturerNumber: '',
      manufacturer: '',
      warehouseStock: 0,
      availableStock: 0,
      minimumStock: 1,
      isUnderMinimumStock: false,
      minimumReorderQuantity: 1,
      packagingUnitOnReorder: 1,
      description: '',
      listOfDescription: const [],
      descriptionShort: '',
      listOfDescriptionShort: const [],
      metaTitle: '',
      listOfMetaTitle: const [],
      metaDescription: '',
      listOfMetaDescription: const [],
      listOfProductImages: const [],
      listOfSetProducts: const [],
      productMarketplaces: const [],
    );
  }

  factory Product.fromMarketplaceProduct({
    required MarketplaceProduct marketplaceProduct,
    required AbstractMarketplace marketplace,
    required MainSettings mainSettings,
    required List<ProductIdWithQuantity>? listOfProductIdWithQuantity,
  }) {
    return switch (marketplaceProduct.marketplaceType) {
      MarketplaceType.prestashop => Product._fromProductPresta(
          productPresta: marketplaceProduct as ProductPresta,
          marketplace: marketplace as MarketplacePresta,
          mainSettings: mainSettings,
          listOfProductIdWithQuantity: listOfProductIdWithQuantity,
        ),
      MarketplaceType.shopify => Product._fromProductShopify(
          productShopify: marketplaceProduct as ProductShopify,
          marketplace: marketplace as MarketplaceShopify,
          mainSettings: mainSettings,
          listOfProductIdWithQuantity: listOfProductIdWithQuantity,
        ),
      MarketplaceType.shop => throw Exception('Ladengeschäft wird nicht unterstützt.'),
    };
  }

  factory Product._fromProductPresta({
    required ProductPresta productPresta,
    required MarketplacePresta marketplace,
    required MainSettings mainSettings,
    required List<ProductIdWithQuantity>? listOfProductIdWithQuantity,
  }) {
    List<FieldLanguage> getListOfProductLanguages(List<Multilanguage>? valueMultilanguage) {
      List<FieldLanguage> listOfProductLanguages = [];
      if (valueMultilanguage != null &&
          valueMultilanguage.isNotEmpty &&
          productPresta.marketplaceLanguages != null &&
          productPresta.marketplaceLanguages!.isNotEmpty) {
        final marketplaceLanguages = productPresta.marketplaceLanguages!;
        for (final value in valueMultilanguage) {
          final mLanguage = marketplaceLanguages.where((e) => e.id.toString() == value.id).firstOrNull;
          if (mLanguage == null) continue;
          final language = Language.languageList.where((e) => e.isoCode.toUpperCase() == mLanguage.isoCode.toUpperCase()).firstOrNull;
          if (language == null) continue;
          final id = language.id;
          listOfProductLanguages.add(FieldLanguage(id: id, value: value.value, isoCode: language.isoCode));
        }
      }
      return listOfProductLanguages;
    }

    String getProductValue(List<FieldLanguage> listOfProductLanguages, String? value) {
      String toReturnValue = '';
      if (listOfProductLanguages.isNotEmpty) {
        final phValue = listOfProductLanguages.where((e) => e.isoCode.toUpperCase() == 'DE').firstOrNull;
        if (phValue != null) {
          toReturnValue = phValue.value;
        }
      } else {
        toReturnValue = value ?? '';
      }
      return toReturnValue;
    }

    final productMarketplaces = [ProductMarketplace.fromMarketplaceProduct(productPresta, marketplace)];
    final taxRule = mainSettings.taxes.where((e) => e.isDefault).first;

    final listOfName = getListOfProductLanguages(productPresta.nameMultilanguage);
    final listOfDescription = getListOfProductLanguages(productPresta.descriptionMultilanguage);
    final listOfDescriptionShort = getListOfProductLanguages(productPresta.descriptionShortMultilanguage);
    final listOfMetaTitle = getListOfProductLanguages(productPresta.metaTitleMultilanguage);
    final listOfMetaDescription = getListOfProductLanguages(productPresta.metaDescriptionMultilanguage);

    final name = getProductValue(listOfName, productPresta.name);
    final description = getProductValue(listOfDescription, productPresta.description);
    final descriptionShort = getProductValue(listOfDescriptionShort, productPresta.descriptionShort);
    final metaTitle = getProductValue(listOfMetaTitle, productPresta.metaTitle);
    final metaDescription = getProductValue(listOfMetaDescription, productPresta.metaDescription);

    return Product.empty().copyWith(
      articleNumber: productPresta.reference,
      supplierArticleNumber: productPresta.reference,
      // TODO: Lieferanten anlegen und id(number) mit übergenben
      supplierNumber: Product.empty().supplierNumber,
      supplier: productPresta.supplierReference,
      sku: productPresta.reference,
      ean: productPresta.ean13,
      name: name,
      listOfName: listOfName,
      tax: taxRule,
      isActive: Product.empty().isActive,
      // TODO: Wieviele von diesem Artikel schon nachbestellt wurden
      // ordered: productPresta.reference ?? Product.empty().articleNumber,
      brandName: productPresta.manufacturerName,
      unity: productPresta.unity,
      width: productPresta.width.toMyDouble(),
      height: productPresta.height.toMyDouble(),
      depth: productPresta.depth.toMyDouble(),
      weight: productPresta.weight.toMyDouble(),
      netPrice: productPresta.price.toMyDouble(),
      grossPrice: (productPresta.price.toMyDouble() * taxToCalc(taxRule.taxRate)).toMyRoundedDouble(),
      wholesalePrice: productPresta.wholesalePrice.toMyDouble(),
      recommendedRetailPrice: productPresta.price.toMyDouble() * taxToCalc(taxRule.taxRate),
      haveVariants: productPresta.associations!.associationsCombinations != null,
      isSetArticle: switch (productPresta.type) {
        'simple' => false,
        'pack' => true,
        (_) => Product.empty().isSetArticle,
      },
      isOutlet: false,
      listOfProductIdWithQuantity: listOfProductIdWithQuantity ?? [],
      // TODO: Hersteller anlegen und Nummer übergeben
      manufacturerNumber: Product.empty().manufacturerNumber,
      manufacturer: productPresta.manufacturerName,
      warehouseStock: productPresta.quantity.toMyInt(),
      availableStock: productPresta.quantity.toMyInt(),
      description: description,
      listOfDescription: listOfDescription,
      descriptionShort: descriptionShort,
      listOfDescriptionShort: listOfDescriptionShort,
      metaTitle: metaTitle,
      listOfMetaTitle: listOfMetaTitle,
      metaDescription: metaDescription,
      listOfMetaDescription: listOfMetaDescription,
      productMarketplaces: productMarketplaces,
    );
  }

  factory Product._fromProductShopify({
    required ProductShopify productShopify,
    required MarketplaceShopify marketplace,
    required MainSettings mainSettings,
    required List<ProductIdWithQuantity>? listOfProductIdWithQuantity,
  }) {
    // List<FieldLanguage> getListOfProductLanguages(List<Multilanguage>? valueMultilanguage) {
    //   List<FieldLanguage> listOfProductLanguages = [];
    //   if (valueMultilanguage != null &&
    //       valueMultilanguage.isNotEmpty &&
    //       productShopify.marketplaceLanguages != null &&
    //       productShopify.marketplaceLanguages!.isNotEmpty) {
    //     final marketplaceLanguages = productShopify.marketplaceLanguages!;
    //     for (final value in valueMultilanguage) {
    //       final mLanguage = marketplaceLanguages.where((e) => e.id.toString() == value.id).firstOrNull;
    //       if (mLanguage == null) continue;
    //       final language = Language.languageList.where((e) => e.isoCode.toUpperCase() == mLanguage.isoCode.toUpperCase()).firstOrNull;
    //       if (language == null) continue;
    //       final id = language.id;
    //       listOfProductLanguages.add(FieldLanguage(id: id, value: value.value, isoCode: language.isoCode));
    //     }
    //   }
    //   return listOfProductLanguages;
    // }

    // String getProductValue(List<FieldLanguage> listOfProductLanguages, String? value) {
    //   String toReturnValue = '';
    //   if (listOfProductLanguages.isNotEmpty) {
    //     final phValue = listOfProductLanguages.where((e) => e.isoCode.toUpperCase() == 'DE').firstOrNull;
    //     if (phValue != null) {
    //       toReturnValue = phValue.value;
    //     }
    //   } else {
    //     toReturnValue = value ?? '';
    //   }
    //   return toReturnValue;
    // }

    final productMarketplaces = [ProductMarketplace.fromMarketplaceProduct(productShopify, marketplace)];
    final taxRule = mainSettings.taxes.where((e) => e.isDefault).first;

    final listOfName = <FieldLanguage>[]; //getListOfProductLanguages(productShopify.nameMultilanguage);
    final listOfDescription = <FieldLanguage>[]; // getListOfProductLanguages(productShopify.descriptionMultilanguage);
    final listOfDescriptionShort = <FieldLanguage>[]; //getListOfProductLanguages(productShopify.descriptionShortMultilanguage);
    final listOfMetaTitle = <FieldLanguage>[]; //getListOfProductLanguages(productShopify.metaTitleMultilanguage);
    final listOfMetaDescription = <FieldLanguage>[]; // getListOfProductLanguages(productShopify.metaDescriptionMultilanguage);

    final name = productShopify.title;
    final description = productShopify.bodyHtml;
    const descriptionShort = '';
    final metaTitle = productShopify.metafields.where((e) => e.metafieldType == MetafieldType.productMetaTitle).firstOrNull?.value ?? '';
    final metaDescription = productShopify.metafields.where((e) => e.metafieldType == MetafieldType.productMetaDescription).firstOrNull?.value ?? '';

    final grossPrice = productShopify.variants.first.price.toMyDouble();
    final netPrice = (grossPrice / taxToCalc(taxRule.taxRate)).toMyRoundedDouble();

    return Product.empty().copyWith(
      articleNumber: productShopify.variants.first.sku,
      supplierArticleNumber: productShopify.variants.first.sku,
      // TODO: Lieferanten anlegen und id(number) mit übergenben
      supplierNumber: Product.empty().supplierNumber,
      supplier: Product.empty().supplier,
      sku: productShopify.variants.first.barcode,
      ean: productShopify.variants.first.barcode,
      name: name,
      listOfName: listOfName,
      tax: taxRule,
      isActive: Product.empty().isActive,
      // TODO: Wieviele von diesem Artikel schon nachbestellt wurden
      // ordered: productPresta.reference ?? Product.empty().articleNumber,
      brandName: productShopify.vendor,
      unity: null, //TODO: https://help.shopify.com/de/manual/intro-to-shopify/initial-setup/sell-in-germany/price-per-unit
      width: 0.0,
      height: 0.0,
      depth: 0.0,
      weight: productShopify.variants.first.weight,
      netPrice: netPrice,
      grossPrice: grossPrice,
      wholesalePrice: 0.0,
      recommendedRetailPrice: grossPrice,
      haveVariants: productShopify.variants.length > 1,
      isSetArticle: false, //TODO: Set-Artikel muss noch in Shopify erkundet werden
      isOutlet: false,
      listOfProductIdWithQuantity: listOfProductIdWithQuantity ?? [],
      // TODO: Hersteller anlegen und Nummer übergeben
      manufacturerNumber: Product.empty().manufacturerNumber,
      manufacturer: productShopify.vendor,
      warehouseStock: productShopify.variants.first.inventoryQuantity,
      availableStock: productShopify.variants.first.inventoryQuantity,
      description: description,
      listOfDescription: listOfDescription,
      descriptionShort: descriptionShort,
      listOfDescriptionShort: listOfDescriptionShort,
      metaTitle: metaTitle,
      listOfMetaTitle: listOfMetaTitle,
      metaDescription: metaDescription,
      listOfMetaDescription: listOfMetaDescription,
      productMarketplaces: productMarketplaces,
    );
  }

  Product copyWith({
    String? id,
    String? articleNumber,
    String? supplierArticleNumber,
    String? supplierNumber,
    String? supplier,
    String? sku,
    String? ean,
    String? name,
    List<FieldLanguage>? listOfName,
    Tax? tax,
    List<String>? imageUrls,
    bool? isActive,
    int? ordered,
    String? brandName,
    String? unity,
    double? unitPrice,
    double? width,
    double? height,
    double? depth,
    double? weight,
    double? netPrice,
    double? grossPrice,
    double? wholesalePrice,
    double? recommendedRetailPrice,
    bool? haveVariants,
    bool? isSetArticle,
    bool? isOutlet,
    List<String>? listOfIsPartOfSetIds,
    List<ProductIdWithQuantity>? listOfProductIdWithQuantity,
    bool? isSetSelfQuantityManaged,
    String? manufacturerNumber,
    String? manufacturer,
    int? warehouseStock,
    int? availableStock,
    int? minimumStock,
    bool? isUnderMinimumStock,
    int? minimumReorderQuantity,
    int? packagingUnitOnReorder,
    String? description,
    List<FieldLanguage>? listOfDescription,
    String? descriptionShort,
    List<FieldLanguage>? listOfDescriptionShort,
    String? metaTitle,
    List<FieldLanguage>? listOfMetaTitle,
    String? metaDescription,
    List<FieldLanguage>? listOfMetaDescription,
    List<ProductImage>? listOfProductImages,
    List<SetProduct>? listOfSetProducts,
    List<ProductMarketplace>? productMarketplaces,
  }) {
    return Product(
      id: id ?? this.id,
      articleNumber: articleNumber ?? this.articleNumber,
      supplierArticleNumber: supplierArticleNumber ?? this.supplierArticleNumber,
      supplierNumber: supplierNumber ?? this.supplierNumber,
      supplier: supplier ?? this.supplier,
      sku: sku ?? this.sku,
      ean: ean ?? this.ean,
      name: name ?? this.name,
      listOfName: listOfName ?? this.listOfName,
      tax: tax ?? this.tax,
      imageUrls: imageUrls ?? this.imageUrls,
      isActive: isActive ?? this.isActive,
      ordered: ordered ?? this.ordered,
      brandName: brandName ?? this.brandName,
      unity: unity ?? this.unity,
      unitPrice: unitPrice ?? this.unitPrice,
      width: width ?? this.width,
      height: height ?? this.height,
      depth: depth ?? this.depth,
      weight: weight ?? this.weight,
      netPrice: netPrice ?? this.netPrice,
      grossPrice: grossPrice ?? this.grossPrice,
      wholesalePrice: wholesalePrice ?? this.wholesalePrice,
      recommendedRetailPrice: recommendedRetailPrice ?? this.recommendedRetailPrice,
      haveVariants: haveVariants ?? this.haveVariants,
      isSetArticle: isSetArticle ?? this.isSetArticle,
      isOutlet: isOutlet ?? this.isOutlet,
      listOfIsPartOfSetIds: listOfIsPartOfSetIds ?? this.listOfIsPartOfSetIds,
      listOfProductIdWithQuantity: listOfProductIdWithQuantity ?? this.listOfProductIdWithQuantity,
      isSetSelfQuantityManaged: isSetSelfQuantityManaged ?? this.isSetSelfQuantityManaged,
      manufacturerNumber: manufacturerNumber ?? this.manufacturerNumber,
      manufacturer: manufacturer ?? this.manufacturer,
      warehouseStock: warehouseStock ?? this.warehouseStock,
      availableStock: availableStock ?? this.availableStock,
      minimumStock: minimumStock ?? this.minimumStock,
      isUnderMinimumStock: isUnderMinimumStock ?? this.isUnderMinimumStock,
      minimumReorderQuantity: minimumReorderQuantity ?? this.minimumReorderQuantity,
      packagingUnitOnReorder: packagingUnitOnReorder ?? this.packagingUnitOnReorder,
      description: description ?? this.description,
      listOfDescription: listOfDescription ?? this.listOfDescription,
      descriptionShort: descriptionShort ?? this.descriptionShort,
      listOfDescriptionShort: listOfDescriptionShort ?? this.listOfDescriptionShort,
      metaTitle: metaTitle ?? this.metaTitle,
      listOfMetaTitle: listOfMetaTitle ?? this.listOfMetaTitle,
      metaDescription: metaDescription ?? this.metaDescription,
      listOfMetaDescription: listOfMetaDescription ?? this.listOfMetaDescription,
      listOfProductImages: listOfProductImages ?? this.listOfProductImages,
      listOfSetProducts: listOfSetProducts ?? this.listOfSetProducts,
      productMarketplaces: productMarketplaces ?? this.productMarketplaces,
    );
  }

  @override
  List<Object?> get props => [
        id,
        articleNumber,
        supplierArticleNumber,
        supplierNumber,
        supplier,
        sku,
        ean,
        name,
        listOfName,
        tax,
        imageUrls,
        isActive,
        ordered,
        brandName,
        unity,
        unitPrice,
        width,
        height,
        depth,
        weight,
        netPrice,
        grossPrice,
        wholesalePrice,
        recommendedRetailPrice,
        haveVariants,
        isSetArticle,
        listOfIsPartOfSetIds,
        listOfProductIdWithQuantity,
        isSetSelfQuantityManaged,
        manufacturerNumber,
        manufacturer,
        warehouseStock,
        availableStock,
        minimumStock,
        isUnderMinimumStock,
        minimumReorderQuantity,
        packagingUnitOnReorder,
        description,
        listOfDescription,
        descriptionShort,
        listOfDescriptionShort,
        metaTitle,
        listOfMetaTitle,
        metaDescription,
        listOfMetaDescription,
        listOfProductImages,
        listOfSetProducts,
        productMarketplaces,
      ];

  @override
  bool get stringify => true;
}
