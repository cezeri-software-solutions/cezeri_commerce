import 'package:dartz/dartz.dart';

import '../../../core/abstract_failure.dart';
import '../../../core/firebase_failures.dart';
import '../../entities/receipt/load_appointments_helper/to_load_appointments_from_marketplace.dart';
import '../../entities/receipt/receipt.dart';
import '../../entities/receipt/receipt_product.dart';

abstract class ReceiptRepository {
  Future<Either<FirebaseFailure, Receipt>> getReceipt(Receipt receipt);
  Future<Either<FirebaseFailure, List<Receipt>>> getListOfReceipts(int value, ReceiptTyp receiptTyp);
  Future<Either<FirebaseFailure, Unit>> updateReceipt(
    Receipt receipt,
    List<ReceiptProduct> oldListOfReceiptProducts,
    List<ReceiptProduct> newListOfReceiptProducts,
  );
  Future<Either<FirebaseFailure, Receipt>> createReceiptManually(Receipt receipt);
  Future<Either<FirebaseFailure, Unit>> deleteListOfReceipts(List<Receipt> listOfReceipts);
  //* ###### Generate Receipts #####
  Future<Either<FirebaseFailure, List<Receipt>>> generateFromListOfOffersNewAppointments(List<Receipt> listOfOffers);
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
  Future<Either<FirebaseFailure, Receipt>> generateFromInvoiceNewCredit(Receipt invoice);
  Future<Either<FirebaseFailure, Unit>> sendEmails();
  //* ###### Load Appointments from Marketplaces #####
  Future<Either<AbstractFailure, List<ToLoadAppointmentsFromMarketplace>>> getToLoadAppointmentsFromMarketplaces();
  Future<Either<AbstractFailure, LoadedOrderFromMarketplace>> loadAppointmentsFromMarketplace(ToLoadAppointmentFromMarketplace toLoadAppointment);
  Future<Either<AbstractFailure, Receipt>> uploadLoadedAppointmentToFirestore(LoadedOrderFromMarketplace loadedAppointmentFromMarketplace);
}
