import 'package:cezeri_commerce/3_domain/entities/product/booking_product.dart';
import 'package:cezeri_commerce/3_domain/entities/reorder/reorder.dart';
import 'package:cezeri_commerce/failures/firebase_failures.dart';
import 'package:dartz/dartz.dart';

import '../../../1_presentation/core/core.dart';
import '../../../3_domain/entities/reorder/reorder_product.dart';
import '../../../3_domain/enums/enums.dart';
import '../../../3_domain/repositories/firebase/main_settings_respository.dart';
import '../../../3_domain/repositories/firebase/product_repository.dart';
import '../../../3_domain/repositories/firebase/reorder_repository.dart';
import '../../../3_domain/repositories/marketplace/marketplace_edit_repository.dart';
import '../../../constants.dart';
import '../../../failures/abstract_failure.dart';
import '../functions/repository_functions.dart';

class ReorderRepositoryImpl implements ReorderRepository {
  final MarketplaceEditRepository marketplaceEditRepository;
  final ProductRepository productRepository;
  final MainSettingsRepository settingsRepository;

  ReorderRepositoryImpl({
    required this.marketplaceEditRepository,
    required this.productRepository,
    required this.settingsRepository,
  });

  @override
  Future<Either<AbstractFailure, Reorder>> createReorder(Reorder reorder) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final databaseReorders = supabase.from('d_reorders');
    final databaseSettings = supabase.from('d_main_settings');

    try {
      final fosSettings = await settingsRepository.getSettings();
      if (fosSettings.isLeft()) return Left(fosSettings.getLeft());
      final settings = fosSettings.getRight();

      final reorderJson = reorder.toJson();
      reorderJson.addEntries([MapEntry('ownerId', ownerId)]);
      final reorderResponse = await databaseReorders.insert(reorderJson).select('*').single();
      final createdReorder = Reorder.fromJson(reorderResponse);

      final updatedSettings = settings.copyWith(nextReorderNumber: settings.nextReorderNumber + 1);
      await databaseSettings.update(updatedSettings.toJson()).eq('settingsId', settings.settingsId);

      return Right(createdReorder);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Erstellen der Nachbestellung ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, Reorder>> getReorder(String id) async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final query = supabase.from('d_reorders').select().eq('ownerId', ownerId).eq('id', id).single();

    try {
      final response = await query;
      final reorder = Reorder.fromJson(response);

      return Right(reorder);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Laden der Nachbestellung ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, List<Reorder>>> getListOfReorders(GetReordersType getReordersType) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final preQuery = supabase.from('d_reorders').select().eq('ownerId', ownerId);
    final query = switch (getReordersType) {
      GetReordersType.open => preQuery.eq('reorderStatus', ReorderStatus.open.name),
      GetReordersType.partialOpen => preQuery.eq('reorderStatus', ReorderStatus.partiallyCompleted.name),
      GetReordersType.openOrPartialOpen =>
        preQuery.or('reorderStatus.eq.${ReorderStatus.open.name},reorderStatus.eq.${ReorderStatus.partiallyCompleted.name}'),
      GetReordersType.completed => preQuery.eq('reorderStatus', ReorderStatus.completed.name),
      GetReordersType.all => preQuery,
    };

    try {
      final listOfReorders = await query.then((list) => list.map((e) => Reorder.fromJson(e)).toList());
      if (listOfReorders.isEmpty) return const Right([]);

      return Right(listOfReorders);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Laden der Nachbestellungen ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, Reorder>> updateReorder(Reorder reorder) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    try {
      await supabase.from('d_reorders').update(reorder.toJson()).eq('ownerId', ownerId).eq('id', reorder.id);

      return Right(reorder);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Aktualisieren der Nachbestellung ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, Unit>> deleteReorder(String id) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    try {
      await supabase.from('d_reorders').delete().eq('ownerId', ownerId).eq('id', id);

      return const Right(unit);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Löschen der Nachbestellung ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, Unit>> deleteReorders(List<String> ids) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    try {
      for (final id in ids) {
        await deleteReorder(id);
      }

      return const Right(unit);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Löschen der Nachbestellungen ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, Unit>> updateReordersFromProductsBooking(List<BookingProduct> listOfBookingProducts) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    Reorder? curReorder;

    listOfBookingProducts.sort((a, b) => a.id.compareTo(b.id));

    try {
      for (final bookingProduct in listOfBookingProducts) {
        if (curReorder == null || (bookingProduct.reorderId != curReorder.id)) {
          final fosReorder = await getReorder(bookingProduct.reorderId);
          if (fosReorder.isLeft()) return Left(fosReorder.getLeft());
          curReorder = fosReorder.getRight();
        }

        //* Update Reorder
        List<ReorderProduct> listOfReorderProducts = List.from(curReorder.listOfReorderProducts);
        final index = listOfReorderProducts.indexWhere((e) => e.productId == bookingProduct.productId);
        if (index == -1) return Left(GeneralFailure());
        listOfReorderProducts[index] =
            listOfReorderProducts[index].copyWith(bookedQuantity: listOfReorderProducts[index].bookedQuantity + bookingProduct.toBookQuantity);
        final isReorderCompleted = listOfReorderProducts.every((e) => e.openQuantity <= 0);
        final updatedReorder = curReorder.copyWith(
          listOfReorderProducts: listOfReorderProducts,
          reorderStatus: isReorderCompleted ? ReorderStatus.completed : ReorderStatus.partiallyCompleted,
        );

        final fosUpdateReorder = await updateReorder(updatedReorder);
        if (fosUpdateReorder.isLeft()) return Left(fosUpdateReorder.getLeft());

        curReorder = updatedReorder;

        //* Update Product stocks
        final fosUpdateProductStock = await updateProductQuantityInDbAndMps(
          productId: bookingProduct.productId,
          incQuantity: bookingProduct.toBookQuantity,
          updateOnlyAvailableQuantity: false,
        );
        if (fosUpdateProductStock.isLeft()) return Left(fosUpdateProductStock.getLeft());
      }
      return const Right(unit);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Aktualisieren der Nachbestellung/en ist ein Fehler aufgetreten. Error: $e'));
    }
  }
}
