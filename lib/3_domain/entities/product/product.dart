import 'package:cezeri_commerce/1_presentation/core/extensions/string_to_int.dart';
import 'package:cezeri_commerce/1_presentation/core/extensions/to_my_currency.dart';
import 'package:cezeri_commerce/3_domain/entities/product/field_language.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../1_presentation/core/functions/mixed_functions.dart';
import '../../entities_presta/product_presta.dart';
import '../language.dart';
import '../marketplace/marketplace.dart';
import '../settings/main_settings.dart';
import '../settings/tax.dart';
import 'product_id_with_quantity.dart';
import 'product_image.dart';
import 'product_marketplace.dart';
import 'set_product.dart';

part 'product.g.dart';

@JsonSerializable(explicitToJson: true)
class Product {
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

  Product({
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
      listOfName: [],
      tax: Tax.empty(),
      imageUrls: [],
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
      listOfIsPartOfSetIds: [],
      listOfProductIdWithQuantity: [],
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
      listOfDescription: [],
      descriptionShort: '',
      listOfDescriptionShort: [],
      metaTitle: '',
      listOfMetaTitle: [],
      metaDescription: '',
      listOfMetaDescription: [],
      listOfProductImages: [],
      listOfSetProducts: [],
      productMarketplaces: [],
    );
  }

  factory Product.fromProductPresta({
    required ProductPresta productPresta,
    required Marketplace marketplace,
    required MainSettings mainSettings,
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

    final productMarketplaces = [ProductMarketplace.fromProductPresta(productPresta, marketplace)];
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
      haveVariants: productPresta.associations.associationsCombinations != null,
      isSetArticle: switch (productPresta.type) {
        'simple' => false,
        'pack' => true,
        (_) => Product.empty().isSetArticle,
      },
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
  String toString() {
    return 'Product(id: $id, articleNumber: $articleNumber, supplierArticleNumber: $supplierArticleNumber, supplierNumber: $supplierNumber, supplier: $supplier, sku: $sku, ean: $ean, name: $name, listOfName: $listOfName, tax: $tax, imageUrls: $imageUrls, isActive: $isActive, ordered: $ordered, brandName: $brandName, unity: $unity, unitPrice: $unitPrice, width: $width, height: $height, depth: $depth, weight: $weight, netPrice: $netPrice, grossPrice: $grossPrice, wholesalePrice: $wholesalePrice, recommendedRetailPrice: $recommendedRetailPrice, haveVariants: $haveVariants, isSetArticle: $isSetArticle, listOfIsPartOfSetIds: $listOfIsPartOfSetIds, listOfProductIdWithQuantity: $listOfProductIdWithQuantity, isSetSelfQuantityManaged: $isSetSelfQuantityManaged, manufacturerNumber: $manufacturerNumber, manufacturer: $manufacturer, warehouseStock: $warehouseStock, availableStock: $availableStock, minimumStock: $minimumStock, isUnderMinimumStock: $isUnderMinimumStock, minimumReorderQuantity: $minimumReorderQuantity, packagingUnitOnReorder: $packagingUnitOnReorder, description: $description, listOfDescription: $listOfDescription, descriptionShort: $descriptionShort, listOfDescriptionShort: $listOfDescriptionShort, metaTitle: $metaTitle, listOfMetaTitle: $listOfMetaTitle, metaDescription: $metaDescription, listOfMetaDescription: $listOfMetaDescription, volume: $volume, listOfProductImages: $listOfProductImages, listOfSetProducts: $listOfSetProducts, productMarketplaces: $productMarketplaces)';
  }
}
