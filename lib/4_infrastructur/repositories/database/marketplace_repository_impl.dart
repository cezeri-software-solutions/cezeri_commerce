import 'dart:io';

import 'package:cezeri_commerce/3_domain/entities/e_mail_automation.dart';
import 'package:cezeri_commerce/3_domain/entities/marketplace/marketplace_shopify.dart';
import 'package:cezeri_commerce/failures/firebase_failures.dart';
import 'package:dartz/dartz.dart';
import 'package:path/path.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '/1_presentation/core/core.dart';
import '/3_domain/entities/id.dart';
import '../../../3_domain/entities/marketplace/abstract_marketplace.dart';
import '../../../3_domain/entities/marketplace/marketplace_presta.dart';
import '../../../3_domain/entities/marketplace/marketplace_shop.dart';
import '../../../3_domain/repositories/database/marketplace_repository.dart';
import '../../../constants.dart';
import '../../../failures/abstract_failure.dart';
import 'functions/repository_functions.dart';

class MarketplaceRepositoryImpl implements MarketplaceRepository {
  final SupabaseClient supabase;

  MarketplaceRepositoryImpl({required this.supabase});

  @override
  Future<Either<AbstractFailure, Unit>> createMarketplace(AbstractMarketplace marketplace, File? imageFile) async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final databas = supabase.from('d_marketplaces');
    final genId = UniqueID().value;

