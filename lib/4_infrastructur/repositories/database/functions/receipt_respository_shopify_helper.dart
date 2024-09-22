import 'package:cezeri_commerce/failures/shopify_failure.dart';
import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';

import '/1_presentation/core/core.dart';
import '/3_domain/entities/customer/customer.dart';
import '/3_domain/entities/marketplace/marketplace_shopify.dart';
import '/3_domain/entities/product/product.dart';
import '/3_domain/entities/receipt/receipt.dart';
import '/3_domain/entities/receipt/receipt_product.dart';
import '/3_domain/entities/settings/main_settings.dart';
import '/failures/abstract_failure.dart';
import '../../../../3_domain/repositories/database/customer_repository.dart';
import '../../../../3_domain/repositories/database/product_repository.dart';
import '../../shopify_api/shopify.dart';
import 'product_import.dart';
import 'product_repository_helper.dart';
import 'receipt_respository_helper.dart';

Future<Either<AbstractFailure, Receipt>> createReceiptFromOrderShopify(
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
      await getListOfReceiptProductsFromShopifyAndSetQuantities(productRepository, mainSettings, marketplace, orderShopify);
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

  // TODO: load customer via customer email like for prestashop
  // final loadedCustomerFromFirestore = await getCustomerByEmail(customerRepository, customer.email);
  final loadedCustomerFromFirestore = await getCustomerByMarketplaceId(customerRepository, marketplace.id, orderShopify.customer.id);
  Customer? customerFirestore;
  if (loadedCustomerFromFirestore == null) {
    final tax = mainSettings.taxes.where((e) => e.taxRate.round() == (orderShopify.taxLines.first.rate * 100).toStringAsFixed(0).toMyInt()).first;
    final createdCustomerInFirestore = await createCustomerFromMarketplace(
      customerRepository,
      Customer.fromShopify(
        orderShopify.customer,
        mainSettings.nextCustomerNumber,
        orderShopify.email ?? '',
        marketplace,
        orderShopify.billingAddress,
        orderShopify.shippingAddress,
        tax,
      ),
    );
    customerFirestore = createdCustomerInFirestore;
  } else {
    customerFirestore = loadedCustomerFromFirestore;
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
    Logger().e('Kunde aus Bestellung von Marktplatz konnte weder in Firestore erstellt werden, noch in Firestore gespeichert werden');
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

  return Right(phAppointment);
}

Future<Either<AbstractFailure, List<ReceiptProduct>>> getListOfReceiptProductsFromShopifyAndSetQuantities(
  ProductRepository productRepository,
  MainSettings mainSettings,
  MarketplaceShopify marketplace,
  OrderShopify orderShopify,
) async {
  List<ReceiptProduct> listOfReceiptproduct = [];

  for (final orderProductShopify in orderShopify.lineItems) {
    final quantity = orderProductShopify.quantity;
    final tax = (orderProductShopify.taxLines.first.rate * 100).toStringAsFixed(0).toMyInt();

    ProductShopify? phProductShopify;
    AbstractFailure? fosProductShopifyFailure;
    final fosProductShopify = await ShopifyRepositoryGet(marketplace).getProductById(orderProductShopify.productId!);
    fosProductShopify.fold(
      (failure) => fosProductShopifyFailure = failure,
      (loadedProductShopify) => phProductShopify = loadedProductShopify,
    );
    if (fosProductShopifyFailure != null) return Left(fosProductShopifyFailure!);
    if (phProductShopify == null) return Left(ShopifyGeneralFailure(errorMessage: 'Artikel konnte nicht aus Shopify geladen werden.'));
    final productShopify = phProductShopify!;

    Product? appointmentProduct;
    final fosAppointmentProduct = await getOrCreateProductFromShopifyOnImportAppointment(
      productShopify: productShopify,
      quantity: orderProductShopify.quantity,
      marketplace: marketplace,
      mainSettings: mainSettings,
      productRepository: productRepository,
      listOfProductIdWithQuantity: null,
    );
    fosAppointmentProduct.fold(
      (failure) => left(failure),
      (appProduct) => appointmentProduct = appProduct,
    );

    await updateProductQuantityInDbAndMps(
      productId: appointmentProduct!.id,
      incQuantity: quantity * -1,
      updateOnlyAvailableQuantity: true,
      marketplaceToSkip: marketplace,
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
