import 'package:dartz/dartz.dart';

import '../../../failures/abstract_failure.dart';
import '../../entities/user.dart';

abstract class AuthRepository {
  //* Unit == Wenn die Funktion funktioniert hat gibt es Unit zurück
  Future<Either<AbstractFailure, Unit>> registerWithEmailAndPassword({required String email, required String password});

  Future<Either<AbstractFailure, Unit>> signInWithEmailAndPassword({required String email, required String password});

  Future<void> signOut();

  Option<CustomUser> getSignedInUser();

  bool checkIfUserIsSignedIn();

  Future<Either<AbstractFailure, Unit>> sendPasswordResetEmail({required String email});

  Future<Either<AbstractFailure, Unit>> resetPasswordForEmail({required String email, required String password});
}
