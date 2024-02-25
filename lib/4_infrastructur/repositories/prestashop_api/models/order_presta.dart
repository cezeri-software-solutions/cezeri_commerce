import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'product_raw_presta.dart';

part 'order_presta.g.dart';

@JsonSerializable()
class OrdersPresta {
  static const _encoder = JsonEncoder.withIndent('  ');

  @JsonKey(name: 'orders')
  final List<OrderPresta> items;

  const OrdersPresta({required this.items});

  factory OrdersPresta.fromJson(Map<String, dynamic> json) => _$OrdersPrestaFromJson(json);
  Map<String, dynamic> toJson() => _$OrdersPrestaToJson(this);

  List<Object?> get props => [items];

  @override
  String toString() => _encoder.convert(toJson());
}

@JsonSerializable()
class OrderPresta {
  static const _encoder = JsonEncoder.withIndent('  ');

  final int id;
  @JsonKey(name: 'id_address_delivery')
  final String idAddressDelivery;
  @JsonKey(name: 'id_address_invoice')
  final String idAddressInvoice;
  @JsonKey(name: 'id_cart')
  final String idCart;
  @JsonKey(name: 'id_currency')
  final String idCurrency;
  @JsonKey(name: 'id_lang')
  final String idLang;
  @JsonKey(name: 'id_customer')
  final String idCustomer;
  @JsonKey(name: 'id_carrier')
  final String idCarrier;
  @JsonKey(name: 'current_state')
  final String currentState;
  final String module;
  @JsonKey(name: 'invoice_number')
  final String invoiceNumber;
  @JsonKey(name: 'invoice_date')
  final String invoiceDate;
  @JsonKey(name: 'delivery_number')
  final String deliveryNumber;
  @JsonKey(name: 'delivery_date')
  final String deliveryDate;
  final String valid;
  @JsonKey(name: 'date_add')
  final String dateAdd;
  @JsonKey(name: 'date_upd')
  final String dateUpd;
  @JsonKey(name: 'shipping_number')
  final String shippingNumber;
  final String note;
  @JsonKey(name: 'id_shop_group')
  final String idShopGroup;
  @JsonKey(name: 'id_shop')
  final String idShop;
  @JsonKey(name: 'secure_key')
  final String secureKey;
  final String payment;
  final String recyclable;
  final String gift;
  @JsonKey(name: 'gift_message')
  final String giftMessage;
  @JsonKey(name: 'mobile_theme')
  final String mobileTheme;
  @JsonKey(name: 'total_discounts')
  final String totalDiscounts;
  @JsonKey(name: 'total_discounts_tax_incl')
  final String totalDiscountsTaxIncl;
  @JsonKey(name: 'total_discounts_tax_excl')
  final String totalDiscountsTaxExcl;
  @JsonKey(name: 'total_paid')
  final String totalPaid;
  @JsonKey(name: 'total_paid_tax_incl')
  final String totalPaidTaxIncl;
  @JsonKey(name: 'total_paid_tax_excl')
  final String totalPaidTaxExcl;
  @JsonKey(name: 'total_paid_real')
  final String totalPaidReal;
  @JsonKey(name: 'total_products')
  final String totalProducts;
  @JsonKey(name: 'total_products_wt')
  final String totalProductsWt;
  @JsonKey(name: 'total_shipping')
  final String totalShipping;
  @JsonKey(name: 'total_shipping_tax_incl')
  final String totalShippingTaxIncl;
  @JsonKey(name: 'total_shipping_tax_excl')
  final String totalShippingTaxExcl;
  @JsonKey(name: 'carrier_tax_rate')
  final String carrierTaxRate;
  @JsonKey(name: 'total_wrapping')
  final String totalWrapping;
  @JsonKey(name: 'total_wrapping_tax_incl')
  final String totalWrappingTaxIncl;
  @JsonKey(name: 'total_wrapping_tax_excl')
  final String totalWrappingTaxExcl;
  @JsonKey(name: 'round_mode')
  final String roundMode;
  @JsonKey(name: 'round_type')
  final String roundType;
  @JsonKey(name: 'conversion_rate')
  final String conversionRate;
  final String reference;
  @JsonKey(name: 'crn_invoice_number')
  final String? crnInvoiceNumber;
  @JsonKey(name: 'crn_delivery_number')
  final String? crnDeliveryNumber;
  final OrderAssociations? associations;

