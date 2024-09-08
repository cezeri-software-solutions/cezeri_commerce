import 'package:cezeri_commerce/3_domain/entities/incoming_invoice/incoming_invoice.dart';
import 'package:cezeri_commerce/failures/abstract_failure.dart';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../3_domain/repositories/database/incoming_invoice_repository.dart';

class IncomingInvoiceRepositoryImpl implements IncomingInvoiceRepository {
  final SupabaseClient supabase;

  IncomingInvoiceRepositoryImpl({required this.supabase});

  @override
  Future<Either<AbstractFailure, IncomingInvoice>> createIncomingInvoice(IncomingInvoice incomingInvoice) async {
    // final isConnected = await checkInternetConnection();
    // if (!isConnected) return left(NoConnectionFailure());

    // final currentUserUid = firebaseAuth.currentUser!.uid;
    // final docRef = ColRef.get(ColRefType.incomingInvoice, db, currentUserUid).doc();

    // try {
    //   IncomingInvoice toCreateIncomingInvoice = incomingInvoice.copyWith(id: docRef.id);
    //   await docRef.set(toCreateIncomingInvoice.toJson());

    //   return right(toCreateIncomingInvoice);
    // } on FirebaseException catch (e) {
    //   logger.e(e.message);
    //   //TODO: not take id it have to be incomingInvoiceNumber
    //   return left(GeneralFailure(customMessage: 'Sachkonto: "${incomingInvoice.id}" konnte nicht erstellt werden.', e: e));
    // }
    throw UnimplementedError();
  }

  @override
  Future<Either<AbstractFailure, IncomingInvoice>> getIncomingInvoice(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<AbstractFailure, List<IncomingInvoice>>> getListOfIncomingInvoices() async {
    throw UnimplementedError();
  }

  @override
  Future<Either<AbstractFailure, IncomingInvoice>> updateIncomingInvoice(IncomingInvoice gLAccount) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<AbstractFailure, Unit>> deleteIncomingInvoice(String id) async {
    throw UnimplementedError();
  }
}
