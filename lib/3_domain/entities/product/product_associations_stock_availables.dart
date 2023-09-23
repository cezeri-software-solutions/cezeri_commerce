import 'package:json_annotation/json_annotation.dart';

part 'product_associations_stock_availables.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductAssociationsStockAvailables {
  final String? href;
  final int? id;
  final int? idProductAttribute;

  const ProductAssociationsStockAvailables({
    required this.href,
    required this.id,
    required this.idProductAttribute,
  });

  factory ProductAssociationsStockAvailables.fromJson(Map<String, dynamic> json) => _$ProductAssociationsStockAvailablesFromJson(json);

  Map<String, dynamic> toJson() => _$ProductAssociationsStockAvailablesToJson(this);

  ProductAssociationsStockAvailables copyWith({
    String? href,
    int? id,
    int? idProductAttribute,
  }) {
    return ProductAssociationsStockAvailables(
      href: href ?? this.href,
      id: id ?? this.id,
      idProductAttribute: idProductAttribute ?? this.idProductAttribute,
    );
  }

  @override
  String toString() => 'ProductAssociationsStockAvailables(href: $href, id: $id, idProductAttribute: $idProductAttribute)';
}

//! stockAvailables
//? Bei normalen Artikeln
// <stock_availables nodeType="stock_available" api="stock_availables">
// 	<stock_available xlink:href="https://ccf-autopflege.at/api/stock_availables/8264">
// 	<id><![CDATA[8264]]></id>
// 	<id_product_attribute><![CDATA[0]]></id_product_attribute>
// 	</stock_available>
// </stock_availables>

//! stockAvailables
//? Bei Varianten Artikeln
// <stock_availables nodeType="stock_available" api="stock_availables">
// 	<stock_available xlink:href="https://www.meine-kinderschuhe.com/api/stock_availables/91">
// 	<id><![CDATA[91]]></id>
// 	<id_product_attribute><![CDATA[0]]></id_product_attribute>
// 	</stock_available>
// 	<stock_available xlink:href="https://www.meine-kinderschuhe.com/api/stock_availables/1130">
// 	<id><![CDATA[1130]]></id>
// 	<id_product_attribute><![CDATA[52]]></id_product_attribute>
// 	</stock_available>
// 	<stock_available xlink:href="https://www.meine-kinderschuhe.com/api/stock_availables/1132">
// 	<id><![CDATA[1132]]></id>
// 	<id_product_attribute><![CDATA[54]]></id_product_attribute>
// 	</stock_available>
// 	<stock_available xlink:href="https://www.meine-kinderschuhe.com/api/stock_availables/1131">
// 	<id><![CDATA[1131]]></id>
// 	<id_product_attribute><![CDATA[55]]></id_product_attribute>
// 	</stock_available>
// 	<stock_available xlink:href="https://www.meine-kinderschuhe.com/api/stock_availables/1110">
// 	<id><![CDATA[1110]]></id>
// 	<id_product_attribute><![CDATA[564]]></id_product_attribute>
// 	</stock_available>
// 	<stock_available xlink:href="https://www.meine-kinderschuhe.com/api/stock_availables/1111">
// 	<id><![CDATA[1111]]></id>
// 	<id_product_attribute><![CDATA[565]]></id_product_attribute>
// 	</stock_available>
// 	<stock_available xlink:href="https://www.meine-kinderschuhe.com/api/stock_availables/1112">
// 	<id><![CDATA[1112]]></id>
// 	<id_product_attribute><![CDATA[566]]></id_product_attribute>
// 	</stock_available>
// 	<stock_available xlink:href="https://www.meine-kinderschuhe.com/api/stock_availables/1113">
// 	<id><![CDATA[1113]]></id>
// 	<id_product_attribute><![CDATA[567]]></id_product_attribute>
// 	</stock_available>
// 	<stock_available xlink:href="https://www.meine-kinderschuhe.com/api/stock_availables/1114">
// 	<id><![CDATA[1114]]></id>
// 	<id_product_attribute><![CDATA[568]]></id_product_attribute>
// 	</stock_available>
// 	<stock_available xlink:href="https://www.meine-kinderschuhe.com/api/stock_availables/1115">
// 	<id><![CDATA[1115]]></id>
// 	<id_product_attribute><![CDATA[569]]></id_product_attribute>
// 	</stock_available>
// </stock_availables>