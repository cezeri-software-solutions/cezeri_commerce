import 'package:dartz/dartz.dart';

import '../../../failures/abstract_failure.dart';
import '../../entities/settings/general_ledger_account.dart';

abstract class GeneralLedgerAccountRepository {
  Future<Either<AbstractFailure, GeneralLedgerAccount>> createGLAccount(GeneralLedgerAccount gLAccount);
  Future<Either<AbstractFailure, GeneralLedgerAccount>> getGLAccount(String id);
  Future<Either<AbstractFailure, List<GeneralLedgerAccount>>> getListOfGLAccounts();
  Future<Either<AbstractFailure, GeneralLedgerAccount>> updateGLAccount(GeneralLedgerAccount gLAccount);
  Future<Either<AbstractFailure, Unit>> deleteGLAccount(String id);
}
