import 'package:cezeri_commerce/core/firebase_failures.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../1_presentation/core/functions/check_internet_connection.dart';
import '../../../3_domain/entities/marketplace/marketplace.dart';
import '../../../3_domain/repositories/firebase/marketplace_repository.dart';

class MarketplaceRepositoryImpl implements MarketplaceRepository {
  final FirebaseFirestore db;
  final FirebaseAuth firebaseAuth;

  MarketplaceRepositoryImpl({required this.db, required this.firebaseAuth});

  @override
  Future<Either<FirebaseFailure, Unit>> createMarketplace(Marketplace marketplace) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;

    try {
      final docRef = db.collection(currentUserUid).doc(currentUserUid).collection('Marketetplaces').doc();

      final toCreateMarketplace = marketplace.copyWith(id: docRef.id);

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
      //   final updatedMp = marketplace.copyWith(marketplaceSettings: MarketplaceSettings.empty());
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
  Future<Either<FirebaseFailure, Unit>> updateMarketplace(Marketplace marketplace) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;

    try {
      final docRef = db.collection(currentUserUid).doc(currentUserUid).collection('Marketetplaces').doc(marketplace.id);

      await docRef.update(marketplace.toJson());

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
