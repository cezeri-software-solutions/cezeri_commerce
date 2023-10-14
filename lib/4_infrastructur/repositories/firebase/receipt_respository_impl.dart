import 'package:cezeri_commerce/1_presentation/core/extensions/to_my_currency.dart';
import 'package:cezeri_commerce/3_domain/entities/receipt/receipt.dart';
import 'package:cezeri_commerce/3_domain/entities/receipt/receipt_product.dart';
import 'package:cezeri_commerce/3_domain/repositories/firebase/customer_repository.dart';
import 'package:cezeri_commerce/3_domain/repositories/firebase/receipt_respository.dart';
import 'package:cezeri_commerce/core/firebase_failures.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';

import '../../../1_presentation/core/functions/check_internet_connection.dart';
import '../../../1_presentation/core/functions/mixed_functions.dart';
import '../../../3_domain/entities/address.dart';
import '../../../3_domain/entities/customer/customer.dart';
import '../../../3_domain/entities/marketplace/marketplace.dart';
import '../../../3_domain/entities/product/product.dart';
import '../../../3_domain/entities/settings/main_settings.dart';
import '../../../3_domain/entities_presta/order_presta.dart';
import '../../../3_domain/entities_presta/product_presta.dart';
import '../../../3_domain/repositories/firebase/product_repository.dart';
import '../../../3_domain/repositories/prestashop/product/product_import_repository.dart';
import '../prestashop_api/prestashop_api.dart';

class ReceiptRespositoryImpl implements ReceiptRepository {
  final FirebaseFirestore db;
  final FirebaseAuth firebaseAuth;
  final ProductRepository productRepository;
  final ProductImportRepository productImportRepository;
  final CustomerRepository customerRepository;

  const ReceiptRespositoryImpl({
    required this.db,
    required this.firebaseAuth,
    required this.productRepository,
    required this.productImportRepository,
    required this.customerRepository,
  });

  @override
  Future<Either<FirebaseFailure, Receipt>> getAppointment(Receipt appointment) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection(currentUserUid).doc(currentUserUid).collection('Appointments').doc(appointment.receiptId);

