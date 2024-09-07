import 'dart:convert';

import 'package:cezeri_commerce/4_infrastructur/repositories/shopify_api/models/inventory/inventory_level_shopify.dart';
import 'package:cezeri_commerce/failures/abstract_failure.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../../../1_presentation/core/core.dart';
import '../../../../3_domain/entities/carrier/parcel_tracking.dart';
import '../../../../3_domain/entities/product/product.dart';
import '../../../../3_domain/entities/product/product_image.dart';
import '../../../../constants.dart';
import '../../../../failures/shopify_failure.dart';
import '../shopify.dart';

const _apiVersion = '2024-01';

class ShopifyApiConfig {
  final String storefrontToken;
  final String adminToken;

  ShopifyApiConfig({required this.storefrontToken, required this.adminToken});
}

class ShopifyApi {
  final ShopifyApiConfig _config;
  final String _url;

  ShopifyApi(this._config, this._url);

  Future<Either<ShopifyGeneralFailure, List<ProductRawShopify>>> getProductsAllRaw() async {
    const key = 'products';
    final fosProductsRaw = await _doGetAll(uri: '$_url/api/$_apiVersion/$key.json', key: key, isList: true);

    return fosProductsRaw.fold(
      (failure) => Left(failure),
      (data) => Right(List<ProductRawShopify>.from(data.map((model) => ProductRawShopify.fromJson(model)))),
    );
  }

  Future<Either<ShopifyGeneralFailure, ProductRawShopify>> getProductRawById(int productId) async {
    const key = 'product';
    final collectsResult = await _doGet(uri: '$_url/api/$_apiVersion/products/$productId.json', key: key, isList: false);

    return collectsResult.fold(
      (failure) => Left(failure),
      (data) => Right(ProductRawShopify.fromJson(data)),
    );
  }

