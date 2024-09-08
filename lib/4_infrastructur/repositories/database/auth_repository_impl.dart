import 'package:cezeri_commerce/3_domain/entities/user.dart';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../3_domain/repositories/database/auth_repository.dart';
import '../../../constants.dart';
import '../../../failures/abstract_failure.dart';
import '../../../failures/auth_failures.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<Either<AbstractFailure, Unit>> registerWithEmailAndPassword({required String email, required String password}) async {
    // try {
    //   await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    //   return right(unit);
    // } on FirebaseAuthException catch (e) {
    //   if (e.code == 'email-already-in-use') {
    //     return left(EmailAlreadyInUseFailure());
    //   } else if (e.code == 'invalid-email') {
    //     return left(InvalidEmailFailure());
    //   } else if (e.code == 'operation-not-allowed') {
    //     return left(EmailNotFoundFailure());
    //   } else if (e.code == 'user-not-found') {
    //     return left(EmailNotFoundFailure());
    //   } else {
    //     logger.e('else');
    //     logger.e(e.code);
    //     logger.e(e.message);
    //     return left(AuthServerFailure());
    //   }
    // }

    try {
      await supabase.auth.signUp(
        email: email.trim(),
        password: password.trim(),
        emailRedirectTo: 'io.supabase.flutterquickstart://login-callback/',
      );

      return right(unit);
    } on AuthApiException catch (e) {
      logger.e(e.statusCode);
      logger.e(e.message);

      switch (e.message) {
        case 'Invalid login credentials':
          return left(WrongEmailOrPasswordFailure());
        case 'Email not confirmed':
          return left(EmailNotConfirmedFailure());
        default:
          return left(AuthServerFailure());
      }
    } catch (e) {
      logger.e(e);
      logger.e((e as AuthException).message);
      logger.e((e).statusCode);
      return left(AuthServerFailure());
    }
  }

  @override
  Future<Either<AbstractFailure, Unit>> signInWithEmailAndPassword({required String email, required String password}) async {
    try {
      final response = await supabase.auth.signInWithPassword(email: email.trim(), password: password.trim());

      print(response);

      return right(unit);
    } on AuthApiException catch (e) {
      logger.e(e.statusCode);
      logger.e(e.message);

      switch (e.message) {
        case 'Invalid login credentials':
          return left(WrongEmailOrPasswordFailure());
        case 'Email not confirmed':
          return left(EmailNotConfirmedFailure());
        default:
          return left(AuthServerFailure());
      }
    } catch (e) {
      return left(AuthServerFailure());
    }
  }

  @override
  Future<void> signOut() async {
    logger.i('// ###### signOut pressed');
    await supabase.auth.signOut();
  }

  @override
  // Option<CustomUser> getSignedInUser() => optionOf(firebaseAuth.currentUser?.toDomain());

  @override
  bool checkIfUserIsSignedIn() {
    // Session? value;
    // supabase.auth.onAuthStateChange.listen((event) {
    //   final session = event.session;
    //   value = session;
    // });

    final session = supabase.auth.currentSession;
    logger.i(session);
    return session != null ? true : false;
  }

  @override
  Future<Either<AbstractFailure, Unit>> sendPasswordResetEmail({required String email}) async {
    try {
      await supabase.auth.resetPasswordForEmail(email, redirectTo: 'io.supabase.flutterquickstart://login-callback/');
      return right(unit);
    } catch (e) {
      logger.e(e);
      return left(AuthServerFailure());
    }
  }

  @override
  Future<Either<AbstractFailure, Unit>> resetPasswordForEmail({required String email, required String password}) async {
    try {
      final response = await supabase.auth.updateUser(UserAttributes(email: email, password: password));
      logger.i(response);
      return right(unit);
    } catch (e) {
      logger.e(e);
      return left(AuthServerFailure());
    }
  }

  @override
  Option<CustomUser> getSignedInUser() {
    // TODO: implement getSignedInUser
    throw UnimplementedError();
  }
}
