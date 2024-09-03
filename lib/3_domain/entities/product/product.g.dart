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
          .map((e) => FieldLanguage.fromJson(e as Map<String, dynamic>))
          .toList(),
      tax: Tax.fromJson(json['tax'] as Map<String, dynamic>),
      imageUrls:
          (json['imageUrls'] as List<dynamic>).map((e) => e as String).toList(),
      isActive: json['isActive'] as bool,
      ordered: (json['ordered'] as num).toInt(),
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
      isOutlet: json['isOutlet'] as bool,
      listOfIsPartOfSetIds: (json['listOfIsPartOfSetIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      listOfProductIdWithQuantity: (json['listOfProductIdWithQuantity']
              as List<dynamic>)
          .map((e) => ProductIdWithQuantity.fromJson(e as Map<String, dynamic>))
          .toList(),
      isSetSelfQuantityManaged: json['isSetSelfQuantityManaged'] as bool,
      manufacturerNumber: json['manufacturerNumber'] as String,
      manufacturer: json['manufacturer'] as String,
      warehouseStock: (json['warehouseStock'] as num).toInt(),
      availableStock: (json['availableStock'] as num).toInt(),
      minimumStock: (json['minimumStock'] as num).toInt(),
      isUnderMinimumStock: json['isUnderMinimumStock'] as bool,
      minimumReorderQuantity: (json['minimumReorderQuantity'] as num).toInt(),
      packagingUnitOnReorder: (json['packagingUnitOnReorder'] as num).toInt(),
      description: json['description'] as String,
      listOfDescription: (json['listOfDescription'] as List<dynamic>)
          .map((e) => FieldLanguage.fromJson(e as Map<String, dynamic>))
          .toList(),
      descriptionShort: json['descriptionShort'] as String,
      listOfDescriptionShort: (json['listOfDescriptionShort'] as List<dynamic>)
          .map((e) => FieldLanguage.fromJson(e as Map<String, dynamic>))
          .toList(),
      metaTitle: json['metaTitle'] as String,
      listOfMetaTitle: (json['listOfMetaTitle'] as List<dynamic>)
          .map((e) => FieldLanguage.fromJson(e as Map<String, dynamic>))
          .toList(),
      metaDescription: json['metaDescription'] as String,
      listOfMetaDescription: (json['listOfMetaDescription'] as List<dynamic>)
          .map((e) => FieldLanguage.fromJson(e as Map<String, dynamic>))
          .toList(),
      listOfProductImages: (json['listOfProductImages'] as List<dynamic>)
          .map((e) => ProductImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      listOfSetProducts: (json['listOfSetProducts'] as List<dynamic>)
          .map((e) => SetProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
      productMarketplaces: (json['productMarketplaces'] as List<dynamic>)
          .map((e) => ProductMarketplace.fromJson(e as Map<String, dynamic>))
          .toList(),
      creationDate: DateTime.parse(json['creationDate'] as String),
      lastEditingDate: DateTime.parse(json['lastEditingDate'] as String),
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'articleNumber': instance.articleNumber,
      'supplierArticleNumber': instance.supplierArticleNumber,
      'supplierNumber': instance.supplierNumber,
      'supplier': instance.supplier,
      'sku': instance.sku,
      'ean': instance.ean,
      'name': instance.name,
      'listOfName': instance.listOfName.map((e) => e.toJson()).toList(),
      'tax': instance.tax.toJson(),
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
      'isOutlet': instance.isOutlet,
      'listOfIsPartOfSetIds': instance.listOfIsPartOfSetIds,
      'listOfProductIdWithQuantity':
          instance.listOfProductIdWithQuantity.map((e) => e.toJson()).toList(),
      'isSetSelfQuantityManaged': instance.isSetSelfQuantityManaged,
      'manufacturerNumber': instance.manufacturerNumber,
      'manufacturer': instance.manufacturer,
      'warehouseStock': instance.warehouseStock,
      'availableStock': instance.availableStock,
      'minimumStock': instance.minimumStock,
      'isUnderMinimumStock': instance.isUnderMinimumStock,
      'minimumReorderQuantity': instance.minimumReorderQuantity,
      'packagingUnitOnReorder': instance.packagingUnitOnReorder,
      'description': instance.description,
      'listOfDescription':
          instance.listOfDescription.map((e) => e.toJson()).toList(),
      'descriptionShort': instance.descriptionShort,
      'listOfDescriptionShort':
          instance.listOfDescriptionShort.map((e) => e.toJson()).toList(),
      'metaTitle': instance.metaTitle,
      'listOfMetaTitle':
          instance.listOfMetaTitle.map((e) => e.toJson()).toList(),
      'metaDescription': instance.metaDescription,
      'listOfMetaDescription':
          instance.listOfMetaDescription.map((e) => e.toJson()).toList(),
      'listOfProductImages':
          instance.listOfProductImages.map((e) => e.toJson()).toList(),
      'listOfSetProducts':
          instance.listOfSetProducts.map((e) => e.toJson()).toList(),
      'productMarketplaces':
          instance.productMarketplaces.map((e) => e.toJson()).toList(),
    };
