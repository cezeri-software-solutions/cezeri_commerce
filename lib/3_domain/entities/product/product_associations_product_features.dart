import 'package:json_annotation/json_annotation.dart';

part 'product_associations_product_features.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductAssociationsProductFeatures {
  final String? href;
  final int? id;
  final String? idFeatureValue;

  const ProductAssociationsProductFeatures({
    required this.href,
    required this.id,
    required this.idFeatureValue,
  });

    factory ProductAssociationsProductFeatures.fromJson(Map<String, dynamic> json) => _$ProductAssociationsProductFeaturesFromJson(json);

  Map<String, dynamic> toJson() => _$ProductAssociationsProductFeaturesToJson(this);

  ProductAssociationsProductFeatures copyWith({
    String? href,
    int? id,
    String? idFeatureValue,
  }) {
    return ProductAssociationsProductFeatures(
      href: href ?? this.href,
      id: id ?? this.id,
      idFeatureValue: idFeatureValue ?? this.idFeatureValue,
    );
  }
}


//! productFeatures
//? Nur für Varianten Artikel
// <product_features nodeType="product_feature" api="product_features">
// 	<product_feature xlink:href="https://www.meine-kinderschuhe.com/api/product_features/3">
// 	<id><![CDATA[3]]></id>
// 	<id_feature_value xlink:href="https://www.meine-kinderschuhe.com/api/product_feature_values/13"><![CDATA[13]]></id_feature_value>
// 	</product_feature>
// 	<product_feature xlink:href="https://www.meine-kinderschuhe.com/api/product_features/4">
// 	<id><![CDATA[4]]></id>
// 	<id_feature_value xlink:href="https://www.meine-kinderschuhe.com/api/product_feature_values/18"><![CDATA[18]]></id_feature_value>
// 	</product_feature>
// 	<product_feature xlink:href="https://www.meine-kinderschuhe.com/api/product_features/5">
// 	<id><![CDATA[5]]></id>
// 	<id_feature_value xlink:href="https://www.meine-kinderschuhe.com/api/product_feature_values/20"><![CDATA[20]]></id_feature_value>
// 	</product_feature>
// 	<product_feature xlink:href="https://www.meine-kinderschuhe.com/api/product_features/6">
// 	<id><![CDATA[6]]></id>
// 	<id_feature_value xlink:href="https://www.meine-kinderschuhe.com/api/product_feature_values/21"><![CDATA[21]]></id_feature_value>
// 	</product_feature>
// 	<product_feature xlink:href="https://www.meine-kinderschuhe.com/api/product_features/7">
// 	<id><![CDATA[7]]></id>
// 	<id_feature_value xlink:href="https://www.meine-kinderschuhe.com/api/product_feature_values/24"><![CDATA[24]]></id_feature_value>
// 	</product_feature>
// 	<product_feature xlink:href="https://www.meine-kinderschuhe.com/api/product_features/8">
// 	<id><![CDATA[8]]></id>
// 	<id_feature_value xlink:href="https://www.meine-kinderschuhe.com/api/product_feature_values/29"><![CDATA[29]]></id_feature_value>
// 	</product_feature>
// 	<product_feature xlink:href="https://www.meine-kinderschuhe.com/api/product_features/9">
// 	<id><![CDATA[9]]></id>
// 	<id_feature_value xlink:href="https://www.meine-kinderschuhe.com/api/product_feature_values/17"><![CDATA[17]]></id_feature_value>
// 	</product_feature>
// </product_features>