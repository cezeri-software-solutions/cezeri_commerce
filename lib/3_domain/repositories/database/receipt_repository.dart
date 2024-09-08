import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../failures/abstract_failure.dart';
import '../../entities/carrier/parcel_tracking.dart';
import '../../entities/receipt/load_appointments_helper/to_load_appointments_from_marketplace.dart';
import '../../entities/receipt/receipt.dart';
import '../../entities/receipt/receipt_product.dart';

abstract class ReceiptRepository {
  Future<Either<AbstractFailure, Receipt>> getReceipt(String receiptId, ReceiptType receiptType);
  Future<Either<AbstractFailure, List<Receipt>>> getListOfReceipts(int value, ReceiptType receiptTyp, {bool sortOutDeliveryBlocked = false});
  Future<Either<AbstractFailure, int>> getTotalNumberOfReceiptsBySearchText({
    required ReceiptType receiptType,
    required int tabIndex,
    required String searchText,
  });
  Future<Either<AbstractFailure, List<Receipt>>> getListOfReceiptsPerPageBySearchText({
    required int tabIndex,
    required ReceiptType receiptType,
    required String searchText,
    required int currentPage,
    required int itemsPerPage,
  });
  Future<Either<AbstractFailure, List<Receipt>>> getListOfReceiptsBetweenDates({
    required DateTimeRange dates,
    required ReceiptType receiptType,
  });
  Future<Either<AbstractFailure, List<Receipt>>> getListOfReceiptsByCustomerId(String customerId);
  Future<Either<AbstractFailure, List<Receipt>>> getListOfReceiptsByReceiptId(String receiptId);
  Future<Either<AbstractFailure, Unit>> updateReceipt(
    Receipt receipt,
    List<ReceiptProduct> oldListOfReceiptProducts,
    List<ReceiptProduct> newListOfReceiptProducts,
  );

  Future<Either<AbstractFailure, Receipt>> createReceiptManually(Receipt receipt);
  Future<Either<AbstractFailure, List<Receipt>>> createPosReceipts(Receipt receipt);
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
  Future<Either<AbstractFailure, Receipt>> generateFromInvoiceNewCredit(Receipt invoice, bool setQuantity);
  Future<Either<AbstractFailure, ParcelTracking>> createNewParcelForReceipt(Receipt deliveryNote, double weight);
  //* ###### Load Appointments from Marketplaces #####
  Future<Either<AbstractFailure, List<ToLoadAppointmentsFromMarketplace>>> getToLoadAppointmentsFromMarketplaces();
  Future<Either<AbstractFailure, LoadedOrderFromMarketplace>> loadAppointmentsFromMarketplacePresta(
      ToLoadAppointmentFromMarketplace toLoadAppointment);
  Future<Either<AbstractFailure, List<LoadedOrderFromMarketplace>>> loadAppointmentsFromMarketplaceShopify(
      ToLoadAppointmentsFromMarketplace toLoadAppointment);
  Future<Either<AbstractFailure, Receipt>> uploadLoadedAppointmentToDatabase(LoadedOrderFromMarketplace loadedAppointmentFromMarketplace);
}
