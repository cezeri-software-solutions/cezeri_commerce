import '../../../3_domain/entities/receipt/receipt.dart';
import '../../../3_domain/entities/statistic/stat_dashboard.dart';
import '../../../3_domain/entities/statistic/stat_product.dart';
import '../../../3_domain/entities/statistic/stat_product_detail.dart';
import '../../../constants.dart';

//? ###########################################################################################################################
//? #################################################### STAT PRODUCT #########################################################
//? ###########################################################################################################################

Future<void> createOrIncrementStatDashboardOnCreateReceipt(Receipt receipt, String ownerId) async {
  final now = DateTime.now();
  final curYear = now.year;
  final curMonth = now.month;
  final id = '$curYear$curMonth';

  final database = supabase.from('d_stat_dashboards');
  final selectQuery = database.select().eq('ownerId', ownerId).eq('statDashboardId', id).single();

  try {
    final selectResponse = await selectQuery;
    final statDashboard = StatDashboard.fromJson(selectResponse);

    if (receipt.receiptTyp == ReceiptTyp.offer) {
      final updatedStatDashboard = statDashboard.copyWith(offerVolume: statDashboard.offerVolume + receipt.totalNet);
      await database.update(updatedStatDashboard.toJson()).eq('ownerId', ownerId).eq('statDashboardId', id);
    }

    if (receipt.receiptTyp == ReceiptTyp.appointment) {
      final updatedStatDashboard = statDashboard.copyWith(incomingOrders: statDashboard.incomingOrders + receipt.totalNet);
      await database.update(updatedStatDashboard.toJson()).eq('ownerId', ownerId).eq('statDashboardId', id);
    }

    if (receipt.receiptTyp == ReceiptTyp.invoice) {
      final updatedStatDashboard = statDashboard.copyWith(salesVolume: statDashboard.salesVolume + receipt.totalNet);
      await database.update(updatedStatDashboard.toJson()).eq('ownerId', ownerId).eq('statDashboardId', id);
    }
  } catch (e) {
    logger.e(e);

    final StatDashboard phStatDashboard = StatDashboard.empty();
    final StatDashboard statDashboard = phStatDashboard.copyWith(
      statDashboardId: id,
      dateTime: DateTime.now(),
      incomingOrders: receipt.receiptTyp == ReceiptTyp.appointment ? receipt.totalNet : 0,
      salesVolume: receipt.receiptTyp == ReceiptTyp.invoice ? receipt.totalNet : 0,
      offerVolume: receipt.receiptTyp == ReceiptTyp.offer ? receipt.totalNet : 0,
    );

    final statDashboardJson = statDashboard.toJson();
    statDashboardJson.addEntries([MapEntry('ownerId', ownerId)]);
    await database.insert(statDashboardJson);
  }
}

Future<void> incrementStatDashboardOnUpdateReceipt(Receipt receipt, Receipt receiptBeforeUpdate, String ownerId) async {
  final double difference = receipt.totalNet - receiptBeforeUpdate.totalNet;

  final id = '${receipt.creationDateMarektplace.year}${receipt.creationDateMarektplace.month}';

  final database = supabase.from('d_stat_dashboards');
  final selectQuery = database.select().eq('ownerId', ownerId).eq('statDashboardId', id).single();

  try {
    final selectResponse = await selectQuery;
    final statDashboard = StatDashboard.fromJson(selectResponse);

    if (receipt.receiptTyp == ReceiptTyp.offer) {
      final updatedStatDashboard = statDashboard.copyWith(offerVolume: statDashboard.offerVolume + difference);
      await database.update(updatedStatDashboard.toJson()).eq('ownerId', ownerId).eq('statDashboardId', id);
    }

    if (receipt.receiptTyp == ReceiptTyp.appointment) {
      final updatedStatDashboard = statDashboard.copyWith(incomingOrders: statDashboard.incomingOrders + difference);
      await database.update(updatedStatDashboard.toJson()).eq('ownerId', ownerId).eq('statDashboardId', id);
    }

    if (receipt.receiptTyp == ReceiptTyp.invoice) {
      final updatedStatDashboard = statDashboard.copyWith(salesVolume: statDashboard.salesVolume + difference);
      await database.update(updatedStatDashboard.toJson()).eq('ownerId', ownerId).eq('statDashboardId', id);
    }
  } catch (e) {
    logger.e(e);
    return;
  }
}

