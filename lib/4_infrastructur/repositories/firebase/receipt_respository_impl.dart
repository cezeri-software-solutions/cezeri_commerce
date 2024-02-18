import 'dart:convert';

import 'package:cezeri_commerce/1_presentation/core/extensions/string_to_int.dart';
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

import '../functions/product_import.dart';
import '../functions/product_repository_helper.dart';
import '../prestashop_api/prestashop_api.dart';
import '../shipping_methods/austrian_post/austrian_post_api.dart';
import '/1_presentation/core/functions/check_internet_connection.dart';
import '/1_presentation/core/functions/mixed_functions.dart';
import '/3_domain/entities/address.dart';
import '/3_domain/entities/carrier/parcel_tracking.dart';
import '/3_domain/entities/customer/customer.dart';
import '/3_domain/entities/e_mail_automation.dart';
import '/3_domain/entities/marketplace/marketplace.dart';
import '/3_domain/entities/product/product.dart';
import '/3_domain/entities/product/product_id_with_quantity.dart';
import '/3_domain/entities/settings/main_settings.dart';
import '/3_domain/entities_presta/order_presta.dart';
import '/3_domain/entities_presta/product_presta.dart';
import '/3_domain/enums/enums.dart';
import '/3_domain/pdf/pdf_receipt_generator.dart';
import '/3_domain/repositories/firebase/main_settings_respository.dart';
import '/3_domain/repositories/firebase/product_repository.dart';
import '/3_domain/repositories/marketplace/marketplace_edit_repository.dart';
import '/3_domain/repositories/marketplace/marketplace_import_repository.dart';
import 'receipt_respository_helper.dart';

final logger = Logger();

class ReceiptRespositoryImpl implements ReceiptRepository {
  final FirebaseFirestore db;
  final FirebaseAuth firebaseAuth;
  final ProductRepository productRepository;
  final MarketplaceImportRepository productImportRepository;
  final CustomerRepository customerRepository;
  final MainSettingsRepository mainSettingsRepository;
  final MarketplaceEditRepository marketplaceEditRepository;

  const ReceiptRespositoryImpl({
    required this.db,
    required this.firebaseAuth,
    required this.productRepository,
    required this.productImportRepository,
    required this.customerRepository,
    required this.mainSettingsRepository,
    required this.marketplaceEditRepository,
  });

  @override
  Future<Either<AbstractFailure, Receipt>> getReceipt(Receipt receipt) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = getColRef(currentUserUid, receipt.receiptTyp).doc(receipt.id);

