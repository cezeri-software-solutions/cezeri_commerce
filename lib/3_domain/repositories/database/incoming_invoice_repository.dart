import 'package:dartz/dartz.dart';

import '../../../failures/abstract_failure.dart';
import '../../entities/incoming_invoice/incoming_invoice.dart';

abstract class IncomingInvoiceRepository {
  Future<Either<AbstractFailure, IncomingInvoice>> createIncomingInvoice(IncomingInvoice incomingInvoice);
  Future<Either<AbstractFailure, IncomingInvoice>> getIncomingInvoice(String id);
  Future<Either<AbstractFailure, int>> getCountOfIncomingInvoices(String searchText);
  Future<Either<AbstractFailure, List<IncomingInvoice>>> getListOfIncomingInvoices({
    required String searchText,
    required int currentPage,
    required int itemsPerPage,
  });
  Future<Either<AbstractFailure, IncomingInvoice>> updateIncomingInvoice(IncomingInvoice incomingInvoice);
  Future<Either<AbstractFailure, Unit>> deleteIncomingInvoice(String id);
}
