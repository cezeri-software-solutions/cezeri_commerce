import 'package:dartz/dartz.dart';

import '../../../core/firebase_failures.dart';
import '../../entities/receipt/receipt.dart';
import '../../entities/receipt/receipt_product.dart';

abstract class ReceiptRepository {
  Future<Either<FirebaseFailure, Receipt>> getAppointment(Receipt receipt);
  Future<Either<FirebaseFailure, List<Receipt>>> loadNewAppointments();
  Future<Either<FirebaseFailure, List<Receipt>>> getListOfReceipts(int value, ReceiptTyp receiptTyp);
  Future<Either<FirebaseFailure, Unit>> updateAppointment(
    Receipt appointment,
    List<ReceiptProduct> oldListOfReceiptProducts,
    List<ReceiptProduct> newListOfReceiptProducts,
  );
  Future<Either<FirebaseFailure, Receipt>> createAppointmentManually(Receipt receipt);
  Future<Either<FirebaseFailure, Unit>> deleteAppointment(String id);
  Future<Either<FirebaseFailure, Unit>> deleteListOfReceipts(List<Receipt> listOfReceipts);
  //* ###### Generate Receipts #####
  Future<Either<FirebaseFailure, List<Receipt>>> generateFromListOfAppointments(
    List<Receipt> listOfReceipts,
    bool generateDeliveryNote,
    bool generateInvoice,
  );
  Future<Either<FirebaseFailure, List<Receipt>>> generateFromAppointment(
    Receipt incomingAppointment,
    Receipt originalAppointment,
    bool generateDeliveryNote,
    bool generateInvoice,
  );
  Future<Either<FirebaseFailure, Unit>> sendEmails();
}
