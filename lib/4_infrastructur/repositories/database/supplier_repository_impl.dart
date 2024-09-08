import 'package:cezeri_commerce/3_domain/entities/reorder/supplier.dart';
import 'package:cezeri_commerce/failures/firebase_failures.dart';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../1_presentation/core/core.dart';
import '../../../3_domain/repositories/database/main_settings_respository.dart';
import '../../../3_domain/repositories/database/supplier_repository.dart';
import '../../../constants.dart';
import '../../../failures/abstract_failure.dart';
import 'functions/repository_functions.dart';

class SupplierRepositoryImpl implements SupplierRepository {
  final SupabaseClient supabase;
  final MainSettingsRepository settingsRepository;

  SupplierRepositoryImpl({required this.supabase, required this.settingsRepository});

  @override
  Future<Either<AbstractFailure, Supplier>> createSupplier(Supplier supplier) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final databaseSuppliers = supabase.from('d_suppliers');

    try {
      final fosSettings = await settingsRepository.getSettings();
      if (fosSettings.isLeft()) return Left(fosSettings.getLeft());

      final supplierJson = supplier.toJson();
      supplierJson.addEntries([MapEntry('ownerId', ownerId)]);
      final supplierResponse = await databaseSuppliers.insert(supplierJson).select('*').single();
      final createdSupplier = Supplier.fromJson(supplierResponse);

      return Right(createdSupplier);
    } catch (e) {
      return Left(GeneralFailure(customMessage: 'Beim Erstellen des Lieferanten ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, Supplier>> getSupplier(String id) async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final query = supabase.from('d_suppliers').select().eq('ownerId', ownerId).eq('id', id).single();

    try {
      final response = await query;

      return right(Supplier.fromJson(response));
    } catch (e) {
      logger.e(e);
      return left(GeneralFailure(customMessage: 'Beim Laden des Lieferanten ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, List<Supplier>>> getListOfSuppliers() async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final query = supabase.from('d_suppliers').select().eq('ownerId', ownerId);

    try {
      final response = await query;
      if (response.isEmpty) return const Right([]);

      final listOfSuppliers = response.map((e) => Supplier.fromJson(e)).toList();

      return Right(listOfSuppliers);
    } catch (e) {
      logger.e(e);
      return left(GeneralFailure(customMessage: 'Beim Laden der Lieferanten ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, Supplier>> updateSupplier(Supplier supplier) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    try {
      await supabase.from('d_suppliers').update(supplier.toJson()).eq('ownerId', ownerId).eq('id', supplier.id);

      return Right(supplier);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Aktualisieren des Lieferanten ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, Unit>> deleteSupplier(String id) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    try {
      await supabase.from('d_suppliers').delete().eq('ownerId', ownerId).eq('id', id);

      return const Right(unit);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Löschen des Lieferanten ist ein Fehler aufgetreten. Error: $e'));
    }
  }
}
