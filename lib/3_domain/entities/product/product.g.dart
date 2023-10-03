// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      id: json['id'] as String,
      articleNumber: json['articleNumber'] as String,
      supplierArticleNumber: json['supplierArticleNumber'] as String,
      supplierNumber: json['supplierNumber'] as String,
      supplier: json['supplier'] as String,
      sku: json['sku'] as String,
      ean: json['ean'] as String,
      name: json['name'] as String,
      listOfName: (json['listOfName'] as List<dynamic>)
          .map((e) => ProductLanguage.fromJson(e as Map<String, dynamic>))
          .toList(),
      tax: Tax.fromJson(json['tax'] as Map<String, dynamic>),
      haveImages: json['haveImages'] as bool,
      mainImageUrl: json['mainImageUrl'] as String,
      mainImageId: json['mainImageId'] as int,
      imageUrls:
          (json['imageUrls'] as List<dynamic>).map((e) => e as String).toList(),
      isActive: json['isActive'] as bool,
      ordered: json['ordered'] as int,
      brandName: json['brandName'] as String,
      unity: json['unity'] as String,
      unitPrice: (json['unitPrice'] as num).toDouble(),
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      depth: (json['depth'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
      netPrice: (json['netPrice'] as num).toDouble(),
      grossPrice: (json['grossPrice'] as num).toDouble(),
      wholesalePrice: (json['wholesalePrice'] as num).toDouble(),
      recommendedRetailPrice:
          (json['recommendedRetailPrice'] as num).toDouble(),
      haveVariants: json['haveVariants'] as bool,
      isSetArticle: json['isSetArticle'] as bool,
      manufacturerNumber: json['manufacturerNumber'] as String,
      manufacturer: json['manufacturer'] as String,
      warehouseStock: json['warehouseStock'] as int,
      availableStock: json['availableStock'] as int,
      description: json['description'] as String,
      listOfDescription: (json['listOfDescription'] as List<dynamic>)
          .map((e) => ProductLanguage.fromJson(e as Map<String, dynamic>))
          .toList(),
      descriptionShort: json['descriptionShort'] as String,
      listOfDescriptionShort: (json['listOfDescriptionShort'] as List<dynamic>)
          .map((e) => ProductLanguage.fromJson(e as Map<String, dynamic>))
          .toList(),
      volume: (json['volume'] as num).toDouble(),
      listOfProductImages: (json['listOfProductImages'] as List<dynamic>)
          .map((e) => ProductImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      productMarketplaces: (json['productMarketplaces'] as List<dynamic>)
          .map((e) => ProductMarketplace.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'articleNumber': instance.articleNumber,
      'supplierArticleNumber': instance.supplierArticleNumber,
      'supplierNumber': instance.supplierNumber,
      'supplier': instance.supplier,
      'sku': instance.sku,
      'ean': instance.ean,
      'name': instance.name,
      'listOfName': instance.listOfName.map((e) => e.toJson()).toList(),
      'tax': instance.tax.toJson(),
      'haveImages': instance.haveImages,
      'mainImageUrl': instance.mainImageUrl,
      'mainImageId': instance.mainImageId,
      'imageUrls': instance.imageUrls,
      'isActive': instance.isActive,
      'ordered': instance.ordered,
      'brandName': instance.brandName,
      'unity': instance.unity,
      'unitPrice': instance.unitPrice,
      'width': instance.width,
      'height': instance.height,
      'depth': instance.depth,
      'weight': instance.weight,
      'netPrice': instance.netPrice,
      'grossPrice': instance.grossPrice,
      'wholesalePrice': instance.wholesalePrice,
      'recommendedRetailPrice': instance.recommendedRetailPrice,
      'haveVariants': instance.haveVariants,
      'isSetArticle': instance.isSetArticle,
      'manufacturerNumber': instance.manufacturerNumber,
      'manufacturer': instance.manufacturer,
      'warehouseStock': instance.warehouseStock,
      'availableStock': instance.availableStock,
      'description': instance.description,
      'listOfDescription':
          instance.listOfDescription.map((e) => e.toJson()).toList(),
      'descriptionShort': instance.descriptionShort,
      'listOfDescriptionShort':
          instance.listOfDescriptionShort.map((e) => e.toJson()).toList(),
      'volume': instance.volume,
      'listOfProductImages':
          instance.listOfProductImages.map((e) => e.toJson()).toList(),
      'productMarketplaces':
          instance.productMarketplaces.map((e) => e.toJson()).toList(),
    };
