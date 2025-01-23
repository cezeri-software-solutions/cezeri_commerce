import 'dart:convert';

import 'package:cezeri_commerce/1_presentation/core/core.dart';
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
  Future<Either<AbstractFailure, List<CustomCollectionShopify>>> getCategories() async {
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
      logger.e('Error on Marketplace ${marketplace.shortName}: $e');
      return Left(ShopifyGeneralFailure(errorMessage: e.toString()));
    }
  }

  Future<Either<AbstractFailure, List<CollectShopify>>> getCollectsOfProduct(int productId) async {
    try {
      final response = await supabase.functions.invoke(
        'shopify_api',
        body: jsonEncode({'credentials': credentials, 'functionName': 'getCollectsOfProduct', 'productId': productId}),
      );

      final responseData = response.data['collects'];
      final collects = List<CollectShopify>.from(responseData.map((model) => CollectShopify.fromJson(model)));
      return Right(collects);
    } catch (e) {
      logger.e('Error on Marketplace ${marketplace.shortName}: $e');
      return Left(ShopifyGeneralFailure(errorMessage: e.toString()));
    }
  }

  Future<Either<AbstractFailure, List<CustomCollectionShopify>>> getCustomCollectionsByProductId(int productId) async {
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
      logger.e('Error on Marketplace ${marketplace.shortName}: $e');
      return Left(ShopifyGeneralFailure(errorMessage: e.toString()));
    }
  }

  Future<Either<AbstractFailure, List<MetafieldShopify>>> getMetafieldsByProductId(int productId) async {
    try {
      final response = await supabase.functions.invoke(
        'shopify_api',
        body: jsonEncode({
          'credentials': credentials,
          'functionName': 'getMetafieldsByProductId',
          'productId': productId,
        }),
      );

      final responseData = response.data['metafields'];
      final customCollections = List<MetafieldShopify>.from(responseData.map((model) => MetafieldShopify.fromJson(model)));
      return Right(customCollections);
    } catch (e) {
      logger.e('Error on Marketplace ${marketplace.shortName}: $e');
      return Left(ShopifyGeneralFailure(errorMessage: e.toString()));
    }
  }

  //* Orders */
  Future<Either<AbstractFailure, Map<String, dynamic>>> getOrderFulfillmentsOfFulfillmentOrder(int orderId) async {
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
      logger.e('Error on Marketplace ${marketplace.shortName}: $e');
      return Left(ShopifyGeneralFailure(errorMessage: e.toString()));
    }
  }

  Future<Either<AbstractFailure, List<OrderShopify>>> getOrdersByCreatedAtMin(DateTime minDateTime) async {
    try {
      final response = await supabase.functions.invoke(
        'shopify_api',
        body: jsonEncode({
          'credentials': credentials,
          'functionName': 'getOrdersByCreatedAtMin',
          'minDateTime': (minDateTime.toUtc().toIso8601String()),
        }),
      );

      print(response.data);

      final responseData = response.data['orders'];
      final ordersShopify = List<OrderShopify>.from(responseData.map((model) => OrderShopify.fromJson(model)));
      return Right(ordersShopify);
    } catch (e) {
      logger.e('Error on Marketplace ${marketplace.shortName}: $e');
      return Left(ShopifyGeneralFailure(errorMessage: e.toString()));
    }
  }

  //* Products */
  Future<Either<AbstractFailure, List<ProductRawShopify>>> getProductsAllRaw() async {
    try {
      final response = await supabase.functions.invoke(
        'shopify_api',
        body: jsonEncode({'credentials': credentials, 'functionName': 'getProductsAllRaw'}),
      );

      final responseData = response.data;
      final List<dynamic> parsedData = responseData is String ? jsonDecode(responseData) : responseData;
      final customCollections = parsedData.map((e) {
        final item = e as Map<String, dynamic>;
        return ProductRawShopify.fromJson(item);
      }).toList();
      return Right(customCollections);
    } catch (e) {
      logger.e('Error on Marketplace ${marketplace.shortName}: $e');
      return Left(ShopifyGeneralFailure(errorMessage: e.toString()));
    }
  }

  Future<Either<AbstractFailure, ProductRawShopify>> getProductRawById(int productId) async {
    try {
      final response = await supabase.functions.invoke(
        'shopify_api',
        body: jsonEncode({'credentials': credentials, 'functionName': 'getProductRawById', 'productId': productId}),
      );

      return Right(ProductRawShopify.fromJson(response.data['product']));
    } catch (e) {
      logger.e('Error on Marketplace ${marketplace.shortName}: $e');
      return Left(ShopifyGeneralFailure(errorMessage: e.toString()));
    }
  }

  Future<Either<AbstractFailure, InventoryLevelShopify>> getInventoryLevelByInventoryItemId(int inventoryItemId) async {
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
      logger.e('Error on Marketplace ${marketplace.shortName}: $e');
      return Left(ShopifyGeneralFailure(errorMessage: e.toString()));
    }
  }

  Future<Either<AbstractFailure, ProductShopify>> getProductById(int productId) async {
    const defaultErrorMessage = 'Artikel konnte aus Shopify nicht geladen werden.';
    final fosProductsRaw = await getProductRawById(productId);
    if (fosProductsRaw.isLeft()) return Left(fosProductsRaw.getLeft());

    final productRaw = fosProductsRaw.getRight();

    final fosCustomCollections = await getCustomCollectionsByProductId(productRaw.variants.first.productId);
    if (fosCustomCollections.isLeft()) return Left(fosCustomCollections.getLeft());

    final customCollections = fosCustomCollections.getRight();

    final fosMetafields = await getMetafieldsByProductId(productRaw.variants.first.productId);
    if (fosMetafields.isLeft()) return Left(ShopifyGeneralFailure(errorMessage: defaultErrorMessage));

    final metafields = fosMetafields.getRight();

    final productShopify = ProductShopify.fromRaw(productRaw: productRaw, customCollections: customCollections, metafields: metafields);

    return Right(productShopify);
  }

  Future<Either<AbstractFailure, List<ProductShopify>>> getProductsByArticleNumber(String articleNumber) async {
    final defaultErrorMessage = 'Artikel mit der Artikelnummer: "$articleNumber" konnte nicht geladen werden.';

    final fosProductsRaw = await getProductsAllRaw();
    if (fosProductsRaw.isLeft()) return Left(fosProductsRaw.getLeft());

    final listOfProductRaw = fosProductsRaw.getRight().where((e) => e.variants.first.sku == articleNumber).toList();
    if (listOfProductRaw.isEmpty) {
      return Left(ShopifyGeneralFailure(errorMessage: 'Artikel mit der Artikelnummer: "$articleNumber" konnte nicht im Marktplatz gefunden werden.'));
    }

    final List<ProductShopify> listOfProductShopify = [];
    for (final productRaw in listOfProductRaw) {
      List<CustomCollectionShopify>? customCollections;
      final fosCustomCollections = await getCustomCollectionsByProductId(productRaw.variants.first.productId);
      fosCustomCollections.fold(
        (failure) => Left(failure),
        (data) => customCollections = data,
      );
      if (customCollections == null) return Left(ShopifyGeneralFailure(errorMessage: defaultErrorMessage));

      List<MetafieldShopify>? metafields;
      final fosMetafields = await getMetafieldsByProductId(productRaw.variants.first.productId);
      fosMetafields.fold(
        (failure) => Left(failure),
        (data) => metafields = data,
      );
      if (metafields == null) return Left(ShopifyGeneralFailure(errorMessage: defaultErrorMessage));

      final productShopify = ProductShopify.fromRaw(productRaw: productRaw, customCollections: customCollections!, metafields: metafields!);
      listOfProductShopify.add(productShopify);
    }
    return Right(listOfProductShopify);
  }
}
