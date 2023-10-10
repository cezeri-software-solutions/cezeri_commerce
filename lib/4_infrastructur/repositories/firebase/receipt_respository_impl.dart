import 'package:cezeri_commerce/1_presentation/core/extensions/to_my_currency.dart';
import 'package:cezeri_commerce/3_domain/entities/receipt/receipt.dart';
import 'package:cezeri_commerce/3_domain/entities/receipt/receipt_product.dart';
import 'package:cezeri_commerce/3_domain/repositories/firebase/receipt_respository.dart';
import 'package:cezeri_commerce/core/firebase_failures.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';

import '../../../1_presentation/core/functions/check_internet_connection.dart';
import '../../../1_presentation/core/functions/mixed_functions.dart';
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

  const ReceiptRespositoryImpl({
    required this.db,
    required this.firebaseAuth,
    required this.productRepository,
    required this.productImportRepository,
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
  Future<Either<FirebaseFailure, Unit>> updateAppointment(Receipt appointment) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection(currentUserUid).doc(currentUserUid).collection('Appointments').doc(appointment.receiptId);

    try {
      await docRef.update(appointment.toJson());
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
  Future<Either<FirebaseFailure, Unit>> deleteListOfAppointments(List<String> listOfIds) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;

    try {
      for (final id in listOfIds) {
        final docRef = db.collection(currentUserUid).doc(currentUserUid).collection('Appointments').doc(id);
        await docRef.delete();
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
