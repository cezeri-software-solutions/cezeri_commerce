import 'dart:io';

import 'package:cezeri_commerce/3_domain/entities/e_mail_automation.dart';
import 'package:cezeri_commerce/3_domain/entities/marketplace/marketplace_shopify.dart';
import 'package:cezeri_commerce/core/firebase_failures.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';

import '../../../3_domain/entities/marketplace/abstract_marketplace.dart';
import '../../../3_domain/entities/marketplace/marketplace_presta.dart';
import '../../../core/abstract_failure.dart';
import '/1_presentation/core/functions/check_internet_connection.dart';
import '/3_domain/entities/id.dart';
import '/3_domain/repositories/firebase/marketplace_repository.dart';

final logger = Logger();

class MarketplaceRepositoryImpl implements MarketplaceRepository {
  final FirebaseFirestore db;
  final FirebaseAuth firebaseAuth;

  MarketplaceRepositoryImpl({required this.db, required this.firebaseAuth});

  @override
  Future<Either<AbstractFailure, Unit>> createMarketplace(AbstractMarketplace marketplace, File? imageFile) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;

    try {
      final docRef = db.collection('Marketetplaces').doc(currentUserUid).collection('Marketetplaces').doc();

      AbstractMarketplace toCreateMarketplace;
      //* Marktplatzlogo erstellen START
      if (imageFile != null) {
        final firebaseStoragePath = '$currentUserUid/MarketplaceLogo/${docRef.id}';
        final logoUrl = await uploadImageFileToStorage(imageFile, firebaseStoragePath);
        toCreateMarketplace = switch (marketplace.marketplaceType) {
          MarketplaceType.prestashop => (marketplace as MarketplacePresta).copyWith(id: docRef.id, logoUrl: logoUrl),
          MarketplaceType.shopify => (marketplace as MarketplaceShopify).copyWith(id: docRef.id, logoUrl: logoUrl),
          MarketplaceType.shop => throw Exception(),
        };
        //* Marktplatzlogo erstellen START
      } else {
        toCreateMarketplace = switch (marketplace.marketplaceType) {
          MarketplaceType.prestashop => (marketplace as MarketplacePresta).copyWith(id: docRef.id),
          MarketplaceType.shopify => (marketplace as MarketplaceShopify).copyWith(id: docRef.id),
          MarketplaceType.shop => throw Exception(),
        };
      }

      await docRef.set(toCreateMarketplace.toJson());

      return right(unit);
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(customMessage: 'Beim Erstellen des Marktplatzes ist ein Fehler aufgetreten.', e: e));
    }
  }

  @override
  Future<Either<AbstractFailure, Unit>> updateMarketplace(AbstractMarketplace marketplace, File? imageFile) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;

    try {
      final docRef = db.collection('Marketetplaces').doc(currentUserUid).collection('Marketetplaces').doc(marketplace.id);

      AbstractMarketplace toUpdateMarketplace;
      //* Marktplatzlogo erstellen oder updaten START
      if (imageFile != null) {
        final firebaseStoragePath = '$currentUserUid/MarketplaceLogo/${docRef.id}';
        if (marketplace.logoUrl == '') {
          final logoUrl = await uploadImageFileToStorage(imageFile, firebaseStoragePath);
          toUpdateMarketplace = switch (marketplace.marketplaceType) {
            MarketplaceType.prestashop => (marketplace as MarketplacePresta).copyWith(logoUrl: logoUrl),
            MarketplaceType.shopify => (marketplace as MarketplaceShopify).copyWith(logoUrl: logoUrl),
            MarketplaceType.shop => throw Exception(),
          };
        } else {
          final logoUrl = await updateImageFileInStorage(imageFile, marketplace.logoUrl, firebaseStoragePath);
          toUpdateMarketplace = switch (marketplace.marketplaceType) {
            MarketplaceType.prestashop => (marketplace as MarketplacePresta).copyWith(logoUrl: logoUrl),
            MarketplaceType.shopify => (marketplace as MarketplaceShopify).copyWith(logoUrl: logoUrl),
            MarketplaceType.shop => throw Exception(),
          };
        }
        //* Marktplatzlogo erstellen oder updaten START
      } else {
        toUpdateMarketplace = marketplace;
      }

      await docRef.update((toUpdateMarketplace).toJson());

      // switch (toUpdateMarketplace.marketplaceType) {
      //   case MarketplaceType.prestashop:
      //     {
      //       await docRef.update((toUpdateMarketplace as MarketplacePresta).toJson());
      //     }
      //   case MarketplaceType.shopify:
      //     {
      //       await docRef.update((toUpdateMarketplace as MarketplaceShopify).toJson());
      //     }
      //   case MarketplaceType.shop:
      //     {
      //       throw Exception('Unknown Marketplace type: ${toUpdateMarketplace.marketplaceType}');
      //     }
      // }

      return right(unit);
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(customMessage: 'Beim Aktualisieren des Marktplatzes ist ein Fehler aufgetreten.', e: e));
    }
  }

  @override
  Future<Either<AbstractFailure, Unit>> deleteMarketplace(String id) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;

    try {
      final docRef = db.collection('Marketetplaces').doc(currentUserUid).collection('Marketetplaces').doc(id);

      await docRef.delete();

      return right(unit);
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(customMessage: 'Beim Löschen des Marktplatzes ist ein Fehler aufgetreten.', e: e));
    }
  }

  @override
  Future<Either<AbstractFailure, MarketplacePresta>> getMarketplace(String id) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection('Marketetplaces').doc(currentUserUid).collection('Marketetplaces').doc(id);

    try {
      final marketplace = await docRef.get();
      return right(MarketplacePresta.fromJson(marketplace.data()!));
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(customMessage: 'Beim Laden des Marktplatzes ist ein Fehler aufgetreten.', e: e));
    }
  }

  @override
  Future<Either<AbstractFailure, List<AbstractMarketplace>>> getListOfMarketplaces() async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection('Marketetplaces').doc(currentUserUid).collection('Marketetplaces');

    try {
      final listOfMarketplaces = await docRef.get().then(
            (value) => value.docs.map((querySnapshot) => AbstractMarketplace.fromJson(querySnapshot.data())).toList(),
          );

      //* Zum hinzufügen von neuen Attributen.
      // for (final marketplace in listOfMarketplaces) {
      //   final docRefMp = db.collection('Marketetplaces').doc(currentUserUid).collection('Marketetplaces').doc(marketplace.id);
      //   final updatedMp = marketplace.copyWith(address: Address.empty(), bankDetails: BankDetails.empty());
      //   await docRefMp.update(updatedMp.toJson());
      // }

      return right(listOfMarketplaces);
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(customMessage: 'Beim Laden der Marktplätze ist ein Fehler aufgetreten.', e: e));
    }
  }

  @override
  Future<Either<AbstractFailure, Unit>> addMarketplaceEMailAutomation(MarketplacePresta marketplace, EMailAutomation eMailAutomation) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection('Marketetplaces').doc(currentUserUid).collection('Marketetplaces').doc(marketplace.id);

    try {
      final dsMarketplace = await docRef.get();
      final marketplace = MarketplacePresta.fromJson(dsMarketplace.data()!);

      final newEMailAutomation = eMailAutomation.copyWith(id: UniqueID().value);

      List<EMailAutomation> listOfEMailAutomations = List.from(marketplace.marketplaceSettings.listOfEMailAutomations);
      listOfEMailAutomations.add(newEMailAutomation);
      final updatedMarketplace = marketplace.copyWith(
        marketplaceSettings: marketplace.marketplaceSettings.copyWith(listOfEMailAutomations: listOfEMailAutomations),
      );

      await docRef.update(updatedMarketplace.toJson());

      return right(unit);
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(customMessage: 'Beim Hinzufügen einer E-Mail Automatisierung ist ein Fehler aufgetreten.', e: e));
    }
  }

  @override
  Future<Either<AbstractFailure, Unit>> updateMarketplaceEMailAutomation(MarketplacePresta marketplace, EMailAutomation eMailAutomation) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection('Marketetplaces').doc(currentUserUid).collection('Marketetplaces').doc(marketplace.id);

    try {
      final dsMarketplace = await docRef.get();
      final marketplace = MarketplacePresta.fromJson(dsMarketplace.data()!);

      List<EMailAutomation> listOfEMailAutomations = List.from(marketplace.marketplaceSettings.listOfEMailAutomations);
      for (int i = 0; i < listOfEMailAutomations.length; i++) {
        if (listOfEMailAutomations[i].id == eMailAutomation.id) {
          listOfEMailAutomations[i] = eMailAutomation;
        }
      }
      final updatedMarketplace = marketplace.copyWith(
        marketplaceSettings: marketplace.marketplaceSettings.copyWith(listOfEMailAutomations: listOfEMailAutomations),
      );

      await docRef.update(updatedMarketplace.toJson());

      return right(unit);
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(customMessage: 'Beim Aktualisieren einer E-Mail Automatisierung ist ein Fehler aufgetreten.', e: e));
    }
  }
}

