import 'package:xml/xml.dart';

import 'order_product_presta_test.dart';

class OrderPrestaTest {
  final int id;
  final int idAddressDelivery;
  final int idAddressInvoice;
  final int idCart;
  final int idCurrency;
  final int idLang;
  final int idCustomer;
  final int idCarrier;
  final int currentState;
  final String module;
  final int invoiceNumber;
  final DateTime invoiceDate;
  final int deliveryNumber;
  final DateTime deliveryDate;
  final bool valid;
  final DateTime dateAdd;
  final DateTime dateUpd;
  final String shippingNumber;
  final String note;
  final int idShopGroup;
  final int idShop;
  final String secureKey;
  final String payment;
  final bool recyclable;
  final bool gift;
  final String giftMessage;
  final bool mobileTheme;
  final double totalDiscounts;
  final double totalDiscountsTaxIncl;
  final double totalDiscountsTaxExcl;
  final double totalPaid;
  final double totalPaidTaxIncl;
  final double totalPaidTaxExcl;
  final double totalPaidReal;
  final double totalProducts;
  final double totalProductsWt;
  final double totalShipping;
  final double totalShippingTaxIncl;
  final double totalShippingTaxExcl;
  final double carrierTaxRate;
  final double totalWrapping;
  final double totalWrappingTaxIncl;
  final double totalWrappingTaxExcl;
  final int roundMode;
  final int roundType;
  final double conversionRate;
  final String reference;
  final String crnInvoiceNumber;
  final String crnDeliveryNumber;
  final List<OrderProductPrestaTest> orderRows;

  OrderPrestaTest({
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
    required this.crnInvoiceNumber,
    required this.crnDeliveryNumber,
    required this.orderRows,
  });

  factory OrderPrestaTest.fromXml(XmlDocument document) {
    final orderElement = document.findAllElements('order').first;
    return OrderPrestaTest(
      id: int.parse(orderElement.findElements('id').first.text),
      idAddressDelivery: int.parse(orderElement.findElements('id_address_delivery').first.text),
      idAddressInvoice: int.parse(orderElement.findElements('id_address_invoice').first.text),
      idCart: int.parse(orderElement.findElements('id_cart').first.text),
      idCurrency: int.parse(orderElement.findElements('id_currency').first.text),
      idLang: int.parse(orderElement.findElements('id_lang').first.text),
      idCustomer: int.parse(orderElement.findElements('id_customer').first.text),
      idCarrier: int.parse(orderElement.findElements('id_carrier').first.text),
      currentState: int.parse(orderElement.findElements('current_state').first.text),
      module: orderElement.findElements('module').first.text,
      invoiceNumber: int.parse(orderElement.findElements('invoice_number').first.text),
      invoiceDate: DateTime.parse(orderElement.findElements('invoice_date').first.text),
      deliveryNumber: int.parse(orderElement.findElements('delivery_number').first.text),
      deliveryDate: DateTime.parse(orderElement.findElements('delivery_date').first.text),
      valid: orderElement.findElements('valid').first.text == '1',
      dateAdd: DateTime.parse(orderElement.findElements('date_add').first.text),
      dateUpd: DateTime.parse(orderElement.findElements('date_upd').first.text),
      shippingNumber: orderElement.findElements('shipping_number').first.text,
      note: orderElement.findElements('note').first.text,
      idShopGroup: int.parse(orderElement.findElements('id_shop_group').first.text),
      idShop: int.parse(orderElement.findElements('id_shop').first.text),
      secureKey: orderElement.findElements('secure_key').first.text,
      payment: orderElement.findElements('payment').first.text,
      recyclable: orderElement.findElements('recyclable').first.text == '1',
      gift: orderElement.findElements('gift').first.text == '1',
      giftMessage: orderElement.findElements('gift_message').first.text,
      mobileTheme: orderElement.findElements('mobile_theme').first.text == '1',
      totalDiscounts: double.parse(orderElement.findElements('total_discounts').first.text),
      totalDiscountsTaxIncl: double.parse(orderElement.findElements('total_discounts_tax_incl').first.text),
      totalDiscountsTaxExcl: double.parse(orderElement.findElements('total_discounts_tax_excl').first.text),
      totalPaid: double.parse(orderElement.findElements('total_paid').first.text),
      totalPaidTaxIncl: double.parse(orderElement.findElements('total_paid_tax_incl').first.text),
      totalPaidTaxExcl: double.parse(orderElement.findElements('total_paid_tax_excl').first.text),
      totalPaidReal: double.parse(orderElement.findElements('total_paid_real').first.text),
      totalProducts: double.parse(orderElement.findElements('total_products').first.text),
      totalProductsWt: double.parse(orderElement.findElements('total_products_wt').first.text),
      totalShipping: double.parse(orderElement.findElements('total_shipping').first.text),
      totalShippingTaxIncl: double.parse(orderElement.findElements('total_shipping_tax_incl').first.text),
      totalShippingTaxExcl: double.parse(orderElement.findElements('total_shipping_tax_excl').first.text),
      carrierTaxRate: double.parse(orderElement.findElements('carrier_tax_rate').first.text),
      totalWrapping: double.parse(orderElement.findElements('total_wrapping').first.text),
      totalWrappingTaxIncl: double.parse(orderElement.findElements('total_wrapping_tax_incl').first.text),
      totalWrappingTaxExcl: double.parse(orderElement.findElements('total_wrapping_tax_excl').first.text),
      roundMode: int.parse(orderElement.findElements('round_mode').first.text),
      roundType: int.parse(orderElement.findElements('round_type').first.text),
      conversionRate: double.parse(orderElement.findElements('conversion_rate').first.text),
      reference: orderElement.findElements('reference').first.text,
      crnInvoiceNumber: orderElement.findElements('crn_invoice_number').first.text,
      crnDeliveryNumber: orderElement.findElements('crn_delivery_number').first.text,
      orderRows: orderElement.findElements('associations').first.findElements('order_row').map((orderRowElement) {
        return OrderProductPrestaTest.fromXml(orderElement);
      }).toList(),
    );
  }

