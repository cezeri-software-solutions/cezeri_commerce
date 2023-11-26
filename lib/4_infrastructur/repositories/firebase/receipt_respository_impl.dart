import 'dart:convert';

import 'package:cezeri_commerce/1_presentation/core/extensions/to_my_currency.dart';
import 'package:cezeri_commerce/3_domain/entities/receipt/load_appointments_helper/to_load_appointments_from_marketplace.dart';
import 'package:cezeri_commerce/3_domain/entities/receipt/receipt.dart';
import 'package:cezeri_commerce/3_domain/entities/receipt/receipt_product.dart';
import 'package:cezeri_commerce/3_domain/repositories/firebase/customer_repository.dart';
import 'package:cezeri_commerce/3_domain/repositories/firebase/receipt_respository.dart';
import 'package:cezeri_commerce/core/abstract_failure.dart';
import 'package:cezeri_commerce/core/firebase_failures.dart';
import 'package:cezeri_commerce/core/presta_failure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';

import '../../../1_presentation/core/functions/check_internet_connection.dart';
import '../../../1_presentation/core/functions/mixed_functions.dart';
import '../../../3_domain/entities/address.dart';
import '../../../3_domain/entities/carrier/parcel_tracking.dart';
import '../../../3_domain/entities/customer/customer.dart';
import '../../../3_domain/entities/e_mail_automation.dart';
import '../../../3_domain/entities/marketplace/marketplace.dart';
import '../../../3_domain/entities/product/product.dart';
import '../../../3_domain/entities/settings/main_settings.dart';
import '../../../3_domain/entities_presta/order_presta.dart';
import '../../../3_domain/entities_presta/product_presta.dart';
import '../../../3_domain/enums/enums.dart';
import '../../../3_domain/pdf/pdf_receipt_generator.dart';
import '../../../3_domain/repositories/firebase/main_settings_respository.dart';
import '../../../3_domain/repositories/firebase/product_repository.dart';
import '../../../3_domain/repositories/prestashop/product/product_import_repository.dart';
import '../prestashop_api/prestashop_api.dart';
import '../shipping_methods/austrian_post/austrian_post_api.dart';
import 'receipt_respository_helper.dart';
import 'repository_impl_helper.dart';

class ReceiptRespositoryImpl implements ReceiptRepository {
  final FirebaseFirestore db;
  final FirebaseAuth firebaseAuth;
  final ProductRepository productRepository;
  final ProductImportRepository productImportRepository;
  final CustomerRepository customerRepository;
  final MainSettingsRepository mainSettingsRepository;

  const ReceiptRespositoryImpl({
    required this.db,
    required this.firebaseAuth,
    required this.productRepository,
    required this.productImportRepository,
    required this.customerRepository,
    required this.mainSettingsRepository,
  });

  @override
  Future<Either<FirebaseFailure, Receipt>> getAppointment(Receipt receipt) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = getColRef(currentUserUid, receipt.receiptTyp).doc(receipt.id);

    try {
      final loadedAppointment = await docRef.get();
      return right(Receipt.fromJson(loadedAppointment.data()!));
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, Unit>> updateReceipt(
    Receipt receipt,
    List<ReceiptProduct> oldListOfReceiptProducts,
    List<ReceiptProduct> newListOfReceiptProducts,
  ) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = getColRef(currentUserUid, receipt.receiptTyp).doc(receipt.id);
    final docRefStatDashboard = db
        .collection(currentUserUid)
        .doc(currentUserUid)
        .collection('StatDashboard')
        .doc('${receipt.creationDateMarektplace.year}${receipt.creationDateMarektplace.month}');

    try {
      await db.runTransaction((transaction) async {
        final dsAppointmentBeforeUpdate = await transaction.get(docRef);
        final appointmentBeforeUpdate = Receipt.fromJson(dsAppointmentBeforeUpdate.data()!);
        final dsStatDashboard = await transaction.get(docRefStatDashboard);

        for (final oldProduct in oldListOfReceiptProducts) {
          if (!oldProduct.isFromDatabase) continue;
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
          if (!newProduct.isFromDatabase) continue;
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

        await incrementStatDashboardOnUpdateReceipt(receipt, appointmentBeforeUpdate, docRefStatDashboard, dsStatDashboard, transaction);
        transaction.update(docRef, receipt.toJson());
      });
      return right(unit);
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, Receipt>> createReceiptManually(Receipt receipt) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());
    final logger = Logger();

    final now = DateTime.now();
    final curYear = now.year;
    final curMonth = now.month;

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRefSettings = db.collection(currentUserUid).doc(currentUserUid).collection('Settings').doc(currentUserUid);
    final docRef = getColRef(currentUserUid, receipt.receiptTyp).doc();
    final docRefStatDashboard = db.collection(currentUserUid).doc(currentUserUid).collection('StatDashboard').doc('$curYear$curMonth');

    try {
      Receipt toCreateReceipt = Receipt.empty();
      await db.runTransaction((transaction) async {
        final dsStatDashboard = await transaction.get(docRefStatDashboard);
        final settingsSnapshot = await transaction.get(docRefSettings);
        final settings = MainSettings.fromJson(settingsSnapshot.data()!);

        toCreateReceipt = switch (receipt.receiptTyp) {
          ReceiptTyp.offer => receipt.copyWith(
              id: docRef.id,
              receiptId: docRef.id,
              offerId: settings.nextOfferNumber,
              offerNumberAsString: settings.offerPraefix + settings.nextOfferNumber.toString(),
            ),
          ReceiptTyp.appointment => receipt.copyWith(
              id: docRef.id,
              receiptId: docRef.id,
              appointmentId: settings.nextAppointmentNumber,
              appointmentNumberAsString: settings.appointmentPraefix + settings.nextAppointmentNumber.toString(),
            ),
          ReceiptTyp.deliveryNote => receipt.copyWith(
              id: docRef.id,
              receiptId: docRef.id,
              deliveryNoteId: settings.nextDeliveryNoteNumber,
              deliveryNoteNumberAsString: settings.deliveryNotePraefix + settings.nextDeliveryNoteNumber.toString(),
            ),
          ReceiptTyp.invoice || ReceiptTyp.credit => receipt.copyWith(
              id: docRef.id,
              receiptId: docRef.id,
              invoiceId: settings.nextInvoiceNumber,
              invoiceNumberAsString: settings.invoicePraefix + settings.nextInvoiceNumber.toString(),
            ),
        };

        final updatedMainSettings = switch (receipt.receiptTyp) {
          ReceiptTyp.offer => settings.copyWith(nextOfferNumber: settings.nextOfferNumber + 1),
          ReceiptTyp.appointment => settings.copyWith(nextAppointmentNumber: settings.nextAppointmentNumber + 1),
          ReceiptTyp.deliveryNote => settings.copyWith(nextDeliveryNoteNumber: settings.nextDeliveryNoteNumber + 1),
          ReceiptTyp.invoice || ReceiptTyp.credit => settings.copyWith(nextInvoiceNumber: settings.nextInvoiceNumber + 1),
        };
        transaction.update(docRefSettings, updatedMainSettings.toJson());

        transaction.set(docRef, toCreateReceipt.toJson());

        await createOrIncrementStatDashboardOnCreateReceipt(toCreateReceipt, docRefStatDashboard, dsStatDashboard, transaction);
      });
      return right(toCreateReceipt);
    } on FirebaseException {
      return left(GeneralFailure());
    } catch (e) {
      logger.e(e);
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, List<Receipt>>> loadNewAppointmentsFromMarketplaces() async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());
    final logger = Logger();

    final now = DateTime.now();
    final curYear = now.year;
    final curMonth = now.month;

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRefMainSettings = db.collection(currentUserUid).doc(currentUserUid).collection('Settings').doc(currentUserUid);
    final docRefMarketplaces = db.collection(currentUserUid).doc(currentUserUid).collection('Marketetplaces');
    final docRefStatDashboard = db.collection(currentUserUid).doc(currentUserUid).collection('StatDashboard').doc('$curYear$curMonth');

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

            final productFirestore = await getProductFromFirestoreIfExists(
              orderProductPresta.productReference,
              orderProductPresta.productEan13,
              orderProductPresta.productName,
              marketplace,
              mainSettings,
              productRepository,
            );
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
                productRepository,
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
          }

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

          final loadedCustomerFromFirestore = await getCustomerByMarketplaceId(marketplace.id, customer.id);
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
            final tax = mainSettings.taxes.where((e) => e.taxRate.round() == calcTaxPercent(getTotalGross(), getTotalNet()).round()).first;
            final createdCustomerInFirestore = await createCustomerFromMarketplace(
              Customer.fromPresta(customer, nextCustomerNumber, marketplace, addressInvoice, addressDelivery, countryInvoice, countryDelivery, tax),
            );
            customerFirestore = createdCustomerInFirestore;
            nextCustomerNumber += 1;
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
            carrierPresta: carrier,
            customer: customerFirestore,
          );

