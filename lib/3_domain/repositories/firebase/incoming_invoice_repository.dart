import 'package:dartz/dartz.dart';

import '../../../failures/abstract_failure.dart';
import '../../entities/incoming_invoice/incoming_invoice.dart';

abstract class IncomingInvoiceRepository {
  Future<Either<AbstractFailure, IncomingInvoice>> createIncomingInvoice(IncomingInvoice incomingInvoice);
  Future<Either<AbstractFailure, IncomingInvoice>> getIncomingInvoice(String id);
  Future<Either<AbstractFailure, List<IncomingInvoice>>> getListOfIncomingInvoices();
  Future<Either<AbstractFailure, IncomingInvoice>> updateIncomingInvoice(IncomingInvoice gLAccount);
  Future<Either<AbstractFailure, Unit>> deleteIncomingInvoice(String id);
}