  OrderPrestaTest copyWith({
    int? id,
    int? idAddressDelivery,
    int? idAddressInvoice,
    int? idCart,
    int? idCurrency,
    int? idLang,
    int? idCustomer,
    int? idCarrier,
    int? currentState,
    String? module,
    int? invoiceNumber,
    DateTime? invoiceDate,
    int? deliveryNumber,
    DateTime? deliveryDate,
    bool? valid,
    DateTime? dateAdd,
    DateTime? dateUpd,
    String? shippingNumber,
    String? note,
    int? idShopGroup,
    int? idShop,
    String? secureKey,
    String? payment,
    bool? recyclable,
    bool? gift,
    String? giftMessage,
    bool? mobileTheme,
    double? totalDiscounts,
    double? totalDiscountsTaxIncl,
    double? totalDiscountsTaxExcl,
    double? totalPaid,
    double? totalPaidTaxIncl,
    double? totalPaidTaxExcl,
    double? totalPaidReal,
    double? totalProducts,
    double? totalProductsWt,
    double? totalShipping,
    double? totalShippingTaxIncl,
    double? totalShippingTaxExcl,
    double? carrierTaxRate,
    double? totalWrapping,
    double? totalWrappingTaxIncl,
    double? totalWrappingTaxExcl,
    int? roundMode,
    int? roundType,
    double? conversionRate,
    String? reference,
    String? crnInvoiceNumber,
    String? crnDeliveryNumber,
    List<OrderProductPrestaTest>? orderRows,
  }) {
    return OrderPrestaTest(
      id: id ?? this.id,
      idAddressDelivery: idAddressDelivery ?? this.idAddressDelivery,
      idAddressInvoice: idAddressInvoice ?? this.idAddressInvoice,
      idCart: idCart ?? this.idCart,
      idCurrency: idCurrency ?? this.idCurrency,
      idLang: idLang ?? this.idLang,
      idCustomer: idCustomer ?? this.idCustomer,
      idCarrier: idCarrier ?? this.idCarrier,
      currentState: currentState ?? this.currentState,
      module: module ?? this.module,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      invoiceDate: invoiceDate ?? this.invoiceDate,
      deliveryNumber: deliveryNumber ?? this.deliveryNumber,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      valid: valid ?? this.valid,
      dateAdd: dateAdd ?? this.dateAdd,
      dateUpd: dateUpd ?? this.dateUpd,
      shippingNumber: shippingNumber ?? this.shippingNumber,
      note: note ?? this.note,
      idShopGroup: idShopGroup ?? this.idShopGroup,
      idShop: idShop ?? this.idShop,
      secureKey: secureKey ?? this.secureKey,
      payment: payment ?? this.payment,
      recyclable: recyclable ?? this.recyclable,
      gift: gift ?? this.gift,
      giftMessage: giftMessage ?? this.giftMessage,
      mobileTheme: mobileTheme ?? this.mobileTheme,
      totalDiscounts: totalDiscounts ?? this.totalDiscounts,
      totalDiscountsTaxIncl: totalDiscountsTaxIncl ?? this.totalDiscountsTaxIncl,
      totalDiscountsTaxExcl: totalDiscountsTaxExcl ?? this.totalDiscountsTaxExcl,
      totalPaid: totalPaid ?? this.totalPaid,
      totalPaidTaxIncl: totalPaidTaxIncl ?? this.totalPaidTaxIncl,
      totalPaidTaxExcl: totalPaidTaxExcl ?? this.totalPaidTaxExcl,
      totalPaidReal: totalPaidReal ?? this.totalPaidReal,
      totalProducts: totalProducts ?? this.totalProducts,
      totalProductsWt: totalProductsWt ?? this.totalProductsWt,
      totalShipping: totalShipping ?? this.totalShipping,
      totalShippingTaxIncl: totalShippingTaxIncl ?? this.totalShippingTaxIncl,
      totalShippingTaxExcl: totalShippingTaxExcl ?? this.totalShippingTaxExcl,
      carrierTaxRate: carrierTaxRate ?? this.carrierTaxRate,
      totalWrapping: totalWrapping ?? this.totalWrapping,
      totalWrappingTaxIncl: totalWrappingTaxIncl ?? this.totalWrappingTaxIncl,
      totalWrappingTaxExcl: totalWrappingTaxExcl ?? this.totalWrappingTaxExcl,
      roundMode: roundMode ?? this.roundMode,
      roundType: roundType ?? this.roundType,
      conversionRate: conversionRate ?? this.conversionRate,
      reference: reference ?? this.reference,
      crnInvoiceNumber: crnInvoiceNumber ?? this.crnInvoiceNumber,
      crnDeliveryNumber: crnDeliveryNumber ?? this.crnDeliveryNumber,
      orderRows: orderRows ?? this.orderRows,
    );
  }

