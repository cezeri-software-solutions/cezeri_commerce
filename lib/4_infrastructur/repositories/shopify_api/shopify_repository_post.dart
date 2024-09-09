import 'dart:convert';

import 'package:cezeri_commerce/1_presentation/core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../3_domain/entities/carrier/parcel_tracking.dart';
import '../../../3_domain/entities/marketplace/marketplace_shopify.dart';
import '../../../3_domain/entities/product/product_image.dart';
import '../../../constants.dart';
import '../../../failures/failures.dart';
import 'shopify_repository_get.dart';

class ShopifyRepositoryPost {
  final MarketplaceShopify marketplace;
  final Map<String, String> credentials;

  ShopifyRepositoryPost(this.marketplace)
      : credentials = {
          'storefrontToken': marketplace.storefrontAccessToken,
          'adminToken': marketplace.adminAccessToken,
          'url': '${marketplace.endpointUrl}${marketplace.storeName}.myshopify.com/${marketplace.shopSuffix}',
        };

  final supabase = GetIt.I<SupabaseClient>();

  Future<Either<AbstractFailure, Unit>> postInventoryItemAvailability({
    required MarketplaceShopify marketplace,
    required int productId, // Artikel-ID im Marktplatz
    required int quantity,
    required int inventoryItemId,
    required int locationId,
  }) async {
    try {
      await supabase.functions.invoke(
        'shopify_api',
        body: jsonEncode({
          'credentials': credentials,
          'functionName': 'postInventoryItemAvailability',
          'postBody': {'location_id': locationId, 'inventory_item_id': inventoryItemId, 'available': quantity},
        }),
      );

      return const Right(unit);
    } catch (e) {
      logger.e('Error: $e');
      return Left(ShopifyGeneralFailure(errorMessage: e.toString()));
    }
  }

  Future<Either<AbstractFailure, Unit>> postCollect({
    required MarketplaceShopify marketplace,
    required int productId, // Artikel-ID im Marktplatz
    required int customCollectionId,
  }) async {
    try {
      await supabase.functions.invoke(
        'shopify_api',
        body: jsonEncode({
          'credentials': credentials,
          'functionName': 'postCollect',
          'postBody': {
            'collect': {
              'product_id': productId,
              'collection_id': customCollectionId,
            }
          },
        }),
      );

      return const Right(unit);
    } catch (e) {
      logger.e('Error: $e');
      return Left(ShopifyGeneralFailure(errorMessage: e.toString()));
    }
  }

  Future<Either<AbstractFailure, Unit>> postFulfillment({
    required MarketplaceShopify marketplace,
    required Map<String, Map<String, Object>> body,
  }) async {
    try {
      await supabase.functions.invoke(
        'shopify_api',
        body: jsonEncode({
          'credentials': credentials,
          'functionName': 'postFulfillment',
          'postBody': body,
        }),
      );

      return const Right(unit);
    } catch (e) {
      logger.e('Error: $e');
      return Left(ShopifyGeneralFailure(errorMessage: e.toString()));
    }
  }

  Future<Either<AbstractFailure, Unit>> postProductImage({
    required MarketplaceShopify marketplace,
    required int productId, // Artikel-ID im Marktplatz
    required Map<String, Map<String, Object>> postBody,
  }) async {
    try {
      await supabase.functions.invoke(
        'shopify_api',
        body: jsonEncode({
          'credentials': credentials,
          'functionName': 'postProductImage',
          'productId': productId,
          'postBody': postBody,
        }),
      );

      return const Right(unit);
    } catch (e) {
      logger.e('Error: $e');
      return Left(ShopifyGeneralFailure(errorMessage: e.toString()));
    }
  }

