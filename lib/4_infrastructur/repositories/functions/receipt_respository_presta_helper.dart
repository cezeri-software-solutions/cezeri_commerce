import 'package:cezeri_commerce/1_presentation/core/extensions/string_to_int.dart';
import 'package:cezeri_commerce/1_presentation/core/extensions/to_my_currency.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';

import '../../../3_domain/entities/settings/tax.dart';
import '../prestashop_api/models/order_presta.dart';
import '../prestashop_api/prestashop_api.dart';
import '/1_presentation/core/functions/mixed_functions.dart';
import '/3_domain/entities/address.dart';
import '/3_domain/entities/customer/customer.dart';
import '/3_domain/entities/marketplace/marketplace_presta.dart';
import '/3_domain/entities/product/product.dart';
import '/3_domain/entities/product/product_id_with_quantity.dart';
import '/3_domain/entities/receipt/load_appointments_helper/to_load_appointments_from_marketplace.dart';
import '/3_domain/entities/receipt/receipt.dart';
import '/3_domain/entities/receipt/receipt_product.dart';
import '/3_domain/entities/settings/main_settings.dart';
import '/3_domain/enums/enums.dart';
import '/3_domain/repositories/firebase/customer_repository.dart';
import '/3_domain/repositories/firebase/product_repository.dart';
import '/3_domain/repositories/marketplace/marketplace_edit_repository.dart';
import '/core/abstract_failure.dart';
import '/core/firebase_failures.dart';
import 'product_import.dart';
import 'product_repository_helper.dart';
import 'receipt_respository_helper.dart';

final logger = Logger();

Future<Either<AbstractFailure, ({Receipt receipt, int customerNumber})>> createReceiptFromOrderPresta(
  FirebaseFirestore db,
  String currentUserUid,
  ProductRepository productRepository,
  CustomerRepository customerRepository,
  MarketplaceEditRepository marketplaceEditRepository,
  MainSettings mainSettings,
  MarketplacePresta marketplace,
  OrderPresta orderPresta,
  LoadedOrderFromMarketplace loadedAppointmentFromMarketplace,
) async {
  final api = PrestashopApi(Client(), PrestashopApiConfig(apiKey: marketplace.key, webserviceUrl: marketplace.fullUrl));

  List<ReceiptProduct> listOfReceiptproducts = [];
  AbstractFailure? abstractFailureFromGetListOfReceipts;
  final fosListOfReceiptproduct =
      await getListOfReceiptProductsFromPresta(db, currentUserUid, productRepository, mainSettings, marketplace, orderPresta);
  fosListOfReceiptproduct.fold(
    (failure) => abstractFailureFromGetListOfReceipts = failure,
    (receiptProducts) => listOfReceiptproducts = receiptProducts,
  );
  if (abstractFailureFromGetListOfReceipts != null) return Left(abstractFailureFromGetListOfReceipts!);

  //* Neuen Bestellstatus im Marktplatz setzen
  final fosOrderStatus = await marketplaceEditRepository.setOrderStatusInMarketplace(
    marketplace,
    loadedAppointmentFromMarketplace.orderMarketplaceId,
    OrderStatusUpdateType.onImport,
  );
  fosOrderStatus.fold(
    (failure) =>
        logger.e('Bestellstatus für Bestellung mit der ID: ${loadedAppointmentFromMarketplace.orderMarketplaceId} konnte nicht gesetzt werden'),
    (unit) => logger
        .i('Bestellstatus für die Bestellung mit der ID: ${loadedAppointmentFromMarketplace.orderMarketplaceId} wurde erfolgreich aktualisiert'),
  );

  final optionalCurrency = await api.getCurrency(int.parse(orderPresta.idCurrency));
  final currency = optionalCurrency.value;
  final optionalCarrier = await api.getCarrier(int.parse(orderPresta.idCarrier));
  final carrier = optionalCarrier.value;
  final optionalCustomer = await api.getCustomer(int.parse(orderPresta.idCustomer));
  final customer = optionalCustomer.value;
  final optionalAddressInvoice = await api.getAddress(int.parse(orderPresta.idAddressInvoice));
  final addressInvoice = optionalAddressInvoice.value;
  final optionalAddressDelivery = await api.getAddress(int.parse(orderPresta.idAddressDelivery));
  final addressDelivery = optionalAddressDelivery.value;
  final optionalCountryInvoice = await api.getCountry(int.parse(addressInvoice.idCountry));
  final countryInvoice = optionalCountryInvoice.value;
  final optionalCountryDelivery = await api.getCountry(int.parse(addressDelivery.idCountry));
  final countryDelivery = optionalCountryDelivery.value;

  final loadedCustomerFromFirestore = await getCustomerByMarketplaceId(customerRepository, marketplace.id, customer.id);
  Customer? customerFirestore;
  int nextCustomerNumber = mainSettings.nextCustomerNumber;
  if (loadedCustomerFromFirestore == null) {
    double getTotalNet() =>
        (orderPresta.totalProducts).toMyDouble() +
        (orderPresta.totalShippingTaxExcl).toMyDouble() +
        (orderPresta.totalWrappingTaxExcl).toMyDouble() -
        (orderPresta.totalDiscountsTaxExcl).toMyDouble();
    double getTotalGross() =>
        (orderPresta.totalProductsWt).toMyDouble() +
        (orderPresta.totalShippingTaxIncl).toMyDouble() +
        (orderPresta.totalWrappingTaxIncl).toMyDouble() -
        (orderPresta.totalDiscountsTaxIncl).toMyDouble();
    Tax? tax = mainSettings.taxes.where((e) => e.taxRate.round() == calcTaxPercent(getTotalGross(), getTotalNet()).round()).firstOrNull;
    tax ??= mainSettings.taxes.where((e) => e.isDefault).first;

    final createdCustomerInFirestore = await createCustomerFromMarketplace(
      customerRepository,
      Customer.fromPresta(customer, nextCustomerNumber, marketplace, addressInvoice, addressDelivery, countryInvoice, countryDelivery, tax),
    );
    customerFirestore = createdCustomerInFirestore;
    nextCustomerNumber += 1;
  } else {
    final invoiceAddress = Address.fromPresta(addressInvoice, countryInvoice, AddressType.invoice);
    final deliveryAddress = Address.fromPresta(addressDelivery, countryDelivery, AddressType.delivery);
    final checkedCustomer = await checkCustomerAddressIsUpToDateOrUpdateThem(
      customerRepository,
      loadedCustomerFromFirestore,
      invoiceAddress,
      deliveryAddress,
    );
    customerFirestore = checkedCustomer;
  }
  //* Wenn der Kunde nicht geladen werden kann und auch nicht erstellt werden kann, soll diese Bestellung übersprungen werden.
  if (customerFirestore == null) {
    logger.e('Kunde aus Bestellung von Marktplatz konnte weder in Firestore erstellt werden, noch in Firestore gespeichert werden');
    return left(MixedFailure(
        errorMessage: 'Kunde aus Bestellung von Marktplatz konnte weder in Firestore erstellt werden, noch in Firestore gespeichert werden'));
  }

  final phAppointment = Receipt.fromOrderPresta(
    marketplace: marketplace,
    mainSettings: mainSettings,
    listOfReceiptproduct: listOfReceiptproducts,
    orderPresta: orderPresta,
    currencyPresta: currency,
    customerPresta: customer,
    addressInvoicePresta: addressInvoice,
    addressDeliveryPresta: addressDelivery,
    countryInvoicePresta: countryInvoice,
    countryDeliveryPresta: countryDelivery,
    carrierPresta: carrier,
    customer: customerFirestore,
  );

  return Right((receipt: phAppointment, customerNumber: nextCustomerNumber));
}

