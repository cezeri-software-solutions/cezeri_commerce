import 'dart:io';

import 'package:cezeri_commerce/core/firebase_failures.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

import '../../../1_presentation/core/functions/check_internet_connection.dart';
import '../../../3_domain/entities/marketplace/marketplace.dart';
import '../../../3_domain/repositories/firebase/marketplace_repository.dart';

class MarketplaceRepositoryImpl implements MarketplaceRepository {
  final FirebaseFirestore db;
  final FirebaseAuth firebaseAuth;

  MarketplaceRepositoryImpl({required this.db, required this.firebaseAuth});

  @override
  Future<Either<FirebaseFailure, Unit>> createMarketplace(Marketplace marketplace, File? imageFile) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;

    try {
      final docRef = db.collection(currentUserUid).doc(currentUserUid).collection('Marketetplaces').doc();

      Marketplace toCreateMarketplace;
      //* Marktplatzlogo erstellen START
      if (imageFile != null) {
        final firebaseStoragePath = '$currentUserUid/MarketplaceLogo/${docRef.id}';
        final logoUrl = await uploadImageFileToStorage(imageFile, firebaseStoragePath);

        toCreateMarketplace = marketplace.copyWith(id: docRef.id, logoUrl: logoUrl);
        //* Marktplatzlogo erstellen START
      } else {
        toCreateMarketplace = marketplace.copyWith(id: docRef.id);
      }

      await docRef.set(toCreateMarketplace.toJson());

      return right(unit);
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, List<Marketplace>>> getListOfMarketplaces() async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection(currentUserUid).doc(currentUserUid).collection('Marketetplaces');

    try {
      final listOfMarketplaces = await docRef.get().then(
            (value) => value.docs.map((querySnapshot) => Marketplace.fromJson(querySnapshot.data())).toList(),
          );

      //* Zum hinzufügen von neuen Attributen.
      // for (final marketplace in listOfMarketplaces) {
      //   final docRefMp = db.collection(currentUserUid).doc(currentUserUid).collection('Marketetplaces').doc(marketplace.id);
      //   final updatedMp = marketplace.copyWith(address: Address.empty(), bankDetails: BankDetails.empty());
      //   await docRefMp.update(updatedMp.toJson());
      // }

      if (listOfMarketplaces.isEmpty) return left(EmptyFailure());
      return right(listOfMarketplaces);
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, Marketplace>> getMarketplace(String id) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection(currentUserUid).doc(currentUserUid).collection('Marketetplaces').doc(id);

    try {
      final marketplace = await docRef.get();
      return right(Marketplace.fromJson(marketplace.data()!));
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, Unit>> updateMarketplace(Marketplace marketplace, File? imageFile) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;

    try {
      final docRef = db.collection(currentUserUid).doc(currentUserUid).collection('Marketetplaces').doc(marketplace.id);

      Marketplace toUpdateMarketplace;
      //* Marktplatzlogo erstellen oder updaten START
      if (imageFile != null) {
        final firebaseStoragePath = '$currentUserUid/MarketplaceLogo/${docRef.id}';
        if (marketplace.logoUrl == '') {
          final logoUrl = await uploadImageFileToStorage(imageFile, firebaseStoragePath);
          toUpdateMarketplace = marketplace.copyWith(logoUrl: logoUrl);
        } else {
          final logoUrl = await updateImageFileInStorage(imageFile, marketplace.logoUrl, firebaseStoragePath);
          toUpdateMarketplace = marketplace.copyWith(logoUrl: logoUrl);
        }
        //* Marktplatzlogo erstellen oder updaten START
      } else {
        toUpdateMarketplace = marketplace;
      }

      await docRef.update(toUpdateMarketplace.toJson());

      return right(unit);
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, Unit>> deleteMarketplace(String id) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;

    try {
      final docRef = db.collection(currentUserUid).doc(currentUserUid).collection('Marketetplaces').doc(id);

      await docRef.delete();

      return right(unit);
    } on FirebaseException {
      return left(GeneralFailure());
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
