import 'package:dartz/dartz.dart';

import '../../../core/firebase_failures.dart';
import '../../entities/client.dart';

abstract class ClientRepository {
  Future<Either<FirebaseFailure, Unit>> createClient(Client client);
  Future<Either<FirebaseFailure, Client>> getCurClient();
}