  @override
  String toString() {
    return 'OrderPresta(id: $id, idAddressDelivery: $idAddressDelivery, idAddressInvoice: $idAddressInvoice, idCart: $idCart, idCurrency: $idCurrency, idLang: $idLang, idCustomer: $idCustomer, idCarrier: $idCarrier, currentState: $currentState, module: $module, invoiceNumber: $invoiceNumber, invoiceDate: $invoiceDate, deliveryNumber: $deliveryNumber, deliveryDate: $deliveryDate, valid: $valid, dateAdd: $dateAdd, dateUpd: $dateUpd, shippingNumber: $shippingNumber, note: $note, idShopGroup: $idShopGroup, idShop: $idShop, secureKey: $secureKey, payment: $payment, recyclable: $recyclable, gift: $gift, giftMessage: $giftMessage, mobileTheme: $mobileTheme, totalDiscounts: $totalDiscounts, totalDiscountsTaxIncl: $totalDiscountsTaxIncl, totalDiscountsTaxExcl: $totalDiscountsTaxExcl, totalPaid: $totalPaid, totalPaidTaxIncl: $totalPaidTaxIncl, totalPaidTaxExcl: $totalPaidTaxExcl, totalPaidReal: $totalPaidReal, totalProducts: $totalProducts, totalProductsWt: $totalProductsWt, totalShipping: $totalShipping, totalShippingTaxIncl: $totalShippingTaxIncl, totalShippingTaxExcl: $totalShippingTaxExcl, carrierTaxRate: $carrierTaxRate, totalWrapping: $totalWrapping, totalWrappingTaxIncl: $totalWrappingTaxIncl, totalWrappingTaxExcl: $totalWrappingTaxExcl, roundMode: $roundMode, roundType: $roundType, conversionRate: $conversionRate, reference: $reference, crnInvoiceNumber: $crnInvoiceNumber, crnDeliveryNumber: $crnDeliveryNumber, orderRows: $orderRows)';
  }
}
