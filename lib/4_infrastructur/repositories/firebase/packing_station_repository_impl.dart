import 'package:cezeri_commerce/3_domain/entities/id.dart';
import 'package:cezeri_commerce/3_domain/entities/picklist/picklist.dart';
import 'package:cezeri_commerce/3_domain/entities/product/product.dart';
import 'package:cezeri_commerce/4_infrastructur/repositories/functions/get_database.dart';
import 'package:cezeri_commerce/failures/firebase_failures.dart';
import 'package:dartz/dartz.dart';

import '../../../1_presentation/core/core.dart';
import '../../../3_domain/entities/picklist/picklist_product.dart';
import '../../../3_domain/entities/receipt/receipt.dart';
import '../../../3_domain/repositories/firebase/packing_station_repository.dart';
import '../../../3_domain/repositories/firebase/product_repository.dart';
import '../../../constants.dart';
import '../../../failures/abstract_failure.dart';
import '../functions/repository_functions.dart';

class PackingStationRepositoryImpl implements PackingStationRepository {
  final ProductRepository productRepository;

  PackingStationRepositoryImpl({required this.productRepository});

  @override
  Future<Either<AbstractFailure, List<Product>>> getListOfProducts(List<String> productIds) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    List<Product> listOfProducts = [];

    for (final productId in productIds) {
      final fosProduct = await productRepository.getProduct(productId, ownerId: ownerId);
      if (fosProduct.isLeft()) return Left(fosProduct.getLeft());
      listOfProducts.add(fosProduct.getRight());
    }

    return Right(listOfProducts);
  }

  @override
  Future<Either<AbstractFailure, Picklist>> createPicklist(List<Receipt> listOfAppointments) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final databasePicklist = supabase.from('d_picklists');

    final picklist = Picklist.fromListOfAppointments(listOfAppointments);
    final phToCreatePicklist = picklist.copyWith(id: UniqueID().value);

    final productIds = phToCreatePicklist.listOfPicklistProducts.map((e) => e.productId).toList();
    final uniqueProductIds = productIds.toSet().where((id) => id.isNotEmpty).toList();

    //* Funktion zum Aufteilen der Liste
    List<List<T>> splitList<T>(List<T> list, int chunkSize) {
      List<List<T>> chunks = [];
      for (int i = 0; i < list.length; i += chunkSize) {
        int end = (i + chunkSize < list.length) ? i + chunkSize : list.length;
        chunks.add(list.sublist(i, end));
      }
      return chunks;
    }

    //* Teilen der Liste in Teillisten mit maximal 30 Einträgen
    List<List<String>> splittedProductIds = splitList(uniqueProductIds, 30);

    try {
      List<Product> products = [];
      for (final idsChunk in splittedProductIds) {
        final loadedChunkProductsResponse = await supabase.from('d_products').select().eq('ownerId', ownerId).filter('id', 'in', idsChunk);
        final loadedChunkProducts = loadedChunkProductsResponse.map((e) => Product.fromJson(e)).toList();
        products.addAll(loadedChunkProducts);
      }

      List<PicklistProduct> listOfPicklistProducts = [];
      for (final picklistProduct in picklist.listOfPicklistProducts) {
        final product = products.where((e) => e.id == picklistProduct.productId).firstOrNull;
        if (product == null) {
          listOfPicklistProducts.add(picklistProduct);
        } else {
          final updatedPicklistProduct = picklistProduct.copyWith(imageUrl: product.listOfProductImages.where((e) => e.isDefault).first.fileUrl);
          listOfPicklistProducts.add(updatedPicklistProduct);
        }
      }

      final toCreatePicklist = phToCreatePicklist.copyWith(listOfPicklistProducts: listOfPicklistProducts);

      for (final appointment in listOfAppointments) {
        final appointmentResponse =
            await getReceiptDatabase(ReceiptType.appointment).select().eq('ownerId', ownerId).eq('id', appointment.id).single();
        final loadedAppointment = Receipt.fromJson(appointmentResponse);
        final updatedAppointment = loadedAppointment.copyWith(isPicked: true);
        await getReceiptDatabase(ReceiptType.appointment).update(updatedAppointment.toJson()).eq('ownerId', ownerId).eq('id', updatedAppointment.id);
      }

      final picklistJson = toCreatePicklist.toJson();
      picklistJson.addEntries([MapEntry('ownerId', ownerId)]);
      await databasePicklist.insert(picklistJson);

      return Right(toCreatePicklist);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Erstellen der Pickliste ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, Unit>> updatePicklist(Picklist picklist) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final database = supabase.from('d_picklists');
    final toUpdatePicklist = picklist.copyWith(lastEditingDate: DateTime.now());

    try {
      await database.update(toUpdatePicklist.toJson()).eq('ownerId', ownerId).eq('id', toUpdatePicklist.id);

      return const Right(unit);
    } catch (e) {
      logger.e(e);
      return left(GeneralFailure(customMessage: 'Beim Aktualisieren der Pickliste ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, List<Picklist>>> getListOfPicklists() async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final database = supabase.from('d_picklists');
    final query = database.select().eq('ownerId', ownerId).order('creationDate', ascending: false);

    try {
      final listOfPicklists = await query.then((json) => json.map((e) => Picklist.fromJson(e)).toList());

      return Right(listOfPicklists);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Laden der Picklisten ist ein Fehler aufgetreten. Error: $e'));
    }
  }
}
