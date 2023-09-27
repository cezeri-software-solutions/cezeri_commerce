import 'package:cezeri_commerce/3_domain/entities/receipt/receipt.dart';
import 'package:cezeri_commerce/3_domain/entities/receipt/receipt_product.dart';
import 'package:cezeri_commerce/3_domain/repositories/firebase/receipt_respository.dart';
import 'package:cezeri_commerce/core/firebase_failures.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';

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

        final orderIdsPresta = await api.orderIds();
        final allOrderIds = orderIdsPresta.map((e) => e.id).toList();
        allOrderIds.sort((a, b) => a.compareTo(b));

        listOfOrderPresta = await api.ordersFilterIdInterval(marketplace.marketplaceSettings.nextIdToImport, allOrderIds.last);
        for (final orderPresta in listOfOrderPresta) {
          await db.runTransaction((transaction) async {
            final dsMainSettings = await transaction.get(docRefMainSettings);
            final mainSettings = MainSettings.fromJson(dsMainSettings.data()!);

            List<ReceiptProduct> listOfReceiptproduct = [];

            for (final orderProductPresta in orderPresta.associations!.orderRows) {
              final fosProduct = await productRepository.getProductByArticleNumber(orderProductPresta.productReference);
              final ssssssssssssssss = orderPresta;
              final oooooooooooooooo = orderProductPresta; // TODO: delete
              fosProduct.fold(
                (failure) async {
                  logger.e('Artikel ${orderProductPresta.productName} nicht in der Datenbank');
                  if (failure.runtimeType == EmptyFailure) {
                    Either<FirebaseFailure, Product>? fosProduct;
                    // TODO: get full productPresta from PrestashopApi
                    // TODO: make these steps with new PrestashopApi
                    //productRepository.createProduct(Product.fromProductPresta(productPresta: productPresta, marketplace: marketplace))
                    final fosProductPresta =
                        await productImportRepository.getProductByIdFromPrestashop(int.parse(orderProductPresta.productId), marketplace);
                    fosProductPresta.fold(
                      (prestaFailure) {
                        // TODO: do something if error on loading prdouct
                        logger.i('${orderProductPresta.productName} konnte nicht von Prestashop geladen werden');
                      },
                      (productPresta) async {
                        logger.d('${orderProductPresta.productName} wurde erfolgreich von Prestashp geladen');
                        fosProduct =
                            await productRepository.createProduct(Product.fromProductPresta(productPresta: productPresta, marketplace: marketplace));
                      },
                    );
                    fosProduct!.fold(
                      (failure) => null, // TODO: do something if failure
                      (product) => null, // TODO: set availableStock direkt to the correct one
                    );
                  }
                },
                (product) {
                  // TODO: set availableStock of loaded product from firebase direkt to the correct one
                  final quantity = int.parse(orderProductPresta.productQuantity);
                  final tax = calcTaxPercent(double.parse(orderProductPresta.unitPriceTaxIncl), double.parse(orderProductPresta.unitPriceTaxExcl));
                  final receiptProduct = ReceiptProduct(
                    productId: product.id,
                    productAttributeId: int.parse(orderProductPresta.productAttributeId),
                    quantity: quantity,
                    name: orderProductPresta.productName,
                    articleNumber: orderProductPresta.productReference,
                    ean: orderProductPresta.productEan13,
                    price: double.parse(orderProductPresta.productPrice),
                    unitPriceGross: double.parse(orderProductPresta.unitPriceTaxIncl),
                    unitPriceNet: double.parse(orderProductPresta.unitPriceTaxExcl),
                    customization: int.parse(orderProductPresta.idCustomization),
                    tax: tax,
                    wholesalePrice: product.wholesalePrice,
                    discountGrossUnit: product.grossPrice - double.parse(orderProductPresta.unitPriceTaxIncl),
                    discountNetUnit: product.netPrice - double.parse(orderProductPresta.unitPriceTaxExcl),
                    discountGross: product.grossPrice - double.parse(orderProductPresta.unitPriceTaxIncl) * quantity,
                    discountNet: product.netPrice - (double.parse(orderProductPresta.unitPriceTaxExcl)) * quantity,
                    discountPercent: calcPercentageOfTwoDoubles(product.netPrice, double.parse(orderProductPresta.unitPriceTaxExcl)),
                    profitUnit: double.parse(orderProductPresta.unitPriceTaxExcl) - (product.wholesalePrice),
                    profit: (double.parse(orderProductPresta.unitPriceTaxExcl) - product.wholesalePrice) * quantity,
                  );
                  listOfReceiptproduct.add(receiptProduct);
                },
              );
            }

            final optionalCurrency = await api.currency(int.parse(orderPresta.idCurrency));
            final currency = optionalCurrency.value;
            final optionalCustomer = await api.customer(int.parse(orderPresta.idCustomer));
            final customer = optionalCustomer.value;
            final optionalAddressInvoice = await api.address(int.parse(orderPresta.idAddressInvoice));
            final addressInvoice = optionalAddressInvoice.value;
            final optionalAddressDelivery = await api.address(int.parse(orderPresta.idAddressDelivery));
            final addressDelivery = optionalAddressDelivery.value;
            final optionalCountryInvoice = await api.country(int.parse(addressInvoice.idCountry));
            final countryInvoice = optionalCountryInvoice.value;
            final optionalCountryDelivery = await api.country(int.parse(addressDelivery.idCountry));
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

            // TODO: set nextIdToImort in marketplaceSettings to last id of imported orders from Prestashop
          });
        }
      }

      logger.i(listOfReceiptToReturn);
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
}
