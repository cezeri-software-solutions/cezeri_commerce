import 'dart:convert';

import 'package:cezeri_commerce/1_presentation/core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../3_domain/entities/marketplace/marketplace_shopify.dart';
import '../../../constants.dart';
import '../../../failures/failures.dart';
import 'shopify_repository_get.dart';

class ShopifyRepositoryPost {
  ShopifyRepositoryPost();

  final supabase = GetIt.I<SupabaseClient>();

  Future<Either<AbstractFailure, Unit>> postInventoryItemAvailability({
    required String ownerId,
    required MarketplaceShopify marketplace,
    required int productId, // Artikel-ID im Marktplatz
    required int quantity,
    required int inventoryItemId,
    required int locationId,
  }) async {
    try {
      print('quantity: $quantity');
      print('inventoryItemId: $inventoryItemId');
      print('locationId: $locationId');

      await supabase.functions.invoke(
        'shopify_api',
        body: jsonEncode({
          'marketplaceId': marketplace.id,
          'ownerId': ownerId,
          'functionName': 'postInventoryItemAvailability',
          'quantity': quantity,
          'inventoryItemId': inventoryItemId,
          'locationId': locationId
        }),
      );

      return const Right(unit);
    } catch (e) {
      logger.e('Error: $e');
      return Left(ShopifyGeneralFailure(errorMessage: e.toString()));
    }
  }

  Future<Either<AbstractFailure, Unit>> postProductStock({
    required String ownerId,
    required MarketplaceShopify marketplace,
    required int productId, // Artikel-ID im Marktplatz
    required int quantity,
  }) async {
    final fosProductRaw = await ShopifyRepositoryGet().getProductRawById(ownerId, marketplace, productId);
    if (fosProductRaw.isLeft()) return Left(fosProductRaw.getLeft());

    final inventoryItemId = fosProductRaw.getRight().variants.first.inventoryItemId;

    final fosInventoryLevel = await ShopifyRepositoryGet().getInventoryLevelByInventoryItemId(ownerId, marketplace, inventoryItemId);
    if (fosInventoryLevel.isLeft()) return Left(fosInventoryLevel.getLeft());
    final locationId = fosInventoryLevel.getRight().locationId;

    final response = await postInventoryItemAvailability(
      ownerId: ownerId,
      marketplace: marketplace,
      productId: productId,
      quantity: quantity,
      inventoryItemId: inventoryItemId,
      locationId: locationId,
    );

    return response;
  }
}
