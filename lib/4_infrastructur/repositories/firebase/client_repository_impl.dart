import 'package:cezeri_commerce/3_domain/entities/client.dart';
import 'package:cezeri_commerce/core/firebase_failures.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../3_domain/repositories/firebase/client_repository.dart';

class ClientRepositoryImpl implements ClientRepository {
  final FirebaseFirestore db;
  final FirebaseAuth firebaseAuth;

  const ClientRepositoryImpl({required this.db, required this.firebaseAuth});

  @override
  Future<Either<FirebaseFailure, Unit>> createClient(Client client) async {
    final currentUserUid = firebaseAuth.currentUser!.uid;
    try {
      final docRef = db.collection('Users').doc(currentUserUid);

      final Client editedConditioner = client.copyWith(id: currentUserUid, ownerId: currentUserUid);

      await docRef.set(editedConditioner.toJson());

      return right(unit);
    } on FirebaseAuthException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, Client>> getCurClient() async {
    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection(currentUserUid).doc(currentUserUid);
    try {
      final client = await docRef.get();
      if (client.data() == null) return left(EmptyFailure());
      return right(Client.fromJson(client.data()!));
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }
}
