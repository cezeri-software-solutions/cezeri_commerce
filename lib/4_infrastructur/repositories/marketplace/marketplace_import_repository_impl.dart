import 'dart:convert';

import 'package:cezeri_commerce/3_domain/entities/marketplace/marketplace_shopify.dart';
import 'package:cezeri_commerce/3_domain/entities/product/product.dart';
import 'package:cezeri_commerce/3_domain/repositories/firebase/marketplace_repository.dart';
import 'package:cezeri_commerce/4_infrastructur/repositories/shopify_api/shopify.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart';

import '../../../../1_presentation/core/core.dart';
import '../../../../3_domain/repositories/firebase/product_repository.dart';
import '../../../../3_domain/repositories/marketplace/marketplace_import_repository.dart';
import '../../../3_domain/entities/marketplace/abstract_marketplace.dart';
import '../../../3_domain/entities/marketplace/marketplace_presta.dart';
import '../../../3_domain/entities/product/marketplace_product.dart';
import '../../../3_domain/entities/product/product_presta.dart';
import '../../../3_domain/repositories/firebase/main_settings_respository.dart';
import '../../../constants.dart';
import '../../../failures/failures.dart';
import '../functions/repository_functions.dart';
import '../prestashop_api/models/product_raw_presta.dart';
import '../prestashop_api/prestashop_api.dart';
import 'marketplace_import_repository_helper.dart';

class MarketplaceImportRepositoryImpl implements MarketplaceImportRepository {
  final ProductRepository productRepository;
  final MainSettingsRepository mainSettingsRepository;
  final MarketplaceRepository marketplaceRepository;

  MarketplaceImportRepositoryImpl({
    required this.productRepository,
    required this.mainSettingsRepository,
    required this.marketplaceRepository,
  });

