import 'dart:convert';

import 'package:cezeri_commerce/3_domain/entities/receipt/load_appointments_helper/to_load_appointments_from_marketplace.dart';
import 'package:cezeri_commerce/3_domain/entities/receipt/receipt.dart';
import 'package:cezeri_commerce/3_domain/entities/receipt/receipt_product.dart';
import 'package:cezeri_commerce/3_domain/repositories/firebase/customer_repository.dart';
import 'package:cezeri_commerce/3_domain/repositories/firebase/receipt_repository.dart';
import 'package:cezeri_commerce/4_infrastructur/repositories/functions/get_storage_paths.dart';
import 'package:cezeri_commerce/failures/abstract_failure.dart';
import 'package:cezeri_commerce/failures/firebase_failures.dart';
import 'package:cezeri_commerce/failures/presta_failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '/1_presentation/core/core.dart';
import '/3_domain/entities/carrier/parcel_tracking.dart';
import '/3_domain/entities/e_mail_automation.dart';
import '/3_domain/entities/id.dart';
import '/3_domain/entities/marketplace/abstract_marketplace.dart';
import '/3_domain/entities/marketplace/marketplace_presta.dart';
import '/3_domain/entities/marketplace/marketplace_shopify.dart';
import '/3_domain/entities/settings/main_settings.dart';
import '/3_domain/enums/enums.dart';
import '/3_domain/pdf/pdf_receipt_generator.dart';
import '/3_domain/repositories/firebase/main_settings_respository.dart';
import '/3_domain/repositories/firebase/marketplace_repository.dart';
import '/3_domain/repositories/firebase/product_repository.dart';
import '/3_domain/repositories/marketplace/marketplace_edit_repository.dart';
import '/3_domain/repositories/marketplace/marketplace_import_repository.dart';
import '/constants.dart';
import '../functions/get_database.dart';
import '../functions/product_repository_helper.dart';
import '../functions/receipt_respository_presta_helper.dart';
import '../functions/receipt_respository_shopify_helper.dart';
import '../functions/utils_repository_impl.dart';
import '../prestashop_api/prestashop_api.dart';
import '../shipping_methods/austrian_post/austrian_post_api.dart';
import '../shopify_api/api/shopify_api.dart';

class ReceiptRespositoryImpl implements ReceiptRepository {
  final ProductRepository productRepository;
  final MarketplaceImportRepository productImportRepository;
  final CustomerRepository customerRepository;
  final MainSettingsRepository mainSettingsRepository;
  final MarketplaceRepository marketplaceRepository;
  final MarketplaceEditRepository marketplaceEditRepository;

  const ReceiptRespositoryImpl({
    required this.productRepository,
    required this.productImportRepository,
    required this.customerRepository,
    required this.mainSettingsRepository,
    required this.marketplaceRepository,
    required this.marketplaceEditRepository,
  });

  @override
  Future<Either<AbstractFailure, Receipt>> getReceipt(String receiptId, ReceiptType receiptType) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final database = getReceiptDatabase(receiptType);