  OrderPresta({
    required this.id,
    required this.idAddressDelivery,
    required this.idAddressInvoice,
    required this.idCart,
    required this.idCurrency,
    required this.idLang,
    required this.idCustomer,
    required this.idCarrier,
    required this.currentState,
    required this.module,
    required this.invoiceNumber,
    required this.invoiceDate,
    required this.deliveryNumber,
    required this.deliveryDate,
    required this.valid,
    required this.dateAdd,
    required this.dateUpd,
    required this.shippingNumber,
    required this.note,
    required this.idShopGroup,
    required this.idShop,
    required this.secureKey,
    required this.payment,
    required this.recyclable,
    required this.gift,
    required this.giftMessage,
    required this.mobileTheme,
    required this.totalDiscounts,
    required this.totalDiscountsTaxIncl,
    required this.totalDiscountsTaxExcl,
    required this.totalPaid,
    required this.totalPaidTaxIncl,
    required this.totalPaidTaxExcl,
    required this.totalPaidReal,
    required this.totalProducts,
    required this.totalProductsWt,
    required this.totalShipping,
    required this.totalShippingTaxIncl,
    required this.totalShippingTaxExcl,
    required this.carrierTaxRate,
    required this.totalWrapping,
    required this.totalWrappingTaxIncl,
    required this.totalWrappingTaxExcl,
    required this.roundMode,
    required this.roundType,
    required this.conversionRate,
    required this.reference,
    this.crnInvoiceNumber,
    this.crnDeliveryNumber,
    this.associations,
  });

  factory OrderPresta.fromJson(Map<String, dynamic> json) => _$OrderPrestaFromJson(json);
  Map<String, dynamic> toJson() => _$OrderPrestaToJson(this);

  List<Object?> get props => [id];

  @override
  String toString() => _encoder.convert(toJson());
}

@JsonSerializable()
class OrderAssociations {
  static const _encoder = JsonEncoder.withIndent('  ');

  @JsonKey(name: 'order_rows')
  final List<OrderProductPresta> orderRows;

  OrderAssociations({required this.orderRows});

  factory OrderAssociations.fromJson(Map<String, dynamic> json) => _$OrderAssociationsFromJson(json);
  Map<String, dynamic> toJson() => _$OrderAssociationsToJson(this);

  List<Object?> get props => [orderRows];

  @override
  String toString() => _encoder.convert(toJson());
}

@JsonSerializable()
class OrderProductPresta {
  static const _encoder = JsonEncoder.withIndent('  ');

  final String id;
  @JsonKey(name: 'product_id')
  final String productId;
  @JsonKey(name: 'product_attribute_id')
  final String productAttributeId;
  @JsonKey(name: 'product_quantity')
  final String productQuantity;
  @JsonKey(name: 'product_name')
  final String productName;
  @JsonKey(name: 'product_reference')
  final String productReference;
  @JsonKey(name: 'product_ean13')
  final String productEan13;
  @JsonKey(name: 'product_isbn')
  final String productIsbn;
  @JsonKey(name: 'product_upc')
  final String productUpc;
  @JsonKey(name: 'product_price')
  final String productPrice;
  @JsonKey(name: 'id_customization')
  final String idCustomization;
  @JsonKey(name: 'unit_price_tax_incl')
  final String unitPriceTaxIncl;
  @JsonKey(name: 'unit_price_tax_excl')
  final String unitPriceTaxExcl;

  OrderProductPresta({
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

  factory OrderProductPresta.fromJson(Map<String, dynamic> json) => _$OrderProductPrestaFromJson(json);
  Map<String, dynamic> toJson() => _$OrderProductPrestaToJson(this);

  factory OrderProductPresta.fromProductPresta(ProductRawPresta pp) {
    return OrderProductPresta(
      id: '',
      productId: pp.id.toString(),
      productAttributeId: '',
      productQuantity: '',
      productName: pp.name!,
      productReference: pp.reference,
      productEan13: pp.ean13,
      productIsbn: pp.isbn,
      productUpc: pp.upc,
      productPrice: pp.price,
      idCustomization: '',
      unitPriceTaxIncl: pp.price,
      unitPriceTaxExcl: pp.price,
    );
  }

  List<Object?> get props => [id];

  @override
  String toString() => _encoder.convert(toJson());
}
