import 'package:cezeri_commerce/3_domain/entities/product/product_language.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../entities_presta/product_presta.dart';
import '../marketplace/marketplace.dart';
import '../settings/main_settings.dart';
import '../settings/tax.dart';
import 'product_marketplace.dart';

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
  final List<ProductLanguage> listOfName;
  final Tax tax; // Steuer Inland
  final bool haveImages;
  final String mainImageUrl;
  final int mainImageId;
  final List<String> imageUrls;
  final bool isActive;
  final int ordered; // wieviele schon nachbestellt wurden
  final String brandName;
  final String unity; // z.B. pro 1 L
  final double unitPrice; // Preis pro Einheit
  final double width;
  final double height;
  final double depth;
  final double weight;
  final double netPrice;
  final double grossPrice;
  final double wholesalePrice; // EK-Preis
  final double recommendedRetailPrice;
  final bool haveVariants; // Gibt es eine Variante
  final bool isSetArticle;
  final String manufacturerNumber;
  final String manufacturer;
  final int warehouseStock;
  final int availableStock;
  final String description;
  final List<ProductLanguage> listOfDescription;
  final String descriptionShort;
  final List<ProductLanguage> listOfDescriptionShort;
  final double volume; // Volumen in cm3
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
    required this.haveImages,
    required this.mainImageUrl,
    required this.mainImageId,
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
    required this.manufacturerNumber,
    required this.manufacturer,
    required this.warehouseStock,
    required this.availableStock,
    required this.description,
    required this.listOfDescription,
    required this.descriptionShort,
    required this.listOfDescriptionShort,
    required this.volume,
    required this.productMarketplaces,
  });

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
      haveImages: false,
      mainImageUrl: '',
      mainImageId: 0,
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
      manufacturerNumber: '',
      manufacturer: '',
      warehouseStock: 0,
      availableStock: 0,
      description: '',
      listOfDescription: [],
      descriptionShort: '',
      listOfDescriptionShort: [],
      volume: 0,
      productMarketplaces: [],
    );
  }

  factory Product.fromProductPresta({
    required ProductPresta productPresta,
    required Marketplace marketplace,
    required MainSettings mainSettings,
  }) {
    final productMarketplaces = [ProductMarketplace.fromProductPresta(productPresta, marketplace)];

    return Product.empty().copyWith(
      articleNumber: productPresta.reference ?? Product.empty().articleNumber,
      supplierArticleNumber: productPresta.reference ?? Product.empty().supplierArticleNumber,
      // TODO: Lieferanten anlegen und id(number) mit übergenben
      supplierNumber: Product.empty().supplierNumber,
      supplier: productPresta.supplierReference ?? Product.empty().supplier,
      sku: productPresta.reference ?? Product.empty().sku,
      ean: productPresta.ean13 ?? Product.empty().ean,
      name: productPresta.name ?? Product.empty().name,
      listOfName: productPresta.listOfName ?? Product.empty().listOfName,
      tax: mainSettings.taxes.where((e) => e.isDefault).first,
      haveImages: productPresta.imageIds != null
          ? productPresta.imageIds!.isNotEmpty
              ? true
              : Product.empty().haveImages
          : false,
      // TODO: Bilder mit laden
      //mainImageUrl: ,
      // imageUrls: ,
      isActive: Product.empty().isActive,
      // TODO: Wieviele von diesem Artikel schon nachbestellt wurden
      // ordered: productPresta.reference ?? Product.empty().articleNumber,
      brandName: productPresta.manufacturerName ?? Product.empty().brandName,
      unity: productPresta.unity ?? Product.empty().unity,
      width: productPresta.width ?? Product.empty().width,
      height: productPresta.height ?? Product.empty().height,
      depth: productPresta.depth ?? Product.empty().depth,
      weight: productPresta.weight ?? Product.empty().weight,
      netPrice: productPresta.price ?? Product.empty().netPrice,
      // TODO: Hole die MwSt. von Settings
      grossPrice: productPresta.price! * (Product.empty().tax.taxRate / 100 + 1),
      wholesalePrice: productPresta.wholesalePrice ?? Product.empty().wholesalePrice,
      recommendedRetailPrice: Product.empty().netPrice * (Product.empty().tax.taxRate / 100 + 1),
      // TODO: nachschauen woher ich die Varianten bekomme
      haveVariants: Product.empty().haveVariants,
      // TODO: Wenn SetArtikel, alle Artikel aus dem Set mit importieren, anlegen und den Bestand davon berechnen
      isSetArticle: switch (productPresta.type) {
        'simple' => false,
        'pack' => true,
        (_) => Product.empty().isSetArticle,
      },
      // TODO: Hersteller anlegen und Nummer übergeben
      manufacturerNumber: Product.empty().manufacturerNumber,
      manufacturer: productPresta.manufacturerName ?? Product.empty().manufacturer,
      warehouseStock: productPresta.quantity ?? Product.empty().warehouseStock,
      availableStock: productPresta.quantity ?? Product.empty().availableStock,
      description: productPresta.description ?? Product.empty().description,
      listOfDescription: productPresta.listOfDescription ?? Product.empty().listOfDescription,
      descriptionShort: productPresta.descriptionShort ?? Product.empty().descriptionShort,
      listOfDescriptionShort: productPresta.listOfDescriptionShort ?? Product.empty().listOfDescriptionShort,
      volume: (productPresta.width ?? Product.empty().width) *
          (productPresta.height ?? Product.empty().height) *
          (productPresta.depth ?? Product.empty().depth),
      productMarketplaces: productMarketplaces,
    );
  }

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);

  Product copyWith({
    String? id,
    String? articleNumber,
    String? supplierArticleNumber,
    String? supplierNumber,
    String? supplier,
    String? sku,
    String? ean,
    String? name,
    List<ProductLanguage>? listOfName,
    Tax? tax,
    bool? haveImages,
    String? mainImageUrl,
    int? mainImageId,
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
    String? manufacturerNumber,
    String? manufacturer,
    int? warehouseStock,
    int? availableStock,
    String? description,
    List<ProductLanguage>? listOfDescription,
    String? descriptionShort,
    List<ProductLanguage>? listOfDescriptionShort,
    double? volume,
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
      haveImages: haveImages ?? this.haveImages,
      mainImageUrl: mainImageUrl ?? this.mainImageUrl,
      mainImageId: mainImageId ?? this.mainImageId,
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
      manufacturerNumber: manufacturerNumber ?? this.manufacturerNumber,
      manufacturer: manufacturer ?? this.manufacturer,
      warehouseStock: warehouseStock ?? this.warehouseStock,
      availableStock: availableStock ?? this.availableStock,
      description: description ?? this.description,
      listOfDescription: listOfDescription ?? this.listOfDescription,
      descriptionShort: descriptionShort ?? this.descriptionShort,
      listOfDescriptionShort: listOfDescriptionShort ?? this.listOfDescriptionShort,
      volume: volume ?? this.volume,
      productMarketplaces: productMarketplaces ?? this.productMarketplaces,
    );
  }

  @override
  String toString() {
    return 'Product(id: $id, articleNumber: $articleNumber, supplierArticleNumber: $supplierArticleNumber, supplierNumber: $supplierNumber, supplier: $supplier, sku: $sku, ean: $ean, name: $name, listOfName: $listOfName, tax: $tax, haveImages: $haveImages, mainImageUrl: $mainImageUrl, mainImageId: $mainImageId, imageUrls: $imageUrls, isActive: $isActive, ordered: $ordered, brandName: $brandName, unity: $unity, unitPrice: $unitPrice, width: $width, height: $height, depth: $depth, weight: $weight, netPrice: $netPrice, grossPrice: $grossPrice, wholesalePrice: $wholesalePrice, recommendedRetailPrice: $recommendedRetailPrice, haveVariants: $haveVariants, isSetArticle: $isSetArticle, manufacturerNumber: $manufacturerNumber, manufacturer: $manufacturer, warehouseStock: $warehouseStock, availableStock: $availableStock, description: $description, listOfDescription: $listOfDescription, descriptionShort: $descriptionShort, listOfDescriptionShort: $listOfDescriptionShort, volume: $volume, productMarketplaces: $productMarketplaces)';
  }
}
