import 'package:dartz/dartz.dart';

import '../../../core/firebase_failures.dart';
import '../../entities/settings/main_settings.dart';

abstract class MainSettingsRepository {
  Future<Either<FirebaseFailure, Unit>> updateSettings(MainSettings settings);
  Future<Either<FirebaseFailure, Unit>> createSettings(MainSettings settings);
  Future<Either<FirebaseFailure, MainSettings>> getSettings();
}