    try {
      final response = await database.select().eq('ownerId', ownerId).eq('id', receiptId).single();

      return right(Receipt.fromJson(response));
    } catch (e) {
      logger.e(e);
      return left(GeneralFailure(
        customMessage: 'Beim Laden des Dokuments ist ein Fehler aufgetreten. Error: $e',
      ));
    }
  }

  @override
  Future<Either<AbstractFailure, Unit>> updateReceipt(
    Receipt receipt,
    List<ReceiptProduct> oldListOfReceiptProducts,
    List<ReceiptProduct> newListOfReceiptProducts,
  ) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final receiptType = receipt.receiptTyp;
    final database = getReceiptDatabase(receiptType);

    try {
      //* Bestandupdates erfolgen nur in diesen receiptType's
      if (receiptType == ReceiptType.appointment || receiptType == ReceiptType.deliveryNote || receiptType == ReceiptType.invoice) {
        for (final oldProduct in oldListOfReceiptProducts) {
          if (!oldProduct.isFromDatabase) continue;
          final newProduct = newListOfReceiptProducts.where((p) => p.productId == oldProduct.productId).firstOrNull;

          if (newProduct == null) {
            //* oldProduct wurde entfernt
            //* Erhöhen Sie den Bestand von oldProduct in der Datenbank
            final fosUpdateProductStock = await updateProductQuantityInDbAndMps(
              productId: oldProduct.productId,
              incQuantity: oldProduct.quantity,
              updateOnlyAvailableQuantity: receiptType == ReceiptType.appointment ? true : false,
            );
            if (fosUpdateProductStock.isLeft()) return Left(fosUpdateProductStock.getLeft());
          } else {
            //* Überprüft, ob sich die Menge geändert hat
            final quantityDifference = oldProduct.quantity - newProduct.quantity;
            if (quantityDifference != 0) {
              //* Anpassen des Bestands in der Datenbank basierend auf quantityDifference
              final fosUpdateProductStock = await updateProductQuantityInDbAndMps(
                productId: oldProduct.productId,
                incQuantity: quantityDifference,
                updateOnlyAvailableQuantity: receiptType == ReceiptType.appointment ? true : false,
              );
              if (fosUpdateProductStock.isLeft()) return Left(fosUpdateProductStock.getLeft());
            }
          }
        }

        for (final newProduct in newListOfReceiptProducts) {
          if (!newProduct.isFromDatabase) continue;
          if (!oldListOfReceiptProducts.any((p) => p.productId == newProduct.productId)) {
            //* newProduct wurde hinzugefügt
            //* Verringern Sie den Bestand von newProduct in der Datenbank
            final fosUpdateProductStock = await updateProductQuantityInDbAndMps(
              productId: newProduct.productId,
              incQuantity: newProduct.quantity * -1,
              updateOnlyAvailableQuantity: receiptType == ReceiptType.appointment ? true : false,
            );
            if (fosUpdateProductStock.isLeft()) return Left(fosUpdateProductStock.getLeft());
          }
        }
      }

      await database.update(receipt.toJson()).eq('ownerId', ownerId).eq('id', receipt.id);

      return const Right(unit);
    } catch (e) {
      logger.e(e);
      return left(GeneralFailure(customMessage: 'Beim Aktualisieren des Dokuments ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, Receipt>> createReceiptManually(Receipt receipt) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final receiptType = receipt.receiptTyp;
    final databaseReceipt = getReceiptDatabase(receiptType);

    final genId = UniqueID().value;

    try {
      Receipt toCreateReceipt = Receipt.empty();
      final fosSettings = await mainSettingsRepository.getSettings();
      if (fosSettings.isLeft()) return Left(fosSettings.getLeft());
      final settings = fosSettings.getRight();

      toCreateReceipt = switch (receiptType) {
        ReceiptType.offer => receipt.copyWith(
            id: genId,
            receiptId: genId,
            offerId: settings.nextOfferNumber,
            offerNumberAsString: settings.offerPraefix + settings.nextOfferNumber.toString(),
          ),
        ReceiptType.appointment => receipt.copyWith(
            id: genId,
            receiptId: genId,
            appointmentId: settings.nextAppointmentNumber,
            appointmentNumberAsString: settings.appointmentPraefix + settings.nextAppointmentNumber.toString(),
          ),
        ReceiptType.deliveryNote => receipt.copyWith(
            id: genId,
            receiptId: genId,
            deliveryNoteId: settings.nextDeliveryNoteNumber,
            deliveryNoteNumberAsString: settings.deliveryNotePraefix + settings.nextDeliveryNoteNumber.toString(),
          ),
        ReceiptType.invoice || ReceiptType.credit => receipt.copyWith(
            id: genId,
            receiptId: genId,
            invoiceId: settings.nextInvoiceNumber,
            invoiceNumberAsString: settings.invoicePraefix + settings.nextInvoiceNumber.toString(),
          ),
      };

      if (receiptType == ReceiptType.appointment || receiptType == ReceiptType.deliveryNote || receiptType == ReceiptType.invoice) {
        for (final receiptProduct in toCreateReceipt.listOfReceiptProduct) {
          if (!receiptProduct.isFromDatabase) continue;

          //* Update product stocks in datababase and marketplaces
          final fosUpdateProductStock = await updateProductQuantityInDbAndMps(
            productId: receiptProduct.productId,
            incQuantity: receiptProduct.quantity * -1,
            updateOnlyAvailableQuantity: receiptType == ReceiptType.appointment ? true : false,
          );
          if (fosUpdateProductStock.isLeft()) return Left(fosUpdateProductStock.getLeft());
        }
      }

      final toCreateReceiptJson = toCreateReceipt.toJson();
      toCreateReceiptJson.addEntries([MapEntry('ownerId', ownerId)]);
      await databaseReceipt.insert(toCreateReceiptJson).select('*').single();

      return Right(toCreateReceipt);
    } catch (e) {
      logger.e(e);
      return left(GeneralFailure(customMessage: 'Beim Erstellen des Dokuments ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, List<Receipt>>> createPosReceipts(Receipt receipt) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final databaseAppointment = getReceiptDatabase(ReceiptType.appointment);
    final databaseDeliveryNote = getReceiptDatabase(ReceiptType.deliveryNote);
    final databaseInvoice = getReceiptDatabase(ReceiptType.invoice);

    final genAppointmentId = UniqueID().value;
    final genDeliveryNoteId = UniqueID().value;
    final genInvoiceId = UniqueID().value;

    try {
      final fosSettings = await mainSettingsRepository.getSettings();
      if (fosSettings.isLeft()) return Left(fosSettings.getLeft());
      final settings = fosSettings.getRight();

      final toCreateAppointment = receipt.copyWith(
        id: genAppointmentId,
        receiptId: genAppointmentId,
        appointmentId: settings.nextAppointmentNumber,
        appointmentNumberAsString: settings.appointmentPraefix + settings.nextAppointmentNumber.toString(),
        deliveryNoteId: settings.nextDeliveryNoteNumber,
        deliveryNoteNumberAsString: settings.deliveryNotePraefix + settings.nextDeliveryNoteNumber.toString(),
        invoiceId: settings.nextInvoiceNumber,
        invoiceNumberAsString: settings.invoicePraefix + settings.nextInvoiceNumber.toString(),
        receiptTyp: ReceiptType.appointment,
        appointmentStatus: AppointmentStatus.completed,
        paymentStatus: PaymentStatus.paid,
        listOfReceiptProduct: receipt.listOfReceiptProduct.map((e) => e.copyWith(shippedQuantity: e.quantity)).toList(),
        creationDateInt: DateTime.now().microsecondsSinceEpoch,
      );

      final phToCreateDeliveryNote = Receipt.fromAppointmentGenDeliveryNote(
        appointment: toCreateAppointment,
        settings: settings,
        nextDeliveryNoteNumber: settings.nextDeliveryNoteNumber,
        nextInvoiceNumber: settings.nextInvoiceNumber,
        generateInvoice: true,
      );
      final toCreateDeliveryNote = phToCreateDeliveryNote.copyWith(id: genDeliveryNoteId);

      final phToCreateInvoice = Receipt.fromAppointmentGenInvoice(
        appointment: toCreateAppointment,
        settings: settings,
        nextDeliveryNoteNumber: settings.nextDeliveryNoteNumber,
        nextInvoiceNumber: settings.nextInvoiceNumber,
        generateDeliveryNote: true,
      );
      final toCreateInvoice = phToCreateInvoice.copyWith(id: genInvoiceId);

      //* Artikelbestände anpassen START
      for (final receiptProduct in receipt.listOfReceiptProduct) {
        if (!receiptProduct.isFromDatabase) continue;

        //* Update product stocks in database and marketplaces
        final fosUpdateProductStock = await updateProductQuantityInDbAndMps(
          productId: receiptProduct.productId,
          incQuantity: receiptProduct.quantity * -1,
          updateOnlyAvailableQuantity: false,
        );
        if (fosUpdateProductStock.isLeft()) return Left(fosUpdateProductStock.getLeft());
      }
      //? Artikelbestände anpassen ENDE

      final toCreateAppointmentJson = toCreateAppointment.toJson();
      toCreateAppointmentJson.addEntries([MapEntry('ownerId', ownerId)]);
      await databaseAppointment.insert(toCreateAppointmentJson);

      final toCreateDeliveryNoteJson = toCreateDeliveryNote.toJson();
      toCreateDeliveryNoteJson.addEntries([MapEntry('ownerId', ownerId)]);
      await databaseDeliveryNote.insert(toCreateDeliveryNoteJson);

      final toCreateInvoiceJson = toCreateInvoice.toJson();
      toCreateInvoiceJson.addEntries([MapEntry('ownerId', ownerId)]);
      await databaseInvoice.insert(toCreateInvoiceJson);

      return Right([toCreateAppointment, toCreateDeliveryNote, toCreateInvoice]);
    } catch (e) {
      logger.e(e);
      return left(GeneralFailure(customMessage: 'Beim Erstellen des Dokuments ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, List<Receipt>>> getListOfReceipts(int value, ReceiptType receiptTyp, {bool sortOutDeliveryBlocked = false}) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final offersQuery = getReceiptDatabase(receiptTyp).select().eq('ownerId', ownerId).eq('receiptTyp', receiptTyp.name);
    final appointmentsQuery = sortOutDeliveryBlocked
        ? getReceiptDatabase(receiptTyp).select().eq('ownerId', ownerId).eq('receiptTyp', receiptTyp.name).eq('isDeliveryBlocked', false)
        : getReceiptDatabase(receiptTyp).select().eq('ownerId', ownerId).eq('receiptTyp', receiptTyp.name);
    final deliveryNotesQuery = getReceiptDatabase(receiptTyp).select().eq('ownerId', ownerId).eq('receiptTyp', receiptTyp.name);
    final invoicesQuery = getReceiptDatabase(receiptTyp).select().eq('ownerId', ownerId);

    final query = value != 0
        ? switch (receiptTyp) {
            ReceiptType.offer => offersQuery.order('offerId'),
            ReceiptType.appointment => appointmentsQuery.order('appointmentId'),
            ReceiptType.deliveryNote => deliveryNotesQuery.order('deliveryNoteId'),
            ReceiptType.invoice || ReceiptType.credit => invoicesQuery.order('invoiceId'),
          }
        : switch (receiptTyp) {
            ReceiptType.offer => offersQuery.eq('offerStatus', OfferStatus.open.name),
            ReceiptType.appointment => appointmentsQuery
                .or('appointmentStatus.eq.${AppointmentStatus.open.name},appointmentStatus.eq.${AppointmentStatus.partiallyCompleted.name}'),
            ReceiptType.deliveryNote => deliveryNotesQuery.eq('invoiceId', 0),
            ReceiptType.invoice ||
            ReceiptType.credit =>
              invoicesQuery.or('paymentStatus.eq.${PaymentStatus.open.name},paymentStatus.eq.${PaymentStatus.partiallyPaid.name}'),
          };

    const limit = 990; // Anzahl der Zeilen pro Abfrage
    int offset = 0; // Startposition
    final allReceipts = <Receipt>[];

    try {
      while (true) {
        final response = await query.range(offset, offset + limit - 1);
        if (response.isEmpty) break;

        final listOfReceipts = response.map((e) => Receipt.fromJson(e)).toList();
        allReceipts.addAll(listOfReceipts);

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

        offset += limit; // Offset für die nächste Abfrage erhöhen
      }

      return Right(allReceipts);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Laden der Dokumente ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, int>> getTotalNumberOfReceiptsBySearchText({
    required ReceiptType receiptType,
    required int tabIndex,
    required String searchText,
  }) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    try {
      final response = await supabase.rpc('get_d_receipts_count_by_search_text', params: {
        'owner_id': ownerId,
        'receipt_type': receiptType.name,
        'tab_index': tabIndex,
        'search_text': searchText,
      });

      return Right(response);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Laden der Artikel ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, List<Receipt>>> getListOfReceiptsPerPageBySearchText({
    required int tabIndex,
    required ReceiptType receiptType,
    required String searchText,
    required int currentPage,
    required int itemsPerPage,
  }) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    try {
      final response = await supabase.rpc('get_receipts_by_search_text', params: {
        'owner_id': ownerId,
        'receipt_type': receiptType.name,
        'tab_index': tabIndex,
        'search_text': searchText,
        'current_page': currentPage,
        'items_per_page': itemsPerPage,
      });

      if (response.isEmpty) return const Right([]);

      final listOfReceipts = (response as List<dynamic>).map((e) {
        final item = e as Map<String, dynamic>;
        return Receipt.fromJson(item);
      }).toList();

      return Right(listOfReceipts);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Laden der Dokumente ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, List<Receipt>>> getListOfReceiptsBetweenDates({
    required DateTimeRange dates,
    required ReceiptType receiptType,
  }) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final startDate = dates.start.toConvertedYearMonthDay();
    final endDate = dates.end.add(const Duration(days: 1)).toConvertedYearMonthDay();

    try {
      final response = await supabase.rpc('get_all_receipts_between_dates', params: {
        'owner_id': ownerId,
        'receipt_type': receiptType.name,
        'start_date': startDate,
        'end_date': endDate,
      });

      if (response.isEmpty) return const Right([]);

      final listOfReceipts = (response as List<dynamic>).map((e) {
        final item = e as Map<String, dynamic>;
        return Receipt.fromJson(item);
      }).toList();

      return Right(listOfReceipts);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Laden der Dokumente ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, List<Receipt>>> getListOfReceiptsByCustomerId(String customerId) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    try {
      final response = await supabase.rpc('get_all_receipts_by_customer_id', params: {
        'owner_id': ownerId,
        'customer_id': customerId,
      });

      if (response.isEmpty) return const Right([]);

      final listOfReceipts = (response as List<dynamic>).map((e) {
        final item = e as Map<String, dynamic>;
        return Receipt.fromJson(item);
      }).toList();

      return Right(listOfReceipts);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Laden der Dokumente ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, List<Receipt>>> getListOfReceiptsByReceiptId(String receiptId) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    try {
      final response = await supabase.rpc('get_receipts_with_same_receipt_id', params: {
        'owner_id': ownerId,
        'receipt_id': receiptId,
      });

      if (response.isEmpty) return const Right([]);

      final listOfReceipts = (response as List<dynamic>).map((e) {
        final item = e as Map<String, dynamic>;
        return Receipt.fromJson(item);
      }).toList();

      return Right(listOfReceipts);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Laden der Dokumente ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, Unit>> deleteListOfReceipts(List<Receipt> listOfReceipts) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final receiptTyp = listOfReceipts.first.receiptTyp;

    try {
      for (final receipt in listOfReceipts) {
        final receiptType = receipt.receiptTyp;
        final database = getReceiptDatabase(receiptTyp);

        if (receiptType == ReceiptType.appointment || receiptType == ReceiptType.deliveryNote || receiptType == ReceiptType.invoice) {
          for (final receiptProduct in receipt.listOfReceiptProduct) {
            if (!receiptProduct.isFromDatabase) continue;

            //* Update product stocks in datababase and marketplaces
            await updateProductQuantityInDbAndMps(
              productId: receiptProduct.productId,
              incQuantity: receiptProduct.quantity,
              updateOnlyAvailableQuantity: receiptType == ReceiptType.appointment ? true : false,
            );
          }
        }

        await database.delete().eq('ownerId', ownerId).eq('id', receipt.id);
      }

      return const Right(unit);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Löschen der Dokumente ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, List<Receipt>>> generateFromListOfOffersNewAppointments(List<Receipt> listOfOffers) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    List<Receipt> generatedAppointments = [];

    try {
      final fosSettings = await mainSettingsRepository.getSettings();
      if (fosSettings.isLeft()) return Left(fosSettings.getLeft());
      final settings = fosSettings.getRight();

      int nextAppointmentNumber = settings.nextAppointmentNumber;

      AbstractMarketplace? marketplace;

      for (final offer in listOfOffers) {
        if (marketplace == null) {
          final fosMarketplace = await marketplaceRepository.getMarketplace(offer.marketplaceId);
          if (fosMarketplace.isRight()) marketplace = fosMarketplace.getRight();
        } else {
          if (offer.marketplaceId != marketplace.id) {
            final fosMarketplace = await marketplaceRepository.getMarketplace(offer.marketplaceId);
            if (fosMarketplace.isRight()) marketplace = fosMarketplace.getRight();
          }
        }

        Receipt updatedOffer = offer.copyWith(offerStatus: OfferStatus.closed, lastEditingDate: DateTime.now());
        final phAppointment = Receipt.fromOfferGenAppointment(offer: updatedOffer, settings: settings, nextAppointmentNumber: nextAppointmentNumber);

        final genId = UniqueID().value;
        final appointment = phAppointment.copyWith(id: genId);
        final appointmentJson = appointment.toJson();
        appointmentJson.addEntries([MapEntry('ownerId', ownerId)]);
        await getReceiptDatabase(phAppointment.receiptTyp).insert(appointmentJson);

        nextAppointmentNumber += 1;
        generatedAppointments.add(appointment);
        final generatedAppointmentFromThisOffer = appointment;
        updatedOffer = updatedOffer.copyWith(
          appointmentId: appointment.appointmentId,
          appointmentNumberAsString: appointment.appointmentNumberAsString,
        );

        await getReceiptDatabase(updatedOffer.receiptTyp).update(updatedOffer.toJson()).eq('ownerId', ownerId).eq('id', updatedOffer.id);

        for (final receiptProduct in offer.listOfReceiptProduct) {
          if (!receiptProduct.isFromDatabase) continue;

          await updateProductQuantityInDbAndMps(
            productId: receiptProduct.productId,
            incQuantity: receiptProduct.quantity * -1,
            updateOnlyAvailableQuantity: true,
          );
        }
        if (marketplace != null) await sendCustomerEmailsOnCreateReceipts([generatedAppointmentFromThisOffer], marketplace);
      }

      return Right(generatedAppointments);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Generieren von Aufträgen aus Angeboten ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, List<Receipt>>> generateFromListOfAppointments(
    List<Receipt> listOfReceipts,
    bool generateDeliveryNote,
    bool generateInvoice,
  ) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    List<Receipt> generatedReceipts = [];

    try {
      final fosSettings = await mainSettingsRepository.getSettings();
      if (fosSettings.isLeft()) return Left(fosSettings.getLeft());
      final settings = fosSettings.getRight();

      int nextDeliveryNoteNumber = settings.nextDeliveryNoteNumber;
      int nextInvoiceNumber = settings.nextInvoiceNumber;

      AbstractMarketplace? marketplace;

      for (final receipt in listOfReceipts) {
        if (marketplace == null) {
          final fosMarketplace = await marketplaceRepository.getMarketplace(receipt.marketplaceId);
          if (fosMarketplace.isRight()) marketplace = fosMarketplace.getRight();
        } else {
          if (receipt.marketplaceId != marketplace.id) {
            final fosMarketplace = await marketplaceRepository.getMarketplace(receipt.marketplaceId);
            if (fosMarketplace.isRight()) marketplace = fosMarketplace.getRight();
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

          final genDNId = UniqueID().value;
          final deliveryNote = phDeliveryNote.copyWith(id: genDNId);
          final deliveryNoteJson = deliveryNote.toJson();
          deliveryNoteJson.addEntries([MapEntry('ownerId', ownerId)]);
          await getReceiptDatabase(phDeliveryNote.receiptTyp).insert(deliveryNoteJson);

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

          final genIId = UniqueID().value;
          final invoice = phInvoice.copyWith(id: genIId);
          final invoiceJson = invoice.toJson();
          invoiceJson.addEntries([MapEntry('ownerId', ownerId)]);
          await getReceiptDatabase(phInvoice.receiptTyp).insert(invoiceJson);

          generatedReceipts.add(invoice);
          generatedReceiptsFromThisReceipt.add(invoice);
          appointment = appointment.copyWith(
            invoiceId: invoice.invoiceId,
            invoiceNumberAsString: invoice.invoiceNumberAsString,
          );
        }

        nextDeliveryNoteNumber += 1;
        nextInvoiceNumber += 1;

        await getReceiptDatabase(appointment.receiptTyp).update(appointment.toJson()).eq('ownerId', ownerId).eq('id', appointment.id);

        for (final receiptProduct in receipt.listOfReceiptProduct) {
          if (!receiptProduct.isFromDatabase) continue;

          await productRepository.updateProductWarehouseStock(receiptProduct.productId, receiptProduct.quantity * -1);
        }

        if (marketplace != null) await sendCustomerEmailsOnCreateReceipts(generatedReceiptsFromThisReceipt, marketplace);

        //* Neuen Bestellstatus im Marktplatz setzen
        if (marketplace != null) {
          final fosOrderStatus = await marketplaceEditRepository.setOrderStatusInMarketplace(
            marketplace,
            receipt.receiptMarketplaceId,
            OrderStatusUpdateType.onShipping,
            null,
          );
          fosOrderStatus.fold(
            (failure) => logger.e('Bestellstatus für Bestellung mit der ID: ${receipt.receiptMarketplaceId} konnte nicht gesetzt werden'),
            (unit) => logger.i('Bestellstatus für die Bestellung mit der ID: ${receipt.receiptMarketplaceId} wurde erfolgreich aktualisiert'),
          );
        }
      }

      return Right(generatedReceipts);
    } catch (e) {
      logger.e(e);
      return left(
        GeneralFailure(customMessage: 'Beim Generieren von Lieferscheinen und/oder Rechnungen aus Aufträgen ist ein Fehler aufgetreten. Error: $e'),
      );
    }
  }

  @override
  Future<Either<AbstractFailure, List<Receipt>>> generateFromAppointment(
    Receipt incomingAppointment,
    Receipt originalAppointment,
    bool generateDeliveryNote,
    bool generateInvoice,
  ) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    List<Receipt> generatedReceipts = [];

    final isCompletelyPacked = incomingAppointment.listOfReceiptProduct.every((e) => e.shippedQuantity == e.quantity);
    final isCompletelyPackedInOnePart = originalAppointment.appointmentStatus == AppointmentStatus.open && isCompletelyPacked;

    try {
      final fosSettings = await mainSettingsRepository.getSettings();
      if (fosSettings.isLeft()) return Left(fosSettings.getLeft());
      final settings = fosSettings.getRight();

      int nextDeliveryNoteNumber = settings.nextDeliveryNoteNumber;
      int nextInvoiceNumber = settings.nextInvoiceNumber;

      final fosMarketplace = await marketplaceRepository.getMarketplace(originalAppointment.marketplaceId);
      if (fosMarketplace.isLeft()) return Left(fosMarketplace.getLeft());
      final marketplace = fosMarketplace.getRight();

      ParcelTracking? parcelTracking;
      if (generateDeliveryNote) {
        parcelTracking = await getParcelTracking(ownerId, incomingAppointment, settings, nextDeliveryNoteNumber);
      }
      final isSuccessfulSetParcelTracking =
          parcelTracking != null && parcelTracking.deliveryNoteId != 0 && parcelTracking.trackingNumber != '' && parcelTracking.trackingUrl != '';

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
              listOfParcelTracking: isSuccessfulSetParcelTracking ? [parcelTracking] : [],
              lastEditingDate: DateTime.now(),
            )
          : originalAppointment.copyWith(
              appointmentStatus: updatedOriginalAppointmentProducts.every((e) => e.shippedQuantity == e.quantity)
                  ? AppointmentStatus.completed
                  : AppointmentStatus.partiallyCompleted,
              listOfParcelTracking: isSuccessfulSetParcelTracking
                  ? [...originalAppointment.listOfParcelTracking, parcelTracking]
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

        final database = getReceiptDatabase(phDeliveryNote.receiptTyp);
        final deliveryNote = phDeliveryNote.copyWith(
          id: UniqueID().value,
          listOfParcelTracking: isSuccessfulSetParcelTracking ? [parcelTracking] : [],
          packagingBox: phDeliveryNote.packagingBox != null && phDeliveryNote.packagingBox!.name != ''
              ? phDeliveryNote.packagingBox!.copyWith(deliveryNoteId: nextDeliveryNoteNumber)
              : phDeliveryNote.packagingBox,
        );

        final deliveryNoteJson = deliveryNote.toJson();
        deliveryNoteJson.addEntries([MapEntry('ownerId', ownerId)]);
        await database.insert(deliveryNoteJson);

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

        final genId = UniqueID().value;
        final database = getReceiptDatabase(phInvoice.receiptTyp);
        final invoice = phInvoice.copyWith(
          id: genId,
          listOfParcelTracking: isSuccessfulSetParcelTracking ? [parcelTracking] : [],
        );

        final invoiceJson = invoice.toJson();
        invoiceJson.addEntries([MapEntry('ownerId', ownerId)]);
        await database.insert(invoiceJson);

        generatedReceipts.add(invoice);
        originalAppointmentToUpdate = originalAppointmentToUpdate.copyWith(
          invoiceId: invoice.invoiceId,
          invoiceNumberAsString: invoice.invoiceNumberAsString,
        );
      }

      final databaseUpdateOriginal = getReceiptDatabase(originalAppointmentToUpdate.receiptTyp);
      await databaseUpdateOriginal.update(originalAppointmentToUpdate.toJson()).eq('ownerId', ownerId).eq('id', originalAppointment.id);

      for (final receiptProduct
          in isCompletelyPackedInOnePart ? originalAppointment.listOfReceiptProduct : incomingAppointment.listOfReceiptProduct) {
        if (!receiptProduct.isFromDatabase) continue;

        await productRepository.updateProductWarehouseStock(
          receiptProduct.productId,
          isCompletelyPackedInOnePart ? receiptProduct.quantity * -1 : receiptProduct.shippedQuantity * -1,
        );
      }

      final isSuccessfulSent = await sendCustomerEmailsOnCreateReceipts(generatedReceipts, marketplace);
      if (isSuccessfulSent) {
        logger.i('Alle E-Mails wurden erfolgreich verschickt.');
      } else {
        logger.e('Eine oder meherer E-Mails konnten nicht verschickt werden!');
      }

      //* Neuen Bestellstatus im Marktplatz setzen
      switch (marketplace.marketplaceType) {
        case MarketplaceType.prestashop:
          {
            final fosOrderStatus = await marketplaceEditRepository.setOrderStatusInMarketplace(
              marketplace as MarketplacePresta,
              originalAppointment.receiptMarketplaceId,
              OrderStatusUpdateType.onShipping,
              isSuccessfulSetParcelTracking ? parcelTracking : null,
            );
            fosOrderStatus.fold(
              (failure) =>
                  logger.e('Bestellstatus für Bestellung mit der ID: ${originalAppointment.receiptMarketplaceId} konnte nicht gesetzt werden'),
              (unit) =>
                  logger.i('Bestellstatus für die Bestellung mit der ID: ${originalAppointment.receiptMarketplaceId} wurde erfolgreich aktualisiert'),
            );
          }
        case MarketplaceType.shopify:
          {
            final fosOrderStatus = await marketplaceEditRepository.setOrderStatusInMarketplace(
              marketplace as MarketplaceShopify,
              originalAppointment.receiptMarketplaceId,
              OrderStatusUpdateType.onShipping,
              isSuccessfulSetParcelTracking ? parcelTracking : null,
            );
            fosOrderStatus.fold(
              (failure) =>
                  logger.e('Bestellstatus für Bestellung mit der ID: ${originalAppointment.receiptMarketplaceId} konnte nicht gesetzt werden'),
              (unit) =>
                  logger.i('Bestellstatus für die Bestellung mit der ID: ${originalAppointment.receiptMarketplaceId} wurde erfolgreich aktualisiert'),
            );
          }
        case MarketplaceType.shop:
      }

      return Right(generatedReceipts);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(
        customMessage: 'Beim Generieren von einem Lieferschein und/oder Rechnung aus einem Auftrag ist ein Fehler aufgetreten. Error: $e',
      ));
    }
  }

  @override
  Future<Either<AbstractFailure, Receipt>> generateFromListOfDeliveryNotesNewInvoice(List<Receipt> listOfDeliveryNotes) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    try {
      final fosSettings = await mainSettingsRepository.getSettings();
      if (fosSettings.isLeft()) return Left(fosSettings.getLeft());
      final settings = fosSettings.getRight();

      final fosMarketplace = await marketplaceRepository.getMarketplace(listOfDeliveryNotes.first.marketplaceId);
      if (fosMarketplace.isLeft()) return Left(fosMarketplace.getLeft());
      final marketplace = fosMarketplace.getRight();

      final phInvoice = Receipt.fromDeliveryNotesGenInvoice(deliveryNotes: listOfDeliveryNotes, settings: settings);
      final invoice = phInvoice.copyWith(id: UniqueID().value);

      final database = getReceiptDatabase(phInvoice.receiptTyp);
      final invoiceJson = invoice.toJson();
      invoiceJson.addEntries([MapEntry('ownerId', ownerId)]);
      await database.insert(invoiceJson);

      final generatedReceipt = invoice;

      for (final deliveryNote in listOfDeliveryNotes) {
        final updatedDeliveryNote = deliveryNote.copyWith(
          invoiceId: invoice.invoiceId,
          invoiceNumberAsString: invoice.invoiceNumberAsString,
          lastEditingDate: DateTime.now(),
        );

        final dbDeliveryNote = getReceiptDatabase(deliveryNote.receiptTyp);
        await dbDeliveryNote.update(updatedDeliveryNote.toJson()).eq('ownerId', ownerId).eq('id', deliveryNote.id);
      }

      final isSuccessfulSent = await sendCustomerEmailsOnCreateReceipts([generatedReceipt], marketplace);
      if (isSuccessfulSent) {
        logger.i('Alle E-Mails wurden erfolgreich verschickt.');
      } else {
        logger.e('Eine oder meherer E-Mails konnten nicht verschickt werden!');
      }

      return Right(generatedReceipt);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Generieren von Rechnungen aus Lieferscheinen ist ein Fehler aufgetreten'));
    }
  }

  @override
  Future<Either<AbstractFailure, Receipt>> generateFromInvoiceNewCredit(Receipt invoice, bool setQuantity) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    try {
      final fosSettings = await mainSettingsRepository.getSettings();
      if (fosSettings.isLeft()) return Left(fosSettings.getLeft());
      final settings = fosSettings.getRight();

      final nextInvoiceNumber = settings.nextInvoiceNumber;

      final fosMarketplace = await marketplaceRepository.getMarketplace(invoice.marketplaceId);
      if (fosMarketplace.isLeft()) return Left(fosMarketplace.getLeft());
      final marketplace = fosMarketplace.getRight();

      Receipt updatedInvoice = invoice.copyWith(lastEditingDate: DateTime.now());

      final phCredit = Receipt.fromInvoiceGenCredit(
        invoice: updatedInvoice,
        settings: settings,
        nextInvoiceNumber: nextInvoiceNumber,
      );

      final credit = phCredit.copyWith(id: UniqueID().value);

      final database = getReceiptDatabase(phCredit.receiptTyp);
      final creditJson = credit.toJson();
      creditJson.addEntries([MapEntry('ownerId', ownerId)]);
      await database.insert(creditJson);

      final databaseUpdatedInvoice = getReceiptDatabase(updatedInvoice.receiptTyp);
      await databaseUpdatedInvoice.update(updatedInvoice.toJson()).eq('ownerId', ownerId).eq('id', updatedInvoice.id);

      if (setQuantity) {
        for (final receiptProduct in credit.listOfReceiptProduct) {
          if (!receiptProduct.isFromDatabase) continue;

          await updateProductQuantityInDbAndMps(
            productId: receiptProduct.productId,
            incQuantity: receiptProduct.quantity,
            updateOnlyAvailableQuantity: false,
          );
        }
      }
      await sendCustomerEmailsOnCreateReceipts([credit], marketplace);

      return Right(credit);
    } catch (e) {
      logger.e(e);
      return left(GeneralFailure(customMessage: 'Beim Generieren von einer Gutschrift aus einer Rechnung ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, ParcelTracking>> createNewParcelForReceipt(Receipt deliveryNote, double weight) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final database = getReceiptDatabase(deliveryNote.receiptTyp);

    try {
      final fosDeliveryNote = await getReceipt(deliveryNote.id, deliveryNote.receiptTyp);
      if (fosDeliveryNote.isLeft()) return Left(fosDeliveryNote.getLeft());
      final loadedDeliveryNote = fosDeliveryNote.getRight();

      final fosSettings = await mainSettingsRepository.getSettings();
      if (fosSettings.isLeft()) return Left(fosSettings.getLeft());
      final settings = fosSettings.getRight();

      final fosMarketplace = await marketplaceRepository.getMarketplace(deliveryNote.marketplaceId);
      if (fosMarketplace.isLeft()) return Left(fosMarketplace.getLeft());
      final marketplace = fosMarketplace.getRight();

      final parcelTracking = await getParcelTracking(ownerId, loadedDeliveryNote, settings, loadedDeliveryNote.deliveryNoteId, weight: weight);
      if (parcelTracking == null) return left(GeneralFailure(customMessage: 'Paketlabel konnte nicht erstellt werden'));

      final List<ParcelTracking> listOfUpdatedParcelTracking = loadedDeliveryNote.listOfParcelTracking;
      listOfUpdatedParcelTracking.add(parcelTracking);
      final updatedDeliveryNote = loadedDeliveryNote.copyWith(listOfParcelTracking: listOfUpdatedParcelTracking);

      await database.update(updatedDeliveryNote.toJson()).eq('ownerId', ownerId).eq('id', deliveryNote.id);

      await sendCustomerEmailsOnCreateReceipts([updatedDeliveryNote], marketplace);

      return Right(parcelTracking);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Erstellen eines Versandlabels ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, List<ToLoadAppointmentsFromMarketplace>>> getToLoadAppointmentsFromMarketplaces() async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());

    try {
      List<ToLoadAppointmentsFromMarketplace> listOfToLoadAppointmentsFromMarketplace = [];

      final fosListOfActiveMarketplaces = await marketplaceRepository.getListOfMarketplaces(onlyActive: true);
      if (fosListOfActiveMarketplaces.isLeft()) return Left(fosListOfActiveMarketplaces.getLeft());
      final listOfActiveMarketplaces = fosListOfActiveMarketplaces.getRight().where((e) => e.marketplaceType != MarketplaceType.shop).toList();

      for (final marketplace in listOfActiveMarketplaces) {
        if (!marketplace.isActive) continue;

        switch (marketplace.marketplaceType) {
          case MarketplaceType.prestashop:
            {
              final api = PrestashopApi(
                Client(),
                PrestashopApiConfig(apiKey: (marketplace as MarketplacePresta).key, webserviceUrl: marketplace.fullUrl),
              );
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
          case MarketplaceType.shopify:
            {
              final toLoadAppointmentsFromMarketplace = ToLoadAppointmentsFromMarketplace(
                marketplace: marketplace as MarketplaceShopify,
                nextIdToImport: 0,
                lastIdToImport: 0,
              );
              listOfToLoadAppointmentsFromMarketplace.add(toLoadAppointmentsFromMarketplace);
            }
          case MarketplaceType.shop:
            {
              throw Exception('SHOP not implemented');
            }
        }
      }
      return Right(listOfToLoadAppointmentsFromMarketplace);
    } catch (e) {
      logger.e('Fehler beim laden der zu ladenden Aufträge von Marktplätzen: $e');
      return Left(GeneralFailure(customMessage: 'Fehler beim laden der zu ladenden Aufträge von Marktplätzen: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, LoadedOrderFromMarketplace>> loadAppointmentsFromMarketplacePresta(
    ToLoadAppointmentFromMarketplace toLoadAppointment,
  ) async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());

    final marketplace = toLoadAppointment.marketplace as MarketplacePresta;
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

      return Right(loadedOrderFromMarketplace);
    } catch (e) {
      logger.e('Fehler beim laden der Aufträge von Marktplätzen: $e');
      return Left(PrestaGeneralFailure(errorMessage: 'Fehler beim laden der Aufträge von Marktplätzen: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, List<LoadedOrderFromMarketplace>>> loadAppointmentsFromMarketplaceShopify(
    ToLoadAppointmentsFromMarketplace toLoadAppointments,
  ) async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());

    final marketplace = toLoadAppointments.marketplace as MarketplaceShopify;
    logger.i(marketplace.name);
    final api = ShopifyApi(
      ShopifyApiConfig(storefrontToken: marketplace.storefrontAccessToken, adminToken: marketplace.adminAccessToken),
      marketplace.fullUrl,
    );

    AbstractFailure? abstractFailure;
    final List<LoadedOrderFromMarketplace> loadedOrders = [];

    // try {
    final fosOrders = await api.getOrdersByCreatedAtMin(toLoadAppointments.marketplace.marketplaceSettings.lastImportDateTime);
    fosOrders.fold(
      (failure) => abstractFailure = failure,
      (orders) {
        for (final order in orders) {
          loadedOrders.add(LoadedOrderFromMarketplace(marketplace: marketplace, orderShopify: order, orderMarketplaceId: order.id));
        }
      },
    );

    if (abstractFailure != null) return Left(abstractFailure!);
    return Right(loadedOrders);
    // } catch (e) {
    //   logger.e('Fehler beim laden der Aufträge von Marktplätzen: $e');
    //   return left(PrestaGeneralFailure(errorMessage: 'Fehler beim laden der Aufträge von Marktplätzen: $e'));
    // }
  }

  @override
  Future<Either<AbstractFailure, Receipt>> uploadLoadedAppointmentToDatabase(LoadedOrderFromMarketplace loadedAppointmentFromMarketplace) async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final now = DateTime.now();
    final marketplace = loadedAppointmentFromMarketplace.marketplace;

    // final orderPresta = loadedAppointmentFromMarketplace.orderPresta!;
    final orderMarketplaceId = switch (loadedAppointmentFromMarketplace.marketplace.marketplaceType) {
      MarketplaceType.prestashop => loadedAppointmentFromMarketplace.orderPresta!.id,
      MarketplaceType.shopify => loadedAppointmentFromMarketplace.orderShopify!.id,
      MarketplaceType.shop => 0,
    };

    Receipt? receiptToReturn;
    //* Überprüft, ob die aus dem Marktplatz geladene Bestellung bereits in Firebase Firestore hinterlegt ist
    try {
      final queryReceipt =
          await getReceiptDatabase(ReceiptType.appointment).select().eq('ownerId', ownerId).eq('receiptMarketplaceId', orderMarketplaceId);
      if (queryReceipt.isNotEmpty) {
        logger.e('Vom Marktplatz geladene Bestellung ist bereits in Firestore vorhanden');
        return Left(GeneralFailure(customMessage: 'Vom Marktplatz geladene Bestellung ist bereits in der Datenbank vorhanden'));
      }
    } catch (e) {
      null;
    }

    final fosSettings = await mainSettingsRepository.getSettings();
    if (fosSettings.isLeft()) return Left(fosSettings.getLeft());
    final mainSettings = fosSettings.getRight();

    Receipt? phAppointment;

    switch (loadedAppointmentFromMarketplace.marketplace.marketplaceType) {
      case MarketplaceType.prestashop:
        {
          final fosReceipt = await createReceiptFromOrderPresta(
            ownerId,
            productRepository,
            customerRepository,
            marketplaceEditRepository,
            mainSettings,
            marketplace as MarketplacePresta,
            loadedAppointmentFromMarketplace.orderPresta!,
            loadedAppointmentFromMarketplace,
          );

          if (fosReceipt.isLeft()) return Left(fosReceipt.getLeft());
          final receipt = fosReceipt.getRight();
          phAppointment = receipt;
        }
      case MarketplaceType.shopify:
        {
          final fosReceipt = await createReceiptFromOrderShopify(
            productRepository,
            customerRepository,
            mainSettings,
            marketplace as MarketplaceShopify,
            loadedAppointmentFromMarketplace.orderShopify!,
          );

          if (fosReceipt.isLeft()) return Left(fosReceipt.getLeft());
          final receipt = fosReceipt.getRight();
          phAppointment = receipt;
        }
      case MarketplaceType.shop:
        throw Exception('Aus einem Ladengeschäft können keine Bestellungen geladen werden.');
    }

    try {
      final genAppId = UniqueID().value;
      final appointment = phAppointment.copyWith(id: genAppId, receiptId: genAppId);
      final appointmentJson = appointment.toJson();
      appointmentJson.addEntries([MapEntry('ownerId', ownerId)]);
      final createdAppointmentResponse = await getReceiptDatabase(ReceiptType.appointment).insert(appointmentJson).select('*').single();
      final createdAppointment = Receipt.fromJson(createdAppointmentResponse);
      receiptToReturn = createdAppointment;

      switch (marketplace.marketplaceType) {
        case MarketplaceType.prestashop:
          {
            final updatedMarketplace = (marketplace as MarketplacePresta).copyWith(
              marketplaceSettings: marketplace.marketplaceSettings.copyWith(
                nextIdToImport: loadedAppointmentFromMarketplace.orderMarketplaceId + 1,
                lastImportDateTime: now,
              ),
            );
            await marketplaceRepository.updateMarketplace(updatedMarketplace, null);
          }
        case MarketplaceType.shopify:
          {
            final updatedMarketplace = (marketplace as MarketplaceShopify).copyWith(
              marketplaceSettings: marketplace.marketplaceSettings.copyWith(lastImportDateTime: now),
            );
            await marketplaceRepository.updateMarketplace(updatedMarketplace, null);
          }
        case MarketplaceType.shop:
          throw Exception('Aus einem Ladengeschäft können keine Aufträge importiert und in die Datenbank hochgeladen werden.');
      }
    } catch (e) {
      return Left(GeneralFailure(customMessage: '$e'));
    }
    return Right(receiptToReturn);
  }
}

String fillPlaceholder(Receipt receipt, String value) {
  ParcelTracking? parceltracking;
  final isParceltrackingGiven = receipt.receiptTyp == ReceiptType.deliveryNote && receipt.listOfParcelTracking.isNotEmpty;
  if (isParceltrackingGiven) {
    List<ParcelTracking> listOfParcels = receipt.listOfParcelTracking;
    listOfParcels.sort((a, b) => a.trackingNumber.compareTo(b.trackingNumber));
    parceltracking = listOfParcels.last;
  }

  String newValue = value.replaceAll(
    '{receiptNumber}',
    switch (receipt.receiptTyp) {
      ReceiptType.offer => receipt.offerNumberAsString,
      ReceiptType.appointment => receipt.appointmentNumberAsString,
      ReceiptType.deliveryNote => receipt.deliveryNoteNumberAsString,
      ReceiptType.invoice => receipt.invoiceNumberAsString,
      ReceiptType.credit => receipt.creditNumberAsString,
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

Future<bool> sendCustomerEmailsOnCreateReceipts(List<Receipt> listOfReceipts, AbstractMarketplace marketplace) async {
  bool isSuccess = false;
  for (final receipt in listOfReceipts) {
    switch (receipt.receiptTyp) {
      case ReceiptType.offer:
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
      case ReceiptType.appointment:
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
      case ReceiptType.deliveryNote:
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
      case ReceiptType.invoice:
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
      case ReceiptType.credit:
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

  // TODO: auskommentierte Löschen, wenn der E-Mail Versand problemlos funktioniert
  // HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('sendEmail');

  // try {
  //   final response = await callable.call({
  //     'to': to,
  //     'from': from,
  //     'subject': subject,
  //     // 'text': text,
  //     'html': html,
  //     'bcc': bcc,
  //     'attachment': attachmentBase64,
  //     'filename': filename ?? 'attachment.pdf',
  //   });
  //   logger.i('E-Mail gesendet: ${response.data}');
  //   isSuccess = true;
  // } catch (e) {
  //   logger.e('Fehler beim Senden der E-Mail: $e');
  //   isSuccess = false;
  // }

  try {

  final response = await supabase.functions.invoke(
    'send_email',
    body: jsonEncode({
      'to': to,
      'from': from,
      'subject': subject,
      'html': html,
      'bcc': bcc,
      'attachment': attachmentBase64,
      'filename': filename,
    }),
  );

  print('######## $response ##########');

  // if (response.statusCode == 200) {
  //   print('E-Mail erfolgreich gesendet');
  //   isSuccess = true;
  // } else {
  //   print('Fehler beim Senden der E-Mail: ${response.statusCode}');
  //   print('Antwort: ${response.body}');
  //   isSuccess = false;
  // }
  } catch (e) {
    print('Error on Edge Function: send_email: $e');
    isSuccess = false;
  }

  return isSuccess;
}

Future<ParcelTracking?> getParcelTracking(String ownerId, Receipt receipt, MainSettings ms, int deliveryNoteNumber, {double? weight}) async {
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
    weight ?? receipt.weight,
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

  final trackingNumberTupel = service.getTrackingNumber(responseString);
  final trackingNumber = trackingNumberTupel.trackingNumber;
  final trackingNumber2 = trackingNumberTupel.trackingNumber2;
  final trackingUrl = carrier.trackingUrl;
  final trackingUrl2 = carrier.trackingUrl2;

  final pdfString = service.getPdfLabel(responseString);

  final downloadURL = await uploadShippingLabelToStorage(ownerId, receipt.receiptId, pdfString, trackingNumber);

  final parcelTracking = ParcelTracking(
    deliveryNoteId: deliveryNoteNumber,
    trackingUrl: trackingUrl,
    trackingUrl2: trackingUrl2,
    trackingNumber: trackingNumber,
    trackingNumber2: trackingNumber2,
    pdfString: downloadURL ?? '',
  );

  return parcelTracking;
}

Future<String?> uploadShippingLabelToStorage(String ownerId, String receiptId, String pdfString, String trackingNumber) async {
  final pdfBytes = base64.decode(pdfString);

  final filePath = '${getShippingLabelStoragePath(ownerId, receiptId)}/$trackingNumber.pdf';

  try {
    final storageResponse = await supabase.storage.from('shipping-labels').uploadBinary(filePath, pdfBytes);
    logger.i(storageResponse);
  } catch (e) {
    logger.e(e);
    return null;
  }

  final downloadURL = supabase.storage.from('shipping-labels').getPublicUrl(filePath);

  return downloadURL;
}
