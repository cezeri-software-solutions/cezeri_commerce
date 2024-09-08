import 'package:dartz/dartz.dart';

import '../../../failures/abstract_failure.dart';
import '../../entities/client.dart';

abstract class ClientRepository {
  Future<Either<AbstractFailure, Unit>> createClient(Client client);
  Future<Either<AbstractFailure, Client>> getCurClient();
}
