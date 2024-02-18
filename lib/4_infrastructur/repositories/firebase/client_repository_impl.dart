import 'package:cezeri_commerce/3_domain/entities/client.dart';
import 'package:cezeri_commerce/core/firebase_failures.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

import '../../../core/abstract_failure.dart';
import '/3_domain/entities/settings/main_settings.dart';
import '/3_domain/repositories/firebase/client_repository.dart';

final logger = Logger();

class ClientRepositoryImpl implements ClientRepository {
  final FirebaseFirestore db;
  final FirebaseAuth firebaseAuth;

  const ClientRepositoryImpl({required this.db, required this.firebaseAuth});

  @override
  Future<Either<AbstractFailure, Unit>> createClient(Client client) async {
    final currentUserUid = firebaseAuth.currentUser!.uid;
    try {
      final docRef = db.collection('Users').doc(currentUserUid);
      final docRefSettings = db.collection('Settings').doc(currentUserUid).collection('Settings').doc(currentUserUid);

      final newClient = client.copyWith(id: currentUserUid, ownerId: currentUserUid);
      final newSettings = MainSettings.empty().copyWith(settingsId: docRefSettings.id);

      await docRef.set(newClient.toJson());
      await docRefSettings.set(newSettings.toJson());

      return right(unit);
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(customMessage: 'Beim Erstellen des Nutzers ist ein Fehler aufgetreten.', e: e));
    }
  }

  @override
  Future<Either<AbstractFailure, Client>> getCurClient() async {
    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection('Users').doc(currentUserUid);
    try {
      final client = await docRef.get();
      if (client.data() == null) return left(GeneralFailure(customMessage: 'Beim Laden des Nutzers ist ein Fehler aufgetreten.'));
      return right(Client.fromJson(client.data()!));
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(customMessage: 'Beim Laden des Nutzers ist ein Fehler aufgetreten.', e: e));
    }
  }
}
