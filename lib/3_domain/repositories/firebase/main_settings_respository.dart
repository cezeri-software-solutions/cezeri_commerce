import 'package:dartz/dartz.dart';

import '../../../failures/abstract_failure.dart';
import '../../entities/settings/main_settings.dart';
import '../../entities/settings/packaging_box.dart';

abstract class MainSettingsRepository {
  Future<Either<AbstractFailure, MainSettings>> getSettings();
  Future<Either<AbstractFailure, Unit>> updateSettings(MainSettings settings);
  Future<Either<AbstractFailure, MainSettings>> updateSettingsPackagingBoxs(List<PackagingBox> packagingBoxes);
}
