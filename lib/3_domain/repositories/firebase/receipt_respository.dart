import 'package:dartz/dartz.dart';

import '../../../core/firebase_failures.dart';
import '../../entities/receipt/receipt.dart';

abstract class ReceiptRepository {
  Future<Either<FirebaseFailure, List<Receipt>>> loadNewAppointments();
  Future<Either<FirebaseFailure, List<Receipt>>> getListOfOpenAppointments();
  Future<Either<FirebaseFailure, List<Receipt>>> getListOfAllAppointments();
  Future<Either<FirebaseFailure, Unit>> deleteAppointment(String id);
  Future<Either<FirebaseFailure, Unit>> deleteListOfAppointments(List<String> listOfIds);
}