Future<Either<AbstractFailure, List<ReceiptProduct>>> getListOfReceiptProductsFromPresta(
  FirebaseFirestore db,
  String currentUserUid,
  ProductRepository productRepository,
  MainSettings mainSettings,
  MarketplacePresta marketplace,
  OrderPresta orderPresta,
) async {
  List<ReceiptProduct> listOfReceiptproduct = [];

  for (final orderProductPresta in orderPresta.associations!.orderRows) {
    final quantity = int.parse(orderProductPresta.productQuantity);
    final tax = calcTaxPercent((orderProductPresta.unitPriceTaxIncl).toMyDouble(), (orderProductPresta.unitPriceTaxExcl).toMyDouble());

    final api = PrestashopApi(Client(), PrestashopApiConfig(apiKey: marketplace.key, webserviceUrl: marketplace.fullUrl));

    final optionalProductPresta = await api.getProduct(int.parse(orderProductPresta.productId), marketplace);
    if (optionalProductPresta.isNotPresent) {
      logger.e('Artikel aus Bestellung konnte beim Bestellimport nicht aus Marktplatz geladen werden');
      return left(GeneralFailure(customMessage: 'Artikel aus Bestellung konnte beim Bestellimport nicht aus Marktplatz geladen werden'));
    }
    final productPresta = optionalProductPresta.value;

    Product? appointmentProduct;

    //* Wenn Set-Artikel werden auch die Einzelartikel des Sets mitgeladen
    if (productPresta.type == 'pack' &&
        productPresta.associations.associationsProductBundle != null &&
        productPresta.associations.associationsProductBundle!.isNotEmpty) {
      final List<ProductIdWithQuantity> listOfProductIdWithQuantity = [];
      final List<Product> listOfSetPartProducts = [];
      for (final partProductPrestaId in productPresta.associations.associationsProductBundle!) {
        final optionalProductPresta = await api.getProduct(int.parse(partProductPrestaId.id), marketplace);
        if (optionalProductPresta.isNotPresent) {
          logger.e('Artikel aus Bestellung konnte beim Bestellimport nicht aus Marktplatz geladen werden');
          return left(GeneralFailure(customMessage: 'Artikel aus Bestellung konnte beim Bestellimport nicht aus Marktplatz geladen werden'));
        }
        final loadedProductPresta = optionalProductPresta.value;
        final fosLoadedOrCreatedProduct = await getOrCreateProductFromPrestaOnImportAppointment(
          OrderProductPresta.fromProductPresta(loadedProductPresta),
          partProductPrestaId.quantity.toMyInt(),
          marketplace,
          mainSettings,
          productRepository,
          api,
          null,
        );
        fosLoadedOrCreatedProduct.fold(
          (failure) => left(failure),
          (locProduct) {
            listOfSetPartProducts.add(locProduct);
            listOfProductIdWithQuantity.add(ProductIdWithQuantity(productId: locProduct.id, quantity: partProductPrestaId.quantity.toMyInt()));
          },
        );
      }
      final fosAppointmentProduct = await getOrCreateProductFromPrestaOnImportAppointment(
        orderProductPresta,
        quantity,
        marketplace,
        mainSettings,
        productRepository,
        api,
        listOfProductIdWithQuantity,
      );
      fosAppointmentProduct.fold(
        (failure) => left(failure),
        (appProduct) => appointmentProduct = appProduct,
      );

      await addSetProductIdToPartProducts(
        db: db,
        currentUserUid: currentUserUid,
        transaction: null,
        setProduct: appointmentProduct!,
        listOfSetPartProducts: listOfSetPartProducts,
      );
    } else {
      final fosAppointmentProduct = await getOrCreateProductFromPrestaOnImportAppointment(
        orderProductPresta,
        quantity,
        marketplace,
        mainSettings,
        productRepository,
        api,
        null,
      );
      fosAppointmentProduct.fold(
        (failure) => left(failure),
        (appProduct) => appointmentProduct = appProduct,
      );
    }

    final receiptProduct = generateReceiptProductFromPresta(
      product: appointmentProduct!,
      orderProductPresta: orderProductPresta,
      mainSettings: mainSettings,
      quantity: quantity,
      tax: tax,
    );
    listOfReceiptproduct.add(receiptProduct);
  }
  return Right(listOfReceiptproduct);
}

