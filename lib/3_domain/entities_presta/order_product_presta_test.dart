import 'package:xml/xml.dart';

class OrderProductPrestaTest {
  final int id;
  final int productId;
  final int productAttributeId;
  final int productQuantity;
  final String productName;
  final String productReference;
  final String productEan13;
  final String productIsbn;
  final String productUpc;
  final double productPrice;
  final int idCustomization;
  final double unitPriceTaxIncl;
  final double unitPriceTaxExcl;

  OrderProductPrestaTest({
    required this.id,
    required this.productId,
    required this.productAttributeId,
    required this.productQuantity,
    required this.productName,
    required this.productReference,
    required this.productEan13,
    required this.productIsbn,
    required this.productUpc,
    required this.productPrice,
    required this.idCustomization,
    required this.unitPriceTaxIncl,
    required this.unitPriceTaxExcl,
  });

  factory OrderProductPrestaTest.fromXml(XmlElement orderRowElement) {
    return OrderProductPrestaTest(
      id: int.parse(orderRowElement.findElements('id').first.text),
      productId: int.parse(orderRowElement.findElements('product_id').first.text),
      productAttributeId: int.parse(orderRowElement.findElements('product_attribute_id').first.text),
      productQuantity: int.parse(orderRowElement.findElements('product_quantity').first.text),
      productName: orderRowElement.findElements('product_name').first.text,
      productReference: orderRowElement.findElements('product_reference').first.text,
      productEan13: orderRowElement.findElements('product_ean13').first.text,
      productIsbn: orderRowElement.findElements('product_isbn').first.text,
      productUpc: orderRowElement.findElements('product_upc').first.text,
      productPrice: double.parse(orderRowElement.findElements('product_price').first.text),
      idCustomization: int.parse(orderRowElement.findElements('id_customization').first.text),
      unitPriceTaxIncl: double.parse(orderRowElement.findElements('unit_price_tax_incl').first.text),
      unitPriceTaxExcl: double.parse(orderRowElement.findElements('unit_price_tax_excl').first.text),
    );
  }

  OrderProductPrestaTest copyWith({
    int? id,
    int? productId,
    int? productAttributeId,
    int? productQuantity,
    String? productName,
    String? productReference,
    String? productEan13,
    String? productIsbn,
    String? productUpc,
    double? productPrice,
    int? idCustomization,
    double? unitPriceTaxIncl,
    double? unitPriceTaxExcl,
  }) {
    return OrderProductPrestaTest(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productAttributeId: productAttributeId ?? this.productAttributeId,
      productQuantity: productQuantity ?? this.productQuantity,
      productName: productName ?? this.productName,
      productReference: productReference ?? this.productReference,
      productEan13: productEan13 ?? this.productEan13,
      productIsbn: productIsbn ?? this.productIsbn,
      productUpc: productUpc ?? this.productUpc,
      productPrice: productPrice ?? this.productPrice,
      idCustomization: idCustomization ?? this.idCustomization,
      unitPriceTaxIncl: unitPriceTaxIncl ?? this.unitPriceTaxIncl,
      unitPriceTaxExcl: unitPriceTaxExcl ?? this.unitPriceTaxExcl,
    );
  }

  @override
  String toString() {
    return 'OrderProductPresta(id: $id, productId: $productId, productAttributeId: $productAttributeId, productQuantity: $productQuantity, productName: $productName, productReference: $productReference, productEan13: $productEan13, productIsbn: $productIsbn, productUpc: $productUpc, productPrice: $productPrice, idCustomization: $idCustomization, unitPriceTaxIncl: $unitPriceTaxIncl, unitPriceTaxExcl: $unitPriceTaxExcl)';
  }
}