Future<void> incrementStatDashboardOnDeleteReceipt(Receipt receipt, String ownerId) async {
  final id = '${receipt.creationDateMarektplace.year}${receipt.creationDateMarektplace.month}';

  final database = supabase.from('d_stat_dashboards');
  final selectQuery = database.select().eq('ownerId', ownerId).eq('statDashboardId', id).single();

  try {
    final selectResponse = await selectQuery;
    final statDashboard = StatDashboard.fromJson(selectResponse);

    if (receipt.receiptTyp == ReceiptTyp.offer) {
      final updatedStatDashboard = statDashboard.copyWith(offerVolume: statDashboard.offerVolume - receipt.totalNet);
      await database.update(updatedStatDashboard.toJson()).eq('ownerId', ownerId).eq('statDashboardId', id);
    }

    if (receipt.receiptTyp == ReceiptTyp.appointment) {
      final updatedStatDashboard = statDashboard.copyWith(incomingOrders: statDashboard.incomingOrders - receipt.totalNet);
      await database.update(updatedStatDashboard.toJson()).eq('ownerId', ownerId).eq('statDashboardId', id);
    }

    if (receipt.receiptTyp == ReceiptTyp.invoice) {
      final updatedStatDashboard = statDashboard.copyWith(salesVolume: statDashboard.salesVolume - receipt.totalNet);
      await database.update(updatedStatDashboard.toJson()).eq('ownerId', ownerId).eq('statDashboardId', id);
    }
  } catch (e) {
    logger.e(e);
    return;
  }
}

Future<void> createOrIncrementStatDashboardOnGenerateFromOfferNewAppointment(Receipt offer, String ownerId) async {
  final now = DateTime.now();
  final curYear = now.year;
  final curMonth = now.month;
  final idCreate = '$curYear$curMonth';
  final idUpdate = '${offer.creationDate.year}${offer.creationDate.month}';

  final database = supabase.from('d_stat_dashboards');
  final selectQueryToCreate = database.select().eq('ownerId', ownerId).eq('statDashboardId', idCreate).single();
  final selectQueryToUpdate = database.select().eq('ownerId', ownerId).eq('statDashboardId', idUpdate).single();

  //* Wenn Angebot und Auftag im selben Monat sind
  if (DateTime(offer.creationDate.year, offer.creationDate.month) == DateTime(now.year, now.month)) {
    try {
      final selectCreateResponse = await selectQueryToCreate;
      final statDashboardToCreate = StatDashboard.fromJson(selectCreateResponse);

      final StatDashboard toEditStatDashboard = statDashboardToCreate.copyWith(
        offerVolume: statDashboardToCreate.offerVolume - offer.totalNet,
        incomingOrders: statDashboardToCreate.incomingOrders + offer.totalNet,
      );

      await database.update(toEditStatDashboard.toJson()).eq('ownerId', ownerId).eq('statDashboardId', idCreate);
    } catch (eCreate) {
      logger.e(eCreate);
      return;
    }
  } else {
    //* Das zu bearbeitende Angebot-Dashboard
    try {
      final selectUpdateResponse = await selectQueryToUpdate;
      final statDashboardToUpdate = StatDashboard.fromJson(selectUpdateResponse);

      final StatDashboard editedStatDashboardToUpdate = statDashboardToUpdate.copyWith(
        offerVolume: statDashboardToUpdate.offerVolume - offer.totalNet,
      );

      await database.update(editedStatDashboardToUpdate.toJson()).eq('ownerId', ownerId).eq('statDashboardId', idUpdate);
    } catch (eUpdate) {
      logger.e(eUpdate);
    }

    //* Das zu bearbeitende Auftrag-Dashboard
    //* Wenn es NICHT der erste Auftrag im neuen Monat ist
    try {
      final selectCreateResponse = await selectQueryToCreate;
      final statDashboardToCreate = StatDashboard.fromJson(selectCreateResponse);

      final StatDashboard editedStatDashboardToCreate = statDashboardToCreate.copyWith(
        incomingOrders: statDashboardToCreate.incomingOrders + offer.totalNet,
      );

      await database.update(editedStatDashboardToCreate.toJson()).eq('ownerId', ownerId).eq('statDashboardId', idCreate);
      //* Wenn es der erste Auftrag im neuen Monat ist
    } catch (eCreate) {
      logger.e(eCreate);

      final StatDashboard phStatDashboard = StatDashboard.empty();
      final StatDashboard statDashboard = phStatDashboard.copyWith(
        statDashboardId: idCreate,
        dateTime: now,
        incomingOrders: offer.totalNet,
      );

      final statDashboardJson = statDashboard.toJson();
      statDashboardJson.addEntries([MapEntry('ownerId', ownerId)]);
      await database.insert(statDashboardJson);
    }
  }
}

