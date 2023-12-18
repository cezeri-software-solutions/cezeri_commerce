import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../3_domain/entities/receipt/receipt.dart';
import '../../../3_domain/entities/statistic/stat_dashboard.dart';
import '../../../3_domain/entities/statistic/stat_product.dart';
import '../../../3_domain/entities/statistic/stat_product_detail.dart';

//? ###########################################################################################################################
//? #################################################### STAT PRODUCT #########################################################
//? ###########################################################################################################################

Future<void> createOrIncrementStatDashboardOnCreateReceipt(
  Receipt receipt,
  DocumentReference<Map<String, dynamic>> docRefStatDashboard,
  DocumentSnapshot<Map<String, dynamic>> dsStatDashboard,
  Transaction? transaction,
) async {
  if (!dsStatDashboard.exists) {
    final StatDashboard phStatDashboard = StatDashboard.empty();
    final StatDashboard statDashboard = phStatDashboard.copyWith(
      statDashboardId: docRefStatDashboard.id,
      dateTime: DateTime.now(),
      incomingOrders: receipt.receiptTyp == ReceiptTyp.appointment ? receipt.totalNet : 0,
      salesVolume: receipt.receiptTyp == ReceiptTyp.invoice ? receipt.totalNet : 0,
      offerVolume: receipt.receiptTyp == ReceiptTyp.offer ? receipt.totalNet : 0,
    );
    if (transaction != null) {
      transaction.set(docRefStatDashboard, statDashboard.toJson());
    } else {
      docRefStatDashboard.set(statDashboard.toJson());
    }
  } else {
    if (receipt.receiptTyp == ReceiptTyp.appointment) {
      if (transaction != null) {
        transaction.update(docRefStatDashboard, {'incomingOrders': FieldValue.increment(receipt.totalNet)});
      } else {
        docRefStatDashboard.update({'incomingOrders': FieldValue.increment(receipt.totalNet)});
      }
    }
    if (receipt.receiptTyp == ReceiptTyp.invoice) {
      if (transaction != null) {
        transaction.update(docRefStatDashboard, {'salesVolume': FieldValue.increment(receipt.totalNet)});
      } else {
        docRefStatDashboard.update({'salesVolume': FieldValue.increment(receipt.totalNet)});
      }
    }
    if (receipt.receiptTyp == ReceiptTyp.offer) {
      if (transaction != null) {
        transaction.update(docRefStatDashboard, {'offerVolume': FieldValue.increment(receipt.totalNet)});
      } else {
        docRefStatDashboard.update({'offerVolume': FieldValue.increment(receipt.totalNet)});
      }
    }
  }
}

Future<void> incrementStatDashboardOnUpdateReceipt(
  Receipt receipt,
  Receipt receiptBeforeUpdate,
  DocumentReference<Map<String, dynamic>> docRefStatDashboard,
  DocumentSnapshot<Map<String, dynamic>> dsStatDashboard,
  Transaction transaction,
) async {
  final double difference = receipt.totalNet - receiptBeforeUpdate.totalNet;
  if (dsStatDashboard.exists) {
    if (receipt.receiptTyp == ReceiptTyp.appointment) {
      transaction.update(docRefStatDashboard, {'incomingOrders': FieldValue.increment(difference)});
    }
    if (receipt.receiptTyp == ReceiptTyp.invoice) {
      transaction.update(docRefStatDashboard, {'salesVolume': FieldValue.increment(difference)});
    }
    if (receipt.receiptTyp == ReceiptTyp.offer) {
      transaction.update(docRefStatDashboard, {'offerVolume': FieldValue.increment(difference)});
    }
  }
}

Future<void> incrementStatDashboardOnDeleteReceipt(
  Receipt receipt,
  DocumentReference<Map<String, dynamic>> docRefStatDashboard,
  DocumentSnapshot<Map<String, dynamic>> dsStatDashboard,
  Transaction transaction,
) async {
  if (dsStatDashboard.exists) {
    if (receipt.receiptTyp == ReceiptTyp.appointment) {
      transaction.update(docRefStatDashboard, {'incomingOrders': FieldValue.increment(-receipt.totalNet)});
    }
    if (receipt.receiptTyp == ReceiptTyp.invoice) {
      transaction.update(docRefStatDashboard, {'salesVolume': FieldValue.increment(-receipt.totalNet)});
    }
    if (receipt.receiptTyp == ReceiptTyp.offer) {
      transaction.update(docRefStatDashboard, {'offerVolume': FieldValue.increment(-receipt.totalNet)});
    }
  }
}

