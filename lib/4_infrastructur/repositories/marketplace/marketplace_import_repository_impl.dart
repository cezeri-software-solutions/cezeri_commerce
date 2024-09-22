import 'package:cezeri_commerce/3_domain/entities/marketplace/marketplace_shopify.dart';
import 'package:cezeri_commerce/3_domain/entities/product/product.dart';
import 'package:cezeri_commerce/3_domain/repositories/database/marketplace_repository.dart';
import 'package:cezeri_commerce/4_infrastructur/repositories/prestashop_api/prestashop_repository_get.dart';
import 'package:cezeri_commerce/4_infrastructur/repositories/shopify_api/shopify.dart';
import 'package:dartz/dartz.dart';

import '../../../../1_presentation/core/core.dart';
import '../../../../3_domain/repositories/marketplace/marketplace_import_repository.dart';
import '../../../3_domain/entities/marketplace/abstract_marketplace.dart';
import '../../../3_domain/entities/marketplace/marketplace_presta.dart';
import '../../../3_domain/entities/product/marketplace_product.dart';
import '../../../3_domain/entities/product/product_presta.dart';
import '../../../3_domain/repositories/database/main_settings_respository.dart';
import '../../../3_domain/repositories/database/product_repository.dart';
import '../../../constants.dart';
import '../../../failures/failures.dart';
import '../database/functions/repository_functions.dart';
import '../prestashop_api/models/product_raw_presta.dart';
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

      switch (marketplace.marketplaceType) {
        case MarketplaceType.prestashop:
          {
            final fosProductIdsPresta = switch (onlyActive) {
              false => await PrestashopRepositoryGet(marketplace).getProductIds(),
              true => await PrestashopRepositoryGet(marketplace).getProductIdsOnlyActive(),
            };
            if (fosProductIdsPresta.isLeft()) return Left(fosProductIdsPresta.getLeft());
            final productIdsPresta = fosProductIdsPresta.getRight();
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

    try {
      final fosProductPresta = await PrestashopRepositoryGet(marketplace).getProduct(productId);
      if (fosProductPresta.isLeft()) {
        logger.e('Fehler beim Laden des Artikels aus Prestashop');
        return left(PrestaGeneralFailure(errorMessage: 'Fehler beim Laden der Artikels aus Prestashop'));
      }
      final productPresta = fosProductPresta.getRight();

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

    try {
      final fosProductPresta = await PrestashopRepositoryGet(marketplace).getProduct(id);
      if (fosProductPresta.isLeft()) return left(fosProductPresta.getLeft());
      final productPresta = ProductPresta.fromProductRawPresta(fosProductPresta.getRight());

      return Right(productPresta);
    } catch (e) {
      logger.e(e);
      return Left(PrestaGeneralFailure());
    }
  }

  @override
  Future<Either<AbstractFailure, List<ProductShopify>>> loadProductByArticleNumberFromShopify(
    String articleNumber,
    MarketplaceShopify marketplace,
  ) async {
    if (!await checkInternetConnection()) return left(NoConnectionFailure());

    try {
      final fosProductShopify = await ShopifyRepositoryGet(marketplace).getProductsByArticleNumber(articleNumber);
      if (fosProductShopify.isLeft()) return Left(fosProductShopify.getLeft());

      return Right(fosProductShopify.getRight());
    } catch (e) {
      logger.e(e);
      return left(ShopifyGeneralFailure());
    }
  }

  @override
  Future<Either<AbstractFailure, List<dynamic>>> getAllMarketplaceCategories(AbstractMarketplace marketplace) async {
    if (!await checkInternetConnection()) return left(PrestaGeneralFailure());

    return switch (marketplace.marketplaceType) {
      MarketplaceType.prestashop => await PrestashopRepositoryGet(marketplace as MarketplacePresta).getCategories(),
      MarketplaceType.shopify => await ShopifyRepositoryGet(marketplace as MarketplaceShopify).getCategories(),
      MarketplaceType.shop => Left(GeneralFailure(customMessage: 'Ein Ladengeschäft kann keine Schnitstelle haben.')),
    };
  }
}
