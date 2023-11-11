import 'package:dartz/dartz.dart';

import '../../../core/firebase_failures.dart';
import '../../entities/settings/main_settings.dart';
import '../../entities/settings/packaging_box.dart';

abstract class MainSettingsRepository {
  Future<Either<FirebaseFailure, Unit>> updateSettings(MainSettings settings);
  Future<Either<FirebaseFailure, Unit>> createSettings(MainSettings settings);
  Future<Either<FirebaseFailure, MainSettings>> getSettings();
  Future<Either<FirebaseFailure, MainSettings>> updateSettingsPackagingBoxs(List<PackagingBox> packagingBoxes);
}
