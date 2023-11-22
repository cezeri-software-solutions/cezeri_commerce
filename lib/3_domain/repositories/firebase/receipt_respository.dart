import 'package:dartz/dartz.dart';

import '../../../core/abstract_failure.dart';
import '../../../core/firebase_failures.dart';
import '../../entities/marketplace/marketplace.dart';
import '../../entities/receipt/load_appointments_helper/to_load_appointments_from_marketplace.dart';
import '../../entities/receipt/receipt.dart';
import '../../entities/receipt/receipt_product.dart';

abstract class ReceiptRepository {
  Future<Either<FirebaseFailure, Receipt>> getAppointment(Receipt receipt);
  Future<Either<FirebaseFailure, List<Receipt>>> loadNewAppointmentsFromMarketplaces();
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
  //* ###### Load Appointments from Marketplaces #####
  Future<Either<AbstractFailure, List<ToLoadAppointmentsFromMarketplace>>> getToLoadAppointmentsFromMarketplaces();
  Future<Either<AbstractFailure, LoadedOrderFromMarketplace>> loadAppointmentsFromMarketplace(ToLoadAppointmentFromMarketplace toLoadAppointment);
  Future<Either<AbstractFailure, Receipt>> uploadLoadedAppointmentToFirestore(LoadedOrderFromMarketplace loadedAppointmentFromMarketplace);
  Future<Either<AbstractFailure, Receipt>> loadAppointmentFromMarketplaceAndUploadToFirestore(Marketplace marketplace, int toLoadOrderId);
}
