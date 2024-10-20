import 'package:cezeri_commerce/3_domain/entities/customer/customer.dart';
import 'package:cezeri_commerce/failures/firebase_failures.dart';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '/1_presentation/core/core.dart';
import '../../../3_domain/repositories/database/customer_repository.dart';
import '../../../3_domain/repositories/database/main_settings_respository.dart';
import '../../../constants.dart';
import '../../../failures/abstract_failure.dart';
import 'functions/repository_functions.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final SupabaseClient supabase;
  final MainSettingsRepository settingsRepository;

  CustomerRepositoryImpl({required this.supabase, required this.settingsRepository});

  @override
  Future<Either<AbstractFailure, Customer>> createCustomer(Customer customer) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final customerQuery = supabase.from('d_customers');

    final customerJson = customer.toJson();
    customerJson.addEntries([MapEntry('ownerId', ownerId)]);

    try {
      final fosSettings = await settingsRepository.getSettings();
      if (fosSettings.isLeft()) return Left(fosSettings.getLeft());

      final customerResponse = await customerQuery.insert(customerJson).select('*').single();
      final createdCustomer = Customer.fromJson(customerResponse);

      return Right(createdCustomer);
    } catch (e) {
      logger.e(e.runtimeType);
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Erstellen des Kunden ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, Customer>> getCustomer(String id) async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final query = supabase.from('d_customers').select().eq('ownerId', ownerId).eq('id', id).single();

    try {
      final response = await query;

      return right(Customer.fromJson(response));
    } catch (e) {
      logger.e(e);
      return left(GeneralFailure(customMessage: 'Beim Laden des Kunden ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, int>> getTotalNumberOfCustomersBySearchText(String searchText) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    try {
      final response = await supabase.rpc('get_customers_count', params: {'owner_id': ownerId, 'search_text': searchText});

      return Right(response);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Laden der Artikel ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, List<Customer>>> getListOfCustomersPerPageBySearchText({
    required String searchText,
    required int currentPage,
    required int itemsPerPage,
  }) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    try {
      final response = await supabase.rpc('get_customers', params: {
        'owner_id': ownerId,
        'search_text': searchText,
        'current_page': currentPage,
        'items_per_page': itemsPerPage,
      });

      if (response.isEmpty) return const Right([]);

      final listOfCustomers = (response as List<dynamic>).map((e) {
        final item = e as Map<String, dynamic>;
        return Customer.fromJson(item);
      }).toList();

      return Right(listOfCustomers);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Laden der Artikel ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, Customer>> updateCustomer(Customer customer) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    try {
      await supabase.from('d_customers').update(customer.toJson()).eq('ownerId', ownerId).eq('id', customer.id);

      return Right(customer);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Aktualisieren des Kunden ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, Unit>> deleteCustomer(String id) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    try {
      await supabase.from('d_customers').delete().eq('ownerId', ownerId).eq('id', id);

      return const Right(unit);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Löschen des Kunden ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, Customer>> getCustomerByCustomerIdInMarketplace(String marketplaceId, int customerIdMarketplace) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final query = supabase
        .from('d_customers')
        .select()
        .eq('ownerId', ownerId)
        .filter('customerMarketplace->>marketplaceId', 'eq', marketplaceId)
        .filter('customerMarketplace->>customerIdMarketplace', 'eq', customerIdMarketplace);

    try {
      final response = await query;

      if (response.isEmpty) return Left(GeneralFailure(customMessage: 'In der Datenbank konnte kein Kunde gefunden werden.'));
      final listOfCustomers = response.map((e) => Customer.fromJson(e)).toList();

      final customer = listOfCustomers.first;

      return Right(customer);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Laden des Kunden ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, Customer>> getCustomerByEmail(String email) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final query = supabase.from('d_customers').select().eq('ownerId', ownerId).eq('email', email);

    try {
      final response = await query;

      if (response.isEmpty) return Left(GeneralFailure(customMessage: 'In der Datenbank konnte kein Kunde gefunden werden.'));
      final listOfCustomers = response.map((e) => Customer.fromJson(e)).toList();

      final customer = listOfCustomers.first;

      return Right(customer);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Laden des Kunden ist ein Fehler aufgetreten. Error: $e'));
    }
  }
}
