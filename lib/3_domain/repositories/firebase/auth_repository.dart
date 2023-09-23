import 'package:dartz/dartz.dart';

import '../../../core/auth_failures.dart';
import '../../entities/user.dart';

abstract class AuthRepository {
  //* Unit == Wenn die Funktion funktioniert hat gibt es Unit zurück
  Future<Either<AuthFailure, Unit>> registerWithEmailAndPassword(
      {required String email, required String password});

  Future<Either<AuthFailure, Unit>> signInWithEmailAndPassword(
      {required String email, required String password});

  Future<void> signOut();

  Option<CustomUser> getSignedInUser();

  Future<Either<AuthFailure, Unit>> sendPasswordResetEmail(
      {required String email});
}
