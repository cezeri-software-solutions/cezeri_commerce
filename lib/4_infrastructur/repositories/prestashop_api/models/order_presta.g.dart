// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_presta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrdersPresta _$OrdersPrestaFromJson(Map<String, dynamic> json) => OrdersPresta(
      items: (json['orders'] as List<dynamic>)
          .map((e) => OrderPresta.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrdersPrestaToJson(OrdersPresta instance) =>
    <String, dynamic>{
      'orders': instance.items,
    };

OrderPresta _$OrderPrestaFromJson(Map<String, dynamic> json) => OrderPresta(
      id: (json['id'] as num).toInt(),
      idAddressDelivery: json['id_address_delivery'] as String,
      idAddressInvoice: json['id_address_invoice'] as String,
      idCart: json['id_cart'] as String,
      idCurrency: json['id_currency'] as String,
      idLang: json['id_lang'] as String,
      idCustomer: json['id_customer'] as String,
      idCarrier: json['id_carrier'] as String,
      currentState: json['current_state'] as String,
      module: json['module'] as String,
      invoiceNumber: json['invoice_number'] as String,
      invoiceDate: json['invoice_date'] as String,
      deliveryNumber: json['delivery_number'] as String,
      deliveryDate: json['delivery_date'] as String,
      valid: json['valid'] as String,
      dateAdd: json['date_add'] as String,
      dateUpd: json['date_upd'] as String,
      shippingNumber: json['shipping_number'] as String,
      note: json['note'] as String,
      idShopGroup: json['id_shop_group'] as String,
      idShop: json['id_shop'] as String,
      secureKey: json['secure_key'] as String,
      payment: json['payment'] as String,
      recyclable: json['recyclable'] as String,
      gift: json['gift'] as String,
      giftMessage: json['gift_message'] as String,
      mobileTheme: json['mobile_theme'] as String,
      totalDiscounts: json['total_discounts'] as String,
      totalDiscountsTaxIncl: json['total_discounts_tax_incl'] as String,
      totalDiscountsTaxExcl: json['total_discounts_tax_excl'] as String,
      totalPaid: json['total_paid'] as String,
      totalPaidTaxIncl: json['total_paid_tax_incl'] as String,
      totalPaidTaxExcl: json['total_paid_tax_excl'] as String,
      totalPaidReal: json['total_paid_real'] as String,
      totalProducts: json['total_products'] as String,
      totalProductsWt: json['total_products_wt'] as String,
      totalShipping: json['total_shipping'] as String,
      totalShippingTaxIncl: json['total_shipping_tax_incl'] as String,
      totalShippingTaxExcl: json['total_shipping_tax_excl'] as String,
      carrierTaxRate: json['carrier_tax_rate'] as String,
      totalWrapping: json['total_wrapping'] as String,
      totalWrappingTaxIncl: json['total_wrapping_tax_incl'] as String,
      totalWrappingTaxExcl: json['total_wrapping_tax_excl'] as String,
      roundMode: json['round_mode'] as String,
      roundType: json['round_type'] as String,
      conversionRate: json['conversion_rate'] as String,
      reference: json['reference'] as String,
      crnInvoiceNumber: json['crn_invoice_number'] as String?,
      crnDeliveryNumber: json['crn_delivery_number'] as String?,
      associations: json['associations'] == null
          ? null
          : OrderAssociations.fromJson(
              json['associations'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OrderPrestaToJson(OrderPresta instance) =>
    <String, dynamic>{
      'id': instance.id,
      'id_address_delivery': instance.idAddressDelivery,
      'id_address_invoice': instance.idAddressInvoice,
      'id_cart': instance.idCart,
      'id_currency': instance.idCurrency,
      'id_lang': instance.idLang,
      'id_customer': instance.idCustomer,
      'id_carrier': instance.idCarrier,
      'current_state': instance.currentState,
      'module': instance.module,
      'invoice_number': instance.invoiceNumber,
      'invoice_date': instance.invoiceDate,
      'delivery_number': instance.deliveryNumber,
      'delivery_date': instance.deliveryDate,
      'valid': instance.valid,
      'date_add': instance.dateAdd,
      'date_upd': instance.dateUpd,
      'shipping_number': instance.shippingNumber,
      'note': instance.note,
      'id_shop_group': instance.idShopGroup,
      'id_shop': instance.idShop,
      'secure_key': instance.secureKey,
      'payment': instance.payment,
      'recyclable': instance.recyclable,
      'gift': instance.gift,
      'gift_message': instance.giftMessage,
      'mobile_theme': instance.mobileTheme,
      'total_discounts': instance.totalDiscounts,
      'total_discounts_tax_incl': instance.totalDiscountsTaxIncl,
      'total_discounts_tax_excl': instance.totalDiscountsTaxExcl,
      'total_paid': instance.totalPaid,
      'total_paid_tax_incl': instance.totalPaidTaxIncl,
      'total_paid_tax_excl': instance.totalPaidTaxExcl,
      'total_paid_real': instance.totalPaidReal,
      'total_products': instance.totalProducts,
      'total_products_wt': instance.totalProductsWt,
      'total_shipping': instance.totalShipping,
      'total_shipping_tax_incl': instance.totalShippingTaxIncl,
      'total_shipping_tax_excl': instance.totalShippingTaxExcl,
      'carrier_tax_rate': instance.carrierTaxRate,
      'total_wrapping': instance.totalWrapping,
      'total_wrapping_tax_incl': instance.totalWrappingTaxIncl,
      'total_wrapping_tax_excl': instance.totalWrappingTaxExcl,
      'round_mode': instance.roundMode,
      'round_type': instance.roundType,
      'conversion_rate': instance.conversionRate,
      'reference': instance.reference,
      'crn_invoice_number': instance.crnInvoiceNumber,
      'crn_delivery_number': instance.crnDeliveryNumber,
      'associations': instance.associations,
    };

OrderAssociations _$OrderAssociationsFromJson(Map<String, dynamic> json) =>
    OrderAssociations(
      orderRows: (json['order_rows'] as List<dynamic>)
          .map((e) => OrderProductPresta.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrderAssociationsToJson(OrderAssociations instance) =>
    <String, dynamic>{
      'order_rows': instance.orderRows,
    };

OrderProductPresta _$OrderProductPrestaFromJson(Map<String, dynamic> json) =>
    OrderProductPresta(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      productAttributeId: json['product_attribute_id'] as String,
      productQuantity: json['product_quantity'] as String,
      productName: json['product_name'] as String,
      productReference: json['product_reference'] as String,
      productEan13: json['product_ean13'] as String,
      productIsbn: json['product_isbn'] as String,
      productUpc: json['product_upc'] as String,
      productPrice: json['product_price'] as String,
      idCustomization: json['id_customization'] as String,
      unitPriceTaxIncl: json['unit_price_tax_incl'] as String,
      unitPriceTaxExcl: json['unit_price_tax_excl'] as String,
    );

Map<String, dynamic> _$OrderProductPrestaToJson(OrderProductPresta instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product_id': instance.productId,
      'product_attribute_id': instance.productAttributeId,
      'product_quantity': instance.productQuantity,
      'product_name': instance.productName,
      'product_reference': instance.productReference,
      'product_ean13': instance.productEan13,
      'product_isbn': instance.productIsbn,
      'product_upc': instance.productUpc,
      'product_price': instance.productPrice,
      'id_customization': instance.idCustomization,
      'unit_price_tax_incl': instance.unitPriceTaxIncl,
      'unit_price_tax_excl': instance.unitPriceTaxExcl,
    };
