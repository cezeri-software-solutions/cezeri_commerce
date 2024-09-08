import '../../../../3_domain/entities/client.dart';
import '../../../../constants.dart';

String getCurrentUserId() {
  return supabase.auth.currentUser!.id;
}

String getCurrentUserEmail() {
  return supabase.auth.currentUser!.email!;
}

Future<String?> getOwnerId() async {
  final userId = getCurrentUserId();

  try {
    final response = await supabase.from('clients').select().eq('id', userId).single();

    final client = Client.fromJson(response);
    return client.ownerId;
  } catch (e) {
    logger.e(e);
    return null;
  }
}