          try {
            await db.runTransaction((transaction) async {
              final dsStatDashboard = await transaction.get(docRefStatDashboard);

              final docRefAppointment = db.collection(currentUserUid).doc(currentUserUid).collection('Appointments').doc();
              final appointment = phAppointment.copyWith(id: docRefAppointment.id, receiptId: docRefAppointment.id);
              transaction.set(docRefAppointment, appointment.toJson());
              listOfReceiptToReturn.add(appointment);

              await createOrIncrementStatDashboardOnCreateReceipt(appointment, docRefStatDashboard, dsStatDashboard, transaction);

              final nextAppointmentNumber = mainSettings.nextAppointmentNumber + 1;
              final updatedMainSettings = mainSettings.copyWith(nextAppointmentNumber: nextAppointmentNumber, nextCustomerNumber: nextCustomerNumber);
              transaction.update(docRefMainSettings, updatedMainSettings.toJson());
            });
          } on FirebaseException {
            return left(GeneralFailure());
          }
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
  Future<Either<FirebaseFailure, List<Receipt>>> getListOfReceipts(int value, ReceiptTyp receiptTyp) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final colRef = value != 0
        ? getColRef(currentUserUid, receiptTyp)
        : switch (receiptTyp) {
            ReceiptTyp.offer => getColRef(currentUserUid, receiptTyp).where('offerStatus', isEqualTo: OfferStatus.open.name),
            ReceiptTyp.appointment => getColRef(currentUserUid, receiptTyp)
                .where('appointmentStatus', whereIn: [AppointmentStatus.open.name, AppointmentStatus.partiallyCompleted.name]),
            ReceiptTyp.deliveryNote =>
              getColRef(currentUserUid, receiptTyp).where('paymentStatus', whereIn: [PaymentStatus.open.name, PaymentStatus.partiallyPaid.name]),
            ReceiptTyp.invoice ||
            ReceiptTyp.credit =>
              getColRef(currentUserUid, receiptTyp).where('paymentStatus', whereIn: [PaymentStatus.open.name, PaymentStatus.partiallyPaid.name]),
          };

