import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../../../../core/shopify_failure.dart';
import '../shopify.dart';

final logger = Logger();
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

  //? ###############################################################################################################################################
  //? ###############################################################################################################################################
  //? ###############################################################################################################################################

  Future<Either<ShopifyGeneralFailure, dynamic>> _doGet({required String uri, required String key, required bool isList}) async {
    final authHeader = base64Encode(utf8.encode('${_config.storefrontToken}:${_config.adminToken}'));
    final headers = {'Authorization': 'Basic $authHeader', 'Content-Type': 'application/json'};

    try {
      final response = await http.get(Uri.parse(uri), headers: headers);

      if (response.statusCode == 200) {
        return Right(isList ? jsonDecode(response.body)[key] : jsonDecode(response.body));
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
          final nextPageUrl = linkHeader == null ? null : extractNextPageUrl(linkHeader);
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

  String? extractNextPageUrl(String linkHeader) {
    final regex = RegExp(r'<([^>]+)>; rel="next"');
    final match = regex.firstMatch(linkHeader);
    return match?.group(1);
  }
}
