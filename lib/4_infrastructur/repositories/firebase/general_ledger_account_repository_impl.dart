import 'package:cezeri_commerce/3_domain/entities/settings/general_ledger_account.dart';
import 'package:cezeri_commerce/failures/abstract_failure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '/1_presentation/core/core.dart';
import '/3_domain/entities/col_ref.dart';
import '/3_domain/repositories/firebase/general_ledger_account_repository.dart';
import '../../../constants.dart';
import '../../../failures/firebase_failures.dart';

class GeneralLedgerAccountRepositoryImpl implements GeneralLedgerAccountRepository {
  final FirebaseFirestore db;
  final FirebaseAuth firebaseAuth;

  GeneralLedgerAccountRepositoryImpl({required this.db, required this.firebaseAuth});

  @override
  Future<Either<AbstractFailure, GeneralLedgerAccount>> createGLAccount(GeneralLedgerAccount gLAccount) async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = ColRef.get(ColRefType.generalLedgerAccount, db, currentUserUid).doc();

    try {
      GeneralLedgerAccount toCreateGLA = gLAccount.copyWith(id: docRef.id);
      await docRef.set(toCreateGLA.toJson());

      return right(toCreateGLA);
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(customMessage: 'Sachkonto: "${gLAccount.name}" konnte nicht erstellt werden.', e: e));
    }
  }

  @override
  Future<Either<AbstractFailure, GeneralLedgerAccount>> getGLAccount(String id) async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = ColRef.get(ColRefType.generalLedgerAccount, db, currentUserUid).doc(id);

    try {
      final gLAccount = await docRef.get();
      return right(GeneralLedgerAccount.fromJson(gLAccount.data()!));
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(customMessage: 'Sachkonto konnte nicht geladen werden.', e: e));
    }
  }

  @override
  Future<Either<AbstractFailure, List<GeneralLedgerAccount>>> getListOfGLAccounts() async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = ColRef.get(ColRefType.generalLedgerAccount, db, currentUserUid);

    try {
      final listOfGLAccounts =
          await docRef.get().then((value) => value.docs.map((querySnapshot) => GeneralLedgerAccount.fromJson(querySnapshot.data())).toList());

      return right(listOfGLAccounts);
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(customMessage: 'Sachkontos konnten nicht geladen werden.', e: e));
    }
  }

  @override
  Future<Either<AbstractFailure, GeneralLedgerAccount>> updateGLAccount(GeneralLedgerAccount gLAccount) async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = ColRef.get(ColRefType.generalLedgerAccount, db, currentUserUid).doc(gLAccount.id);

    try {
      await docRef.update(gLAccount.toJson());

      return right(gLAccount);
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(customMessage: 'Sachkonto konnte nicht aktualisiert werden.', e: e));
    }
  }

  @override
  Future<Either<AbstractFailure, Unit>> deleteGLAccount(String id) async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = ColRef.get(ColRefType.generalLedgerAccount, db, currentUserUid).doc(id);

    try {
      await docRef.delete();

      return right(unit);
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(customMessage: 'Sachkonto konnte nicht gelöscht werden.', e: e));
    }
  }
}