    try {
      final listOfAppointments = await colRef.get().then(
            (value) => value.docs.map((querySnapshot) => Receipt.fromJson(querySnapshot.data())).toList(),
          );

      //* Zum hinzufügen von neuen Attributen.
      // for (final receipt in listOfAppointments) {
      //   final docRefReceipt = getColRef(currentUserUid, receiptTyp).doc(receipt.id);
      //   final updatedReceipt = receipt.copyWith(isPicked: false);
      //   await docRefReceipt.update(updatedReceipt.toJson());
      // }
      //* ENDE hinzufügen von neuen Attributen

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
  Future<Either<FirebaseFailure, Unit>> deleteListOfReceipts(List<Receipt> listOfReceipts) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final receiptTyp = listOfReceipts.first.receiptTyp;

    try {
      for (final receipt in listOfReceipts) {
        final listOfProducts = await getListOfProducts(db: db, receipt: receipt, currentUserUid: currentUserUid);
        if (listOfProducts == null) continue;

        final docRefStatDashboard = db
            .collection(currentUserUid)
            .doc(currentUserUid)
            .collection('StatDashboard')
            .doc('${receipt.creationDateMarektplace.year}${receipt.creationDateMarektplace.month}');

        await db.runTransaction((transaction) async {
          final dsStatDashboard = await transaction.get(docRefStatDashboard);

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
          await incrementStatDashboardOnDeleteReceipt(receipt, docRefStatDashboard, dsStatDashboard, transaction);
          final docRef = getColRef(currentUserUid, receiptTyp).doc(receipt.id);
          transaction.delete(docRef);
        });
      }

      return right(unit);
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, List<Receipt>>> generateFromListOfOffersNewAppointments(List<Receipt> listOfOffers) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());
    final logger = Logger();

    final now = DateTime.now();
    final curYear = now.year;
    final curMonth = now.month;

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRefSettings = db.collection(currentUserUid).doc(currentUserUid).collection('Settings').doc(currentUserUid);
    final docRefStatDashboardToCreate = db.collection(currentUserUid).doc(currentUserUid).collection('StatDashboard').doc('$curYear$curMonth');

    List<Receipt> generatedAppointments = [];

    try {
      final settingsSnapshot = await docRefSettings.get();
      final settings = MainSettings.fromJson(settingsSnapshot.data()!);
      int nextAppointmentNumber = settings.nextAppointmentNumber;

      final dsStatDashboardToCreate = await docRefStatDashboardToCreate.get();

      Marketplace? marketplace;

      for (final offer in listOfOffers) {
        final docRefStatDashboardToUpdate = db
            .collection(currentUserUid)
            .doc(currentUserUid)
            .collection('StatDashboard')
            .doc('${offer.creationDate.year}${offer.creationDate.month}');
        await db.runTransaction((transaction) async {
          final docRefMarketplace = db.collection(currentUserUid).doc(currentUserUid).collection('Marketetplaces').doc(offer.marketplaceId);
          if (marketplace == null) {
            final dsMarketplace = await docRefMarketplace.get();
            if (dsMarketplace.exists) marketplace = Marketplace.fromJson(dsMarketplace.data()!);
          } else {
            if (offer.marketplaceId != marketplace!.id) {
              final dsMarketplace = await docRefMarketplace.get();
              if (dsMarketplace.exists) marketplace = Marketplace.fromJson(dsMarketplace.data()!);
            }
          }

          DocumentSnapshot<Map<String, dynamic>>? dsStatDashboardToUpdate;
          if (DateTime(offer.creationDate.year, offer.creationDate.month) != DateTime(now.year, now.month)) {
            dsStatDashboardToUpdate = await transaction.get(docRefStatDashboardToUpdate);
          }

          Receipt? generatedAppointmentFromThisOffer;

          Receipt updatedOffer = offer.copyWith(
            offerStatus: OfferStatus.closed,
            lastEditingDate: DateTime.now(),
          );
          final phAppointment = Receipt.fromOfferGenAppointment(
            offer: updatedOffer,
            settings: settings,
            nextAppointmentNumber: nextAppointmentNumber,
          );
          final docRefApp = getColRef(currentUserUid, phAppointment.receiptTyp).doc();
          final appointment = phAppointment.copyWith(id: docRefApp.id);
          transaction.set(docRefApp, appointment.toJson());
          nextAppointmentNumber += 1;
          generatedAppointments.add(appointment);
          generatedAppointmentFromThisOffer = appointment;
          updatedOffer = updatedOffer.copyWith(
            appointmentId: appointment.appointmentId,
            appointmentNumberAsString: appointment.appointmentNumberAsString,
          );

          generatedAppointmentFromThisOffer = appointment;

          await createOrIncrementStatDashboardOnGenerateFromOfferNewAppointment(
            offer,
            docRefStatDashboardToUpdate,
            docRefStatDashboardToCreate,
            dsStatDashboardToUpdate,
            dsStatDashboardToCreate,
            transaction,
          );

          transaction.update(getColRef(currentUserUid, updatedOffer.receiptTyp).doc(updatedOffer.id), updatedOffer.toJson());

          for (final receiptProduct in offer.listOfReceiptProduct) {
            if (!receiptProduct.isFromDatabase) continue;
            Product? product;
            final fosProduct = await productRepository.getProduct(receiptProduct.productId);
            fosProduct.fold(
              (failure) {
                logger.e('Artikel ${receiptProduct.name} kontte nicht aus Firestore geladen werden: $failure');
                return left(GeneralFailure());
              },
              (productFromFirestore) => product = productFromFirestore,
            );
            await updateProductAvailableQuantityIncremental(
              transaction: transaction,
              db: db,
              currentUserUid: currentUserUid,
              product: product!,
              newQuantityIncremental: receiptProduct.quantity * -1,
            );
          }
          if (marketplace != null) await sendCustomerEmails([generatedAppointmentFromThisOffer], marketplace!);
        });
      }
      final updatedMainSettings = settings.copyWith(nextAppointmentNumber: nextAppointmentNumber);
      await docRefSettings.update(updatedMainSettings.toJson());
      return right(generatedAppointments);
    } on FirebaseException {
      return left(GeneralFailure());
    } catch (e) {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, List<Receipt>>> generateFromListOfAppointments(
    List<Receipt> listOfReceipts,
    bool generateDeliveryNote,
    bool generateInvoice,
  ) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());
    final logger = Logger();

    final now = DateTime.now();
    final curYear = now.year;
    final curMonth = now.month;

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRefSettings = db.collection(currentUserUid).doc(currentUserUid).collection('Settings').doc(currentUserUid);
    final docRefStatDashboard = db.collection(currentUserUid).doc(currentUserUid).collection('StatDashboard').doc('$curYear$curMonth');

    List<Receipt> generatedReceipts = [];

    try {
      final settingsSnapshot = await docRefSettings.get();
      final settings = MainSettings.fromJson(settingsSnapshot.data()!);
      int nextDeliveryNoteNumber = settings.nextDeliveryNoteNumber;
      int nextInvoiceNumber = settings.nextInvoiceNumber;

      final dsStatDashboard = await docRefStatDashboard.get();

      Marketplace? marketplace;

      for (final receipt in listOfReceipts) {
        await db.runTransaction((transaction) async {
          final docRefMarketplace = db.collection(currentUserUid).doc(currentUserUid).collection('Marketetplaces').doc(receipt.marketplaceId);
          if (marketplace == null) {
            final dsMarketplace = await docRefMarketplace.get();
            if (dsMarketplace.exists) marketplace = Marketplace.fromJson(dsMarketplace.data()!);
          } else {
            if (receipt.marketplaceId != marketplace!.id) {
              final dsMarketplace = await docRefMarketplace.get();
              if (dsMarketplace.exists) marketplace = Marketplace.fromJson(dsMarketplace.data()!);
            }
          }
          List<Receipt> generatedReceiptsFromThisReceipt = [];

          List<ReceiptProduct> updatedReceiptProducts = receipt.listOfReceiptProduct.map((e) {
            return e.copyWith(shippedQuantity: e.quantity);
          }).toList();
          Receipt appointment = receipt.copyWith(
            appointmentStatus: AppointmentStatus.completed,
            lastEditingDate: DateTime.now(),
            listOfReceiptProduct: updatedReceiptProducts,
          );
          if (generateDeliveryNote) {
            final phDeliveryNote = Receipt.fromAppointmentGenDeliveryNote(
              appointment: appointment,
              settings: settings,
              nextDeliveryNoteNumber: nextDeliveryNoteNumber,
              nextInvoiceNumber: nextInvoiceNumber,
              generateInvoice: generateInvoice,
            );
            final docRefDn = getColRef(currentUserUid, phDeliveryNote.receiptTyp).doc();
            final deliveryNote = phDeliveryNote.copyWith(id: docRefDn.id);
            transaction.set(docRefDn, deliveryNote.toJson());
            nextDeliveryNoteNumber += 1;
            generatedReceipts.add(deliveryNote);
            generatedReceiptsFromThisReceipt.add(deliveryNote);
            appointment = appointment.copyWith(
              deliveryNoteId: deliveryNote.deliveryNoteId,
              deliveryNoteNumberAsString: deliveryNote.deliveryNoteNumberAsString,
            );
          }

          if (generateInvoice) {
            final phInvoice = Receipt.fromAppointmentGenInvoice(
              appointment: appointment,
              settings: settings,
              nextDeliveryNoteNumber: nextDeliveryNoteNumber,
              nextInvoiceNumber: nextInvoiceNumber,
              generateDeliveryNote: generateDeliveryNote,
            );
            final docRefI = getColRef(currentUserUid, phInvoice.receiptTyp).doc();
            final invoice = phInvoice.copyWith(id: docRefI.id);
            transaction.set(docRefI, invoice.toJson());
            nextInvoiceNumber += 1;
            generatedReceipts.add(invoice);
            generatedReceiptsFromThisReceipt.add(invoice);
            appointment = appointment.copyWith(
              invoiceId: invoice.invoiceId,
              invoiceNumberAsString: invoice.invoiceNumberAsString,
            );

            await createOrIncrementStatDashboardOnCreateReceipt(invoice, docRefStatDashboard, dsStatDashboard, transaction);
          }

          transaction.update(getColRef(currentUserUid, appointment.receiptTyp).doc(appointment.id), appointment.toJson());

          for (final receiptProduct in receipt.listOfReceiptProduct) {
            if (!receiptProduct.isFromDatabase) continue;
            Product? product;
            final fosProduct = await productRepository.getProduct(receiptProduct.productId);
            fosProduct.fold(
              (failure) {
                logger.e('Artikel ${receiptProduct.name} kontte nicht aus Firestore geladen werden: $failure');
                return left(GeneralFailure());
              },
              (productFromFirestore) => product = productFromFirestore,
            );
            await updateProductWarehouseQuantityIncremental(
              transaction: transaction,
              db: db,
              currentUserUid: currentUserUid,
              product: product!,
              newQuantityIncremental: receiptProduct.quantity * -1,
            );
          }
          if (marketplace != null) await sendCustomerEmails(generatedReceiptsFromThisReceipt, marketplace!);
        });
      }
      final updatedMainSettings = settings.copyWith(nextDeliveryNoteNumber: nextDeliveryNoteNumber, nextInvoiceNumber: nextInvoiceNumber);
      await docRefSettings.update(updatedMainSettings.toJson());
      return right(generatedReceipts);
    } on FirebaseException {
      return left(GeneralFailure());
    } catch (e) {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, List<Receipt>>> generateFromAppointment(
    Receipt incomingAppointment,
    Receipt originalAppointment,
    bool generateDeliveryNote,
    bool generateInvoice,
  ) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());
    final logger = Logger();

    final now = DateTime.now();
    final curYear = now.year;
    final curMonth = now.month;

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRefSettings = db.collection(currentUserUid).doc(currentUserUid).collection('Settings').doc(currentUserUid);
    final docRefStatDashboard = db.collection(currentUserUid).doc(currentUserUid).collection('StatDashboard').doc('$curYear$curMonth');
    final docRefMarketplace = db.collection(currentUserUid).doc(currentUserUid).collection('Marketetplaces').doc(originalAppointment.marketplaceId);

    List<Receipt> generatedReceipts = [];

    final isCompletelyPacked = incomingAppointment.listOfReceiptProduct.every((e) => e.shippedQuantity == e.quantity);
    final isCompletelyPackedInOnePart = originalAppointment.appointmentStatus == AppointmentStatus.open && isCompletelyPacked;

    try {
      final settingsSnapshot = await docRefSettings.get();
      final settings = MainSettings.fromJson(settingsSnapshot.data()!);
      int nextDeliveryNoteNumber = settings.nextDeliveryNoteNumber;
      int nextInvoiceNumber = settings.nextInvoiceNumber;

      final dsMarketplace = await docRefMarketplace.get();
      final marketplace = Marketplace.fromJson(dsMarketplace.data()!);

      ParcelTracking? parcelTracking;
      if (generateDeliveryNote) {
        parcelTracking = await getParcelTracking(incomingAppointment, settings, nextDeliveryNoteNumber);
      }
      final isSuccessfulSetParcelTracking =
          parcelTracking != null && parcelTracking.deliveryNoteId != 0 && parcelTracking.trackingNumber != '' && parcelTracking.trackingUrl != '';

      await db.runTransaction((transaction) async {
        final dsStatDashboard = await transaction.get(docRefStatDashboard);

        List<ReceiptProduct> updatedOriginalAppointmentProducts = isCompletelyPacked
            ? originalAppointment.listOfReceiptProduct.map((e) {
                return e.copyWith(shippedQuantity: e.quantity);
              }).toList()
            : originalAppointment.listOfReceiptProduct.map((e) {
                final receiptProduct = incomingAppointment.listOfReceiptProduct
                    .where((element) => element.name == e.name && element.articleNumber == e.articleNumber)
                    .firstOrNull;
                if (receiptProduct == null) {
                  return e;
                } else {
                  return e.copyWith(shippedQuantity: receiptProduct.shippedQuantity);
                }
              }).toList();

        Receipt partialAppointment = Receipt.genPartial(GenType.partialToCreate, incomingAppointment);

        Receipt originalAppointmentToUpdate = isCompletelyPackedInOnePart
            ? incomingAppointment.copyWith(
                appointmentStatus: AppointmentStatus.completed,
                listOfParcelTracking: isSuccessfulSetParcelTracking ? [parcelTracking!] : [],
                lastEditingDate: DateTime.now(),
              )
            : originalAppointment.copyWith(
                appointmentStatus: updatedOriginalAppointmentProducts.every((e) => e.shippedQuantity == e.quantity)
                    ? AppointmentStatus.completed
                    : AppointmentStatus.partiallyCompleted,
                listOfParcelTracking: isSuccessfulSetParcelTracking
                    ? [...originalAppointment.listOfParcelTracking, parcelTracking!]
                    : originalAppointment.listOfParcelTracking,
                lastEditingDate: DateTime.now(),
                listOfReceiptProduct: updatedOriginalAppointmentProducts,
              );

        if (generateDeliveryNote) {
          final phDeliveryNote = Receipt.fromAppointmentGenDeliveryNote(
            appointment: isCompletelyPackedInOnePart ? incomingAppointment : partialAppointment,
            settings: settings,
            nextDeliveryNoteNumber: nextDeliveryNoteNumber,
            nextInvoiceNumber: nextInvoiceNumber,
            generateInvoice: generateInvoice,
          );
          final docRefDn = getColRef(currentUserUid, phDeliveryNote.receiptTyp).doc();
          final deliveryNote = phDeliveryNote.copyWith(
            id: docRefDn.id,
            listOfParcelTracking: isSuccessfulSetParcelTracking ? [parcelTracking!] : [],
            packagingBox: phDeliveryNote.packagingBox != null && phDeliveryNote.packagingBox!.name != ''
                ? phDeliveryNote.packagingBox!.copyWith(deliveryNoteId: nextDeliveryNoteNumber)
                : phDeliveryNote.packagingBox,
          );
          transaction.set(docRefDn, deliveryNote.toJson());
          nextDeliveryNoteNumber += 1;
          generatedReceipts.add(deliveryNote);
          originalAppointmentToUpdate = originalAppointmentToUpdate.copyWith(
            deliveryNoteId: deliveryNote.deliveryNoteId,
            deliveryNoteNumberAsString: deliveryNote.deliveryNoteNumberAsString,
          );
        }

        if (generateInvoice) {
          final phInvoice = Receipt.fromAppointmentGenInvoice(
            appointment: isCompletelyPackedInOnePart ? incomingAppointment : partialAppointment,
            settings: settings,
            nextDeliveryNoteNumber: nextDeliveryNoteNumber,
            nextInvoiceNumber: nextInvoiceNumber,
            generateDeliveryNote: generateDeliveryNote,
          );
          final docRefI = getColRef(currentUserUid, phInvoice.receiptTyp).doc();
          final invoice = phInvoice.copyWith(
            id: docRefI.id,
            listOfParcelTracking: isSuccessfulSetParcelTracking ? [parcelTracking!] : [],
          );
          transaction.set(docRefI, invoice.toJson());
          nextInvoiceNumber += 1;
          generatedReceipts.add(invoice);
          originalAppointmentToUpdate = originalAppointmentToUpdate.copyWith(
            invoiceId: invoice.invoiceId,
            invoiceNumberAsString: invoice.invoiceNumberAsString,
          );

          await createOrIncrementStatDashboardOnCreateReceipt(invoice, docRefStatDashboard, dsStatDashboard, transaction);
        }

        transaction.update(
          getColRef(currentUserUid, originalAppointmentToUpdate.receiptTyp).doc(originalAppointment.id),
          originalAppointmentToUpdate.toJson(),
        );

        for (final receiptProduct
            in isCompletelyPackedInOnePart ? originalAppointment.listOfReceiptProduct : incomingAppointment.listOfReceiptProduct) {
          if (!receiptProduct.isFromDatabase) continue;
          Product? product;
          final fosProduct = await productRepository.getProduct(receiptProduct.productId);
          fosProduct.fold(
            (failure) {
              logger.e('Artikel ${receiptProduct.name} kontte nicht aus Firestore geladen werden: $failure');
              return left(GeneralFailure());
            },
            (productFromFirestore) => product = productFromFirestore,
          );
          await updateProductWarehouseQuantityIncremental(
            transaction: transaction,
            db: db,
            currentUserUid: currentUserUid,
            product: product!,
            newQuantityIncremental: isCompletelyPackedInOnePart ? receiptProduct.quantity * -1 : receiptProduct.shippedQuantity * -1,
          );
        }
      });

      final updatedMainSettings = settings.copyWith(nextDeliveryNoteNumber: nextDeliveryNoteNumber, nextInvoiceNumber: nextInvoiceNumber);
      await docRefSettings.update(updatedMainSettings.toJson());
      final isSuccessfulSent = await sendCustomerEmails(generatedReceipts, marketplace);
      if (isSuccessfulSent) {
        logger.i('Alle E-Mails wurden erfolgreich verschickt.');
      } else {
        logger.e('Eine oder meherer E-Mails konnten nicht verschickt werden!');
      }
      return right(generatedReceipts);
    } on FirebaseException {
      return left(GeneralFailure());
    } catch (e) {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, Receipt>> generateFromInvoiceNewCredit(Receipt invoice) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());
    final logger = Logger();

    final now = DateTime.now();
    final curYear = now.year;
    final curMonth = now.month;

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRefSettings = db.collection(currentUserUid).doc(currentUserUid).collection('Settings').doc(currentUserUid);
    final docRefStatDashboardToCreate = db.collection(currentUserUid).doc(currentUserUid).collection('StatDashboard').doc('$curYear$curMonth');

    Receipt? generatedCredit;

    try {
      final settingsSnapshot = await docRefSettings.get();
      final settings = MainSettings.fromJson(settingsSnapshot.data()!);
      int nextInvoiceNumber = settings.nextInvoiceNumber;

      final dsStatDashboardToCreate = await docRefStatDashboardToCreate.get();

      Marketplace? marketplace;

      final docRefStatDashboardToUpdate = db
          .collection(currentUserUid)
          .doc(currentUserUid)
          .collection('StatDashboard')
          .doc('${invoice.creationDate.year}${invoice.creationDate.month}');
      await db.runTransaction((transaction) async {
        final docRefMarketplace = db.collection(currentUserUid).doc(currentUserUid).collection('Marketetplaces').doc(invoice.marketplaceId);
        if (marketplace == null) {
          final dsMarketplace = await docRefMarketplace.get();
          if (dsMarketplace.exists) marketplace = Marketplace.fromJson(dsMarketplace.data()!);
        } else {
          if (invoice.marketplaceId != marketplace!.id) {
            final dsMarketplace = await docRefMarketplace.get();
            if (dsMarketplace.exists) marketplace = Marketplace.fromJson(dsMarketplace.data()!);
          }
        }

        DocumentSnapshot<Map<String, dynamic>>? dsStatDashboardToUpdate;
        if (DateTime(invoice.creationDate.year, invoice.creationDate.month) != DateTime(now.year, now.month)) {
          dsStatDashboardToUpdate = await transaction.get(docRefStatDashboardToUpdate);
        }

        Receipt? generatedAppointmentFromThisOffer;

        Receipt updatedInvoice = invoice.copyWith(lastEditingDate: DateTime.now());
        final phCredit = Receipt.fromInvoiceGenCredit(
          invoice: updatedInvoice,
          settings: settings,
          nextInvoiceNumber: nextInvoiceNumber,
        );
        final docRefCredit = getColRef(currentUserUid, phCredit.receiptTyp).doc();
        final credit = phCredit.copyWith(id: docRefCredit.id);
        transaction.set(docRefCredit, credit.toJson());
        nextInvoiceNumber += 1;
        generatedCredit = credit;
        generatedAppointmentFromThisOffer = credit;

        await createOrIncrementStatDashboardOnGenerateFromInvoiceNewCredit(
          invoice,
          docRefStatDashboardToUpdate,
          docRefStatDashboardToCreate,
          dsStatDashboardToUpdate,
          dsStatDashboardToCreate,
          transaction,
        );

        transaction.update(getColRef(currentUserUid, updatedInvoice.receiptTyp).doc(updatedInvoice.id), updatedInvoice.toJson());

        for (final receiptProduct in invoice.listOfReceiptProduct) {
          if (!receiptProduct.isFromDatabase) continue;
          Product? product;
          final fosProduct = await productRepository.getProduct(receiptProduct.productId);
          fosProduct.fold(
            (failure) {
              logger.e('Artikel ${receiptProduct.name} kontte nicht aus Firestore geladen werden: $failure');
              return left(GeneralFailure());
            },
            (productFromFirestore) => product = productFromFirestore,
          );
          await updateProductAvailableQuantityIncremental(
            transaction: transaction,
            db: db,
            currentUserUid: currentUserUid,
            product: product!,
            newQuantityIncremental: receiptProduct.quantity * -1,
          );
        }
        if (marketplace != null) await sendCustomerEmails([generatedAppointmentFromThisOffer], marketplace!);
      });

      final updatedMainSettings = settings.copyWith(nextInvoiceNumber: nextInvoiceNumber);
      await docRefSettings.update(updatedMainSettings.toJson());
      return right(generatedCredit!);
    } on FirebaseException {
      return left(GeneralFailure());
    } catch (e) {
      return left(GeneralFailure());
    }
  }