    try {
      final loadedAppointment = await docRef.get();
      return right(Receipt.fromJson(loadedAppointment.data()!));
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(customMessage: 'Beim Laden des Dokuments ist ein Fehler aufgetreten', e: e));
    }
  }

  @override
  Future<Either<AbstractFailure, Unit>> updateReceipt(
    Receipt receipt,
    List<ReceiptProduct> oldListOfReceiptProducts,
    List<ReceiptProduct> newListOfReceiptProducts,
  ) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = getColRef(currentUserUid, receipt.receiptTyp).doc(receipt.id);
    final docRefStatDashboard = db
        .collection('StatDashboard')
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
            await productRepository.updateAvailableQuantityOfProductInremental(toUpdateProduct, oldProduct.quantity, null);
          } else {
            // Überprüfen Sie, ob sich die Menge geändert hat
            final quantityDifference = oldProduct.quantity - newProduct.quantity;
            if (quantityDifference != 0) {
              // Anpassen des Bestands in Firestore basierend auf quantityDifference
              Product? toUpdateProduct = await loadProductToUpdate(oldProduct);
              if (toUpdateProduct == null) return left(GeneralFailure());
              await productRepository.updateAvailableQuantityOfProductInremental(toUpdateProduct, quantityDifference, null);
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
            await productRepository.updateAvailableQuantityOfProductInremental(toUpdateProduct, newProduct.quantity * -1, null);
          }
        }

        await incrementStatDashboardOnUpdateReceipt(receipt, appointmentBeforeUpdate, docRefStatDashboard, dsStatDashboard, transaction);
        transaction.update(docRef, receipt.toJson());
      });
      return right(unit);
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(customMessage: 'Beim Aktualisieren des Dokuments ist ein Fehler aufgetreten', e: e));
    }
  }

  @override
  Future<Either<AbstractFailure, Receipt>> createReceiptManually(Receipt receipt) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final now = DateTime.now();
    final curYear = now.year;
    final curMonth = now.month;

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRefSettings = db.collection('Settings').doc(currentUserUid).collection('Settings').doc(currentUserUid);
    final docRef = getColRef(currentUserUid, receipt.receiptTyp).doc();
    final docRefStatDashboard = db.collection('StatDashboard').doc(currentUserUid).collection('StatDashboard').doc('$curYear$curMonth');

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

        for (final receiptProduct in toCreateReceipt.listOfReceiptProduct) {
          Product? toUpdateProduct;
          final fosProduct = await productRepository.getProduct(receiptProduct.productId);
          fosProduct.fold(
            (failure) => null,
            (product) => toUpdateProduct = product,
          );
          await productRepository.updateAvailableQuantityOfProductInremental(toUpdateProduct!, receiptProduct.quantity * -1, null);
        }

        transaction.update(docRefSettings, updatedMainSettings.toJson());

        transaction.set(docRef, toCreateReceipt.toJson());

        await createOrIncrementStatDashboardOnCreateReceipt(toCreateReceipt, docRefStatDashboard, dsStatDashboard, transaction);
        await createOrIncrementStatProductOnCreateReceipt(toCreateReceipt, currentUserUid, db);
      });
      return right(toCreateReceipt);
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(customMessage: 'Beim Erstellen des Dokuments ist ein Fehler aufgetreten', e: e));
    } catch (e) {
      logger.e(e);
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<AbstractFailure, List<Receipt>>> getListOfReceipts(int value, ReceiptTyp receiptTyp) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final colRef = value != 0
        ? getColRef(currentUserUid, receiptTyp)
        : switch (receiptTyp) {
            ReceiptTyp.offer => getColRef(currentUserUid, receiptTyp).where('offerStatus', isEqualTo: OfferStatus.open.name),
            ReceiptTyp.appointment => getColRef(currentUserUid, receiptTyp)
                .where('appointmentStatus', whereIn: [AppointmentStatus.open.name, AppointmentStatus.partiallyCompleted.name]),
            ReceiptTyp.deliveryNote => getColRef(currentUserUid, receiptTyp).where('invoiceId', isEqualTo: 0),
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
      //* Zum hinzufügen StatProducts.
      // for (final receipt in listOfAppointments) {
      //   if (value == 1 && (receipt.receiptTyp == ReceiptTyp.invoice || receipt.receiptTyp == ReceiptTyp.appointment)) {
      //     await createOrIncrementStatProductOnCreateReceipt(receipt, currentUserUid, db);
      //   }
      // }
      //* ENDE Zum hinzufügen StatProducts.

      return right(listOfAppointments);
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(customMessage: 'Beim Laden der Dokumente ist ein Fehler aufgetreten', e: e));
    }
  }

  @override
  Future<Either<AbstractFailure, Unit>> deleteListOfReceipts(List<Receipt> listOfReceipts) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final receiptTyp = listOfReceipts.first.receiptTyp;

    try {
      for (final receipt in listOfReceipts) {
        final listOfProducts = await getListOfProductsInReceipt(db: db, receipt: receipt, currentUserUid: currentUserUid);
        if (listOfProducts == null) continue;

        final docRefStatDashboard = db
            .collection('StatDashboard')
            .doc(currentUserUid)
            .collection('StatDashboard')
            .doc('${receipt.creationDateMarektplace.year}${receipt.creationDateMarektplace.month}');

        await db.runTransaction((transaction) async {
          final dsStatDashboard = await transaction.get(docRefStatDashboard);

          for (final product in listOfProducts) {
            await productRepository.updateAvailableQuantityOfProductInremental(
              product,
              receipt.listOfReceiptProduct.where((e) => e.productId == product.id).first.quantity,
              null,
            );
          }
          await incrementStatDashboardOnDeleteReceipt(receipt, docRefStatDashboard, dsStatDashboard, transaction);
          final docRef = getColRef(currentUserUid, receiptTyp).doc(receipt.id);
          transaction.delete(docRef);
        });
      }

      return right(unit);
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(customMessage: 'Beim Löschen der Dokumente ist ein Fehler aufgetreten', e: e));
    }
  }

  @override
  Future<Either<AbstractFailure, List<Receipt>>> generateFromListOfOffersNewAppointments(List<Receipt> listOfOffers) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final now = DateTime.now();
    final curYear = now.year;
    final curMonth = now.month;

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRefSettings = db.collection('Settings').doc(currentUserUid).collection('Settings').doc(currentUserUid);
    final docRefStatDashboardToCreate = db.collection('StatDashboard').doc(currentUserUid).collection('StatDashboard').doc('$curYear$curMonth');

    List<Receipt> generatedAppointments = [];

    try {
      final settingsSnapshot = await docRefSettings.get();
      final settings = MainSettings.fromJson(settingsSnapshot.data()!);
      int nextAppointmentNumber = settings.nextAppointmentNumber;

      final dsStatDashboardToCreate = await docRefStatDashboardToCreate.get();

      Marketplace? marketplace;

      for (final offer in listOfOffers) {
        final docRefStatDashboardToUpdate = db
            .collection('StatDashboard')
            .doc(currentUserUid)
            .collection('StatDashboard')
            .doc('${offer.creationDate.year}${offer.creationDate.month}');
        await db.runTransaction((transaction) async {
          final docRefMarketplace = db.collection('Marketetplaces').doc(currentUserUid).collection('Marketetplaces').doc(offer.marketplaceId);
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
          await createOrIncrementStatProductOnCreateReceipt(appointment, currentUserUid, db);

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
            await productRepository.updateAvailableQuantityOfProductInremental(product!, receiptProduct.quantity * -1, null);
          }
          if (marketplace != null) await sendCustomerEmailsOnCreateReceipts([generatedAppointmentFromThisOffer], marketplace!);
        });
      }
      final updatedMainSettings = settings.copyWith(nextAppointmentNumber: nextAppointmentNumber);
      await docRefSettings.update(updatedMainSettings.toJson());
      return right(generatedAppointments);
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(customMessage: 'Beim Generieren von Aufträgen aus Angeboten ist ein Fehler aufgetreten', e: e));
    } catch (e) {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<AbstractFailure, List<Receipt>>> generateFromListOfAppointments(
    List<Receipt> listOfReceipts,
    bool generateDeliveryNote,
    bool generateInvoice,
  ) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final now = DateTime.now();
    final curYear = now.year;
    final curMonth = now.month;

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRefSettings = db.collection('Settings').doc(currentUserUid).collection('Settings').doc(currentUserUid);
    final docRefStatDashboard = db.collection('StatDashboard').doc(currentUserUid).collection('StatDashboard').doc('$curYear$curMonth');

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
          final docRefMarketplace = db.collection('Marketetplaces').doc(currentUserUid).collection('Marketetplaces').doc(receipt.marketplaceId);
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
            await createOrIncrementStatProductOnCreateReceipt(invoice, currentUserUid, db);
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
          if (marketplace != null) await sendCustomerEmailsOnCreateReceipts(generatedReceiptsFromThisReceipt, marketplace!);
        });

        //* Neuen Bestellstatus im Marktplatz setzen
        if (marketplace != null) {
          final fosOrderStatus = await marketplaceEditRepository.setOrderStatusInMarketplace(
            marketplace!,
            receipt.receiptMarketplaceId,
            OrderStatusUpdateType.onShipping,
          );
          fosOrderStatus.fold(
            (failure) => logger.e('Bestellstatus für Bestellung mit der ID: ${receipt.receiptMarketplaceId} konnte nicht gesetzt werden'),
            (unit) => logger.i('Bestellstatus für die Bestellung mit der ID: ${receipt.receiptMarketplaceId} wurde erfolgreich aktualisiert'),
          );
        }
      }
      final updatedMainSettings = settings.copyWith(nextDeliveryNoteNumber: nextDeliveryNoteNumber, nextInvoiceNumber: nextInvoiceNumber);
      await docRefSettings.update(updatedMainSettings.toJson());
      return right(generatedReceipts);
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(
        customMessage: 'Beim Generieren von Lieferscheinen und/oder Rechnungen aus Aufträgen ist ein Fehler aufgetreten',
        e: e,
      ));
    } catch (e) {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<AbstractFailure, List<Receipt>>> generateFromAppointment(
    Receipt incomingAppointment,
    Receipt originalAppointment,
    bool generateDeliveryNote,
    bool generateInvoice,
  ) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final now = DateTime.now();
    final curYear = now.year;
    final curMonth = now.month;

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRefSettings = db.collection('Settings').doc(currentUserUid).collection('Settings').doc(currentUserUid);
    final docRefStatDashboard = db.collection('StatDashboard').doc(currentUserUid).collection('StatDashboard').doc('$curYear$curMonth');
    final docRefMarketplace = db.collection('Marketetplaces').doc(currentUserUid).collection('Marketetplaces').doc(originalAppointment.marketplaceId);

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
          await createOrIncrementStatProductOnCreateReceipt(invoice, currentUserUid, db);
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
      final isSuccessfulSent = await sendCustomerEmailsOnCreateReceipts(generatedReceipts, marketplace);
      if (isSuccessfulSent) {
        logger.i('Alle E-Mails wurden erfolgreich verschickt.');
      } else {
        logger.e('Eine oder meherer E-Mails konnten nicht verschickt werden!');
      }

      //* Neuen Bestellstatus im Marktplatz setzen
      final fosOrderStatus = await marketplaceEditRepository.setOrderStatusInMarketplace(
        marketplace,
        originalAppointment.receiptMarketplaceId,
        OrderStatusUpdateType.onShipping,
      );
      fosOrderStatus.fold(
        (failure) => logger.e('Bestellstatus für Bestellung mit der ID: ${originalAppointment.receiptMarketplaceId} konnte nicht gesetzt werden'),
        (unit) => logger.i('Bestellstatus für die Bestellung mit der ID: ${originalAppointment.receiptMarketplaceId} wurde erfolgreich aktualisiert'),
      );

      return right(generatedReceipts);
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(
        customMessage: 'Beim Generieren von einem Lieferschein und/oder Rechnung aus einem Auftrag ist ein Fehler aufgetreten',
        e: e,
      ));
    } catch (e) {
      logger.e('Beim Generieren der Dokumente aus einem Auftrag ist ein Fehler aufgetreten: $e');
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<AbstractFailure, Receipt>> generateFromListOfDeliveryNotesNewInvoice(List<Receipt> listOfDeliveryNotes) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final now = DateTime.now();
    final curYear = now.year;
    final curMonth = now.month;

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRefSettings = db.collection('Settings').doc(currentUserUid).collection('Settings').doc(currentUserUid);
    final docRefStatDashboard = db.collection('StatDashboard').doc(currentUserUid).collection('StatDashboard').doc('$curYear$curMonth');
    final docRefMarketplace =
        db.collection('Marketetplaces').doc(currentUserUid).collection('Marketetplaces').doc(listOfDeliveryNotes.first.marketplaceId);

    Receipt? generatedReceipt;

    try {
      final settingsSnapshot = await docRefSettings.get();
      final settings = MainSettings.fromJson(settingsSnapshot.data()!);

      final dsMarketplace = await docRefMarketplace.get();
      final marketplace = Marketplace.fromJson(dsMarketplace.data()!);

      await db.runTransaction((transaction) async {
        final dsStatDashboard = await transaction.get(docRefStatDashboard);

        final phInvoice = Receipt.fromDeliveryNotesGenInvoice(deliveryNotes: listOfDeliveryNotes, settings: settings);
        final docRefI = getColRef(currentUserUid, phInvoice.receiptTyp).doc();
        final invoice = phInvoice.copyWith(id: docRefI.id);
        transaction.set(docRefI, invoice.toJson());
        generatedReceipt = invoice;

        await createOrIncrementStatDashboardOnCreateReceipt(invoice, docRefStatDashboard, dsStatDashboard, transaction);
        await createOrIncrementStatProductOnCreateReceipt(invoice, currentUserUid, db);

        for (final deliveryNote in listOfDeliveryNotes) {
          final updatedDeliveryNote = deliveryNote.copyWith(
            invoiceId: invoice.invoiceId,
            invoiceNumberAsString: invoice.invoiceNumberAsString,
            lastEditingDate: now,
          );
          transaction.update(
            getColRef(currentUserUid, deliveryNote.receiptTyp).doc(deliveryNote.id),
            updatedDeliveryNote.toJson(),
          );
        }

        final updatedMainSettings = settings.copyWith(nextInvoiceNumber: settings.nextInvoiceNumber + 1);
        transaction.update(docRefSettings, updatedMainSettings.toJson());
      });
      if (generatedReceipt == null) return left(GeneralFailure());

      final isSuccessfulSent = await sendCustomerEmailsOnCreateReceipts([generatedReceipt!], marketplace);
      if (isSuccessfulSent) {
        logger.i('Alle E-Mails wurden erfolgreich verschickt.');
      } else {
        logger.e('Eine oder meherer E-Mails konnten nicht verschickt werden!');
      }

      return right(generatedReceipt!);
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(customMessage: 'Beim Generieren von Rechnungen aus Lieferscheinen ist ein Fehler aufgetreten', e: e));
    }
  }

  @override
  Future<Either<AbstractFailure, Receipt>> generateFromInvoiceNewCredit(Receipt invoice) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final now = DateTime.now();
    final curYear = now.year;
    final curMonth = now.month;

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRefSettings = db.collection('Settings').doc(currentUserUid).collection('Settings').doc(currentUserUid);
    final docRefStatDashboardToCreate = db.collection('StatDashboard').doc(currentUserUid).collection('StatDashboard').doc('$curYear$curMonth');

    Receipt? generatedCredit;

    try {
      final settingsSnapshot = await docRefSettings.get();
      final settings = MainSettings.fromJson(settingsSnapshot.data()!);
      int nextInvoiceNumber = settings.nextInvoiceNumber;

      final dsStatDashboardToCreate = await docRefStatDashboardToCreate.get();

      Marketplace? marketplace;

      final docRefStatDashboardToUpdate = db
          .collection('StatDashboard')
          .doc(currentUserUid)
          .collection('StatDashboard')
          .doc('${invoice.creationDate.year}${invoice.creationDate.month}');
      await db.runTransaction((transaction) async {
        final docRefMarketplace = db.collection('Marketetplaces').doc(currentUserUid).collection('Marketetplaces').doc(invoice.marketplaceId);
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
          await productRepository.updateAvailableQuantityOfProductInremental(product!, receiptProduct.quantity * -1, null);
        }
        if (marketplace != null) await sendCustomerEmailsOnCreateReceipts([generatedAppointmentFromThisOffer], marketplace!);
      });

      final updatedMainSettings = settings.copyWith(nextInvoiceNumber: nextInvoiceNumber);
      await docRefSettings.update(updatedMainSettings.toJson());
      return right(generatedCredit!);
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(customMessage: 'Beim Generieren von einer Gutschrift aus einer Rechnung ist ein Fehler aufgetreten', e: e));
    } catch (e) {
      return left(GeneralFailure());
    }
  }

  CollectionReference<Map<String, dynamic>> getColRef(String currentUserUid, ReceiptTyp receiptTyp) {
    return switch (receiptTyp) {
      ReceiptTyp.offer => db.collection('Receipts').doc(currentUserUid).collection('Offers'),
      ReceiptTyp.appointment => db.collection('Receipts').doc(currentUserUid).collection('Appointments'),
      ReceiptTyp.deliveryNote => db.collection('Receipts').doc(currentUserUid).collection('DeliveryNotes'),
      ReceiptTyp.invoice || ReceiptTyp.credit => db.collection('Receipts').doc(currentUserUid).collection('Invoices'),
    };
  }

  Future<ProductPresta?> getProductByIdFromPrestashop(int id, Marketplace marketplace) async {
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
    Customer? createdCustomer;
    final fosCustomer = await customerRepository.createCustomer(customer);
    fosCustomer.fold(
      (failure) => logger.e('Kunde: ${customer.name} konte nicht in der Firestore Datenbank angelegt werden. \n Error: $failure'),
      (customer) => createdCustomer = customer,
    );

    return createdCustomer;
  }

  Future<Customer?> checkCustomerAddressIsUpToDateOrUpdateThem(Customer customer, Address addressInvoice, Address addressDelivery) async {
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
  Future<Either<AbstractFailure, Unit>> sendEmails() async {
    // bool isFailure = false;
    //await sendEmail(to: 'info@ccf-autopflege.at', from: 'ince.ali@msn.com', subject: 'Test-Mail', text: 'Hallo das ist eine Test-Mail');
    // if (isFailure) return left(GeneralFailure());
    return right(unit);
  }

  @override
  Future<Either<AbstractFailure, ParcelTracking>> createNewParcelForReceipt(Receipt deliveryNote) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = getColRef(currentUserUid, deliveryNote.receiptTyp).doc(deliveryNote.id);
    final docRefMS = db.collection('Settings').doc(currentUserUid).collection('Settings').doc(currentUserUid);
    final docRefMP = db.collection('Marketetplaces').doc(currentUserUid).collection('Marketetplaces').doc(deliveryNote.marketplaceId);

    try {
      final loadedDeliveryNoteDs = await docRef.get();
      if (!loadedDeliveryNoteDs.exists) return left(GeneralFailure(customMessage: 'Dokument konnte nicht aus der Datenbank geladen werden'));
      final loadedDeliveryNote = Receipt.fromJson(loadedDeliveryNoteDs.data()!);

      final settingsDs = await docRefMS.get();
      if (!settingsDs.exists) return left(GeneralFailure(customMessage: 'Einstellungen konnten nicht aus der Datenbank geladen werden'));
      final settings = MainSettings.fromJson(settingsDs.data()!);

      final marketplaceDs = await docRefMP.get();
      if (!marketplaceDs.exists) return left(GeneralFailure(customMessage: 'Marktplatz konnten nicht aus der Datenbank geladen werden'));
      final marketplace = Marketplace.fromJson(marketplaceDs.data()!);

      final parcelTracking = await getParcelTracking(loadedDeliveryNote, settings, loadedDeliveryNote.deliveryNoteId);
      if (parcelTracking == null) return left(GeneralFailure(customMessage: 'Paketlabel konnte nicht erstellt werden'));

      final List<ParcelTracking> listOfUpdatedParcelTracking = loadedDeliveryNote.listOfParcelTracking;
      listOfUpdatedParcelTracking.add(parcelTracking);
      final updatedDeliveryNote = loadedDeliveryNote.copyWith(listOfParcelTracking: listOfUpdatedParcelTracking);

      await docRef.update(updatedDeliveryNote.toJson());

      await sendCustomerEmailsOnCreateReceipts([updatedDeliveryNote], marketplace);

      return right(parcelTracking);
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(customMessage: 'Beim Erstellen eines Versandlabels ist ein Fehler aufgetreten', e: e));
    }
  }

  @override
  Future<Either<AbstractFailure, List<ToLoadAppointmentsFromMarketplace>>> getToLoadAppointmentsFromMarketplaces() async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRefMarketplaces = db.collection('Marketetplaces').doc(currentUserUid).collection('Marketetplaces').where('isActive', isEqualTo: true);

    try {
      List<ToLoadAppointmentsFromMarketplace> listOfToLoadAppointmentsFromMarketplace = [];
      final listOfActiveMarketplaces = await docRefMarketplaces.get().then(
            (value) => value.docs.map((querySnapshot) => Marketplace.fromJson(querySnapshot.data())).toList(),
          );

      for (final marketplace in listOfActiveMarketplaces) {
        if (!marketplace.isActive) continue;

        final api = PrestashopApi(Client(), PrestashopApiConfig(apiKey: marketplace.key, webserviceUrl: marketplace.fullUrl));

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
      return left(GeneralFailure(customMessage: 'Fehler beim laden der zu ladenden Aufträge von Marktplätzen: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, LoadedOrderFromMarketplace>> loadAppointmentsFromMarketplace(
    ToLoadAppointmentFromMarketplace toLoadAppointment,
  ) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final marketplace = toLoadAppointment.marketplace;
    logger.i(marketplace.name);
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

    final now = DateTime.now();
    final curYear = now.year;
    final curMonth = now.month;

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final marketplace = loadedAppointmentFromMarketplace.marketplace;
    logger.i(marketplace.name);
    final api = PrestashopApi(Client(), PrestashopApiConfig(apiKey: marketplace.key, webserviceUrl: marketplace.fullUrl));
    logger.i(marketplace.fullUrl);
    final docRefMainSettings = db.collection('Settings').doc(currentUserUid).collection('Settings').doc(currentUserUid);
    final docRefStatDashboard = db.collection('StatDashboard').doc(currentUserUid).collection('StatDashboard').doc('$curYear$curMonth');
    final docRefMarketplace = db.collection('Marketetplaces').doc(currentUserUid).collection('Marketetplaces').doc(marketplace.id);

    final orderPresta = loadedAppointmentFromMarketplace.orderPresta;

    Receipt? receiptToReturn;
    // try {
    //* Überprüft, ob die aus dem Marktplatz geladene Bestellung bereits in Firebase Firestore hinterlegt ist
    final docRefReceipt = getColRef(currentUserUid, ReceiptTyp.appointment).where('receiptMarketplaceId', isEqualTo: orderPresta.id);
    final appointmentListFirestore =
        await docRefReceipt.get().then((value) => value.docs.map((querySnapshot) => Receipt.fromJson(querySnapshot.data())).toList());
    if (appointmentListFirestore.isNotEmpty) {
      logger.e('Vom Marktplatz geladene Bestellung ist bereits in Firestore gespeicher');
      return left(GeneralFailure(customMessage: 'Vom Marktplatz geladene Bestellung ist bereits in Firestore gespeicher'));
    }

    final dsMainSettings = await docRefMainSettings.get();
    if (!dsMainSettings.exists) {
      logger.e('MainSettings konnte nicht aus Firestore geladen werden');
      return left(GeneralFailure(customMessage: 'MainSettings konnte nicht aus Firestore geladen werden'));
    }
    final mainSettings = MainSettings.fromJson(dsMainSettings.data()!);

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

      final receiptProduct = generateReceiptProduct(
        product: appointmentProduct!,
        orderProductPresta: orderProductPresta,
        mainSettings: mainSettings,
        quantity: quantity,
        tax: tax,
      );
      listOfReceiptproduct.add(receiptProduct);
    }

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
      logger.e('Kunde aus Bestellung von Marktplatz konnte weder in Firestore erstellt werden, noch in Firestore gespeichert werden');
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

        final docRefAppointment = getColRef(currentUserUid, ReceiptTyp.appointment).doc();
        final appointment = phAppointment.copyWith(id: docRefAppointment.id, receiptId: docRefAppointment.id);
        transaction.set(docRefAppointment, appointment.toJson());
        receiptToReturn = appointment;

        await createOrIncrementStatDashboardOnCreateReceipt(appointment, docRefStatDashboard, dsStatDashboard, transaction);
        await createOrIncrementStatProductOnCreateReceipt(appointment, currentUserUid, db);

        final nextAppointmentNumber = mainSettings.nextAppointmentNumber + 1;
        final updatedMainSettings = mainSettings.copyWith(nextAppointmentNumber: nextAppointmentNumber, nextCustomerNumber: nextCustomerNumber);
        transaction.update(docRefMainSettings, updatedMainSettings.toJson());

        final updatedMarketplace = marketplace.copyWith(
          marketplaceSettings: marketplace.marketplaceSettings.copyWith(nextIdToImport: loadedAppointmentFromMarketplace.orderMarketplaceId + 1),
        );
        transaction.update(docRefMarketplace, updatedMarketplace.toJson());
      });
    } on FirebaseException catch (e) {
      return left(GeneralFailure(customMessage: e.message));
    }

    if (receiptToReturn == null) {
      logger.e('Bestellung wurde aus Marktplatz geladen, konnten aber nicht in Firestore gespeichert werden');
      return left(GeneralFailure(customMessage: 'Bestellung wurde aus Marktplatz geladen, konnten aber nicht in Firestore gespeichert werden'));
    }
    return right(receiptToReturn!);
    // } catch (e) {
    //   logger.e('Fehler beim hochladen der Aufträge zu Firestore: $e');
    //   return left(PrestaGeneralFailure(errorMessage: 'Fehler beim hochladen der Aufträge zu Firestore: $e'));
    // }
  }
}

