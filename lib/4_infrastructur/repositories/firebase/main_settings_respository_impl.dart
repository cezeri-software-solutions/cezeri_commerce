import 'package:cezeri_commerce/3_domain/repositories/firebase/main_settings_respository.dart';
import 'package:cezeri_commerce/core/firebase_failures.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

import '../../../core/abstract_failure.dart';
import '/1_presentation/core/functions/check_internet_connection.dart';
import '/3_domain/entities/settings/main_settings.dart';
import '/3_domain/entities/settings/packaging_box.dart';

final logger = Logger();

class MainSettingsRepositoryImpl implements MainSettingsRepository {
  final FirebaseFirestore db;
  final FirebaseAuth firebaseAuth;

  MainSettingsRepositoryImpl({required this.db, required this.firebaseAuth});

  @override
  Future<Either<AbstractFailure, MainSettings>> getSettings() async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection('Settings').doc(currentUserUid).collection('Settings').doc(currentUserUid);

    try {
      final settings = await docRef.get();
      //* Zum hinzufügen von neuen Feldern
      // final phMainSetting = MainSettings.fromJson(settings.data()!);
      // final mainSettings = phMainSetting.copyWith(listOfCarriers: []);
      // await docRef.update(mainSettings.toJson());
      //
      return right(MainSettings.fromJson(settings.data()!));
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(customMessage: 'Beim Laden der Einstellungen ist ein Fehler aufgetreten.', e: e));
    }
  }

  @override
  Future<Either<AbstractFailure, Unit>> updateSettings(MainSettings settings) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection('Settings').doc(currentUserUid).collection('Settings').doc(currentUserUid);

    try {
      await docRef.update(settings.toJson());
      return right(unit);
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(customMessage: 'Beim Aktualisieren der Einstellungen ist ein Fehler aufgetreten.', e: e));
    }
  }

  @override
  Future<Either<AbstractFailure, Unit>> createSettings(MainSettings settings) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection('Settings').doc(currentUserUid).collection('Settings').doc(currentUserUid);

    final toCreateSettings = MainSettings.empty().copyWith(settingsId: currentUserUid);

    try {
      await docRef.set(toCreateSettings.toJson());
      return right(unit);
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(customMessage: 'Beim Erstellen der Einstellungen ist ein Fehler aufgetreten.', e: e));
    }
  }

  @override
  Future<Either<AbstractFailure, MainSettings>> updateSettingsPackagingBoxs(List<PackagingBox> packagingBoxes) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection('Settings').doc(currentUserUid).collection('Settings').doc(currentUserUid);

    try {
      MainSettings? updatedSettings;
      await db.runTransaction((transaction) async {
        final settingsDSS = await transaction.get(docRef);
        final settings = MainSettings.fromJson(settingsDSS.data()!);

        updatedSettings = settings.copyWith(listOfPackagingBoxes: packagingBoxes);
        transaction.update(docRef, updatedSettings!.toJson());
      });
      return right(updatedSettings!);
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(customMessage: 'Beim Aktualisieren der Verpackungsboxen ist ein Fehler aufgetreten.', e: e));
    }
  }
}