  Future<Either<AbstractFailure, Unit>> postProductStock({
    required MarketplaceShopify marketplace,
    required int productId, // Artikel-ID im Marktplatz
    required int quantity,
  }) async {
    final fosProductRaw = await ShopifyRepositoryGet(marketplace).getProductRawById(marketplace, productId);
    if (fosProductRaw.isLeft()) return Left(fosProductRaw.getLeft());

    final inventoryItemId = fosProductRaw.getRight().variants.first.inventoryItemId;

    final fosInventoryLevel = await ShopifyRepositoryGet(marketplace).getInventoryLevelByInventoryItemId(marketplace, inventoryItemId);
    if (fosInventoryLevel.isLeft()) return Left(fosInventoryLevel.getLeft());
    final locationId = fosInventoryLevel.getRight().locationId;

    final response = await postInventoryItemAvailability(
      marketplace: marketplace,
      productId: productId,
      quantity: quantity,
      inventoryItemId: inventoryItemId,
      locationId: locationId,
    );

    return response;
  }

  Future<Either<List<AbstractFailure>, Unit>> postProductImages({
    required MarketplaceShopify marketplace,
    required int productId, // Artikel-ID im Marktplatz
    required String productName,
    required List<ProductImage> productImages,
  }) async {
    final List<AbstractFailure> failures = [];

    int pos = 1;
    for (final image in productImages) {
      final response = await http.get(Uri.parse(image.fileUrl));
      String? imageData;
      if (response.statusCode == 200) imageData = base64Encode(response.bodyBytes);
      if (imageData == null) {
        failures.add(ShopifyGeneralFailure(errorMessage: 'Artikelbild konnte nicht aus der Datenbank geladen werden.'));
        continue;
      }

      final alt = pos == 1 ? productName : '${productName}_$pos';

      final body = {
        "image": {
          "position": pos,
          // "metafields": [{"key": "new", "value": image.fileName, "type": "single_line_text_field", "namespace": "global"}],
          "alt": alt,
          "attachment": imageData,
          "filename": image.fileName,
        }
      };

      final result = await postProductImage(marketplace: marketplace, productId: productId, postBody: body);

      if (result.isLeft()) failures.add(result.getLeft());

      pos++;
    }

    if (failures.isNotEmpty) return Left(failures);
    return const Right(unit);
  }

  Future<Either<AbstractFailure, Unit>> updateOrderStatusInMarketplace({
    required MarketplaceShopify marketplace,
    required int orderId,
    required ParcelTracking? parcelTracking,
  }) async {
    final fulfillmentOrdersResponse = await ShopifyRepositoryGet(marketplace).getOrderFulfillmentsOfFulfillmentOrder(marketplace, orderId);
    if (fulfillmentOrdersResponse.isLeft()) return Left(fulfillmentOrdersResponse.getLeft());

    final fulfillmentOrderId = fulfillmentOrdersResponse.getRight()['fulfillment_orders'][0]['id'];

    String? trackingNumber;
    String? trackingUrl;

    if (parcelTracking != null) {
      if (parcelTracking.trackingNumber2 != null &&
          parcelTracking.trackingNumber2!.isNotEmpty &&
          parcelTracking.trackingUrl2 != null &&
          parcelTracking.trackingUrl2!.isNotEmpty) {
        trackingNumber = parcelTracking.trackingNumber2!;
        trackingUrl = parcelTracking.trackingUrl2! + parcelTracking.trackingNumber2!;
      }
      if (parcelTracking.trackingNumber2 == null ||
          parcelTracking.trackingUrl2 == null && parcelTracking.trackingNumber.isNotEmpty && parcelTracking.trackingUrl.isNotEmpty) {
        trackingNumber = parcelTracking.trackingUrl;
        trackingNumber = parcelTracking.trackingNumber;
        trackingUrl = parcelTracking.trackingUrl + parcelTracking.trackingNumber;
      }
    }

    final body = switch (parcelTracking) {
      null => {
          "fulfillment": {
            "line_items_by_fulfillment_order": [
              {"fulfillment_order_id": fulfillmentOrderId}
            ]
          }
        },
      _ => {
          "fulfillment": {
            "line_items_by_fulfillment_order": [
              {"fulfillment_order_id": fulfillmentOrderId}
            ],
            "tracking_info": {"number": trackingNumber, "url": trackingUrl}
          }
        }
    };

    final response = await postFulfillment(marketplace: marketplace, body: body);
    if (response.isLeft()) return Left(response.getLeft());

    return const Right(unit);
  }
}
