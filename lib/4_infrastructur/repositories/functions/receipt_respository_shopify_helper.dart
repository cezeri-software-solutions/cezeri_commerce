import 'package:cezeri_commerce/1_presentation/core/extensions/string_to_int.dart';
import 'package:cezeri_commerce/1_presentation/core/extensions/to_my_currency.dart';
import 'package:cezeri_commerce/core/shopify_failure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';

import '../../../3_domain/entities/marketplace/marketplace_shopify.dart';
import '../shopify_api/shopify.dart';
import '/1_presentation/core/functions/mixed_functions.dart';
import '/3_domain/entities/customer/customer.dart';
import '/3_domain/entities/product/product.dart';
import '/3_domain/entities/receipt/receipt.dart';
import '/3_domain/entities/receipt/receipt_product.dart';
import '/3_domain/entities/settings/main_settings.dart';
import '/3_domain/repositories/firebase/customer_repository.dart';
import '/3_domain/repositories/firebase/product_repository.dart';
import '/core/abstract_failure.dart';
import 'product_import.dart';
import 'receipt_respository_helper.dart';

final logger = Logger();

Future<Either<AbstractFailure, ({Receipt receipt, int customerNumber})>> createReceiptFromOrderShopify(
  FirebaseFirestore db,
  String currentUserUid,
  ProductRepository productRepository,
  CustomerRepository customerRepository,
  MainSettings mainSettings,
  MarketplaceShopify marketplace,
  OrderShopify orderShopify,
) async {
  // final api = ShopifyApi(
  //   ShopifyApiConfig(storefrontToken: marketplace.storefrontAccessToken, adminToken: marketplace.adminAccessToken),
  //   marketplace.fullUrl,
  // );

  List<ReceiptProduct> listOfReceiptproducts = [];
  AbstractFailure? abstractFailureFromGetListOfReceipts;
  final fosListOfReceiptproduct =
      await getListOfReceiptProductsFromShopify(db, currentUserUid, productRepository, mainSettings, marketplace, orderShopify);
  fosListOfReceiptproduct.fold(
    (failure) => abstractFailureFromGetListOfReceipts = failure,
    (receiptProducts) => listOfReceiptproducts = receiptProducts,
  );
  if (abstractFailureFromGetListOfReceipts != null) return Left(abstractFailureFromGetListOfReceipts!);

  // final optionalCurrency = await api.getCurrency(int.parse(orderShopify.idCurrency));
  // final currency = optionalCurrency.value;
  // final optionalCarrier = await api.getCarrier(int.parse(orderShopify.idCarrier));
  // final carrier = optionalCarrier.value;
  // final optionalCustomer = await api.getCustomer(int.parse(orderShopify.idCustomer));
  // final customer = optionalCustomer.value;
  // final optionalAddressInvoice = await api.getAddress(int.parse(orderShopify.idAddressInvoice));
  // final addressInvoice = optionalAddressInvoice.value;
  // final optionalAddressDelivery = await api.getAddress(int.parse(orderShopify.idAddressDelivery));
  // final addressDelivery = optionalAddressDelivery.value;
  // final optionalCountryInvoice = await api.getCountry(int.parse(addressInvoice.idCountry));
  // final countryInvoice = optionalCountryInvoice.value;
  // final optionalCountryDelivery = await api.getCountry(int.parse(addressDelivery.idCountry));
  // final countryDelivery = optionalCountryDelivery.value;

  final loadedCustomerFromFirestore = await getCustomerByMarketplaceId(customerRepository, marketplace.id, orderShopify.customer.id);
  Customer? customerFirestore;
  int nextCustomerNumber = mainSettings.nextCustomerNumber;
  if (loadedCustomerFromFirestore == null) {
    final tax = mainSettings.taxes.where((e) => e.taxRate.round() == (orderShopify.taxLines.first.rate * 100).toStringAsFixed(0).toMyInt()).first;
    final createdCustomerInFirestore = await createCustomerFromMarketplace(
      customerRepository,
      Customer.fromShopify(
        orderShopify.customer,
        nextCustomerNumber,
        orderShopify.email ?? '',
        marketplace,
        orderShopify.billingAddress,
        orderShopify.shippingAddress,
        tax,
      ),
    );
    customerFirestore = createdCustomerInFirestore;
    nextCustomerNumber += 1;
  } else {
    // TODO: SHOPIFY Wenn Adrssen richtig von des SChnittstelle ausgegeben werden aktivieren und anpassen
    // final invoiceAddress = Address.fromShopify(addressInvoice, AddressType.invoice);
    // final deliveryAddress = Address.fromShopify(addressDelivery, AddressType.delivery);
    // final checkedCustomer = await checkCustomerAddressIsUpToDateOrUpdateThem(
    //   customerRepository,
    //   loadedCustomerFromFirestore,
    //   invoiceAddress,
    //   deliveryAddress,
    // );
    // customerFirestore = checkedCustomer;
  }
  //* Wenn der Kunde nicht geladen werden kann und auch nicht erstellt werden kann, soll diese Bestellung übersprungen werden.
  if (customerFirestore == null) {
    logger.e('Kunde aus Bestellung von Marktplatz konnte weder in Firestore erstellt werden, noch in Firestore gespeichert werden');
    return left(MixedFailure(
        errorMessage: 'Kunde aus Bestellung von Marktplatz konnte weder in Firestore erstellt werden, noch in Firestore gespeichert werden'));
  }

  final phAppointment = Receipt.fromOrderShopify(
    marketplace: marketplace,
    mainSettings: mainSettings,
    listOfReceiptproduct: listOfReceiptproducts,
    orderShopify: orderShopify,
    customer: customerFirestore,
  );

  return Right((receipt: phAppointment, customerNumber: nextCustomerNumber));
}