String fillPlaceholder(Receipt receipt, String value) {
  ParcelTracking? parceltracking;
  final isParceltrackingGiven = receipt.receiptTyp == ReceiptTyp.deliveryNote && receipt.listOfParcelTracking.isNotEmpty;
  if (isParceltrackingGiven) {
    List<ParcelTracking> listOfParcels = receipt.listOfParcelTracking;
    listOfParcels.sort((a, b) => a.trackingNumber.compareTo(b.trackingNumber));
    parceltracking = listOfParcels.last;
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

Future<bool> sendCustomerEmailsOnCreateReceipts(List<Receipt> listOfReceipts, Marketplace marketplace) async {
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
              bcc: eMailAutomation.bcc,
              attachmentBase64: attachment,
              filename: '${receipt.offerNumberAsString}.pdf',
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
              bcc: eMailAutomation.bcc,
              attachmentBase64: attachment,
              filename: '${receipt.appointmentNumberAsString}.pdf',
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
                bcc: eMailAutomation.bcc,
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
              bcc: eMailAutomation.bcc,
              attachmentBase64: attachment,
              filename: '${receipt.invoiceNumberAsString}.pdf',
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
              bcc: eMailAutomation.bcc,
              attachmentBase64: attachment,
              filename: '${receipt.invoiceNumberAsString}.pdf',
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

Future<List<Product>?> getListOfProductsInReceipt({
  required FirebaseFirestore db,
  required Receipt receipt,
  required String currentUserUid,
}) async {
  try {
    final listOfProductsInDatabase = receipt.listOfReceiptProduct.where((e) => e.isFromDatabase).toList();
    logger.i(listOfProductsInDatabase.map((e) => e.productId));
    final docRefProducts = db
        .collection('Products')
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

Future<void> updateProductWarehouseQuantityIncremental({
  required Transaction transaction,
  required FirebaseFirestore db,
  required String currentUserUid,
  required Product product,
  required int newQuantityIncremental,
}) async {
  //! Wenn diese Funktion bearbeitet wird muss auch die Funktion (product_repository_impl)(updateWarehouseQuantityOfNewProductOnImportIncremental) geupdatet werden
  final docRefProduct = db.collection('Products').doc(currentUserUid).collection('Products').doc(product.id);

  try {
    final updatedProduct = product.copyWith(
      warehouseStock: product.warehouseStock + newQuantityIncremental,
      isUnderMinimumStock: product.availableStock <= product.minimumStock ? true : false,
    );
    transaction.update(docRefProduct, updatedProduct.toJson());
    if (product.isSetArticle && product.listOfProductIdWithQuantity.isNotEmpty) {
      for (final productIdWithQuantity in product.listOfProductIdWithQuantity) {
        final docRef = db.collection('Products').doc(currentUserUid).collection('Products').doc(productIdWithQuantity.productId);
        transaction.update(docRef, {'warehouseStock': FieldValue.increment(newQuantityIncremental * productIdWithQuantity.quantity)});
      }
    }
  } catch (error) {
    logger.e('Error on updating product quantity in firebase: $error');
  }
}

Future<ParcelTracking?> getParcelTracking(Receipt receipt, MainSettings ms, int deliveryNoteNumber) async {
  final carrier = ms.listOfCarriers.where((e) => e.carrierTyp == receipt.receiptCarrier.carrierTyp).firstOrNull;
  if (carrier == null) return null;
  final cCredentials = carrier.carrierKey;
  final recipientAddress = receipt.addressDelivery;

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
    receipt.receiptCarrier.carrierProduct.id,
    receipt.weight,
    recipientAddress,
    receipt.receiptCustomer.email,
    receipt.receiptMarketplace.address,
    receipt.receiptMarketplace.bankDetails.paypalEmail,
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
    deliveryNoteId: deliveryNoteNumber,
    trackingUrl: carrier.trackingUrl,
    trackingNumber: trackingNumber,
    pdfString: pdfString,
  );

  return parcelTracking;
}
