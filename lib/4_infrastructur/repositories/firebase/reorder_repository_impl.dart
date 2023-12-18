import 'package:cezeri_commerce/3_domain/entities/reorder/reorder.dart';
import 'package:cezeri_commerce/core/firebase_failures.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../1_presentation/core/functions/check_internet_connection.dart';
import '../../../3_domain/enums/enums.dart';
import '../../../3_domain/repositories/firebase/reorder_repository.dart';

class ReorderRepositoryImpl implements ReorderRepository {
  final FirebaseFirestore db;
  final FirebaseAuth firebaseAuth;

  ReorderRepositoryImpl({required this.db, required this.firebaseAuth});

  @override
  Future<Either<FirebaseFailure, Reorder>> createReorder(Reorder reorder) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection('Reorders').doc(currentUserUid).collection('Reorders').doc();
    final docRefSettings = db.collection('Settings').doc(currentUserUid).collection('Settings').doc(currentUserUid);

    try {
      Reorder toCreateReorder = reorder.copyWith(id: docRef.id);
      await docRef.set(toCreateReorder.toJson());

      await docRefSettings.update({'nextReorderNumber': FieldValue.increment(1)});

      return right(toCreateReorder);
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, Reorder>> getReorder(String id) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection('Reorders').doc(currentUserUid).collection('Reorders').doc(id);

    try {
      final reorder = await docRef.get();
      return right(Reorder.fromJson(reorder.data()!));
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, List<Reorder>>> getListOfReorders(GetReordersType getReordersType) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = switch (getReordersType) {
      GetReordersType.open =>
        db.collection('Reorders').doc(currentUserUid).collection('Reorders').where('reorderStatus', isEqualTo: ReorderStatus.open.name),
      GetReordersType.partialOpen =>
        db.collection('Reorders').doc(currentUserUid).collection('Reorders').where('reorderStatus', isEqualTo: ReorderStatus.partiallyCompleted.name),
      GetReordersType.openOrPartialOpen => db.collection('Reorders').doc(currentUserUid).collection('Reorders').where('reorderStatus', whereIn: [
          ReorderStatus.open.name,
          ReorderStatus.partiallyCompleted.name,
        ]),
      GetReordersType.completed =>
        db.collection('Reorders').doc(currentUserUid).collection('Reorders').where('reorderStatus', isEqualTo: ReorderStatus.completed.name),
      GetReordersType.all => db.collection('Reorders').doc(currentUserUid).collection('Reorders'),
    };

    try {
      final listOfReorders = await docRef.get().then((value) => value.docs.map((querySnapshot) => Reorder.fromJson(querySnapshot.data())).toList());

      if (listOfReorders.isEmpty) return left(EmptyFailure());
      return right(listOfReorders);
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, Reorder>> updateReorder(Reorder reorder) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection('Reorders').doc(currentUserUid).collection('Reorders').doc(reorder.id);

    try {
      await docRef.update(reorder.toJson());

      return right(reorder);
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, Unit>> deleteReorder(String id) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection('Reorders').doc(currentUserUid).collection('Reorders').doc(id);

    try {
      await docRef.delete();

      return right(unit);
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }
}
