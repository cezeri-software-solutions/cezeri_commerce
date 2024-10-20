import 'package:cezeri_commerce/3_domain/entities/incoming_invoice/incoming_invoice.dart';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../1_presentation/core/core.dart';
import '../../../3_domain/entities/id.dart';
import '../../../3_domain/repositories/database/incoming_invoice_repository.dart';
import '../../../3_domain/repositories/database/main_settings_respository.dart';
import '../../../constants.dart';
import '../../../failures/failures.dart';
import 'functions/get_storage_paths.dart';
import 'functions/supabase_storage_functions.dart';
import 'functions/utils_repository_impl.dart';

class IncomingInvoiceRepositoryImpl implements IncomingInvoiceRepository {
  final SupabaseClient supabase;
  final MainSettingsRepository settingsRepository;

  IncomingInvoiceRepositoryImpl({required this.supabase, required this.settingsRepository});

  @override
  Future<Either<AbstractFailure, IncomingInvoice>> createIncomingInvoice(IncomingInvoice incomingInvoice) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    try {
      final fosSettings = await settingsRepository.getSettings();
      if (fosSettings.isLeft()) return Left(fosSettings.getLeft());
      final settings = fosSettings.getRight();

      final uuid = UniqueID().value;

      final invoiceFiles = await uploadIncomingInvoiceFilesToStorageFromFlutter(
        incomingInvoice.listOfIncomingInvoiceFiles,
        getIncomingInvoiceStoragePath(ownerId, uuid),
      );

      final updatedInvoice = incomingInvoice.copyWith(
        id: uuid,
        incomingInvoiceNumber: settings.nextIncomingInvoiceNumber,
        incomingInvoiceNumberAsString: settings.incomingInvoicePraefix + settings.nextIncomingInvoiceNumber.toString(),
        listOfIncomingInvoiceFiles: invoiceFiles,
      );

      final incomingInvoiceJson = updatedInvoice.toJson();
      incomingInvoiceJson.addEntries([MapEntry('owner_id', ownerId)]);

      await supabase.rpc('create_incoming_invoice', params: {'p_invoice': incomingInvoiceJson});

      return Right(updatedInvoice);
    } catch (e) {
      logger.e(e.runtimeType);
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Eingangsrechnung: "${incomingInvoice.invoiceNumber}" konnte nicht erstellt werden. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, IncomingInvoice>> getIncomingInvoice(String id) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    try {
      final response = await supabase.rpc('get_incoming_invoice', params: {'p_id': id, 'p_owner_id': ownerId});

      return Right(IncomingInvoice.fromJson(response));
    } catch (e) {
      logger.e(e.runtimeType);
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Eingangsrechnung konnte nicht erstellt werden. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, int>> getCountOfIncomingInvoices(String searchText) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    try {
      final response = await supabase.rpc('get_count_of_incoming_invoices', params: {'p_owner_id': ownerId, 'search_text': searchText});

      return Right(response);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Laden der Artikel ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, List<IncomingInvoice>>> getListOfIncomingInvoices({
    required String searchText,
    required int currentPage,
    required int itemsPerPage,
  }) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    try {
      final response = await supabase.rpc('get_incoming_invoices', params: {
        'p_owner_id': ownerId,
        'search_text': searchText,
        'current_page': currentPage,
        'items_per_page': itemsPerPage,
      });

      if (response == null) return const Right([]);
      if (response.isEmpty) return const Right([]);

      final listOfIncomingInvoices = (response as List<dynamic>).map((e) {
        final item = e as Map<String, dynamic>;
        return IncomingInvoice.fromJson(item);
      }).toList();

      return Right(listOfIncomingInvoices);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Eingangsrechnungen konnten nicht geladen werden. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, IncomingInvoice>> updateIncomingInvoice(IncomingInvoice incomingInvoice) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<AbstractFailure, Unit>> deleteIncomingInvoice(String id) async {
    throw UnimplementedError();
  }
}
