import 'dart:convert';

import 'package:cezeri_commerce/1_presentation/core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../3_domain/entities/marketplace/marketplace_shopify.dart';
import '../../../constants.dart';
import '../../../failures/failures.dart';
import 'shopify.dart';

class ShopifyRepositoryDelete {
  final MarketplaceShopify marketplace;
  final Map<String, String> credentials;

  ShopifyRepositoryDelete(this.marketplace)
      : credentials = {
          'storefrontToken': marketplace.storefrontAccessToken,
          'adminToken': marketplace.adminAccessToken,
          'url': '${marketplace.endpointUrl}${marketplace.storeName}.myshopify.com/${marketplace.shopSuffix}',
        };
  final supabase = GetIt.I<SupabaseClient>();

  Future<Either<AbstractFailure, Unit>> deleteCollect(int collectId) async {
    try {
      await supabase.functions.invoke(
        'shopify_api',
        body: jsonEncode({
          'credentials': credentials,
          'functionName': 'deleteCollect',
          'collectId': collectId,
        }),
      );

      return const Right(unit);
    } catch (e) {
      logger.e('Error on Marketplace ${marketplace.shortName}: $e');
      return Left(ShopifyGeneralFailure(errorMessage: e.toString()));
    }
  }

  Future<Either<AbstractFailure, Unit>> deleteProductImage(int productId, int imageId) async {
    try {
      await supabase.functions.invoke(
        'shopify_api',
        body: jsonEncode({
          'credentials': credentials,
          'functionName': 'deleteProductImage',
          'productId': productId,
          'imageId': imageId,
        }),
      );

      return const Right(unit);
    } catch (e) {
      logger.e('Error on Marketplace ${marketplace.shortName}: $e');
      return Left(ShopifyGeneralFailure(errorMessage: e.toString()));
    }
  }

  Future<Either<List<AbstractFailure>, Unit>> deleteProductImages({required int productId}) async {
    final List<AbstractFailure> failures = [];

    final fosProductRaw = await ShopifyRepositoryGet(marketplace).getProductRawById(productId);
    if (fosProductRaw.isLeft()) return Left([fosProductRaw.getLeft()]);

    final productRawShopify = fosProductRaw.getRight();
    if (productRawShopify.images.isEmpty) return const Right(unit);

    for (final image in productRawShopify.images) {
      final deleteResult = await deleteProductImage(productId, image.id);
      if (deleteResult.isLeft()) failures.add(deleteResult.getLeft());
    }

    if (failures.isNotEmpty) return Left(failures);
    return const Right(unit);
  }

  Future<Either<List<AbstractFailure>, Unit>> removeCollectionsFromProduct(
    ProductShopify productShopify,
    List<CustomCollectionShopify> toRemoveCustomCollections,
  ) async {
    List<AbstractFailure> putProductFailures = [];

    final collectsResult = await ShopifyRepositoryGet(marketplace).getCollectsOfProduct(productShopify.id);
    if (collectsResult.isLeft()) return Left([collectsResult.getLeft()]);
    final listOfCollects = collectsResult.getRight();

    for (final removedCustomCollection in toRemoveCustomCollections) {
      final index = listOfCollects.indexWhere((e) => e.collectionId == removedCustomCollection.id);
      if (index == -1) continue;
      final deletedCollectResult = await deleteCollect(listOfCollects[index].id);
      if (deletedCollectResult.isLeft()) putProductFailures.add(deletedCollectResult.getLeft());
    }

    return putProductFailures.isEmpty ? const Right(unit) : Left(putProductFailures);
  }
}
