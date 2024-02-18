import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

import '../../../3_domain/entities/user.dart';
import '../../../3_domain/repositories/firebase/auth_repository.dart';
import '../../../core/abstract_failure.dart';
import '../../../core/auth_failures.dart';
import '../../extensions/firebase_user_mapper.dart';

final logger = Logger();

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth firebaseAuth;

  const AuthRepositoryImpl({required this.firebaseAuth});

  @override
  Future<Either<AbstractFailure, Unit>> registerWithEmailAndPassword({required String email, required String password}) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return right(unit);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return left(EmailAlreadyInUseFailure());
      } else if (e.code == 'invalid-email') {
        return left(InvalidEmailFailure());
      } else if (e.code == 'operation-not-allowed') {
        return left(EmailNotFoundFailure());
      } else if (e.code == 'user-not-found') {
        return left(EmailNotFoundFailure());
      } else {
        logger.e('else');
        logger.e(e.code);
        logger.e(e.message);
        return left(AuthServerFailure());
      }
    }
  }

  @override
  Future<Either<AbstractFailure, Unit>> signInWithEmailAndPassword({required String email, required String password}) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return right(unit);
    } on FirebaseAuthException catch (e) {
      logger.e(e.code);
      if (e.code == 'wrong-password') {
        return left(WrongPasswordFailure());
      } else if (e.code == 'user-not-found') {
        return left(EmailNotFoundFailure());
      } else if (e.code == 'weak-password') {
        return left(WeakPasswordFailure());
      } else {
        return left(AuthServerFailure());
      }
    }
  }

  @override
  Future<void> signOut() async {
    logger.i('// ###### signOut pressed');
    await firebaseAuth.signOut();
  }

  @override
  Option<CustomUser> getSignedInUser() => optionOf(firebaseAuth.currentUser?.toDomain());

  @override
  Future<Either<AbstractFailure, Unit>> sendPasswordResetEmail({required String email}) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return right(unit);
    } on FirebaseAuthException catch (e) {
      logger.e(e.code);
      if (e.code == 'invalid-email') {
        return left(InvalidEmailFailure());
      } else if (e.code == 'user-not-found') {
        return left(EmailNotFoundFailure());
      } else {
        return left(AuthServerFailure());
      }
    }
  }
}
