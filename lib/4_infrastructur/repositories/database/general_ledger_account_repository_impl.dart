import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../1_presentation/core/core.dart';
import '../../../3_domain/entities/settings/general_ledger_account.dart';
import '../../../3_domain/repositories/database/general_ledger_account_repository.dart';
import '../../../constants.dart';
import '../../../failures/failures.dart';
import 'functions/repository_functions.dart';

class GeneralLedgerAccountRepositoryImpl implements GeneralLedgerAccountRepository {
  final SupabaseClient supabase;

  GeneralLedgerAccountRepositoryImpl({required this.supabase});

  @override
  Future<Either<AbstractFailure, GeneralLedgerAccount>> createGLAccount(GeneralLedgerAccount gLAccount) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final query = supabase.from('general_ledger_accounts');

    final gLAccountJson = gLAccount.toJson();
    gLAccountJson.addEntries([MapEntry('owner_id', ownerId)]);

    try {
      final gLAccountResponse = await query.insert(gLAccountJson).select('*').single();
      final createdGLAccount = GeneralLedgerAccount.fromJson(gLAccountResponse);

      return Right(createdGLAccount);
    } catch (e) {
      logger.e(e.runtimeType);
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Sachkonto: "${gLAccount.name}" konnte nicht erstellt werden. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, GeneralLedgerAccount>> getGLAccount(String id) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final query = supabase.from('general_ledger_accounts').select().eq('owner_id', ownerId).eq('id', id).single();

    try {
      final response = await query;

      return Right(GeneralLedgerAccount.fromJson(response));
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Sachkonto konnte nicht geladen werden. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, List<GeneralLedgerAccount>>> getListOfGLAccounts() async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final query = supabase.from('general_ledger_accounts').select().eq('owner_id', ownerId);

    try {
      final response = await query;
      print(response);

      if (response.isEmpty) return const Right([]);
      final listOfGLAccounts = response.map((e) => GeneralLedgerAccount.fromJson(e)).toList();

      return Right(listOfGLAccounts);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Sachkontos konntes nicht geladen werden. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, GeneralLedgerAccount>> updateGLAccount(GeneralLedgerAccount gLAccount) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final query = supabase.from('general_ledger_accounts').update(gLAccount.toJson()).eq('owner_id', ownerId).eq('id', gLAccount.id);

    try {
      await query;

      return Right(gLAccount);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Sachkonto konnte nicht aktualisiert werden. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, Unit>> deleteGLAccount(String id) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final query = supabase.from('general_ledger_accounts').delete().eq('owner_id', ownerId).eq('id', id);

    try {
      await query;

      return const Right(unit);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Sachkonto konnte nicht gelöscht werden. Error: $e'));
    }
  }
}