ReceiptProduct generateReceiptProductFromPresta({
  required Product product,
  required OrderProductPresta orderProductPresta,
  required MainSettings mainSettings,
  required int quantity,
  required int tax,
}) {
  return ReceiptProduct(
    productId: product.id,
    productAttributeId: int.parse(orderProductPresta.productAttributeId),
    quantity: quantity,
    shippedQuantity: 0,
    name: orderProductPresta.productName,
    articleNumber: orderProductPresta.productReference,
    ean: orderProductPresta.productEan13,
    price: (orderProductPresta.productPrice).toMyDouble(),
    unitPriceGross: (orderProductPresta.unitPriceTaxIncl).toMyDouble(),
    unitPriceNet: (orderProductPresta.unitPriceTaxExcl).toMyDouble(),
    customization: int.parse(orderProductPresta.idCustomization),
    tax: mainSettings.taxes.where((e) => e.taxRate == tax).firstOrNull ?? mainSettings.taxes.where((e) => e.isDefault).first,
    wholesalePrice: product.wholesalePrice,
    discountGrossUnit: 0, //product.grossPrice - (orderProductPresta.unitPriceTaxIncl).toMyDouble(),
    discountNetUnit: 0, //product.netPrice - (orderProductPresta.unitPriceTaxExcl).toMyDouble(),
    discountGross: 0, //product.grossPrice - (orderProductPresta.unitPriceTaxIncl).toMyDouble() * quantity,
    discountNet: 0, //product.netPrice - ((orderProductPresta.unitPriceTaxExcl).toMyDouble()) * quantity,
    discountPercent: 0, //calcPercentageOfTwoDoubles(product.netPrice, (orderProductPresta.unitPriceTaxExcl).toMyDouble()),
    discountPercentAmountGrossUnit: 0,
    discountPercentAmountNetUnit: 0,
    profitUnit: (orderProductPresta.unitPriceTaxExcl).toMyDouble() - (product.wholesalePrice),
    profit: ((orderProductPresta.unitPriceTaxExcl).toMyDouble() - product.wholesalePrice) * quantity,
    weight: product.weight,
    isFromDatabase: true,
  );
}
