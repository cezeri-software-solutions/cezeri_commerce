import 'package:cezeri_commerce/3_domain/repositories/firebase/main_settings_respository.dart';
import 'package:cezeri_commerce/failures/firebase_failures.dart';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '/1_presentation/core/core.dart';
import '/3_domain/entities/settings/main_settings.dart';
import '/3_domain/entities/settings/packaging_box.dart';
import '../../../constants.dart';
import '../../../failures/abstract_failure.dart';
import '../functions/utils_repository_impl.dart';

class MainSettingsRepositoryImpl implements MainSettingsRepository {
  final SupabaseClient supabase;

  MainSettingsRepositoryImpl({required this.supabase});

  @override
  Future<Either<AbstractFailure, MainSettings>> getSettings() async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    try {
      final response = await supabase.from('d_main_settings').select().eq('settingsId', ownerId).single();

      return right(MainSettings.fromJson(response));
    } catch (e) {
      logger.e(e);
      return left(GeneralFailure(customMessage: 'Beim Laden der Einstellungen ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, Unit>> updateSettings(MainSettings settings) async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    try {
      await supabase.from('d_main_settings').update(settings.toJson()).eq('settingsId', ownerId);
      // await supabase.rpc('update_main_settings', params: {'main_settings_json': settings.toJson()});

      return right(unit);
    } catch (e) {
      logger.e(e);
      return left(GeneralFailure(customMessage: 'Beim Aktualisieren der Einstellungen ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, MainSettings>> updateSettingsPackagingBoxs(List<PackagingBox> packagingBoxes) async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    try {
      final settings = MainSettings.fromJson(await supabase.from('d_main_settings').select().eq('settingsId', ownerId).single());

      final updatedSettings = settings.copyWith(listOfPackagingBoxes: packagingBoxes);
      await supabase.from('d_main_settings').update(updatedSettings.toJson()).eq('settingsId', ownerId);

      return right(updatedSettings);
    } catch (e) {
      logger.e(e);
      return left(GeneralFailure(customMessage: 'Beim Aktualisieren der Einstellungen ist ein Fehler aufgetreten. Error: $e'));
    }
  }
}
