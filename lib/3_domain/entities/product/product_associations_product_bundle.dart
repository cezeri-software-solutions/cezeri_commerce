import 'package:json_annotation/json_annotation.dart';

part 'product_associations_product_bundle.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductAssociationsProductBundle {
  final int? id; // Product id
  final int? idProductAttribute; // Trifft glaube ich nur auf Variantenartikel zu
  final int? quantity; // Menge je Produkt vom Bundle
  const ProductAssociationsProductBundle({
    required this.id,
    required this.idProductAttribute,
    required this.quantity,
  });

  factory ProductAssociationsProductBundle.fromJson(Map<String, dynamic> json) => _$ProductAssociationsProductBundleFromJson(json);

  Map<String, dynamic> toJson() => _$ProductAssociationsProductBundleToJson(this);

  ProductAssociationsProductBundle copyWith({
    int? id,
    int? idProductAttribute,
    int? quantity,
  }) {
    return ProductAssociationsProductBundle(
      id: id ?? this.id,
      idProductAttribute: idProductAttribute ?? this.idProductAttribute,
      quantity: quantity ?? this.quantity,
    );
  }
}

//? Bei BündelArtikeln wird diese Association hinzugefügt und
//! type ändert sich von simple zu pack

// <product_bundle nodeType="product" api="products">
// 	<product>
// 	<id><![CDATA[310]]></id>
// 	<id_product_attribute><![CDATA[0]]></id_product_attribute>
// 	<quantity><![CDATA[1]]></quantity>
// 	</product>
// 	<product>
// 	<id><![CDATA[322]]></id>
// 	<id_product_attribute><![CDATA[0]]></id_product_attribute>
// 	<quantity><![CDATA[1]]></quantity>
// 	</product>
// 	<product>
// 	<id><![CDATA[326]]></id>
// 	<id_product_attribute><![CDATA[0]]></id_product_attribute>
// 	<quantity><![CDATA[1]]></quantity>
// 	</product>
// 	<product>
// 	<id><![CDATA[594]]></id>
// 	<id_product_attribute><![CDATA[0]]></id_product_attribute>
// 	<quantity><![CDATA[1]]></quantity>
// 	</product>
// 	<product>
// 	<id><![CDATA[667]]></id>
// 	<id_product_attribute><![CDATA[0]]></id_product_attribute>
// 	<quantity><![CDATA[1]]></quantity>
// 	</product>
// 	<product>
// 	<id><![CDATA[712]]></id>
// 	<id_product_attribute><![CDATA[0]]></id_product_attribute>
// 	<quantity><![CDATA[1]]></quantity>
// 	</product>
// </product_bundle>