Future<String> uploadImageFileToStorage(File imageFile, String firebaseStoragePath) async {
  final FirebaseStorage storage = FirebaseStorage.instance;

  // Erstelle einen eindeutigen Dateinamen, um Kollisionen zu vermeiden
  final fileName = basename(imageFile.path);
  // Erstelle einen Verweis auf den Firebase Cloud Storage-Pfad, an dem das Bild gespeichert werden soll
  final Reference firebaseStorageRef = storage.ref().child('$firebaseStoragePath/$fileName');
  // Erstelle einen Byte-Datenstrom aus der Datei
  final bytes = await imageFile.readAsBytes();
  // Lade die Byte-Daten in Firebase Cloud Storage hoch
  await firebaseStorageRef.putData(bytes);
  // Speichere die URL des hochgeladenen Bildes in Firestore
  final String fileUrl = await firebaseStorageRef.getDownloadURL();

  return fileUrl;
}

Future<String> updateImageFileInStorage(File imageFile, String oldLogoUrl, String firebaseStoragePath) async {
  final FirebaseStorage storage = FirebaseStorage.instance;

  // Erstelle einen eindeutigen Dateinamen, um Kollisionen zu vermeiden
  final fileName = basename(imageFile.path);
  // Erstelle einen Verweis auf den Firebase Cloud Storage-Pfad, an dem das Bild gespeichert werden soll
  final Reference firebaseStorageRef = storage.ref().child('$firebaseStoragePath/$fileName');
  // Erstelle einen Byte-Datenstrom aus der Datei
  final bytes = await imageFile.readAsBytes();
  // Lade die Byte-Daten in Firebase Cloud Storage hoch
  await firebaseStorageRef.putData(bytes);
  // Speichere die URL des hochgeladenen Bildes in Firestore
  final String fileUrl = await firebaseStorageRef.getDownloadURL();

  // Lösche das alte Logo aus Firebase Storage
  final firebaseStoragePathToDelete = FirebaseStorage.instance.refFromURL(oldLogoUrl);
  await firebaseStoragePathToDelete.delete();

  return fileUrl;
}