Future<void> createOrIncrementStatDashboardOnGenerateFromOfferNewAppointment(
  Receipt offer,
  DocumentReference<Map<String, dynamic>> docRefStatDashboardToUpdate,
  DocumentReference<Map<String, dynamic>> docRefStatDashboardToCreate,
  DocumentSnapshot<Map<String, dynamic>>? statDashboardToUpdate,
  DocumentSnapshot<Map<String, dynamic>> statDashboardToCreate,
  Transaction transaction,
) async {
  final DateTime now = DateTime.now();
  if (statDashboardToUpdate == null) {
    if (statDashboardToCreate.exists) {
      final StatDashboard phToEditStatDashboard = StatDashboard.fromJson(statDashboardToCreate.data()!);
      final StatDashboard toEditStatDashboard = phToEditStatDashboard.copyWith(
        offerVolume: phToEditStatDashboard.offerVolume - offer.totalNet,
        incomingOrders: phToEditStatDashboard.incomingOrders + offer.totalNet,
      );
      transaction.update(docRefStatDashboardToCreate, toEditStatDashboard.toJson());
    }
  } else {
    if (statDashboardToUpdate.exists) {
      transaction.update(docRefStatDashboardToUpdate, {'offerVolume': FieldValue.increment(-offer.totalNet)});
    }
    if (statDashboardToCreate.exists) {
      transaction.update(docRefStatDashboardToCreate, {'incomingOrders': FieldValue.increment(offer.totalNet)});
    } else {
      final StatDashboard phStatDashboard = StatDashboard.empty();
      final StatDashboard statDashboard = phStatDashboard.copyWith(
        statDashboardId: docRefStatDashboardToCreate.id,
        dateTime: now,
        incomingOrders: offer.totalNet,
      );
      transaction.set(docRefStatDashboardToCreate, statDashboard.toJson());
    }
  }
}

Future<void> createOrIncrementStatDashboardOnGenerateFromAppointmentNewInvoice(
  Receipt receipt,
  DocumentReference<Map<String, dynamic>> docRefStatDashboardToCreate,
  DocumentSnapshot<Map<String, dynamic>> statDashboardToCreate,
  Transaction transaction,
) async {
  final DateTime now = DateTime.now();
  if (statDashboardToCreate.exists) {
    transaction.update(docRefStatDashboardToCreate, {'salesVolume': FieldValue.increment(receipt.totalNet)});
  } else {
    final StatDashboard phStatDashboard = StatDashboard.empty();
    final StatDashboard statDashboard = phStatDashboard.copyWith(
      statDashboardId: docRefStatDashboardToCreate.id,
      dateTime: now,
      salesVolume: receipt.totalNet,
    );
    transaction.set(docRefStatDashboardToCreate, statDashboard.toJson());
  }
}

Future<void> createOrIncrementStatDashboardOnGenerateFromInvoiceNewCredit(
  Receipt receipt,
  DocumentReference<Map<String, dynamic>> docRefStatDashboardToUpdate,
  DocumentReference<Map<String, dynamic>> docRefStatDashboardToCreate,
  DocumentSnapshot<Map<String, dynamic>>? statDashboardToUpdate,
  DocumentSnapshot<Map<String, dynamic>> statDashboardToCreate,
  Transaction transaction,
) async {
  if (statDashboardToUpdate == null) {
    if (statDashboardToCreate.exists) {
      transaction.update(docRefStatDashboardToCreate, {'salesVolume': FieldValue.increment(-receipt.totalNet)});
    }
  } else {
    if (statDashboardToUpdate.exists) {
      transaction.update(docRefStatDashboardToUpdate, {'salesVolume': FieldValue.increment(-receipt.totalNet)});
    }
  }
}

//? ###########################################################################################################################
//? #################################################### STAT PRODUCT #########################################################
//? ###########################################################################################################################

Future<void> createOrIncrementStatProductOnCreateReceipt(
  Receipt receipt,
  String currentUserUid,
  FirebaseFirestore db,
) async {
  final now = DateTime.now();
  final curYear = now.year;
  final curMonth = now.month;

  for (final receiptProduct in receipt.listOfReceiptProduct) {
    if (!receiptProduct.isFromDatabase) continue;
    final docRefStatProduct = db.collection('StatProducts').doc(currentUserUid).collection('$curYear$curMonth').doc(receiptProduct.productId);
    DocumentSnapshot<Map<String, dynamic>> dsStatProduct = await docRefStatProduct.get();
    if (!dsStatProduct.exists) {
      final StatProduct statProduct = StatProduct.empty().copyWith(
        statProductId: docRefStatProduct.id,
        name: receiptProduct.name,
        articleNumber: receiptProduct.articleNumber,
        ean: receiptProduct.ean,
        listOfStatProductDetail: [StatProductDetail.fromReceitProduct(receipt, receiptProduct)],
        lastEditingDate: receipt.creationDate, //now,
        creationDate: receipt.creationDate, //now,
      );
      docRefStatProduct.set(statProduct.toJson());
    } else {
      final phStatProduct = StatProduct.fromJson(dsStatProduct.data()!);
      StatProduct statProduct = phStatProduct.copyWith(
        listOfStatProductDetail: phStatProduct.listOfStatProductDetail..add(StatProductDetail.fromReceitProduct(receipt, receiptProduct)),
        lastEditingDate: receipt.creationDate, //now,
      );
      docRefStatProduct.update(statProduct.toJson());
    }
  }
}