  @override
  Future<Either<AbstractFailure, List<int>>> getToLoadProductsFromMarketplace(MarketplacePresta marketplace, bool onlyActive) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    try {
      List<int> listOfToLoadAppointmentsFromMarketplace = [];

      final api = PrestashopApi(Client(), PrestashopApiConfig(apiKey: marketplace.key, webserviceUrl: marketplace.fullUrl));

      switch (marketplace.marketplaceType) {
        case MarketplaceType.prestashop:
          {
            final productIdsPresta = switch (onlyActive) {
              false => await api.getProductIds(),
              true => await api.getProductIdsOnlyActive(),
            };
            final allProductIds = productIdsPresta.map((e) => e.id).toList();
            allProductIds.sort((a, b) => a.compareTo(b));

            listOfToLoadAppointmentsFromMarketplace.addAll(allProductIds);
          }
        case MarketplaceType.shopify:
          {
            throw Exception('SHOPIFY not implemented');
          }
        case MarketplaceType.shop:
          {
            throw Exception('SHOP not implemented');
          }
      }
      return right(listOfToLoadAppointmentsFromMarketplace);
    } catch (e) {
      logger.e('Fehler beim laden der zu ladenden Produkte von Marktplätzen: $e');
      return left(MixedFailure(errorMessage: 'Fehler beim laden der zu ladenden Produkte von Marktplätzen: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, ProductRawPresta>> loadProductFromMarketplace(int productId, MarketplacePresta marketplace) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final api = PrestashopApi(Client(), PrestashopApiConfig(apiKey: marketplace.key, webserviceUrl: marketplace.fullUrl));

    try {
      final optionalProductPresta = await api.getProduct(productId, marketplace);
      if (optionalProductPresta.isNotPresent) {
        logger.e('Fehler beim Laden des Artikels aus Prestashop');
        return left(PrestaGeneralFailure(errorMessage: 'Fehler beim Laden der Artikels aus Prestashop'));
      }
      final productPresta = optionalProductPresta.value;

      return right(productPresta);
    } catch (e) {
      logger.e('Fehler beim laden des Artikels mit der ID ($productId) vom Marktplatz: $e');
      return left(PrestaGeneralFailure(errorMessage: 'Fehler beim laden des Artikels vom Marktplatz: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, Product?>> uploadLoadedMarketplaceProductToFirestore(
    MarketplaceProduct marketplaceProduct,
    String marketplaceId,
  ) async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    try {
      final fosSettings = await mainSettingsRepository.getSettings();
      if (fosSettings.isLeft()) return Left(fosSettings.getLeft());
      final mainSettings = fosSettings.getRight();

      switch (marketplaceProduct.marketplaceType) {
        case MarketplaceType.prestashop:
          {
            final fos = await createOrUpdateProductFromMarketplacePresta(
              marketplaceId: marketplaceId,
              ownerId: ownerId,
              productPresta: marketplaceProduct as ProductPresta,
              mainSettings: mainSettings,
              productRepository: productRepository,
              marketplaceRepository: marketplaceRepository,
            );
            return fos.fold(
              (failure) => Left(failure),
              (product) => Right(product),
            );
          }
        case MarketplaceType.shopify:
          {
            final fos = await createOrUpdateProductFromMarketplaceShopify(
              marketplaceId: marketplaceId,
              productShopify: marketplaceProduct as ProductShopify,
              mainSettings: mainSettings,
              productRepository: productRepository,
              marketplaceRepository: marketplaceRepository,
            );
            return fos.fold(
              (failure) => Left(failure),
              (product) => Right(product),
            );
          }
        case MarketplaceType.shop:
          throw Exception('Von einem Ladengeschäft kann kein Artikel importiert werden.');
      }
    } catch (e) {
      logger.e('Fehler beim hochladen des Artikels zu Firestore: $e');
      return left(PrestaGeneralFailure(errorMessage: 'Fehler beim hochladen des Artikels zu Firestore: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, ProductPresta>> loadProductByIdFromPrestashopAsJson(int id, MarketplacePresta marketplace) async {
    if (!await checkInternetConnection()) return left(PrestaGeneralFailure());

    final api = PrestashopApi(Client(), PrestashopApiConfig(apiKey: marketplace.key, webserviceUrl: marketplace.fullUrl));

    try {
      final optionalProductPresta = await api.getProduct(id, marketplace);
      if (optionalProductPresta.isNotPresent) return left(PrestaGeneralFailure());
      final productPresta = ProductPresta.fromProductRawPresta(optionalProductPresta.value);

      return right(productPresta);
    } catch (e) {
      logger.e(e);
      return left(PrestaGeneralFailure());
    }
  }

  @override
  Future<Either<AbstractFailure, List<ProductShopify>>> loadProductByArticleNumberFromShopify(
    String articleNumber,
    MarketplaceShopify marketplace,
  ) async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());

    final api = ShopifyApi(
      ShopifyApiConfig(storefrontToken: marketplace.storefrontAccessToken, adminToken: marketplace.adminAccessToken),
      marketplace.fullUrl,
    );

    try {
      final fosProductShopify = await api.getProductsByArticleNumber(articleNumber);
      return fosProductShopify.fold(
        (failure) => left(failure),
        (products) => right(products),
      );
    } catch (e) {
      logger.e(e);
      return left(ShopifyGeneralFailure());
    }
  }

  @override
  Future<Either<AbstractFailure, List<dynamic>>> getAllMarketplaceCategories(AbstractMarketplace marketplace) async {
    if (!await checkInternetConnection()) return left(PrestaGeneralFailure());
    final ownerId = await getOwnerId();

    final api = switch (marketplace.marketplaceType) {
      MarketplaceType.prestashop =>
        PrestashopApi(Client(), PrestashopApiConfig(apiKey: (marketplace as MarketplacePresta).key, webserviceUrl: marketplace.fullUrl)),
      MarketplaceType.shopify => ShopifyApi(
          ShopifyApiConfig(storefrontToken: (marketplace as MarketplaceShopify).storefrontAccessToken, adminToken: marketplace.adminAccessToken),
          marketplace.fullUrl,
        ),
      MarketplaceType.shop => throw Exception('Ein Ladengeschäft kann keine Schnitstelle haben.'),
    };

    try {
      switch (marketplace.marketplaceType) {
        case MarketplaceType.prestashop:
          {
            final categoriesPresta = await (api as PrestashopApi).getCategories();
            return right(categoriesPresta);
          }
        case MarketplaceType.shopify:
          {
            // final url = Uri.parse('https://zpxmvushxwqsvoidfjeh/getCustomCollectionsAll?marketplaceId=${marketplace.id}&ownerId=$ownerId');
            // final fosCategoriesShopify = await (api as ShopifyApi).getCustomCollectionsAll();
            // return fosCategoriesShopify.fold(
            //   (failure) => left(failure),
            //   (customCollections) => right(customCollections),
            // );

            try {
              print('marketplaceId: ${marketplace.id}');
              print('ownerId: $ownerId');
              print('function: getCustomCollectionsAll');

              final response = await supabase.functions.invoke(
                'shopify_api',
                body: jsonEncode({'marketplaceId': marketplace.id, 'ownerId': ownerId, 'functionName': 'getCustomCollectionsAll'}),
              );

              // final url = Uri.parse('https://zpxmvushxwqsvoidfjeh.supabase.co/functions/v1/shopify_api');
              // final response = await http.post(
              //   url,
              //   headers: {
              //     'Authorization':
              //         'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpweG12dXNoeHdxc3ZvaWRmamVoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTMyODk1NTcsImV4cCI6MjAyODg2NTU1N30.YIzAvITvgBRE5-8CGJ3diLh7K1pZA3xw7wQLDzJ3Qks', // Ersetze 'your-anon-key' mit deinem Supabase-API-Schlüssel
              //     'Content-Type': 'application/json',
              //   },
              //   body: {
              //     'marketplaceId': marketplace.id,
              //     'ownerId': ownerId,
              //     'function': 'getCustomCollectionsAll',
              //   },
              // );

              print('Success: ${response.data}');
              final responseData = response.data;
              final List<dynamic> parsedData = responseData is String ? jsonDecode(responseData) : responseData;
              final customCollections = parsedData.map((e) {
                final item = e as Map<String, dynamic>;
                return CustomCollectionShopify.fromJson(item);
              }).toList();
              return Right(customCollections);
            } catch (e) {
              print('Error: $e');
              return Left(ShopifyGeneralFailure());
            }
          }
        case MarketplaceType.shop:
          return left(GeneralFailure(customMessage: 'Ein Ladengeschäft kann keine Schnitstelle haben.'));
      }
    } catch (e) {
      logger.e(e);
      return left(PrestaGeneralFailure());
    }
  }
}
