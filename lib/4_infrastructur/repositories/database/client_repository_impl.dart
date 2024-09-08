import 'package:cezeri_commerce/3_domain/entities/client.dart';
import 'package:cezeri_commerce/failures/firebase_failures.dart';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '/3_domain/entities/settings/main_settings.dart';
import '../../../1_presentation/core/core.dart';
import '../../../3_domain/repositories/database/client_repository.dart';
import '../../../constants.dart';
import '../../../failures/abstract_failure.dart';

class ClientRepositoryImpl implements ClientRepository {
  final SupabaseClient supabase;

  const ClientRepositoryImpl({required this.supabase});

  @override
  Future<Either<AbstractFailure, Unit>> createClient(Client client) async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());

    final currentUserUid = supabase.auth.currentUser!.id;

    final newClient = client.copyWith(id: currentUserUid, ownerId: currentUserUid);
    final newSettings = MainSettings.empty().copyWith(settingsId: currentUserUid);

    try {
      await supabase.from('clients').update(newClient.toJson()).eq('id', currentUserUid);

      await supabase.from('main_settings').update(newSettings.toJson()).eq('id', currentUserUid);

      return right(unit);
    } catch (e) {
      logger.e(e);
      return left(GeneralFailure(customMessage: 'Beim Erstellen der Userdaten oder den Einstellungen ist ein Fehler aufgetreten.'));
    }
  }

  @override
  Future<Either<AbstractFailure, Client>> getCurClient() async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());

    final currentUserUid = supabase.auth.currentUser!.id;

    try {
      final response = await supabase.from('clients').select().eq('id', currentUserUid).single();

      if (response.isEmpty) {
        return Left(GeneralFailure(customMessage: 'Beim Laden deines Users ist ein Fehler aufgetreten.'));
      } else {
        final client = Client.fromJson(response);
        return Right(client);
      }
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Laden deines Users ist ein Fehler aufgetreten. Error: $e'));
    }
  }
}
