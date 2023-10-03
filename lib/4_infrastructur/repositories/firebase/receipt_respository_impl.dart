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
  Future<Either<FirebaseFailure, List<Receipt>>> loadNewAppointments() async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());
    var logger = Logger();

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
          final productListFirestore =
              await docRefReceipt.get().then((value) => value.docs.map((querySnapshot) => Receipt.fromJson(querySnapshot.data())).toList());
          if (productListFirestore.isNotEmpty) continue;

          await db.runTransaction((transaction) async {
            final dsMainSettings = await transaction.get(docRefMainSettings);
            final mainSettings = MainSettings.fromJson(dsMainSettings.data()!);

            List<ReceiptProduct> listOfReceiptproduct = [];

            for (final orderProductPresta in orderPresta.associations!.orderRows) {
              final fosProduct = await productRepository.getProductByArticleNumber(orderProductPresta.productReference);
              fosProduct.fold(
                (failure) async {
                  logger.i('Artikel ${orderProductPresta.productName} nicht in der Firestore Datenbank');
                  if (failure.runtimeType == EmptyFailure) {
                    // TODO: get full productPresta from PrestashopApi
                    // TODO: make these steps with new PrestashopApi
                    //productRepository.createProduct(Product.fromProductPresta(productPresta: productPresta, marketplace: marketplace))
                    final fosProductPresta =
                        await productImportRepository.getProductByIdFromPrestashop(int.parse(orderProductPresta.productId), marketplace);
                    fosProductPresta.fold(
                      (prestaFailure) {
                        logger.e('${orderProductPresta.productName} konnte nicht von Prestashop geladen werden');
                      },
                      (productPresta) async {
                        logger.i('${orderProductPresta.productName} wurde erfolgreich von Prestashp geladen');
                        final fosProduct = await productRepository.createProduct(Product.fromProductPresta(
                          productPresta: productPresta,
                          marketplace: marketplace,
                          mainSettings: mainSettings,
                        ));

                        fosProduct.fold(
                          (failure) => logger.e(
                            'Artikel: ${orderProductPresta.productName} konte nicht in der Firestore Datenbank angelegt werden. \n Error: $failure',
                          ),
                          (product) async {
                            final quantity = int.parse(orderProductPresta.productQuantity);
                            final tax =
                                calcTaxPercent(double.parse(orderProductPresta.unitPriceTaxIncl), double.parse(orderProductPresta.unitPriceTaxExcl));

                            final receiptProduct = generateReceiptProduct(
                              product: product,
                              orderProductPresta: orderProductPresta,
                              mainSettings: mainSettings,
                              quantity: quantity,
                              tax: tax,
                            );
                            listOfReceiptproduct.add(receiptProduct);
                            await productRepository.updateWarehouseQuantityOfProductIncremental(product, quantity);
                          },
                        );
                      },
                    );
                  }
                },
                (product) async {
                  final quantity = int.parse(orderProductPresta.productQuantity);
                  final tax = calcTaxPercent(double.parse(orderProductPresta.unitPriceTaxIncl), double.parse(orderProductPresta.unitPriceTaxExcl));
                  final receiptProduct = generateReceiptProduct(
                    product: product,
                    orderProductPresta: orderProductPresta,
                    mainSettings: mainSettings,
                    quantity: quantity,
                    tax: tax,
                  );
                  listOfReceiptproduct.add(receiptProduct);
                  await productRepository.updateAvailableQuantityOfProductInremental(product, quantity * -1);
                },
              );
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
            transaction.set(docRefAppointment, appointment.toJson());
            listOfReceiptToReturn.add(appointment);

            final nextAppointmentNumber = mainSettings.nextAppointmentNumber + 1;
            final updatedMainSettings = mainSettings.copyWith(nextAppointmentNumber: nextAppointmentNumber);
            transaction.set(docRefMainSettings, updatedMainSettings.toJson());
          });
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
  Future<Either<FirebaseFailure, List<Receipt>>> getListOfAppointments() async {
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
    price: double.parse(orderProductPresta.productPrice),
    unitPriceGross: double.parse(orderProductPresta.unitPriceTaxIncl),
    unitPriceNet: double.parse(orderProductPresta.unitPriceTaxExcl),
    customization: int.parse(orderProductPresta.idCustomization),
    tax: mainSettings.taxes.where((e) => e.taxRate == tax).firstOrNull ?? mainSettings.taxes.where((e) => e.isDefault).first,
    wholesalePrice: product.wholesalePrice,
    discountGrossUnit: product.grossPrice - double.parse(orderProductPresta.unitPriceTaxIncl),
    discountNetUnit: product.netPrice - double.parse(orderProductPresta.unitPriceTaxExcl),
    discountGross: product.grossPrice - double.parse(orderProductPresta.unitPriceTaxIncl) * quantity,
    discountNet: product.netPrice - (double.parse(orderProductPresta.unitPriceTaxExcl)) * quantity,
    discountPercent: calcPercentageOfTwoDoubles(product.netPrice, double.parse(orderProductPresta.unitPriceTaxExcl)),
    profitUnit: double.parse(orderProductPresta.unitPriceTaxExcl) - (product.wholesalePrice),
    profit: (double.parse(orderProductPresta.unitPriceTaxExcl) - product.wholesalePrice) * quantity,
  );
}