// Future<void> createOrIncrementStatDashboardOnGenerateFromAppointmentNewInvoice(
//   Receipt receipt,
//   DocumentReference<Map<String, dynamic>> docRefStatDashboardToCreate,
//   DocumentSnapshot<Map<String, dynamic>> statDashboardToCreate,
//   Transaction transaction,
// ) async {
//   final DateTime now = DateTime.now();
//   if (statDashboardToCreate.exists) {
//     transaction.update(docRefStatDashboardToCreate, {'salesVolume': FieldValue.increment(receipt.totalNet)});
//   } else {
//     final StatDashboard phStatDashboard = StatDashboard.empty();
//     final StatDashboard statDashboard = phStatDashboard.copyWith(
//       statDashboardId: docRefStatDashboardToCreate.id,
//       dateTime: now,
//       salesVolume: receipt.totalNet,
//     );
//     transaction.set(docRefStatDashboardToCreate, statDashboard.toJson());
//   }
// }

Future<void> createOrIncrementStatDashboardOnGenerateFromInvoiceNewCredit(Receipt receipt, String ownerId) async {
  final now = DateTime.now();
  final curYear = now.year;
  final curMonth = now.month;
  final idCreate = '$curYear$curMonth';
  final idUpdate = '${receipt.creationDate.year}${receipt.creationDate.month}';

  final database = supabase.from('d_stat_dashboards');
  final selectQueryToCreate = database.select().eq('ownerId', ownerId).eq('statDashboardId', idCreate).single();
  final selectQueryToUpdate = database.select().eq('ownerId', ownerId).eq('statDashboardId', idUpdate).single();

  if (DateTime(receipt.creationDate.year, receipt.creationDate.month) == DateTime(now.year, now.month)) {
    try {
      final selectCreateResponse = await selectQueryToCreate;
      final statDashboardToCreate = StatDashboard.fromJson(selectCreateResponse);

      final StatDashboard editedStatDashboardToCreate = statDashboardToCreate.copyWith(
        salesVolume: statDashboardToCreate.salesVolume - receipt.totalNet,
      );

      await database.update(editedStatDashboardToCreate.toJson()).eq('ownerId', ownerId).eq('statDashboardId', idCreate);
      //* Wenn es der erste Auftrag im neuen Monat ist
    } catch (eCreate) {
      logger.e(eCreate);
    }
  } else {
    try {
      final selectUpdateResponse = await selectQueryToUpdate;
      final statDashboardToUpdate = StatDashboard.fromJson(selectUpdateResponse);

      final StatDashboard editedStatDashboardToUpdate = statDashboardToUpdate.copyWith(
        salesVolume: statDashboardToUpdate.salesVolume - receipt.totalNet,
      );

      await database.update(editedStatDashboardToUpdate.toJson()).eq('ownerId', ownerId).eq('statDashboardId', idUpdate);
    } catch (eUpdate) {
      logger.e(eUpdate);
    }
  }
}

//? ###########################################################################################################################
//? #################################################### STAT PRODUCT #########################################################
//? ###########################################################################################################################

Future<void> createOrIncrementStatProductOnCreateReceipt(Receipt receipt, String ownerId) async {
  final now = DateTime.now();
  final curYear = now.year;
  final curMonth = now.month;

  final database = supabase.from('d_stat_products');

  for (final receiptProduct in receipt.listOfReceiptProduct) {
    if (!receiptProduct.isFromDatabase) continue;
    try {
      final response = await database
          .select()
          .eq('ownerId', ownerId)
          .eq('statProductId', receiptProduct.productId)
          .filter('creationDate', 'gte', DateTime(curYear, curMonth, 1))
          .filter('creationDate', 'lt', DateTime(curYear, curMonth + 1, 1))
          .single();

      final curStatProduct = StatProduct.fromJson(response);

      StatProduct statProduct = curStatProduct.copyWith(
        listOfStatProductDetail: curStatProduct.listOfStatProductDetail..add(StatProductDetail.fromReceitProduct(receipt, receiptProduct)),
        lastEditingDate: receipt.creationDate, //now,
      );

      await database.update(statProduct.toJson()).eq('ownerId', ownerId).eq('statProductId', receipt.id);
    } catch (e) {
      logger.i(e);

      final StatProduct statProduct = StatProduct.empty().copyWith(
        statProductId: receipt.id,
        name: receiptProduct.name,
        articleNumber: receiptProduct.articleNumber,
        ean: receiptProduct.ean,
        listOfStatProductDetail: [StatProductDetail.fromReceitProduct(receipt, receiptProduct)],
        lastEditingDate: receipt.creationDate, //now,
        creationDate: receipt.creationDate, //now,
      );

      final statProductJson = statProduct.toJson();
      statProductJson.addEntries([MapEntry('ownerId', ownerId)]);
      await database.insert(statProductJson);
    }
  }
}
