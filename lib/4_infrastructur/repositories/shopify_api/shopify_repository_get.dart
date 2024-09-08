import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../3_domain/entities/marketplace/marketplace_shopify.dart';
import '../../../constants.dart';
import '../../../failures/failures.dart';
import 'models/inventory/inventory_level_shopify.dart';
import 'models/models.dart';

class ShopifyRepositoryGet {
  ShopifyRepositoryGet();

  final supabase = GetIt.I<SupabaseClient>();

  //* Categories */
  Future<Either<AbstractFailure, List<CustomCollectionShopify>>> getCategories(String ownerId, MarketplaceShopify marketplace) async {
    try {
      final response = await supabase.functions.invoke(
        'shopify_api',
        body: jsonEncode({'marketplaceId': marketplace.id, 'ownerId': ownerId, 'functionName': 'getCustomCollectionsAll'}),
      );

      final responseData = response.data;
      final List<dynamic> parsedData = responseData is String ? jsonDecode(responseData) : responseData;
      final customCollections = parsedData.map((e) {
        final item = e as Map<String, dynamic>;
        return CustomCollectionShopify.fromJson(item);
      }).toList();
      return Right(customCollections);
    } catch (e) {
      logger.e('Error: $e');
      return Left(ShopifyGeneralFailure(errorMessage: e.toString()));
    }
  }

  //* Products */
  Future<Either<AbstractFailure, ProductRawShopify>> getProductRawById(
    String ownerId,
    MarketplaceShopify marketplace,
    int productId,
  ) async {
    try {
      final response = await supabase.functions.invoke(
        'shopify_api',
        body: jsonEncode({'marketplaceId': marketplace.id, 'ownerId': ownerId, 'functionName': 'getProductRawById', 'productId': productId}),
      );

      return Right(ProductRawShopify.fromJson(response.data['product']));
    } catch (e) {
      logger.e('Error: $e');
      return Left(ShopifyGeneralFailure(errorMessage: e.toString()));
    }
  }

  Future<Either<AbstractFailure, InventoryLevelShopify>> getInventoryLevelByInventoryItemId(
    String ownerId,
    MarketplaceShopify marketplace,
    int inventoryItemId,
  ) async {
    try {
      final response = await supabase.functions.invoke(
        'shopify_api',
        body: jsonEncode({
          'marketplaceId': marketplace.id,
          'ownerId': ownerId,
          'functionName': 'getInventoryLevelByInventoryItemId',
          'inventoryItemId': inventoryItemId,
        }),
      );

      return Right(InventoryLevelShopify.fromJson(response.data));
    } catch (e) {
      logger.e('Error: $e');
      return Left(ShopifyGeneralFailure(errorMessage: e.toString()));
    }
  }
}
