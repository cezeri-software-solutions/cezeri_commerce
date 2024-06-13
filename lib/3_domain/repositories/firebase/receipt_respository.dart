import 'package:dartz/dartz.dart';

import '../../../failures/abstract_failure.dart';
import '../../entities/carrier/parcel_tracking.dart';
import '../../entities/receipt/load_appointments_helper/to_load_appointments_from_marketplace.dart';
import '../../entities/receipt/receipt.dart';
import '../../entities/receipt/receipt_product.dart';

abstract class ReceiptRepository {
  Future<Either<AbstractFailure, Receipt>> getReceipt(Receipt receipt);
  Future<Either<AbstractFailure, List<Receipt>>> getListOfReceipts(int value, ReceiptTyp receiptTyp, {bool sortOutDeliveryBlocked = false});
  Future<Either<AbstractFailure, Unit>> updateReceipt(
    Receipt receipt,
    List<ReceiptProduct> oldListOfReceiptProducts,
    List<ReceiptProduct> newListOfReceiptProducts,
  );
  Future<Either<AbstractFailure, Receipt>> createReceiptManually(Receipt receipt);
  Future<Either<AbstractFailure, Unit>> deleteListOfReceipts(List<Receipt> listOfReceipts);
  //* ###### Generate Receipts #####
  Future<Either<AbstractFailure, List<Receipt>>> generateFromListOfOffersNewAppointments(List<Receipt> listOfOffers);
  Future<Either<AbstractFailure, List<Receipt>>> generateFromListOfAppointments(
    List<Receipt> listOfReceipts,
    bool generateDeliveryNote,
    bool generateInvoice,
  );
  Future<Either<AbstractFailure, List<Receipt>>> generateFromAppointment(
    Receipt incomingAppointment,
    Receipt originalAppointment,
    bool generateDeliveryNote,
    bool generateInvoice,
  );
  Future<Either<AbstractFailure, Receipt>> generateFromListOfDeliveryNotesNewInvoice(List<Receipt> listOfDeliveryNotes);
  Future<Either<AbstractFailure, Receipt>> generateFromInvoiceNewCredit(Receipt invoice);
  Future<Either<AbstractFailure, ParcelTracking>> createNewParcelForReceipt(Receipt deliveryNote, double weight);
  //* ###### Load Appointments from Marketplaces #####
  Future<Either<AbstractFailure, List<ToLoadAppointmentsFromMarketplace>>> getToLoadAppointmentsFromMarketplaces();
  Future<Either<AbstractFailure, LoadedOrderFromMarketplace>> loadAppointmentsFromMarketplacePresta(
      ToLoadAppointmentFromMarketplace toLoadAppointment);
  Future<Either<AbstractFailure, List<LoadedOrderFromMarketplace>>> loadAppointmentsFromMarketplaceShopify(
      ToLoadAppointmentsFromMarketplace toLoadAppointment);
  Future<Either<AbstractFailure, Receipt>> uploadLoadedAppointmentToFirestore(LoadedOrderFromMarketplace loadedAppointmentFromMarketplace);
}