  Future<Either<ShopifyGeneralFailure, ProductShopify>> getProductById(int productId) async {
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

  Future<Either<ShopifyGeneralFailure, List<ProductShopify>>> getProductsByArticleNumber(String articleNumber) async {
    final defaultErrorMessage = 'Artikel mit der Artikelnummer: "$articleNumber" konnte nicht geladen werden.';
    const key = 'products';
    final fosProductsRaw = await _doGetAll(uri: '$_url/api/$_apiVersion/$key.json', key: key, isList: true);
    List<ProductRawShopify>? productsRaw;
    fosProductsRaw.fold(
      (failure) => Left(failure),
      (data) => productsRaw = List<ProductRawShopify>.from(data.map((model) => ProductRawShopify.fromJson(model))),
    );
    final listOfProductRaw = productsRaw!.where((e) => e.variants.first.sku == articleNumber).toList();
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

  Future<Either<ShopifyGeneralFailure, List<CollectShopify>>> getCollectsOfProduct(int productId) async {
    const key = 'collects';
    final collectsResult = await _doGet(uri: '$_url/api/$_apiVersion/$key.json?product_id=$productId', key: key, isList: true);

    return collectsResult.fold(
      (failure) => Left(failure),
      (data) => Right(List<CollectShopify>.from(data.map((model) => CollectShopify.fromJson(model)))),
    );
  }

  Future<Either<ShopifyGeneralFailure, List<CustomCollectionShopify>>> getCustomCollectionsByProductId(int productId) async {
    const key = 'custom_collections';
    final collectsResult = await _doGet(uri: '$_url/api/$_apiVersion/$key.json?product_id=$productId', key: key, isList: true);

    return collectsResult.fold(
      (failure) => Left(failure),
      (data) => Right(List<CustomCollectionShopify>.from(data.map((model) => CustomCollectionShopify.fromJson(model)))),
    );
  }

  Future<Either<ShopifyGeneralFailure, List<CustomCollectionShopify>>> getCustomCollectionsAll() async {
    const key = 'custom_collections';
    final collectsResult = await _doGetAll(uri: '$_url/api/$_apiVersion/$key.json?limit=250', key: key, isList: true);

    return collectsResult.fold(
      (failure) => Left(failure),
      (data) => Right(List<CustomCollectionShopify>.from(data.map((model) => CustomCollectionShopify.fromJson(model)))),
    );
  }

  Future<Either<ShopifyGeneralFailure, List<MetafieldShopify>>> getMetafieldsByProductId(int productId) async {
    const key = 'metafields';
    final collectsResult = await _doGet(uri: '$_url/api/$_apiVersion/products/$productId/$key.json', key: key, isList: true);

    return collectsResult.fold(
      (failure) => Left(failure),
      (data) => Right(List<MetafieldShopify>.from(data.map((model) => MetafieldShopify.fromJson(model)))),
    );
  }

  Future<Either<ShopifyGeneralFailure, InventoryLevelShopify>> getInventoryLevelByInventoryItemId(int inventoryItemId) async {
    const key = 'inventory_levels';
    final collectsResult = await _doGet(uri: '$_url/api/$_apiVersion/$key.json?inventory_item_ids=$inventoryItemId', key: key, isList: true);

    return collectsResult.fold(
      (failure) => Left(failure),
      (data) {
        final inventoryLevels = List<InventoryLevelShopify>.from(data.map((model) => InventoryLevelShopify.fromJson(model)));
        return Right(inventoryLevels.first);
      },
    );
  }

  Future<Either<ShopifyGeneralFailure, List<OrderShopify>>> getOrdersByCreatedAtMin(DateTime minDateTime) async {
    const key = 'orders';
    // TODO: Zeitzone wird manuell nachgebessert (Muss automatisch funktionieren)
    final createdAtMin = (minDateTime.subtract(const Duration(hours: 2, seconds: 1))).toIso8601String();
    logger.i(createdAtMin);
    logger.i(_url);
    final collectsResult = await _doGet(uri: '$_url/api/$_apiVersion/$key.json?created_at_min=$createdAtMin', key: key, isList: true);

    return collectsResult.fold(
      (failure) => Left(failure),
      (data) {
        final orders = List<OrderShopify>.from(data.map((model) => OrderShopify.fromJson(model)));

        return Right(orders);
      },
    );
  }

  Future<Either<List<AbstractFailure>, Unit>> addCollectionsToProduct(
    ProductShopify productShopify,
    List<CustomCollectionShopify> toAddCustomCollections,
  ) async {
    List<AbstractFailure> putProductFailures = [];

    final collectsResult = await getCollectsOfProduct(productShopify.id);
    if (collectsResult.isLeft()) return Left([collectsResult.getLeft()]);
    final listOfCollects = collectsResult.getRight();

    for (final newCustomCollection in toAddCustomCollections) {
      if (!listOfCollects.any((e) => e.collectionId == newCustomCollection.id)) {
        final newCollectResult = await postCollect(productShopify.id, newCustomCollection.id);
        if (newCollectResult.isLeft()) putProductFailures.add(newCollectResult.getLeft());
      }
    }

    return putProductFailures.isEmpty ? const Right(unit) : Left(putProductFailures);
  }

  Future<Either<List<AbstractFailure>, Unit>> removeCollectionsFromProduct(
    ProductShopify productShopify,
    List<CustomCollectionShopify> toRemoveCustomCollections,
  ) async {
    List<AbstractFailure> putProductFailures = [];

    final collectsResult = await getCollectsOfProduct(productShopify.id);
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

  Future<Either<List<AbstractFailure>, Unit>> putProduct(ProductShopify productShopify, Product product) async {
    const key = 'products';
    List<AbstractFailure> putProductFailures = [];

    final body = jsonEncode({
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
    });
    final productResult = await _doPut(uri: '$_url/api/$_apiVersion/$key/${productShopify.id}.json', body: body);
    if (productResult.isLeft()) return Left([productResult.getLeft()]);

    final collectsResult = await getCollectsOfProduct(productShopify.id);
    if (collectsResult.isLeft()) return Left([collectsResult.getLeft()]);
    final listOfCollects = collectsResult.getRight();

    final customCollectionsResult = await getCustomCollectionsByProductId(productShopify.id);
    if (customCollectionsResult.isLeft()) return Left([customCollectionsResult.getLeft()]);
    final listOfCustomCollections = customCollectionsResult.getRight();

    // Neue und entfernte Custom Collections identifizieren
    List<CustomCollectionShopify> newAddedCustomCollections = [];
    List<CustomCollectionShopify> removedCustomCollections = [];

    Set<int> existingCollectionIds = Set.from(listOfCustomCollections.map((e) => e.id));
    Set<int> productCollectionIds = Set.from(productShopify.customCollections.map((e) => e.id));

    // Neue hinzugefügte Custom Collections
    for (final customCollection in productShopify.customCollections) {
      if (!existingCollectionIds.contains(customCollection.id)) newAddedCustomCollections.add(customCollection);
    }

    // Entfernte Custom Collections
    for (final customCollection in listOfCustomCollections) {
      if (!productCollectionIds.contains(customCollection.id)) removedCustomCollections.add(customCollection);
    }

    if (newAddedCustomCollections.isNotEmpty) {
      for (final newCustomCollection in newAddedCustomCollections) {
        if (!listOfCollects.any((e) => e.collectionId == newCustomCollection.id)) {
          final newCollectResult = await postCollect(productShopify.id, newCustomCollection.id);
          if (newCollectResult.isLeft()) putProductFailures.add(newCollectResult.getLeft());
        }
      }
    }

    if (removedCustomCollections.isNotEmpty) {
      for (final removedCustomCollection in removedCustomCollections) {
        final index = listOfCollects.indexWhere((e) => e.collectionId == removedCustomCollection.id);
        if (index == -1) continue;
        final deletedCollectResult = await deleteCollect(listOfCollects[index].id);
        if (deletedCollectResult.isLeft()) putProductFailures.add(deletedCollectResult.getLeft());
      }
    }

    return putProductFailures.isEmpty ? const Right(unit) : Left(putProductFailures);
  }

  //* Erstellt einen neuen Artikel in Shopify
  Future<Either<List<AbstractFailure>, ProductShopify>> postProduct(Product product, List<int> customCollectionIds) async {
    const key = 'products';
    List<AbstractFailure> postProductFailures = [];

    final body = jsonEncode({
      "product": {
        "title": product.name,
        "body_html": product.description,
        "status": ProductShopifyStatus.active.toPrettyString(),
        "vendor": product.manufacturer,
        "variants": [
          {
            "price": product.grossPrice,
            "cost": product.wholesalePrice, // EK-Preis
            "sku": product.articleNumber,
            "weight": product.weight,
            "barcode": product.ean,
            "inventory_management": "shopify",
            // "compare_at_price": product.grossPrice,
          }
        ],
        "metafields_global_title_tag": product.name,
        "metafields_global_description_tag": convertHtmlToString(product.descriptionShort),
        "handle": generateFriendlyUrl(product.name),
      }
    });
    final productResult = await _doPost(uri: '$_url/api/$_apiVersion/$key.json', body: body);
    ProductRawShopify? newCreatedProduct;
    productResult.fold(
      (failure) => postProductFailures.add(ShopifyPostProductFailure(
        postProductFailureType: ShopifyPostProductFailureType.product,
        customMessage: failure.errorMessage,
      )),
      (data) {
        newCreatedProduct = ProductRawShopify.fromJson(data['product']);
      },
    );
    if (postProductFailures.isNotEmpty || newCreatedProduct == null) return Left(postProductFailures);

    //* Artikelbilder hinzufügen
    final fosImages = await postProductImages(newCreatedProduct!.id, product.name, product.listOfProductImages);
    fosImages.fold(
      (failure) => postProductFailures.add(ShopifyPostProductFailure(
        postProductFailureType: ShopifyPostProductFailureType.images,
        customMessage: failure.first.errorMessage,
      )),
      (_) => null,
    );

    //* Kategorien zuweisen
    for (final id in customCollectionIds) {
      final newCollectResult = await postCollect(newCreatedProduct!.id, id);
      newCollectResult.fold(
        (failure) => postProductFailures.add(ShopifyPostProductFailure(
          postProductFailureType: ShopifyPostProductFailureType.categories,
          customMessage: failure.errorMessage,
        )),
        (_) => null,
      );
    }

    //* Bestand hinzufügen
    final fosStock = await postProductStock(newCreatedProduct!.id, product.availableStock);
    fosStock.fold(
      (failure) => postProductFailures.add(ShopifyPostProductFailure(
        postProductFailureType: ShopifyPostProductFailureType.stock,
        customMessage: failure.errorMessage,
      )),
      (_) => null,
    );

    //* Neu erstellten Artikel laden als ProductShopify
    ProductShopify? newProductShopify;
    final fosNewProduct = await getProductById(newCreatedProduct!.id);
    fosNewProduct.fold(
      (failure) => postProductFailures.add(failure),
      (newProduct) => newProductShopify = newProduct,
    );
    if (newProductShopify == null) return Left(postProductFailures);

    return postProductFailures.isEmpty ? Right(newProductShopify!) : Left(postProductFailures);
  }

  Future<Either<ShopifyGeneralFailure, Unit>> postProductStock(int productShopifyId, int newQuantity) async {
    const key = 'inventory_levels';

    final fosProductRaw = await getProductRawById(productShopifyId);
    if (fosProductRaw.isLeft()) return Left(fosProductRaw.getLeft());
    final inventoryItemId = fosProductRaw.getRight().variants.first.inventoryItemId;

    final fosInventoryLevel = await getInventoryLevelByInventoryItemId(inventoryItemId);
    if (fosInventoryLevel.isLeft()) return Left(fosInventoryLevel.getLeft());
    final locationId = fosInventoryLevel.getRight().locationId;

    final body = jsonEncode({
      "location_id": locationId,
      "inventory_item_id": inventoryItemId,
      "available": newQuantity,
    });
    final inventoryResult = await _doPost(uri: '$_url/api/$_apiVersion/$key/set.json', body: body);

    return inventoryResult.fold(
      (failure) => Left(failure),
      (_) => const Right(unit),
    );
  }

  Future<Either<ShopifyGeneralFailure, Unit>> postCollect(int productId, int customCollectionId) async {
    const key = 'collects';

    final body = jsonEncode({
      "collect": {
        "product_id": productId,
        "collection_id": customCollectionId,
      }
    });
    final inventoryResult = await _doPost(uri: '$_url/api/$_apiVersion/$key.json', body: body);

    return inventoryResult.fold(
      (failure) => Left(failure),
      (_) => const Right(unit),
    );
  }

  Future<Either<List<ShopifyGeneralFailure>, Unit>> postProductImages(int productId, String productName, List<ProductImage> productImages) async {
    const key = 'products';

    List<ShopifyGeneralFailure> failures = [];

    int pos = 1;
    for (final image in productImages) {
      final response = await http.get(Uri.parse(image.fileUrl));
      String? imageData;
      if (response.statusCode == 200) imageData = base64Encode(response.bodyBytes);
      if (imageData == null) {
        failures.add(ShopifyGeneralFailure(errorMessage: 'Artikelbild konnte nicht aus der Datenbank geladen werden.'));
        continue;
      }

      final alt = switch (pos) {
        1 => productName,
        _ => '${productName}_$pos',
      };

      final body = jsonEncode({
        "image": {
          "position": pos,
          // "metafields": [{"key": "new", "value": image.fileName, "type": "single_line_text_field", "namespace": "global"}],
          "alt": alt,
          "attachment": imageData,
          "filename": image.fileName,
        }
      });
      final productResult = await _doPost(uri: '$_url/api/$_apiVersion/$key/$productId/images.json', body: body);

      productResult.fold(
        (failure) => failures.add(failure),
        (_) => null,
      );
      pos++;
    }

    if (failures.isNotEmpty) return Left(failures);
    return const Right(unit);
  }

  Future<Either<List<ShopifyGeneralFailure>, Unit>> postFulfillment(int orderId, ParcelTracking? parcelTracking) async {
    const key = 'fulfillments';

    final fulfillmentOrdersResponse =
        await _doGet(uri: '$_url/api/$_apiVersion/orders/$orderId/fulfillment_orders.json', key: 'fulfillment_orders', isList: true);
    if (fulfillmentOrdersResponse.isLeft()) return Left([ShopifyGeneralFailure()]);

    for (final a in fulfillmentOrdersResponse.getRight()) {
      (a as Map<String, dynamic>).myJsonPrint();
    }

    final fulfillmentOrderId = fulfillmentOrdersResponse.getRight()[0]['id'];

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
      null => jsonEncode({
          "fulfillment": {
            "line_items_by_fulfillment_order": [
              {"fulfillment_order_id": fulfillmentOrderId}
            ]
          }
        }),
      _ => jsonEncode({
          "fulfillment": {
            "line_items_by_fulfillment_order": [
              {"fulfillment_order_id": fulfillmentOrderId}
            ],
            "tracking_info": {"number": trackingNumber, "url": trackingUrl}
          }
        })
    };

    final productResult = await _doPost(uri: '$_url/api/$_apiVersion/$key.json', body: body);
    if (productResult.isLeft()) return Left([productResult.getLeft()]);

    return const Right(unit);
  }

  Future<Either<ShopifyGeneralFailure, Unit>> deleteCollect(int collectId) async {
    const key = 'collects';
    final inventoryResult = await _doDel(uri: '$_url/api/$_apiVersion/$key/$collectId.json');

    return inventoryResult.fold(
      (failure) => Left(failure),
      (unit) => Right(unit),
    );
  }

  Future<Either<List<ShopifyGeneralFailure>, Unit>> deleteProductImages(int productShopifyId) async {
    const key = 'products';

    List<ShopifyGeneralFailure> deleteImagesFailures = [];
    ProductRawShopify? productRawShopify;
    final fosProductRaw = await getProductRawById(productShopifyId);
    fosProductRaw.fold(
      (failure) => deleteImagesFailures = [failure],
      (productRaw) => productRawShopify = productRaw,
    );
    if (deleteImagesFailures.isNotEmpty) return Left(deleteImagesFailures);
    if (productRawShopify == null) return Left([ShopifyGeneralFailure(errorMessage: 'Artikelbilder konnten nicht gelöscht werden.')]);
    // Wenn der Artikel keine Bilder auf Shopify hat, soll "unit" zurückgegeben werden
    if (productRawShopify!.images.isEmpty) return const Right(unit);

    for (final image in productRawShopify!.images) {
      final deleteResult = await _doDel(uri: '$_url/api/$_apiVersion/$key/${productRawShopify!.id}/images/${image.id}.json');
      deleteResult.fold(
        (failure) => deleteImagesFailures.add(failure),
        (_) => null,
      );
    }
    return deleteImagesFailures.isEmpty ? const Right(unit) : Left(deleteImagesFailures);
  }

  //? ###############################################################################################################################################
  //? ###############################################################################################################################################
  //? ###############################################################################################################################################

  Future<Either<ShopifyGeneralFailure, dynamic>> _doGet({required String uri, required String key, required bool isList}) async {
    final authHeader = base64Encode(utf8.encode('${_config.storefrontToken}:${_config.adminToken}'));
    final headers = {'Authorization': 'Basic $authHeader', 'Content-Type': 'application/json'};

    try {
      final response = await http.get(Uri.parse(uri), headers: headers);

      if (response.statusCode == 200) {
        return Right(isList ? jsonDecode(response.body)[key] : jsonDecode(response.body)[key]);
      } else {
        var errorResponse = jsonDecode(response.body);
        var errorMessage = errorResponse['errors'] ?? 'Unknown error';
        logger.e('Shopify error: $errorMessage');
        return Left(ShopifyGeneralFailure(errorMessage: 'Shopify error: $errorMessage'));
      }
    } catch (e) {
      logger.e('Unexpected error: $e');
      return Left(ShopifyGeneralFailure(errorMessage: 'Unexpected error: $e'));
    }
  }

  //* Eine Erweiterung der _doGet Methode, weil Shopify eine Limitierung von maximal 250 Datensätzen hat.
  //* Diese Funktion lädt alle Daten
  Future<Either<ShopifyGeneralFailure, dynamic>> _doGetAll({
    required String uri,
    required String key,
    required bool isList,
  }) async {
    final authHeader = base64Encode(utf8.encode('${_config.storefrontToken}:${_config.adminToken}'));
    final headers = {'Authorization': 'Basic $authHeader', 'Content-Type': 'application/json'};
    List<dynamic> allItems = [];
    Uri? nextUri = Uri.parse(uri);

    try {
      do {
        final response = await http.get(nextUri!, headers: headers);

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (isList) {
            allItems.addAll(data[key]);
          } else {
            return Right(data);
          }

          // Extrahiere die URL für die nächste Seite aus dem Link-Header
          final linkHeader = response.headers['link'];
          final nextPageUrl = linkHeader == null ? null : _extractNextPageUrl(linkHeader);
          nextUri = nextPageUrl != null ? Uri.parse(nextPageUrl) : null;
        } else {
          var errorResponse = jsonDecode(response.body);
          var errorMessage = errorResponse['errors'] ?? 'Unknown error';
          logger.e('Shopify error: $errorMessage');
          return Left(ShopifyGeneralFailure(errorMessage: 'Shopify error: $errorMessage'));
        }
      } while (nextUri != null);

      return Right(allItems);
    } catch (e) {
      logger.e('Unexpected error: $e');
      return Left(ShopifyGeneralFailure(errorMessage: 'Unexpected error: $e'));
    }
  }

  //* ###############################################################################################################################################

  Future<Either<ShopifyUpdateFailure, Unit>> _doPut({required String uri, required Object body}) async {
    final authHeader = base64Encode(utf8.encode('${_config.storefrontToken}:${_config.adminToken}'));
    final headers = {'Authorization': 'Basic $authHeader', 'Content-Type': 'application/json'};

    try {
      final response = await http.put(Uri.parse(uri), headers: headers, body: body);

      if (response.statusCode == 200) {
        return const Right(unit);
      } else {
        var errorResponse = jsonDecode(response.body);
        var errorMessage = errorResponse['errors'] ?? 'Unknown error';
        logger.e('Shopify error: $errorMessage');
        return Left(ShopifyUpdateFailure(response: response, customResponseMessage: 'Shopify error: $errorMessage'));
      }
    } catch (e) {
      logger.e('Unexpected error: $e');
      return Left(ShopifyUpdateFailure(customResponseMessage: 'Unexpected error: $e'));
    }
  }

  Future<Either<ShopifyGeneralFailure, dynamic>> _doPost({required String uri, required Object body}) async {
    final authHeader = base64Encode(utf8.encode('${_config.storefrontToken}:${_config.adminToken}'));
    final headers = {'Authorization': 'Basic $authHeader', 'Content-Type': 'application/json'};

    try {
      final response = await http.post(Uri.parse(uri), headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(jsonDecode(response.body));
      } else {
        logger.i(response.statusCode);
        logger.e(response.body);
        var errorResponse = jsonDecode(response.body);
        var errorMessage = errorResponse['errors'] ?? 'Unknown error';
        logger.e('Shopify error: $errorMessage');
        return Left(ShopifyGeneralFailure(errorMessage: 'Shopify error: $errorMessage'));
      }
    } catch (e) {
      logger.e('Unexpected error: $e');
      return Left(ShopifyGeneralFailure(errorMessage: 'Unexpected error: $e'));
    }
  }

  Future<Either<ShopifyGeneralFailure, Unit>> _doDel({required String uri}) async {
    final authHeader = base64Encode(utf8.encode('${_config.storefrontToken}:${_config.adminToken}'));
    final headers = {'Authorization': 'Basic $authHeader', 'Content-Type': 'application/json'};

    try {
      final response = await http.delete(Uri.parse(uri), headers: headers);

      if (response.statusCode == 200) {
        return const Right(unit);
      } else {
        logger.i(response.statusCode);
        logger.e(response.body);
        var errorResponse = jsonDecode(response.body);
        var errorMessage = errorResponse['errors'] ?? 'Unknown error';
        logger.e('Shopify error: $errorMessage');
        return Left(ShopifyGeneralFailure(errorMessage: 'Shopify error: $errorMessage'));
      }
    } catch (e) {
      logger.e('Unexpected error: $e');
      return Left(ShopifyGeneralFailure(errorMessage: 'Unexpected error: $e'));
    }
  }

  String? _extractNextPageUrl(String linkHeader) {
    final regex = RegExp(r'<([^>]+)>; rel="next"');
    final match = regex.firstMatch(linkHeader);
    return match?.group(1);
  }
}