Future<Either<AbstractFailure, List<ReceiptProduct>>> getListOfReceiptProductsFromShopify(
  FirebaseFirestore db,
  String currentUserUid,
  ProductRepository productRepository,
  MainSettings mainSettings,
  MarketplaceShopify marketplace,
  OrderShopify orderShopify,
) async {
  List<ReceiptProduct> listOfReceiptproduct = [];

  for (final orderProductShopify in orderShopify.lineItems) {
    final quantity = orderProductShopify.quantity;
    final tax = (orderProductShopify.taxLines.first.rate * 100).toStringAsFixed(0).toMyInt();

    final api = ShopifyApi(
      ShopifyApiConfig(storefrontToken: marketplace.storefrontAccessToken, adminToken: marketplace.adminAccessToken),
      marketplace.fullUrl,
    );

    ProductShopify? phProductShopify;
    AbstractFailure? fosProductShopifyFailure;
    final fosProductShopify = await api.getProductsById(orderProductShopify.productId!);
    fosProductShopify.fold(
      (failure) => fosProductShopifyFailure = failure,
      (loadedProductShopify) => phProductShopify = loadedProductShopify,
    );
    if (fosProductShopifyFailure != null) return Left(fosProductShopifyFailure!);
    if (phProductShopify == null) return Left(ShopifyGeneralFailure(errorMessage: 'Artikel konnte nicht aus Shopify geladen werden.'));
    final productShopify = phProductShopify!;

    Product? appointmentProduct;
    final fosAppointmentProduct = await getOrCreateProductFromShopifyOnImportAppointment(
      productShopify,
      orderProductShopify.quantity,
      marketplace,
      mainSettings,
      productRepository,
      null,
    );
    fosAppointmentProduct.fold(
      (failure) => left(failure),
      (appProduct) => appointmentProduct = appProduct,
    );

    final receiptProduct = generateReceiptProductFromShopify(
      product: appointmentProduct!,
      orderProductShopify: orderProductShopify,
      mainSettings: mainSettings,
      quantity: quantity,
      tax: tax,
    );
    listOfReceiptproduct.add(receiptProduct);
  }
  return Right(listOfReceiptproduct);
}

ReceiptProduct generateReceiptProductFromShopify({
  required Product product,
  required LineItemShopify orderProductShopify,
  required MainSettings mainSettings,
  required int quantity,
  required int tax,
}) {
  final netPricePerUnit = (orderProductShopify.price.toMyDouble() / taxToCalc(tax)).toMyRoundedDouble();
  return ReceiptProduct(
    productId: product.id,
    productAttributeId: 0,
    quantity: quantity,
    shippedQuantity: 0,
    name: orderProductShopify.title,
    articleNumber: product.articleNumber,
    ean: product.ean,
    price: netPricePerUnit,
    unitPriceGross: orderProductShopify.price.toMyDouble(),
    unitPriceNet: netPricePerUnit,
    customization: 0,
    tax: mainSettings.taxes.where((e) => e.taxRate == tax).firstOrNull ?? mainSettings.taxes.where((e) => e.isDefault).first,
    wholesalePrice: product.wholesalePrice,
    discountGrossUnit: 0, //product.grossPrice - (orderProductShopify.unitPriceTaxIncl).toMyDouble(),
    discountNetUnit: 0, //product.netPrice - (orderProductShopify.unitPriceTaxExcl).toMyDouble(),
    discountGross: 0, //product.grossPrice - (orderProductShopify.unitPriceTaxIncl).toMyDouble() * quantity,
    discountNet: 0, //product.netPrice - ((orderProductShopify.unitPriceTaxExcl).toMyDouble()) * quantity,
    discountPercent: 0, //calcPercentageOfTwoDoubles(product.netPrice, (orderProductShopify.unitPriceTaxExcl).toMyDouble()),
    discountPercentAmountGrossUnit: 0,
    discountPercentAmountNetUnit: 0,
    profitUnit: netPricePerUnit - (product.wholesalePrice),
    profit: (netPricePerUnit - product.wholesalePrice) * quantity,
    weight: product.weight,
    isFromDatabase: true,
  );
}