    try {
      final loadedAppointment = await docRef.get();
      return right(Receipt.fromJson(loadedAppointment.data()!));
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, Unit>> updateAppointment(
    Receipt appointment,
    List<ReceiptProduct> oldListOfReceiptProducts,
    List<ReceiptProduct> newListOfReceiptProducts,
  ) async {
    final logger = Logger();
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection(currentUserUid).doc(currentUserUid).collection('Appointments').doc(appointment.receiptId);

    try {
      await db.runTransaction((transaction) async {
        for (final oldProduct in oldListOfReceiptProducts) {
          if (!oldProduct.isFromMarketplace) continue;
          final newProduct = newListOfReceiptProducts.where((p) => p.productId == oldProduct.productId).firstOrNull;

          if (newProduct == null) {
            // oldProduct wurde entfernt
            // Erhöhen Sie den Bestand von oldProduct in Firestore
            Product? toUpdateProduct = await loadProductToUpdate(oldProduct);
            if (toUpdateProduct == null) return left(GeneralFailure());
            await updateProductAvailableQuantityIncremental(
              transaction: transaction,
              db: db,
              currentUserUid: currentUserUid,
              product: toUpdateProduct,
              newQuantityIncremental: oldProduct.quantity,
            );
          } else {
            // Überprüfen Sie, ob sich die Menge geändert hat
            final quantityDifference = oldProduct.quantity - newProduct.quantity;
            if (quantityDifference != 0) {
              // Anpassen des Bestands in Firestore basierend auf quantityDifference
              Product? toUpdateProduct = await loadProductToUpdate(oldProduct);
              if (toUpdateProduct == null) return left(GeneralFailure());
              await updateProductAvailableQuantityIncremental(
                transaction: transaction,
                db: db,
                currentUserUid: currentUserUid,
                product: toUpdateProduct,
                newQuantityIncremental: quantityDifference,
              );
            }
          }
        }

        for (final newProduct in newListOfReceiptProducts) {
          if (!newProduct.isFromMarketplace) continue;
          if (!oldListOfReceiptProducts.any((p) => p.productId == newProduct.productId)) {
            // newProduct wurde hinzugefügt
            // Verringern Sie den Bestand von newProduct in Firestore
            Product? toUpdateProduct = await loadProductToUpdate(newProduct);
              if (toUpdateProduct == null) return left(GeneralFailure());
              await updateProductAvailableQuantityIncremental(
                transaction: transaction,
                db: db,
                currentUserUid: currentUserUid,
                product: toUpdateProduct,
                newQuantityIncremental: newProduct.quantity * -1,
              );
          }
        }

        transaction.update(docRef, appointment.toJson());
      });
      return right(unit);
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, List<Receipt>>> loadNewAppointments() async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());
    final logger = Logger();

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRefMainSettings = db.collection(currentUserUid).doc(currentUserUid).collection('Settings').doc(currentUserUid);
    final docRefMarketplaces = db.collection(currentUserUid).doc(currentUserUid).collection('Marketetplaces');

    List<OrderPresta>? listOfOrderPresta;
    List<Receipt> listOfReceiptToReturn = [];

    try {
      final listOfActiveMarketplaces = await docRefMarketplaces.get().then(
            (value) => value.docs.map((querySnapshot) => Marketplace.fromJson(querySnapshot.data())).toList(),
          );

      for (final marketplace in listOfActiveMarketplaces) {
        final api = PrestashopApi(Client(), PrestashopApiConfig(apiKey: marketplace.key, webserviceUrl: marketplace.fullUrl));
        if (!marketplace.isActive) continue;

        final orderIdsPresta = await api.getOrderIds();
        final allOrderIds = orderIdsPresta.map((e) => e.id).toList();
        allOrderIds.sort((a, b) => a.compareTo(b));

        listOfOrderPresta = await api.getOrdersFilterIdInterval(marketplace.marketplaceSettings.nextIdToImport, allOrderIds.last);

        for (final orderPresta in listOfOrderPresta) {
          final docRefReceipt = db.collection(currentUserUid).doc(currentUserUid).collection('Appointments').where(
                'receiptMarketplaceId',
                isEqualTo: orderPresta.id,
              );
          final appointmentListFirestore =
              await docRefReceipt.get().then((value) => value.docs.map((querySnapshot) => Receipt.fromJson(querySnapshot.data())).toList());
          if (appointmentListFirestore.isNotEmpty) continue;

          final dsMainSettings = await docRefMainSettings.get();
          final mainSettings = MainSettings.fromJson(dsMainSettings.data()!);

          List<ReceiptProduct> listOfReceiptproduct = [];

          for (final orderProductPresta in orderPresta.associations!.orderRows) {
            Product? appointmentProduct;
            final quantity = int.parse(orderProductPresta.productQuantity);
            final tax = calcTaxPercent((orderProductPresta.unitPriceTaxIncl).toMyDouble(), (orderProductPresta.unitPriceTaxExcl).toMyDouble());

            final productFirestore = await getProductByArticleNumber(orderProductPresta.productReference, marketplace, mainSettings);
            if (productFirestore == null) {
              final productPresta = await getProductByIdFromPrestashop(int.parse(orderProductPresta.productId), marketplace);
              if (productPresta == null) return left(GeneralFailure as FirebaseFailure);

              final createdProductFirestore = await createProductInFirestore(
                Product.fromProductPresta(
                  productPresta: productPresta,
                  marketplace: marketplace,
                  mainSettings: mainSettings,
                ),
                productPresta,
                marketplace,
                mainSettings,
              );
              if (createdProductFirestore == null) return left(GeneralFailure as FirebaseFailure);
              appointmentProduct = createdProductFirestore;
              await productRepository.updateWarehouseQuantityOfProductIncremental(createdProductFirestore, quantity);
            } else {
              appointmentProduct = productFirestore;
              await productRepository.updateAvailableQuantityOfProductInremental(productFirestore, quantity * -1);
            }

            final receiptProduct = generateReceiptProduct(
              product: appointmentProduct,
              orderProductPresta: orderProductPresta,
              mainSettings: mainSettings,
              quantity: quantity,
              tax: tax,
            );
            listOfReceiptproduct.add(receiptProduct);

            // #################################################################
          }

          final optionalCurrency = await api.getCurrency(int.parse(orderPresta.idCurrency));
          final currency = optionalCurrency.value;
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

          final loadedCustomerFromFirestore = await getCustomerByMarketplaceId(marketplace.id, customer.id);
          Customer? customerFirestore;
          if (loadedCustomerFromFirestore == null) {
            final createdCustomerInFirestore = await createCustomerFromMarketplace(
              Customer.fromPresta(customer, marketplace, addressInvoice, addressDelivery, countryInvoice, countryDelivery),
            );
            customerFirestore = createdCustomerInFirestore;
          } else {
            final invoiceAddress = Address.fromPresta(addressInvoice, countryInvoice, AddressType.invoice);
            final deliveryAddress = Address.fromPresta(addressDelivery, countryDelivery, AddressType.delivery);
            final checkedCustomer = await checkCustomerAddressIsUpToDateOrUpdateThem(loadedCustomerFromFirestore, invoiceAddress, deliveryAddress);
            customerFirestore = checkedCustomer;
          }
          //* Wenn der Kunde nicht geladen werden kann und auch nicht erstellt werden kann, soll diese Bestellung übersprungen werden.
          if (customerFirestore == null) continue; // TODO: implemnt log error to firestore

          final phAppointment = Receipt.fromOrderPresta(
            marketplace: marketplace,
            mainSettings: mainSettings,
            listOfReceiptproduct: listOfReceiptproduct,
            orderPresta: orderPresta,
            currencyPresta: currency,
            customerPresta: customer,
            addressInvoicePresta: addressInvoice,
            addressDeliveryPresta: addressDelivery,
            countryInvoicePresta: countryInvoice,
            countryDeliveryPresta: countryDelivery,
            customer: customerFirestore,
          );

          final docRefAppointment = db.collection(currentUserUid).doc(currentUserUid).collection('Appointments').doc();
          final appointment = phAppointment.copyWith(receiptId: docRefAppointment.id);
          docRefAppointment.set(appointment.toJson());
          listOfReceiptToReturn.add(appointment);

          final nextAppointmentNumber = mainSettings.nextAppointmentNumber + 1;
          final updatedMainSettings = mainSettings.copyWith(nextAppointmentNumber: nextAppointmentNumber);
          docRefMainSettings.set(updatedMainSettings.toJson());
        }
        final updatedMarketplace = marketplace.copyWith(
          marketplaceSettings: marketplace.marketplaceSettings.copyWith(nextIdToImport: allOrderIds.last + 1),
        );
        final docRefMarketplace = db.collection(currentUserUid).doc(currentUserUid).collection('Marketetplaces').doc(updatedMarketplace.id);
        await docRefMarketplace.update(updatedMarketplace.toJson());
      }

      return right(listOfReceiptToReturn);
    } on FirebaseException catch (e) {
      logger.e('code: ${e.code} | message: ${e.message}');
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, List<Receipt>>> getListOfOpenAppointments() async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef =
        db.collection(currentUserUid).doc(currentUserUid).collection('Appointments').where('receiptStatus', isEqualTo: ReceiptStatus.open.name);

    try {
      final listOfAppointments = await docRef.get().then(
            (value) => value.docs.map((querySnapshot) => Receipt.fromJson(querySnapshot.data())).toList(),
          );

      //* Zum hinzufügen von neuen Attributen.
      // for (final marketplace in listOfAppointments) {
      //   final docRefMp = db.collection(currentUserUid).doc(currentUserUid).collection('Marketetplaces').doc(marketplace.id);
      //   final updatedMp = marketplace.copyWith(marketplaceSettings: AppointmentSettings.empty());
      //   await docRefMp.update(updatedMp.toJson());
      // }

      if (listOfAppointments.isEmpty) return left(EmptyFailure());
      return right(listOfAppointments);
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, List<Receipt>>> getListOfAllAppointments() async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection(currentUserUid).doc(currentUserUid).collection('Appointments');

    try {
      final listOfAppointments = await docRef.get().then(
            (value) => value.docs.map((querySnapshot) => Receipt.fromJson(querySnapshot.data())).toList(),
          );

      //* Zum hinzufügen von neuen Attributen.
      // for (final marketplace in listOfAppointments) {
      //   final docRefMp = db.collection(currentUserUid).doc(currentUserUid).collection('Marketetplaces').doc(marketplace.id);
      //   final updatedMp = marketplace.copyWith(marketplaceSettings: AppointmentSettings.empty());
      //   await docRefMp.update(updatedMp.toJson());
      // }

      // List<Receipt> phAppointments = [];
      // for (final app in listOfAppointments) {
      //   const ccfId = '9dP9VFfOmw0b3tSdmw71';
      //   const cccId = 'kTKz7pH6HvcyTolKTQbm';
      //   if (app.receiptMarketplaceReference.startsWith('CCF_')) {
      //     final docRefNew = db.collection(currentUserUid).doc(currentUserUid).collection('Appointments').doc(app.receiptId);
      //     final phApp = app.copyWith(marketplaceId: ccfId);
      //     await docRefNew.update(phApp.toJson());
      //   } else {
      //     final docRefNew = db.collection(currentUserUid).doc(currentUserUid).collection('Appointments').doc(app.receiptId);
      //     final phApp = app.copyWith(marketplaceId: cccId);
      //     await docRefNew.update(phApp.toJson());
      //   }
      // }

      if (listOfAppointments.isEmpty) return left(EmptyFailure());
      return right(listOfAppointments);
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, Unit>> deleteAppointment(String id) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;

    try {
      final docRef = db.collection(currentUserUid).doc(currentUserUid).collection('Appointments').doc(id);

      await docRef.delete();

      return right(unit);
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, Unit>> deleteListOfAppointments(List<Receipt> listOfReceipts) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;

    try {
      for (final receipt in listOfReceipts) {
        final listOfProducts = await getListOfProducts(db: db, receipt: receipt, currentUserUid: currentUserUid);
        if (listOfProducts == null) continue;

        await db.runTransaction((transaction) async {
          for (final product in listOfProducts) {
            await updateProductAvailableQuantityIncremental(
              transaction: transaction,
              db: db,
              currentUserUid: currentUserUid,
              product: product,
              newQuantityIncremental: receipt.listOfReceiptProduct.where((e) => e.productId == product.id).first.quantity,
            );
          }
          // TODO: update quantity in marketplaces triggern
          final docRef = db.collection(currentUserUid).doc(currentUserUid).collection('Appointments').doc(receipt.receiptId);
          transaction.delete(docRef);
        });
      }

      return right(unit);
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  Future<Product?> getProductByArticleNumber(String articleNumber, Marketplace marketplace, MainSettings mainSettings) async {
    final logger = Logger();
    Product? product;
    final fosProduct = await productRepository.getProductByArticleNumber(articleNumber);
    fosProduct.fold(
      (failure) => logger.i('Artikel $articleNumber nicht in der Firestore Datenbank'),
      (productFirestore) => product = productFirestore,
    );

    return product;
  }

  Future<ProductPresta?> getProductByIdFromPrestashop(int id, Marketplace marketplace) async {
    final logger = Logger();
    ProductPresta? productPresta;
    final fosProductPresta = await productImportRepository.getProductByIdFromPrestashop(id, marketplace);
    fosProductPresta.fold(
      (failure) {
        logger.e('$id konnte nicht von Prestashop geladen werden');
      },
      (product) => productPresta = product,
    );

    return productPresta;
  }

  Future<Product?> createProductInFirestore(Product product, ProductPresta? productPresta, Marketplace marketplace, MainSettings mainSettings) async {
    final logger = Logger();
    Product? createdProduct;
    final fosProduct = await productRepository.createProduct(
      Product.fromProductPresta(
        productPresta: productPresta!,
        marketplace: marketplace,
        mainSettings: mainSettings,
      ),
      productPresta,
    );
    fosProduct.fold(
      (failure) => logger.e('Artikel: ${product.name} konte nicht in der Firestore Datenbank angelegt werden. \n Error: $failure'),
      (productFirestore) => createdProduct = productFirestore,
    );

    return createdProduct;
  }

  Future<Customer?> getCustomerByMarketplaceId(String marketplaceId, int customerIdMarketplace) async {
    final logger = Logger();
    Customer? loadedCustomer;
    final fosCustomer = await customerRepository.getCustomerByCustomerIdInMarketplace(marketplaceId, customerIdMarketplace);
    fosCustomer.fold(
      (failure) =>
          logger.e('Kunde mit der Marktplatz ID: $customerIdMarketplace konte nicht in der Firestore Datenbank gefunden werden. \n Error: $failure'),
      (customer) => loadedCustomer = customer,
    );

    return loadedCustomer;
  }

  Future<Customer?> createCustomerFromMarketplace(Customer customer) async {
    final logger = Logger();
    Customer? createdCustomer;
    final fosCustomer = await customerRepository.createCustomer(customer);
    fosCustomer.fold(
      (failure) => logger.e('Kunde: ${customer.name} konte nicht in der Firestore Datenbank angelegt werden. \n Error: $failure'),
      (customer) => createdCustomer = customer,
    );

    return createdCustomer;
  }

  Future<Customer?> checkCustomerAddressIsUpToDateOrUpdateThem(Customer customer, Address addressInvoice, Address addressDelivery) async {
    final logger = Logger();

    final indexOfStoredInvoiceAddress = customer.listOfAddress.indexWhere((e) => e == addressInvoice);
    final indexOfStoredDeliveryAddress = customer.listOfAddress.indexWhere((e) => e == addressDelivery);

    bool updateRequired = false;

    // Wenn die Rechnungsadresse vorhanden ist, aber isDefault false ist
    if (indexOfStoredInvoiceAddress != -1 && !customer.listOfAddress[indexOfStoredInvoiceAddress].isDefault) {
      customer.listOfAddress[indexOfStoredInvoiceAddress] = customer.listOfAddress[indexOfStoredInvoiceAddress].copyWith(isDefault: true);
      updateRequired = true;
    }

    // Wenn die Lieferadresse vorhanden ist, aber isDefault false ist
    if (indexOfStoredDeliveryAddress != -1 && !customer.listOfAddress[indexOfStoredDeliveryAddress].isDefault) {
      customer.listOfAddress[indexOfStoredDeliveryAddress] = customer.listOfAddress[indexOfStoredDeliveryAddress].copyWith(isDefault: true);
      updateRequired = true;
    }

    // Wenn die Rechnungsadresse nicht vorhanden ist
    if (indexOfStoredInvoiceAddress == -1) {
      customer.listOfAddress.add(addressInvoice.copyWith(isDefault: true));
      updateRequired = true;
    }

    // Wenn die Lieferadresse nicht vorhanden ist
    if (indexOfStoredDeliveryAddress == -1) {
      customer.listOfAddress.add(addressDelivery.copyWith(isDefault: true));
      updateRequired = true;
    }

    // Setzen Sie isDefault für alle anderen Adressen auf false
    for (int i = 0; i < customer.listOfAddress.length; i++) {
      if (i != indexOfStoredInvoiceAddress && i != indexOfStoredDeliveryAddress) {
        customer.listOfAddress[i] = customer.listOfAddress[i].copyWith(isDefault: false);
      }
    }

    Customer? updatedCustomer;

    if (updateRequired) {
      final fosCustomer = await customerRepository.updateCustomer(customer);
      fosCustomer.fold(
        (failure) =>
            logger.e('Adressen des Kunden: ${customer.name} konte nicht in der Firestore Datenbank aktualisiert werden werden. \n Error: $failure'),
        (customer) => updatedCustomer = customer,
      );
    } else {
      updatedCustomer = customer;
    }

    updatedCustomer ??= customer;

    return updatedCustomer;
  }

  Future<Product?> loadProductToUpdate(ReceiptProduct receiptProduct) async {
    final logger = Logger();
    Product? toUpdateProduct;
    final fosToUpdateProduct = await productRepository.getProduct(receiptProduct.productId);
    fosToUpdateProduct.fold(
      (failure) {
        logger.e('Artikel ${receiptProduct.name} zum updaten des Bestandes konnte nicht aus Firestore geladen werden');
        return left(GeneralFailure());
      },
      (loadedProduct) => toUpdateProduct = loadedProduct,
    );

    return toUpdateProduct;
  }
}

ReceiptProduct generateReceiptProduct({
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
    profitUnit: (orderProductPresta.unitPriceTaxExcl).toMyDouble() - (product.wholesalePrice),
    profit: ((orderProductPresta.unitPriceTaxExcl).toMyDouble() - product.wholesalePrice) * quantity,
    isFromMarketplace: true,
  );
}

Future<List<Product>?> getListOfProducts({
  required FirebaseFirestore db,
  required Receipt receipt,
  required String currentUserUid,
}) async {
  final logger = Logger();
  try {
    final listOfProductsInDatabase = receipt.listOfReceiptProduct.where((e) => e.isFromMarketplace).toList();
    logger.i(listOfProductsInDatabase.map((e) => e.productId));
    final docRefProducts = db
        .collection(currentUserUid)
        .doc(currentUserUid)
        .collection('Products')
        .where('id', whereIn: listOfProductsInDatabase.map((e) => e.productId).toList());
    final listOfProducts = await docRefProducts
        .get()
        .then((value) => value.docs.map((queryDocuemntSnapshot) => Product.fromJson(queryDocuemntSnapshot.data())).toList());
    return listOfProducts;
  } catch (error) {
    logger.e("Error fetching list of products: $error");
    return null;
  }
}

Future<void> updateProductAvailableQuantityIncremental({
  required Transaction transaction,
  required FirebaseFirestore db,
  required String currentUserUid,
  required Product product,
  required int newQuantityIncremental,
}) async {
  final logger = Logger();
  final docRefProduct = db.collection(currentUserUid).doc(currentUserUid).collection('Products').doc(product.id);

  try {
    final updatedProduct = product.copyWith(availableStock: product.availableStock + newQuantityIncremental);
    transaction.update(docRefProduct, updatedProduct.toJson());
  } catch (error) {
    logger.e('Error on updating product quantity in firebase: $error');
  }
}
