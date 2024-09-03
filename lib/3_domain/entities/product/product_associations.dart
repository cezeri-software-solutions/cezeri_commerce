import 'package:json_annotation/json_annotation.dart';

part 'product_associations.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductAssociations {
  final String? href;
  final int? id;

  const ProductAssociations({required this.href, required this.id});

  factory ProductAssociations.fromJson(Map<String, dynamic> json) => _$ProductAssociationsFromJson(json);

  Map<String, dynamic> toJson() => _$ProductAssociationsToJson(this);

  ProductAssociations copyWith({
    String? href,
    int? id,
  }) {
    return ProductAssociations(
      href: href ?? this.href,
      id: id ?? this.id,
    );
  }
}


//! categories
// <categories nodeType="category" api="categories">
// 	<category xlink:href="https://ccf-autopflege.at/api/categories/2">
// 	<id><![CDATA[2]]></id>
// 	</category>
// 	<category xlink:href="https://ccf-autopflege.at/api/categories/6">
// 	<id><![CDATA[6]]></id>
// 	</category>
// 	<category xlink:href="https://ccf-autopflege.at/api/categories/8">
// 	<id><![CDATA[8]]></id>
// 	</category>
// 	<category xlink:href="https://ccf-autopflege.at/api/categories/102">
// 	<id><![CDATA[102]]></id>
// 	</category>
// 	<category xlink:href="https://ccf-autopflege.at/api/categories/123">
// 	<id><![CDATA[123]]></id>
// 	</category>
// </categories>

//! images
// <images nodeType="image" api="images">
// 	<image xlink:href="https://ccf-autopflege.at/api/images/products/976/2126">
// 	<id><![CDATA[2126]]></id>
// 	</image>
// 	<image xlink:href="https://ccf-autopflege.at/api/images/products/976/2127">
// 	<id><![CDATA[2127]]></id>
// 	</image>
// 	<image xlink:href="https://ccf-autopflege.at/api/images/products/976/2128">
// 	<id><![CDATA[2128]]></id>
// 	</image>
// 	<image xlink:href="https://ccf-autopflege.at/api/images/products/976/2129">
// 	<id><![CDATA[2129]]></id>
// 	</image>
// 	<image xlink:href="https://ccf-autopflege.at/api/images/products/976/2130">
// 	<id><![CDATA[2130]]></id>
// 	</image>
// 	<image xlink:href="https://ccf-autopflege.at/api/images/products/976/2131">
// 	<id><![CDATA[2131]]></id>
// 	</image>
// 	<image xlink:href="https://ccf-autopflege.at/api/images/products/976/2132">
// 	<id><![CDATA[2132]]></id>
// 	</image>
// 	<image xlink:href="https://ccf-autopflege.at/api/images/products/976/2133">
// 	<id><![CDATA[2133]]></id>
// 	</image>
// 	<image xlink:href="https://ccf-autopflege.at/api/images/products/976/2134">
// 	<id><![CDATA[2134]]></id>
// 	</image>
// 	<image xlink:href="https://ccf-autopflege.at/api/images/products/976/2135">
// 	<id><![CDATA[2135]]></id>
// 	</image>
// 	<image xlink:href="https://ccf-autopflege.at/api/images/products/976/2136">
// 	<id><![CDATA[2136]]></id>
// 	</image>
// </images>

//! combinations
//? Nur für Varianten Artikel
// <combinations nodeType="combination" api="combinations">
// 	<combination xlink:href="https://www.meine-kinderschuhe.com/api/combinations/564">
// 	<id><![CDATA[564]]></id>
// 	</combination>
// 	<combination xlink:href="https://www.meine-kinderschuhe.com/api/combinations/565">
// 	<id><![CDATA[565]]></id>
// 	</combination>
// 	<combination xlink:href="https://www.meine-kinderschuhe.com/api/combinations/566">
// 	<id><![CDATA[566]]></id>
// 	</combination>
// 	<combination xlink:href="https://www.meine-kinderschuhe.com/api/combinations/567">
// 	<id><![CDATA[567]]></id>
// 	</combination>
// 	<combination xlink:href="https://www.meine-kinderschuhe.com/api/combinations/568">
// 	<id><![CDATA[568]]></id>
// 	</combination>
// 	<combination xlink:href="https://www.meine-kinderschuhe.com/api/combinations/569">
// 	<id><![CDATA[569]]></id>
// 	</combination>
// </combinations>

//! productOptionValues
//? Nur für Varianten Artikel
// <product_option_values nodeType="product_option_value" api="product_option_values">
// 	<product_option_value xlink:href="https://www.meine-kinderschuhe.com/api/product_option_values/3">
// 	<id><![CDATA[3]]></id>
// 	</product_option_value>
// 	<product_option_value xlink:href="https://www.meine-kinderschuhe.com/api/product_option_values/17">
// 	<id><![CDATA[17]]></id>
// 	</product_option_value>
// 	<product_option_value xlink:href="https://www.meine-kinderschuhe.com/api/product_option_values/4">
// 	<id><![CDATA[4]]></id>
// 	</product_option_value>
// 	<product_option_value xlink:href="https://www.meine-kinderschuhe.com/api/product_option_values/26">
// 	<id><![CDATA[26]]></id>
// 	</product_option_value>
// 	<product_option_value xlink:href="https://www.meine-kinderschuhe.com/api/product_option_values/27">
// 	<id><![CDATA[27]]></id>
// 	</product_option_value>
// 	<product_option_value xlink:href="https://www.meine-kinderschuhe.com/api/product_option_values/28">
// 	<id><![CDATA[28]]></id>
// 	</product_option_value>
// 	<product_option_value xlink:href="https://www.meine-kinderschuhe.com/api/product_option_values/29">
// 	<id><![CDATA[29]]></id>
// 	</product_option_value>
// </product_option_values>

//! accessories
//? Nur für Varianten Artikel
// <accessories nodeType="product" api="products">
// 	<product>
// 	<id xlink:href="https://www.meine-kinderschuhe.com/api/product/32"><![CDATA[32]]></id>
// 	</product>
// 	<product>
// 	<id xlink:href="https://www.meine-kinderschuhe.com/api/product/33"><![CDATA[33]]></id>
// 	</product>
// 	<product>
// 	<id xlink:href="https://www.meine-kinderschuhe.com/api/product/34"><![CDATA[34]]></id>
// 	</product>
// 	<product>
// 	<id xlink:href="https://www.meine-kinderschuhe.com/api/product/40"><![CDATA[40]]></id>
// 	</product>
// 	<product>
// 	<id xlink:href="https://www.meine-kinderschuhe.com/api/product/41"><![CDATA[41]]></id>
// 	</product>
// 	<product>
// 	<id xlink:href="https://www.meine-kinderschuhe.com/api/product/42"><![CDATA[42]]></id>
// 	</product>
// 	<product>
// 	<id xlink:href="https://www.meine-kinderschuhe.com/api/product/57"><![CDATA[57]]></id>
// 	</product>
// 	<product>
// 	<id xlink:href="https://www.meine-kinderschuhe.com/api/product/103"><![CDATA[103]]></id>
// 	</product>
// </accessories>