  CollectionReference<Map<String, dynamic>> getColRef(String currentUserUid, ReceiptTyp receiptTyp) {
    return switch (receiptTyp) {
      ReceiptTyp.offer => db.collection(currentUserUid).doc(currentUserUid).collection('Offers'),
      ReceiptTyp.appointment => db.collection(currentUserUid).doc(currentUserUid).collection('Appointments'),
      ReceiptTyp.deliveryNote => db.collection(currentUserUid).doc(currentUserUid).collection('DeliveryNotes'),
      ReceiptTyp.invoice || ReceiptTyp.credit => db.collection(currentUserUid).doc(currentUserUid).collection('Invoices'),
    };
  }

  Future<ProductPresta?> getProductByIdFromPrestashop(int id, Marketplace marketplace) async {
    final logger = Logger();
    ProductPresta? productPresta;
    final fosProductPresta = await productImportRepository.getProductByIdFromPrestashopAsJson(id, marketplace);
    fosProductPresta.fold(
      (failure) {
        logger.e('$id konnte nicht von Prestashop geladen werden');
      },
      (product) => productPresta = product,
    );

    return productPresta;
  }

  Future<Customer?> getCustomerByMarketplaceId(String marketplaceId, int customerIdMarketplace) async {
    final logger = Logger();
    Customer? loadedCustomer;
    final fosCustomer = await customerRepository.getCustomerByCustomerIdInMarketplace(marketplaceId, customerIdMarketplace);
    fosCustomer.fold(
      (failure) =>
          logger.i('Kunde mit der Marktplatz ID: $customerIdMarketplace konte nicht in der Firestore Datenbank gefunden werden. \n Error: $failure'),
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

  @override
  Future<Either<FirebaseFailure, Unit>> sendEmails() async {
    bool isFailure = false;
    //await sendEmail(to: 'info@ccf-autopflege.at', from: 'ince.ali@msn.com', subject: 'Test-Mail', text: 'Hallo das ist eine Test-Mail');
    if (isFailure) return left(GeneralFailure());
    return right(unit);
  }

  @override
  Future<Either<AbstractFailure, List<ToLoadAppointmentsFromMarketplace>>> getToLoadAppointmentsFromMarketplaces() async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());
    final logger = Logger();

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRefMarketplaces = db.collection(currentUserUid).doc(currentUserUid).collection('Marketetplaces').where('isActive', isEqualTo: true);

    try {
      List<ToLoadAppointmentsFromMarketplace> listOfToLoadAppointmentsFromMarketplace = [];
      final listOfActiveMarketplaces = await docRefMarketplaces.get().then(
            (value) => value.docs.map((querySnapshot) => Marketplace.fromJson(querySnapshot.data())).toList(),
          );

      for (final marketplace in listOfActiveMarketplaces) {
        final api = PrestashopApi(Client(), PrestashopApiConfig(apiKey: marketplace.key, webserviceUrl: marketplace.fullUrl));
        if (!marketplace.isActive) continue;

        if (marketplace.marketplaceType == MarketplaceType.prestashop) {
          final orderIdsPresta = await api.getOrderIds();
          final allOrderIds = orderIdsPresta.map((e) => e.id).toList();
          allOrderIds.sort((a, b) => a.compareTo(b));

          final toLoadAppointmentsFromMarketplace = ToLoadAppointmentsFromMarketplace(
            marketplace: marketplace,
            nextIdToImport: marketplace.marketplaceSettings.nextIdToImport,
            lastIdToImport: allOrderIds.last,
          );
          listOfToLoadAppointmentsFromMarketplace.add(toLoadAppointmentsFromMarketplace);
        }
      }
      return right(listOfToLoadAppointmentsFromMarketplace);
    } catch (e) {
      logger.e('Fehler beim laden der zu ladenden Aufträge von Marktplätzen: $e');
      return left(MixedFailure(errorMessage: 'Fehler beim laden der zu ladenden Aufträge von Marktplätzen: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, LoadedOrderFromMarketplace>> loadAppointmentsFromMarketplace(
    ToLoadAppointmentFromMarketplace toLoadAppointment,
  ) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());
    final logger = Logger();

    final marketplace = toLoadAppointment.marketplace;
    final api = PrestashopApi(Client(), PrestashopApiConfig(apiKey: marketplace.key, webserviceUrl: marketplace.fullUrl));

    try {
      final optionalOrderPresta = await api.getOrder(toLoadAppointment.orderId);
      if (optionalOrderPresta.isNotPresent) {
        logger.e('Fehler beim Laden der Bestellung aus Prestashop');
        return left(PrestaGeneralFailure(errorMessage: 'Fehler beim Laden der Bestellung aus Prestashop'));
      }
      final orderPresta = optionalOrderPresta.value;
      final loadedOrderFromMarketplace = LoadedOrderFromMarketplace(
        marketplace: toLoadAppointment.marketplace,
        orderPresta: orderPresta,
        orderMarketplaceId: toLoadAppointment.orderId,
      );

      return right(loadedOrderFromMarketplace);
    } catch (e) {
      logger.e('Fehler beim laden der Aufträge von Marktplätzen: $e');
      return left(PrestaGeneralFailure(errorMessage: 'Fehler beim laden der Aufträge von Marktplätzen: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, Receipt>> uploadLoadedAppointmentToFirestore(LoadedOrderFromMarketplace loadedAppointmentFromMarketplace) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());
    final logger = Logger();

    final now = DateTime.now();
    final curYear = now.year;
    final curMonth = now.month;

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final marketplace = loadedAppointmentFromMarketplace.marketplace;
    final api = PrestashopApi(Client(), PrestashopApiConfig(apiKey: marketplace.key, webserviceUrl: marketplace.fullUrl));
    final docRefMainSettings = db.collection(currentUserUid).doc(currentUserUid).collection('Settings').doc(currentUserUid);
    final docRefStatDashboard = db.collection(currentUserUid).doc(currentUserUid).collection('StatDashboard').doc('$curYear$curMonth');
    final docRefMarketplace = db.collection(currentUserUid).doc(currentUserUid).collection('Marketetplaces').doc(marketplace.id);

    final orderPresta = loadedAppointmentFromMarketplace.orderPresta;

    Receipt? receiptToReturn;
    try {
      //* Überprüft, ob die aus dem Marktplatz geladene Bestellung bereits in Firebase Firestore hinterlegt ist
      final docRefReceipt = db.collection(currentUserUid).doc(currentUserUid).collection('Appointments').where(
            'receiptMarketplaceId',
            isEqualTo: orderPresta.id,
          );
      final appointmentListFirestore =
          await docRefReceipt.get().then((value) => value.docs.map((querySnapshot) => Receipt.fromJson(querySnapshot.data())).toList());
      if (appointmentListFirestore.isNotEmpty) {
        return left(MixedFailure(errorMessage: 'Vom Marktplatz geladene Bestellung ist bereits in Firestore gespeicher'));
      }

      final dsMainSettings = await docRefMainSettings.get();
      if (!dsMainSettings.exists) return left(MixedFailure(errorMessage: 'MainSettings konnte nicht aus Firestore geladen werden'));
      final mainSettings = MainSettings.fromJson(dsMainSettings.data()!);

      List<ReceiptProduct> listOfReceiptproduct = [];
      for (final orderProductPresta in orderPresta.associations!.orderRows) {
        Product? appointmentProduct;
        final quantity = int.parse(orderProductPresta.productQuantity);
        final tax = calcTaxPercent((orderProductPresta.unitPriceTaxIncl).toMyDouble(), (orderProductPresta.unitPriceTaxExcl).toMyDouble());

        final productFirestore = await getProductFromFirestoreIfExists(
          orderProductPresta.productReference,
          orderProductPresta.productEan13,
          orderProductPresta.productName,
          marketplace,
          mainSettings,
          productRepository,
        );
        if (productFirestore == null) {
          final optionalProductPresta = await api.getProduct(int.parse(orderProductPresta.productId), marketplace);
          if (optionalProductPresta.isNotPresent) {
            return left(MixedFailure(errorMessage: 'Artikel aus Bestellung konnte beim Bestellimport nicht aus Marktplatz geladen werden'));
          }
          final productPresta = optionalProductPresta.value;

          final createdProductFirestore = await createProductInFirestore(
            Product.fromProductPresta(
              productPresta: productPresta,
              marketplace: marketplace,
              mainSettings: mainSettings,
            ),
            productPresta,
            marketplace,
            mainSettings,
            productRepository,
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
      }

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

      final loadedCustomerFromFirestore = await getCustomerByMarketplaceId(marketplace.id, customer.id);
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
        final tax = mainSettings.taxes.where((e) => e.taxRate.round() == calcTaxPercent(getTotalGross(), getTotalNet()).round()).first;
        final createdCustomerInFirestore = await createCustomerFromMarketplace(
          Customer.fromPresta(customer, nextCustomerNumber, marketplace, addressInvoice, addressDelivery, countryInvoice, countryDelivery, tax),
        );
        customerFirestore = createdCustomerInFirestore;
        nextCustomerNumber += 1;
      } else {
        final invoiceAddress = Address.fromPresta(addressInvoice, countryInvoice, AddressType.invoice);
        final deliveryAddress = Address.fromPresta(addressDelivery, countryDelivery, AddressType.delivery);
        final checkedCustomer = await checkCustomerAddressIsUpToDateOrUpdateThem(loadedCustomerFromFirestore, invoiceAddress, deliveryAddress);
        customerFirestore = checkedCustomer;
      }
      //* Wenn der Kunde nicht geladen werden kann und auch nicht erstellt werden kann, soll diese Bestellung übersprungen werden.
      if (customerFirestore == null) {
        return left(MixedFailure(
            errorMessage: 'Kunde aus Bestellung von Marktplatz konnte weder in Firestore erstellt werden, noch in Firestore gespeichert werden'));
      }

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
        carrierPresta: carrier,
        customer: customerFirestore,
      );

      try {
        await db.runTransaction((transaction) async {
          final dsStatDashboard = await transaction.get(docRefStatDashboard);

          final docRefAppointment = db.collection(currentUserUid).doc(currentUserUid).collection('Appointments').doc();
          final appointment = phAppointment.copyWith(id: docRefAppointment.id, receiptId: docRefAppointment.id);
          transaction.set(docRefAppointment, appointment.toJson());
          receiptToReturn = appointment;

          await createOrIncrementStatDashboardOnCreateReceipt(appointment, docRefStatDashboard, dsStatDashboard, transaction);

          final nextAppointmentNumber = mainSettings.nextAppointmentNumber + 1;
          final updatedMainSettings = mainSettings.copyWith(nextAppointmentNumber: nextAppointmentNumber, nextCustomerNumber: nextCustomerNumber);
          transaction.update(docRefMainSettings, updatedMainSettings.toJson());

          final updatedMarketplace = marketplace.copyWith(
            marketplaceSettings: marketplace.marketplaceSettings.copyWith(nextIdToImport: loadedAppointmentFromMarketplace.orderMarketplaceId + 1),
          );
          transaction.update(docRefMarketplace, updatedMarketplace.toJson());
        });
      } on FirebaseException catch (e) {
        return left(MixedFailure(errorMessage: e.message));
      }

      if (receiptToReturn == null) {
        return left(MixedFailure(errorMessage: 'Bestellung wurde aus Marktplatz geladen werden, aber nicht in Firestore gespeichert werden'));
      }
      return right(receiptToReturn!);
    } catch (e) {
      logger.e('Fehler beim hochladen der Aufträge zu Firestore: $e');
      return left(PrestaGeneralFailure(errorMessage: 'Fehler beim hochladen der Aufträge zu Firestore: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, Receipt>> loadAppointmentFromMarketplaceAndUploadToFirestore(
    Marketplace marketplace,
    int toLoadOrderId,
  ) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());
    final logger = Logger();

    final now = DateTime.now();
    final curYear = now.year;
    final curMonth = now.month;

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final api = PrestashopApi(Client(), PrestashopApiConfig(apiKey: marketplace.key, webserviceUrl: marketplace.fullUrl));
    final docRefMainSettings = db.collection(currentUserUid).doc(currentUserUid).collection('Settings').doc(currentUserUid);
    final docRefStatDashboard = db.collection(currentUserUid).doc(currentUserUid).collection('StatDashboard').doc('$curYear$curMonth');
    final docRefMarketplace = db.collection(currentUserUid).doc(currentUserUid).collection('Marketetplaces').doc(marketplace.id);

    Receipt? receiptToReturn;
    try {
      final optionalOrderPresta = await api.getOrder(toLoadOrderId);
      if (optionalOrderPresta.isNotPresent) return left(PrestaGeneralFailure(errorMessage: 'Fehler beim Laden der Bestellung aus Prestashop'));
      final orderPresta = optionalOrderPresta.value;

      //* Überprüft, ob die aus dem Marktplatz geladene Bestellung bereits in Firebase Firestore hinterlegt ist
      final docRefReceipt = db.collection(currentUserUid).doc(currentUserUid).collection('Appointments').where(
            'receiptMarketplaceId',
            isEqualTo: orderPresta.id,
          );
      final appointmentListFirestore =
          await docRefReceipt.get().then((value) => value.docs.map((querySnapshot) => Receipt.fromJson(querySnapshot.data())).toList());
      if (appointmentListFirestore.isNotEmpty) {
        return left(MixedFailure(errorMessage: 'Vom Marktplatz geladene Bestellung ist bereits in Firestore gespeicher'));
      }

      final dsMainSettings = await docRefMainSettings.get();
      if (!dsMainSettings.exists) return left(MixedFailure(errorMessage: 'MainSettings konnte nicht aus Firestore geladen werden'));
      final mainSettings = MainSettings.fromJson(dsMainSettings.data()!);

      List<ReceiptProduct> listOfReceiptproduct = [];
      for (final orderProductPresta in orderPresta.associations!.orderRows) {
        Product? appointmentProduct;
        final quantity = int.parse(orderProductPresta.productQuantity);
        final tax = calcTaxPercent((orderProductPresta.unitPriceTaxIncl).toMyDouble(), (orderProductPresta.unitPriceTaxExcl).toMyDouble());

        final productFirestore = await getProductFromFirestoreIfExists(
          orderProductPresta.productReference,
          orderProductPresta.productEan13,
          orderProductPresta.productName,
          marketplace,
          mainSettings,
          productRepository,
        );
        if (productFirestore == null) {
          final optionalProductPresta = await api.getProduct(int.parse(orderProductPresta.productId), marketplace);
          if (optionalProductPresta.isNotPresent) {
            return left(MixedFailure(errorMessage: 'Artikel aus Bestellung konnte beim Bestellimport nicht aus Marktplatz geladen werden'));
          }
          final productPresta = optionalProductPresta.value;

          final createdProductFirestore = await createProductInFirestore(
            Product.fromProductPresta(
              productPresta: productPresta,
              marketplace: marketplace,
              mainSettings: mainSettings,
            ),
            productPresta,
            marketplace,
            mainSettings,
            productRepository,
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
      }

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

      final loadedCustomerFromFirestore = await getCustomerByMarketplaceId(marketplace.id, customer.id);
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
        final tax = mainSettings.taxes.where((e) => e.taxRate.round() == calcTaxPercent(getTotalGross(), getTotalNet()).round()).first;
        final createdCustomerInFirestore = await createCustomerFromMarketplace(
          Customer.fromPresta(customer, nextCustomerNumber, marketplace, addressInvoice, addressDelivery, countryInvoice, countryDelivery, tax),
        );
        customerFirestore = createdCustomerInFirestore;
        nextCustomerNumber += 1;
      } else {
        final invoiceAddress = Address.fromPresta(addressInvoice, countryInvoice, AddressType.invoice);
        final deliveryAddress = Address.fromPresta(addressDelivery, countryDelivery, AddressType.delivery);
        final checkedCustomer = await checkCustomerAddressIsUpToDateOrUpdateThem(loadedCustomerFromFirestore, invoiceAddress, deliveryAddress);
        customerFirestore = checkedCustomer;
      }
      //* Wenn der Kunde nicht geladen werden kann und auch nicht erstellt werden kann, soll diese Bestellung übersprungen werden.
      if (customerFirestore == null) {
        return left(MixedFailure(
            errorMessage: 'Kunde aus Bestellung von Marktplatz konnte weder in Firestore erstellt werden, noch in Firestore gespeichert werden'));
      }

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
        carrierPresta: carrier,
        customer: customerFirestore,
      );

      try {
        await db.runTransaction((transaction) async {
          final dsStatDashboard = await transaction.get(docRefStatDashboard);

          final docRefAppointment = db.collection(currentUserUid).doc(currentUserUid).collection('Appointments').doc();
          final appointment = phAppointment.copyWith(id: docRefAppointment.id, receiptId: docRefAppointment.id);
          transaction.set(docRefAppointment, appointment.toJson());
          receiptToReturn = appointment;

          await createOrIncrementStatDashboardOnCreateReceipt(appointment, docRefStatDashboard, dsStatDashboard, transaction);

          final nextAppointmentNumber = mainSettings.nextAppointmentNumber + 1;
          final updatedMainSettings = mainSettings.copyWith(nextAppointmentNumber: nextAppointmentNumber, nextCustomerNumber: nextCustomerNumber);
          transaction.update(docRefMainSettings, updatedMainSettings.toJson());

          final updatedMarketplace = marketplace.copyWith(
            marketplaceSettings: marketplace.marketplaceSettings.copyWith(nextIdToImport: toLoadOrderId + 1),
          );
          transaction.update(docRefMarketplace, updatedMarketplace.toJson());
        });
      } on FirebaseException catch (e) {
        return left(MixedFailure(errorMessage: e.message));
      }

      if (receiptToReturn == null) {
        return left(MixedFailure(errorMessage: 'Bestellung wurde aus Marktplatz geladen werden, aber nicht in Firestore gespeichert werden'));
      }
      return right(receiptToReturn!);
    } catch (e) {
      logger.e('Fehler beim laden der Aufträge von Marktplätzen: $e');
      return left(PrestaGeneralFailure(errorMessage: 'Fehler beim laden der Aufträge von Marktplätzen: $e'));
    }
  }
}

String fillPlaceholder(Receipt receipt, String value) {
  ParcelTracking? parceltracking;
  final isParceltrackingGiven = receipt.receiptTyp == ReceiptTyp.deliveryNote && receipt.listOfParcelTracking.isNotEmpty;
  if (isParceltrackingGiven) {
    parceltracking = receipt.listOfParcelTracking.first;
  }

  String newValue = value.replaceAll(
    '{receiptNumber}',
    switch (receipt.receiptTyp) {
      ReceiptTyp.offer => receipt.offerNumberAsString,
      ReceiptTyp.appointment => receipt.appointmentNumberAsString,
      ReceiptTyp.deliveryNote => receipt.deliveryNoteNumberAsString,
      ReceiptTyp.invoice => receipt.invoiceNumberAsString,
      ReceiptTyp.credit => receipt.creditNumberAsString,
    },
  );
  newValue = newValue.replaceAll('{customerNumer}', receipt.receiptCustomer.customerNumber.toString());
  newValue = newValue.replaceAll('{customerFullName}', receipt.receiptCustomer.name);
  newValue = newValue.replaceAll('{receiptMarketplaceReference}', receipt.receiptMarketplaceReference);
  newValue = newValue.replaceAll('{trackingUrl}', isParceltrackingGiven ? parceltracking!.trackingUrl : '');
  newValue = newValue.replaceAll('{trackingNumber}', isParceltrackingGiven ? parceltracking!.trackingNumber : '');
  newValue = newValue.replaceAll(
      '{trackingLink}',
      isParceltrackingGiven
          ? '<a href="${parceltracking!.trackingUrl}${parceltracking.trackingNumber}" target="_blank">Link zur Sendungsverfolgung</a><br>'
          : '');

  return newValue;
}

Future<bool> sendCustomerEmails(List<Receipt> listOfReceipts, Marketplace marketplace) async {
  bool isSuccess = false;
  for (final receipt in listOfReceipts) {
    switch (receipt.receiptTyp) {
      case ReceiptTyp.offer:
        {
          final index = marketplace.marketplaceSettings.listOfEMailAutomations.indexWhere(
            (e) => e.eMailAutomationType == EMailAutomationType.offer,
          );
          if (index != -1 && marketplace.marketplaceSettings.listOfEMailAutomations[index].isActive) {
            final eMailAutomation = marketplace.marketplaceSettings.listOfEMailAutomations[index];
            final subject = fillPlaceholder(receipt, eMailAutomation.subject);
            final htmlContent = fillPlaceholder(receipt, eMailAutomation.htmlContent);
            final generatedPdf = await PdfReceiptGenerator.generate(receipt: receipt, logoUrl: marketplace.logoUrl);
            final attachment = base64Encode(generatedPdf);
            final isSuccessfull = await sendEmail(
              to: receipt.receiptCustomer.email,
              from: eMailAutomation.fromEmail,
              subject: subject,
              html: htmlContent,
              attachmentBase64: attachment,
              filename: receipt.invoiceNumberAsString,
            );
            isSuccess = isSuccessfull;
          }
          break;
        }
      case ReceiptTyp.appointment:
        {
          final index = marketplace.marketplaceSettings.listOfEMailAutomations.indexWhere(
            (e) => e.eMailAutomationType == EMailAutomationType.appointment,
          );
          if (index != -1 && marketplace.marketplaceSettings.listOfEMailAutomations[index].isActive) {
            final eMailAutomation = marketplace.marketplaceSettings.listOfEMailAutomations[index];
            final subject = fillPlaceholder(receipt, eMailAutomation.subject);
            final htmlContent = fillPlaceholder(receipt, eMailAutomation.htmlContent);
            final generatedPdf = await PdfReceiptGenerator.generate(receipt: receipt, logoUrl: marketplace.logoUrl);
            final attachment = base64Encode(generatedPdf);
            final isSuccessfull = await sendEmail(
              to: receipt.receiptCustomer.email,
              from: eMailAutomation.fromEmail,
              subject: subject,
              html: htmlContent,
              attachmentBase64: attachment,
              filename: receipt.invoiceNumberAsString,
            );
            isSuccess = isSuccessfull;
          }
          break;
        }
      case ReceiptTyp.deliveryNote:
        {
          if (receipt.receiptCarrier.carrierProduct.productName != '' && receipt.listOfParcelTracking.isNotEmpty) {
            final index = marketplace.marketplaceSettings.listOfEMailAutomations.indexWhere(
              (e) => e.eMailAutomationType == EMailAutomationType.shipmentTracking,
            );
            if (index != -1 && marketplace.marketplaceSettings.listOfEMailAutomations[index].isActive) {
              final eMailAutomation = marketplace.marketplaceSettings.listOfEMailAutomations[index];
              final subject = fillPlaceholder(receipt, eMailAutomation.subject);
              final htmlContent = fillPlaceholder(receipt, eMailAutomation.htmlContent);
              final isSuccessfull = await sendEmail(
                to: receipt.receiptCustomer.email,
                from: eMailAutomation.fromEmail,
                subject: subject,
                html: htmlContent,
              );
              isSuccess = isSuccessfull;
            }
          }
          break;
        }
      case ReceiptTyp.invoice:
        {
          final index = marketplace.marketplaceSettings.listOfEMailAutomations.indexWhere(
            (e) => e.eMailAutomationType == EMailAutomationType.invoice,
          );
          if (index != -1 && marketplace.marketplaceSettings.listOfEMailAutomations[index].isActive) {
            final eMailAutomation = marketplace.marketplaceSettings.listOfEMailAutomations[index];
            final subject = fillPlaceholder(receipt, eMailAutomation.subject);
            final htmlContent = fillPlaceholder(receipt, eMailAutomation.htmlContent);
            final generatedPdf = await PdfReceiptGenerator.generate(receipt: receipt, logoUrl: marketplace.logoUrl);
            final attachment = base64Encode(generatedPdf);
            final isSuccessfull = await sendEmail(
              to: receipt.receiptCustomer.email,
              from: eMailAutomation.fromEmail,
              subject: subject,
              html: htmlContent,
              attachmentBase64: attachment,
              filename: receipt.invoiceNumberAsString,
            );
            isSuccess = isSuccessfull;
          }
          break;
        }
      case ReceiptTyp.credit:
        {
          final index = marketplace.marketplaceSettings.listOfEMailAutomations.indexWhere(
            (e) => e.eMailAutomationType == EMailAutomationType.credit,
          );
          if (index != -1 && marketplace.marketplaceSettings.listOfEMailAutomations[index].isActive) {
            final eMailAutomation = marketplace.marketplaceSettings.listOfEMailAutomations[index];
            final subject = fillPlaceholder(receipt, eMailAutomation.subject);
            final htmlContent = fillPlaceholder(receipt, eMailAutomation.htmlContent);
            final generatedPdf = await PdfReceiptGenerator.generate(receipt: receipt, logoUrl: marketplace.logoUrl);
            final attachment = base64Encode(generatedPdf);
            final isSuccessfull = await sendEmail(
              to: receipt.receiptCustomer.email,
              from: eMailAutomation.fromEmail,
              subject: subject,
              html: htmlContent,
              attachmentBase64: attachment,
              filename: receipt.invoiceNumberAsString,
            );
            isSuccess = isSuccessfull;
          }
          break;
        }
    }
  }
  return isSuccess;
}

Future<bool> sendEmail({
  required String to,
  required String from,
  required String subject,
  String? text,
  required String html,
  String? bcc,
  String? attachmentBase64,
  String? filename,
}) async {
  bool isSuccess = false;
  HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('sendEmail');

  try {
    final response = await callable.call({
      'to': to,
      'from': from,
      'subject': subject,
      // 'text': text,
      'html': html,
      'bcc': bcc,
      'attachment': attachmentBase64,
      'filename': filename ?? 'attachment.pdf',
    });
    print('E-Mail gesendet: ${response.data}');
    isSuccess = true;
  } catch (e) {
    print('Fehler beim Senden der E-Mail: $e');
    isSuccess = false;
  }
  return isSuccess;
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
    discountPercentAmountGrossUnit: 0,
    discountPercentAmountNetUnit: 0,
    profitUnit: (orderProductPresta.unitPriceTaxExcl).toMyDouble() - (product.wholesalePrice),
    profit: ((orderProductPresta.unitPriceTaxExcl).toMyDouble() - product.wholesalePrice) * quantity,
    weight: product.weight,
    isFromDatabase: true,
  );
}

Future<List<Product>?> getListOfProducts({
  required FirebaseFirestore db,
  required Receipt receipt,
  required String currentUserUid,
}) async {
  final logger = Logger();
  try {
    final listOfProductsInDatabase = receipt.listOfReceiptProduct.where((e) => e.isFromDatabase).toList();
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

Future<void> updateProductWarehouseQuantityIncremental({
  required Transaction transaction,
  required FirebaseFirestore db,
  required String currentUserUid,
  required Product product,
  required int newQuantityIncremental,
}) async {
  final logger = Logger();
  final docRefProduct = db.collection(currentUserUid).doc(currentUserUid).collection('Products').doc(product.id);

  try {
    final updatedProduct = product.copyWith(warehouseStock: product.warehouseStock + newQuantityIncremental);
    transaction.update(docRefProduct, updatedProduct.toJson());
  } catch (error) {
    logger.e('Error on updating product quantity in firebase: $error');
  }
}

Future<ParcelTracking?> getParcelTracking(Receipt receipt, MainSettings ms, int nextDeliveryNoteNumber) async {
  final logger = Logger();

  final carrier = ms.listOfCarriers.where((e) => e.carrierTyp == receipt.receiptCarrier.carrierTyp).firstOrNull;
  if (carrier == null) return null;
  final cCredentials = carrier.carrierKey;

  final service = AustrianPostApi(
    AustrianPostApiConfig(
      clientId: cCredentials.clientId,
      orgUnitId: cCredentials.orgUnitId,
      orgUnitGuide: cCredentials.orgUnitGuide,
    ),
    AustrianPostApiSettings(
      paperLayout: carrier.paperLayout,
      labelSize: carrier.labelSize,
      printerLanguage: carrier.printerLanguage,
    ),
    false,
  );

  final soapRequest = service.generateSoapRequest();
  String responseString = '';

  try {
    final response = await service.createShipment(soapRequest);
    responseString = response;
    logger.i('Response: $response');
  } catch (e) {
    logger.e('Error: $e');
    return null;
  }

  final trackingNumber = service.getTrackingNumber(responseString);
  final pdfString = service.getPdfLabel(responseString);

  final parcelTracking = ParcelTracking(
    deliveryNoteId: nextDeliveryNoteNumber,
    trackingUrl: carrier.trackingUrl,
    trackingNumber: trackingNumber,
    pdfString: pdfString,
  );

  return parcelTracking;
}
