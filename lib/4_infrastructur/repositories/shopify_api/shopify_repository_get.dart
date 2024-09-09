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
  final MarketplaceShopify marketplace;
  final Map<String, String> credentials;

  ShopifyRepositoryGet(this.marketplace)
      : credentials = {
          'storefrontToken': marketplace.storefrontAccessToken,
          'adminToken': marketplace.adminAccessToken,
          'url': '${marketplace.endpointUrl}${marketplace.storeName}.myshopify.com/${marketplace.shopSuffix}',
        };

  final supabase = GetIt.I<SupabaseClient>();

  //* Categories */
  Future<Either<AbstractFailure, List<CustomCollectionShopify>>> getCategories(MarketplaceShopify marketplace) async {
    try {
      final response = await supabase.functions.invoke(
        'shopify_api',
        body: jsonEncode({'credentials': credentials, 'functionName': 'getCustomCollectionsAll'}),
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

  Future<Either<AbstractFailure, List<CollectShopify>>> getCollectsOfProduct(
    MarketplaceShopify marketplace,
    int productId,
  ) async {
    try {
      final response = await supabase.functions.invoke(
        'shopify_api',
        body: jsonEncode({'credentials': credentials, 'functionName': 'getCollectsOfProduct', 'productId': productId}),
      );

      final responseData = response.data['collects'];
      final collects = List<CollectShopify>.from(responseData.map((model) => CollectShopify.fromJson(model)));
      return Right(collects);
    } catch (e) {
      logger.e('Error: $e');
      return Left(ShopifyGeneralFailure(errorMessage: e.toString()));
    }
  }

  Future<Either<AbstractFailure, List<CustomCollectionShopify>>> getCustomCollectionsByProductId(
    MarketplaceShopify marketplace,
    int productId,
  ) async {
    try {
      final response = await supabase.functions.invoke(
        'shopify_api',
        body: jsonEncode({
          'credentials': credentials,
          'functionName': 'getCustomCollectionsByProductId',
          'productId': productId,
        }),
      );

      final responseData = response.data['custom_collections'];
      final customCollections = List<CustomCollectionShopify>.from(responseData.map((model) => CustomCollectionShopify.fromJson(model)));
      return Right(customCollections);
    } catch (e) {
      logger.e('Error: $e');
      return Left(ShopifyGeneralFailure(errorMessage: e.toString()));
    }
  }

  //* Orders */
  Future<Either<AbstractFailure, Map<String, dynamic>>> getOrderFulfillmentsOfFulfillmentOrder(
    MarketplaceShopify marketplace,
    int orderId,
  ) async {
    try {
      final response = await supabase.functions.invoke(
        'shopify_api',
        body: jsonEncode({
          'credentials': credentials,
          'functionName': 'getOrderFulfillmentsOfFulfillmentOrder',
          'orderId': orderId,
        }),
      );

      return Right(response.data as Map<String, dynamic>);
    } catch (e) {
      logger.e('Error: $e');
      return Left(ShopifyGeneralFailure(errorMessage: e.toString()));
    }
  }

  //* Products */
  Future<Either<AbstractFailure, ProductRawShopify>> getProductRawById(
    MarketplaceShopify marketplace,
    int productId,
  ) async {
    try {
      final response = await supabase.functions.invoke(
        'shopify_api',
        body: jsonEncode({'credentials': credentials, 'functionName': 'getProductRawById', 'productId': productId}),
      );

      return Right(ProductRawShopify.fromJson(response.data['product']));
    } catch (e) {
      logger.e('Error: $e');
      return Left(ShopifyGeneralFailure(errorMessage: e.toString()));
    }
  }

  Future<Either<AbstractFailure, InventoryLevelShopify>> getInventoryLevelByInventoryItemId(
    MarketplaceShopify marketplace,
    int inventoryItemId,
  ) async {
    try {
      final response = await supabase.functions.invoke(
        'shopify_api',
        body: jsonEncode({
          'credentials': credentials,
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