    try {
      AbstractMarketplace toCreateMarketplace;
      //* Marktplatzlogo erstellen START
      if (imageFile != null) {
        final logoUrl = await uploadMarketplaceLogToStorage(imageFile, getMarketplaceStoragePath(ownerId, genId));

        toCreateMarketplace = switch (marketplace.marketplaceType) {
          MarketplaceType.prestashop => (marketplace as MarketplacePresta).copyWith(id: genId, logoUrl: logoUrl),
          MarketplaceType.shopify => (marketplace as MarketplaceShopify).copyWith(id: genId, logoUrl: logoUrl),
          MarketplaceType.shop => (marketplace as MarketplaceShop).copyWith(id: genId, logoUrl: logoUrl),
        };
        //* Marktplatzlogo erstellen ENDE
      } else {
        toCreateMarketplace = switch (marketplace.marketplaceType) {
          MarketplaceType.prestashop => (marketplace as MarketplacePresta).copyWith(id: genId),
          MarketplaceType.shopify => (marketplace as MarketplaceShopify).copyWith(id: genId),
          MarketplaceType.shop => (marketplace as MarketplaceShop).copyWith(id: genId),
        };
      }

      final marketplaceJson = toCreateMarketplace.toJson();
      marketplaceJson.addEntries([MapEntry('ownerId', ownerId)]);
      await databas.insert(marketplaceJson);

      return const Right(unit);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Erstellen des Marktplatzes ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, Unit>> updateMarketplace(AbstractMarketplace marketplace, File? imageFile) async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final databas = supabase.from('d_marketplaces');

    try {
      AbstractMarketplace toUpdateMarketplace;
      //* Marktplatzlogo erstellen oder updaten START
      if (imageFile != null) {
        if (marketplace.logoUrl == '') {
          final logoUrl = await uploadMarketplaceLogToStorage(imageFile, getMarketplaceStoragePath(ownerId, marketplace.id));
          toUpdateMarketplace = switch (marketplace.marketplaceType) {
            MarketplaceType.prestashop => (marketplace as MarketplacePresta).copyWith(logoUrl: logoUrl),
            MarketplaceType.shopify => (marketplace as MarketplaceShopify).copyWith(logoUrl: logoUrl),
            MarketplaceType.shop => (marketplace as MarketplaceShop).copyWith(logoUrl: logoUrl),
          };
        } else {
          final logoUrl = await updateMarketplaceLogoInStorage(imageFile, marketplace.logoUrl, getMarketplaceStoragePath(ownerId, marketplace.id));
          toUpdateMarketplace = switch (marketplace.marketplaceType) {
            MarketplaceType.prestashop => (marketplace as MarketplacePresta).copyWith(logoUrl: logoUrl),
            MarketplaceType.shopify => (marketplace as MarketplaceShopify).copyWith(logoUrl: logoUrl),
            MarketplaceType.shop => (marketplace as MarketplaceShop).copyWith(logoUrl: logoUrl),
          };
        }
        //* Marktplatzlogo erstellen oder updaten ENDE
      } else {
        toUpdateMarketplace = marketplace;
      }

      await databas.update(toUpdateMarketplace.toJson()).eq('ownerId', ownerId).eq('id', marketplace.id);

      return const Right(unit);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Aktualisieren des Marktplatzes ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, Unit>> deleteMarketplace(String id) async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final database = supabase.from('d_marketplaces');

    try {
      final fosMarketplace = await getMarketplace(id);
      if (fosMarketplace.isLeft()) return Left(fosMarketplace.getLeft());
      final marketplace = fosMarketplace.getRight();

      await removeMarketplaceLogoFromStorage(marketplace.logoUrl, getMarketplaceStoragePath(ownerId, marketplace.id));

      await database.delete().eq('ownerId', ownerId).eq('id', marketplace.id);

      return const Right(unit);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Löschen des Marktplatzes ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, AbstractMarketplace>> getMarketplace(String id) async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    try {
      final response = await supabase.from('d_marketplaces').select().eq('ownerId', ownerId).eq('id', id).single();

      if (response.isEmpty) {
        return Left(GeneralFailure(customMessage: 'Beim Laden des Marktplatzes ist ein Fehler aufgetreten.'));
      }
      return Right(AbstractMarketplace.fromJson(response));
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Laden des Marktplatzes ist ein Fehler aufgetreten. Error $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, List<AbstractMarketplace>>> getListOfMarketplaces({bool onlyActive = false}) async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final query = supabase.from('d_marketplaces').select().eq('ownerId', ownerId);
    if (onlyActive) query.eq('isActive', true).limit(1);

    try {
      final response = await query;
      if (response.isEmpty) return const Right([]);

      final listOfMarketplaces = response.map((e) => AbstractMarketplace.fromJson(e)).toList();

      return Right(listOfMarketplaces);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Laden der Marktplätze ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, List<AbstractMarketplace>>> getListOfMarketplacesByType({
    required MarketplaceType type,
    bool onlyActive = false,
  }) async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final query = supabase.from('d_marketplaces').select().eq('ownerId', ownerId).eq('marketplaceType', type.name);
    if (onlyActive) query.eq('isActive', true);

    try {
      final response = await query;
      if (response.isEmpty) return const Right([]);

      final listOfMarketplaces = response.map((e) => AbstractMarketplace.fromJson(e)).toList();

      return Right(listOfMarketplaces);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Laden der Marktplätze ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, Unit>> addMarketplaceEMailAutomation(AbstractMarketplace marketplace, EMailAutomation eMailAutomation) async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    try {
      final fosMarketplace = await getMarketplace(marketplace.id);
      if (fosMarketplace.isLeft()) return Left(fosMarketplace.getLeft());
      final loadedMarketplace = fosMarketplace.getRight();

      final newEMailAutomation = eMailAutomation.copyWith(id: UniqueID().value);

      List<EMailAutomation> listOfEMailAutomations = List.from(loadedMarketplace.marketplaceSettings.listOfEMailAutomations);
      listOfEMailAutomations.add(newEMailAutomation);
      final updatedMarketplace = switch (loadedMarketplace.marketplaceType) {
        MarketplaceType.prestashop => (loadedMarketplace as MarketplacePresta).copyWith(
            marketplaceSettings: loadedMarketplace.marketplaceSettings.copyWith(listOfEMailAutomations: listOfEMailAutomations),
          ),
        MarketplaceType.shopify => (loadedMarketplace as MarketplaceShopify).copyWith(
            marketplaceSettings: loadedMarketplace.marketplaceSettings.copyWith(listOfEMailAutomations: listOfEMailAutomations),
          ),
        MarketplaceType.shop => (loadedMarketplace as MarketplaceShop).copyWith(
            marketplaceSettings: loadedMarketplace.marketplaceSettings.copyWith(listOfEMailAutomations: listOfEMailAutomations),
          ),
      };

      final fosUpdate = await updateMarketplace(updatedMarketplace, null);
      if (fosUpdate.isLeft()) return Left(fosUpdate.getLeft());

      return const Right(unit);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Hinzufügen einer E-Mail Automatisierung ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, Unit>> updateMarketplaceEMailAutomation(AbstractMarketplace marketplace, EMailAutomation eMailAutomation) async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    try {
      final fosMarketplace = await getMarketplace(marketplace.id);
      if (fosMarketplace.isLeft()) return Left(fosMarketplace.getLeft());
      final loadedMarketplace = fosMarketplace.getRight();

      List<EMailAutomation> listOfEMailAutomations = List.from(loadedMarketplace.marketplaceSettings.listOfEMailAutomations);
      for (int i = 0; i < listOfEMailAutomations.length; i++) {
        if (listOfEMailAutomations[i].id == eMailAutomation.id) {
          listOfEMailAutomations[i] = eMailAutomation;
        }
      }

      final updatedMarketplace = switch (loadedMarketplace.marketplaceType) {
        MarketplaceType.prestashop => (loadedMarketplace as MarketplacePresta).copyWith(
            marketplaceSettings: loadedMarketplace.marketplaceSettings.copyWith(listOfEMailAutomations: listOfEMailAutomations),
          ),
        MarketplaceType.shopify => (loadedMarketplace as MarketplaceShopify).copyWith(
            marketplaceSettings: loadedMarketplace.marketplaceSettings.copyWith(listOfEMailAutomations: listOfEMailAutomations),
          ),
        MarketplaceType.shop => (loadedMarketplace as MarketplaceShop).copyWith(
            marketplaceSettings: loadedMarketplace.marketplaceSettings.copyWith(listOfEMailAutomations: listOfEMailAutomations),
          ),
      };

      final fosUpdate = await updateMarketplace(updatedMarketplace, null);
      if (fosUpdate.isLeft()) return Left(fosUpdate.getLeft());

      return const Right(unit);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Aktualisieren einer E-Mail Automatisierung ist ein Fehler aufgetreten. Error: $e'));
    }
  }
}

Future<String> uploadMarketplaceLogToStorage(File imageFile, String supabaseStoragePath) async {
  final fileName = basename(imageFile.path);
  final filePath = '$supabaseStoragePath/${fileName}_${generateRandomString(4)}';
  final storageResponse = await supabase.storage.from('marketplace-logos').upload(filePath, imageFile);
  if (storageResponse.isEmpty) {
    logger.e('Marktplatzlogo konnte nicht hochgeladen werden. Error: $storageResponse');
    return '';
  }

  final fileUrl = supabase.storage.from('marketplace-logos').getPublicUrl(filePath);

  return fileUrl;
}

Future<String> updateMarketplaceLogoInStorage(File newImageFile, String oldLogoUrl, String supabaseStoragePath) async {
  final fileUrl = await uploadMarketplaceLogToStorage(newImageFile, supabaseStoragePath);

  // Lösche das alte Logo aus Firebase Storage
  final filePath = extractPathFromUrl(oldLogoUrl);

  try {
    await supabase.storage.from('marketplace-logos').remove([filePath]);
  } on StorageException catch (e) {
    logger.e('Marktplatz-Logo konnte nicht aus dem Storage gelöscht werden. Error: ${e.message}');
  } catch (e) {
    logger.e('Marktplatz-Logo konnte nicht aus dem Storage gelöscht werden.');
  }

  return fileUrl;
}

Future<void> removeMarketplaceLogoFromStorage(String oldLogoUrl, String supabaseStoragePath) async {
  // Lösche das alte Logo aus Firebase Storage
  final filePath = extractPathFromUrl(oldLogoUrl);

  try {
    await supabase.storage.from('marketplace-logos').remove([filePath]);
  } on StorageException catch (e) {
    logger.e('Marktplatz-Logo konnte nicht aus dem Storage gelöscht werden. Error: ${e.message}');
  } catch (e) {
    logger.e('Marktplatz-Logo konnte nicht aus dem Storage gelöscht werden.');
  }
}
