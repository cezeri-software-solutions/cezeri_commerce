import 'dart:convert';

import 'package:cezeri_commerce/1_presentation/core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../3_domain/entities/marketplace/marketplace_shopify.dart';
import '../../../3_domain/entities/product/product.dart';
import '../../../constants.dart';
import '../../../failures/failures.dart';
import 'shopify.dart';

class ShopifyRepositoryPut {
  final MarketplaceShopify marketplace;
  final Map<String, String> credentials;

  ShopifyRepositoryPut(this.marketplace)
      : credentials = {
          'storefrontToken': marketplace.storefrontAccessToken,
          'adminToken': marketplace.adminAccessToken,
          'url': '${marketplace.endpointUrl}${marketplace.storeName}.myshopify.com/${marketplace.shopSuffix}',
        };

  final supabase = GetIt.I<SupabaseClient>();

  Future<Either<AbstractFailure, Unit>> putProduct({
    required MarketplaceShopify marketplace,
    required int productId, // Artikel-ID im Marktplatz
    required Map<String, Map<String, Object>> body,
  }) async {
    try {
      await supabase.functions.invoke(
        'shopify_api',
        body: jsonEncode({
          'credentials': credentials,
          'functionName': 'putProduct',
          'productId': productId,
          'postBody': body,
        }),
      );

      return const Right(unit);
    } catch (e) {
      logger.e('Error: $e');
      return Left(ShopifyGeneralFailure(errorMessage: e.toString()));
    }
  }

  Future<Either<List<AbstractFailure>, Unit>> updateProductInMarketplace({
    required MarketplaceShopify marketplace,
    required ProductShopify productShopify,
    required Product product,
  }) async {
    final body = {
      "product": {
        "id": productShopify.id,
        "title": product.name,
        "body_html": product.description,
        "status": productShopify.status.toPrettyString(),
        "vendor": product.manufacturer,
        "variants": [
          {
            "price": product.grossPrice,
            "cost": product.wholesalePrice, // EK-Preis
            "sku": product.articleNumber,
            "weight": product.weight,
            "barcode": product.ean,
            // "compare_at_price": product.grossPrice,
          }
        ],
        "metafields_global_title_tag": product.name,
        "metafields_global_description_tag": convertHtmlToString(product.descriptionShort),
        "handle": generateFriendlyUrl(product.name),
      }
    };

    List<AbstractFailure> putProductFailures = [];

    //* Update Product
    final fosProduct = await putProduct(marketplace: marketplace, productId: productShopify.id, body: body);
    if (fosProduct.isLeft()) return Left([fosProduct.getLeft()]);

    final collectsResult = await ShopifyRepositoryGet(marketplace).getCollectsOfProduct(marketplace, productShopify.id);
    if (collectsResult.isLeft()) return Left([collectsResult.getLeft()]);
    final listOfCollects = collectsResult.getRight();

    final customCollectionsResult = await ShopifyRepositoryGet(marketplace).getCustomCollectionsByProductId(marketplace, productShopify.id);
    if (customCollectionsResult.isLeft()) return Left([customCollectionsResult.getLeft()]);
    final listOfCustomCollections = customCollectionsResult.getRight();

    //* Neue und entfernte Custom Collections identifizieren
    final List<CustomCollectionShopify> newAddedCustomCollections = [];
    final List<CustomCollectionShopify> removedCustomCollections = [];

    Set<int> existingCollectionIds = Set.from(listOfCustomCollections.map((e) => e.id));
    Set<int> productCollectionIds = Set.from(productShopify.customCollections.map((e) => e.id));

    //* Neue hinzugefügte Custom Collections
    for (final customCollection in productShopify.customCollections) {
      if (!existingCollectionIds.contains(customCollection.id)) newAddedCustomCollections.add(customCollection);
    }

    //* Entfernte Custom Collections
    for (final customCollection in listOfCustomCollections) {
      if (!productCollectionIds.contains(customCollection.id)) removedCustomCollections.add(customCollection);
    }

    if (newAddedCustomCollections.isNotEmpty) {
      for (final newCustomCollection in newAddedCustomCollections) {
        if (!listOfCollects.any((e) => e.collectionId == newCustomCollection.id)) {
          final newCollectResult = await ShopifyRepositoryPost(marketplace).postCollect(
            marketplace: marketplace,
            productId: productShopify.id,
            customCollectionId: newCustomCollection.id,
          );
          if (newCollectResult.isLeft()) putProductFailures.add(newCollectResult.getLeft());
        }
      }
    }

    if (removedCustomCollections.isNotEmpty) {
      for (final removedCustomCollection in removedCustomCollections) {
        final index = listOfCollects.indexWhere((e) => e.collectionId == removedCustomCollection.id);
        if (index == -1) continue;
        final deletedCollectResult = await ShopifyRepositoryDelete(marketplace).deleteCollect(marketplace, listOfCollects[index].id);
        if (deletedCollectResult.isLeft()) putProductFailures.add(deletedCollectResult.getLeft());
      }
    }

    return putProductFailures.isEmpty ? const Right(unit) : Left(putProductFailures);
  }
}