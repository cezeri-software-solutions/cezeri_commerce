import 'dart:convert';

import 'package:cezeri_commerce/1_presentation/core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../3_domain/entities/marketplace/marketplace_presta.dart';
import '../../../3_domain/entities/product/product.dart';
import '../../../3_domain/entities/product/product_marketplace.dart';
import '../../../3_domain/entities/product/product_presta.dart';
import '../../../constants.dart';
import '../../../failures/failures.dart';
import 'builders/presta_builders.dart';
import 'models/models.dart';
import 'prestashop_repository_get.dart';

class PrestashopRepositoryPatch {
  final MarketplacePresta marketplace;
  final Map<String, String> credentials;

  PrestashopRepositoryPatch(this.marketplace)
      : credentials = {
          'apiKey': marketplace.key,
          'url': '${marketplace.endpointUrl}${marketplace.url}${marketplace.shopSuffix}',
        };

  final supabase = GetIt.I<SupabaseClient>();

  Future<Either<AbstractFailure, Unit>> patchStockAvailable({required String stockAvailableId, required String xmlPayload}) async {
    try {
      await supabase.functions.invoke(
        'prestashop_api',
        body: jsonEncode({
          'credentials': credentials,
          'functionName': 'patchProductQuantity',
          'stockAvailableId': stockAvailableId,
          'xmlPayload': xmlPayload,
        }),
      );

      return const Right(unit);
    } catch (e) {
      logger.e('Error on Marketplace ${marketplace.shortName}: $e');
      return Left(PrestaGeneralFailure(errorMessage: e.toString()));
    }
  }

  Future<Either<AbstractFailure, Unit>> patchSpecificPrice({required String specificPriceId, required String xmlPayload}) async {
    try {
      await supabase.functions.invoke(
        'prestashop_api',
        body: jsonEncode({
          'credentials': credentials,
          'functionName': 'patchSpecificPrice',
          'specificPriceId': specificPriceId,
          'xmlPayload': xmlPayload,
        }),
      );

      return const Right(unit);
    } catch (e) {
      logger.e('Error on Marketplace ${marketplace.shortName}: $e');
      return Left(PrestaGeneralFailure(errorMessage: e.toString()));
    }
  }

  Future<Either<AbstractFailure, Unit>> patchProduct({required int marketplaceProductPrestaId, required String xmlPayload}) async {
    try {
      await supabase.functions.invoke(
        'prestashop_api',
        body: jsonEncode({
          'credentials': credentials,
          'functionName': 'patchProduct',
          'productId': marketplaceProductPrestaId,
          'xmlPayload': xmlPayload,
        }),
      );

      return const Right(unit);
    } catch (e) {
      logger.e('Error on Marketplace ${marketplace.shortName}: $e');
      return Left(PrestaGeneralFailure(errorMessage: e.toString()));
    }
  }

  Future<Either<AbstractFailure, Unit>> patchOrderStatus({required int orderId, required String xmlPayload}) async {
    try {
      await supabase.functions.invoke(
        'prestashop_api',
        body: jsonEncode({
          'credentials': credentials,
          'functionName': 'patchOrderStatus',
          'orderId': orderId,
          'xmlPayload': xmlPayload,
        }),
      );

      return const Right(unit);
    } catch (e) {
      logger.e('Error on Marketplace ${marketplace.shortName}: $e');
      return Left(PrestaGeneralFailure(errorMessage: e.toString()));
    }
  }

  Future<Either<AbstractFailure, Unit>> patchProductQuantity({required int productId, required int quantity}) async {
    final fosProductRaw = await PrestashopRepositoryGet(marketplace).getProductRaw(productId);
    if (fosProductRaw.isLeft()) return Left(fosProductRaw.getLeft());

    final productRaw = fosProductRaw.getRight();
    final stockAvailableId = productRaw.associations.associationsStockAvailables!.first.id;

    final builder = patchStockAvailableBuilder(stockAvailableId, quantity);
    final document = builder.buildDocument();
    final xmlPayload = document.toXmlString();

    final response = await patchStockAvailable(stockAvailableId: stockAvailableId, xmlPayload: xmlPayload);

    return response;
  }

  Future<Either<AbstractFailure, Unit>> patchProductSpecificPrice({
    required int productId,
    required int specificPriceId,
    required Product product,
  }) async {
    final fosSpecificPrice = await PrestashopRepositoryGet(marketplace).getSpecificPrice(specificPriceId, productId);
    if (fosSpecificPrice.isLeft()) return Left(fosSpecificPrice.getLeft());

    final specificPrice = fosSpecificPrice.getRight();

    final builder = patchSpecificPriceBuilder(specificPrice, product);
    final document = builder.buildDocument();
    final xmlPayload = document.toXmlString();

    final response = await patchSpecificPrice(specificPriceId: specificPriceId.toString(), xmlPayload: xmlPayload);

    return response;
  }

  Future<Either<AbstractFailure, Unit>> updateProductInMarketplace({
    required Product product,
    required ProductMarketplace productMarketplace,
    required int marketplaceProductPrestaId,
  }) async {
    final fosProductPresta = await PrestashopRepositoryGet(marketplace).getProduct(marketplaceProductPrestaId);
    if (fosProductPresta.isLeft()) return Left(fosProductPresta.getLeft());
    final productPresta = fosProductPresta.getRight();

    String manufacturerId = '0';

    if (product.manufacturer.isNotEmpty) {
      final manufacturerIdResponse = await PrestashopRepositoryGet(marketplace).getManufacturerId(product.manufacturer);
      if (manufacturerIdResponse.isRight()) manufacturerId = manufacturerIdResponse.getRight();
    }

    final builder = patchProductBuilder(
      id: marketplaceProductPrestaId,
      product: product,
      productMarketplace: productMarketplace,
      productPresta: productPresta,
      manufacturerId: manufacturerId,
    );

    final errorC1 = PrestaGeneralFailure(
      errorMessage:
          'Beim bearbeiten des Artikels: "${product.name}" im Marktplatz: "${marketplace.name}" ist ein Fehler aufgetreten.\nTechnischer Fehler im: patchProductBuilder',
    );

    if (builder == null) return left(errorC1);
    final document = builder.buildDocument();
    final xmlPayload = document.toXmlString();

    final response = await patchProduct(marketplaceProductPrestaId: marketplaceProductPrestaId, xmlPayload: xmlPayload);

    return response;
  }

  Future<Either<AbstractFailure, Unit>> updateSetProductInMarketplace({
    required Product product,
    required List<Product> listOfPartOfSetArticles,
    required ProductMarketplace productMarketplace,
    required int marketplaceProductPrestaId,
  }) async {
    final fosProductPresta = await PrestashopRepositoryGet(marketplace).getProduct(marketplaceProductPrestaId);
    if (fosProductPresta.isLeft()) return Left(fosProductPresta.getLeft());
    final productPresta = fosProductPresta.getRight();

    //* Lädt die Einzelartikel des Set-Artikels aus Prestashop
    final List<ProductRawPresta> listOfPartProductsPresta = [];
    for (final partProduct in listOfPartOfSetArticles) {
      final partProductMarketplace = partProduct.productMarketplaces.where((e) => e.idMarketplace == productMarketplace.idMarketplace).firstOrNull;
      if (partProductMarketplace == null) {
        final e = 'Der Einzelartikel: "${partProduct.name}" des Set-Artikels  konnte im Marktplatz: "${marketplace.name}" nicht gefunden werden';
        logger.e(e);
        return left(PrestaGeneralFailure(errorMessage: e));
      }
      final partMarketplaceProductPresta = partProductMarketplace.marketplaceProduct as ProductPresta;
      final fosPartProductPresta = await PrestashopRepositoryGet(marketplace).getProductRaw(partMarketplaceProductPresta.id);
      if (fosPartProductPresta.isLeft()) {
        final e = 'Der Einzelartikel: "${partProduct.name}" des Set-Artikels konnte aus dem Marktplatz: "${marketplace.name}" nicht geladen werden';
        logger.e(e);
        return Left(PrestaGeneralFailure(errorMessage: e));
      }
      final partProductPresta = fosPartProductPresta.getRight();
      final quantity = product.listOfProductIdWithQuantity.where((e) => e.productId == partProduct.id).first.quantity;
      listOfPartProductsPresta.add(partProductPresta.copyWith(quantity: quantity.toString()));
    }

    String manufacturerId = '0';

    if (product.manufacturer.isNotEmpty) {
      final manufacturerIdResponse = await PrestashopRepositoryGet(marketplace).getManufacturerId(product.manufacturer);
      if (manufacturerIdResponse.isRight()) manufacturerId = manufacturerIdResponse.getRight();
    }

    final builder = patchProductBuilder(
      id: marketplaceProductPrestaId,
      product: product,
      productMarketplace: productMarketplace,
      productPresta: productPresta,
      manufacturerId: manufacturerId,
      listOfPartProductsPresta: listOfPartProductsPresta,
    );

    final errorC1 = PrestaGeneralFailure(
      errorMessage:
          'Beim bearbeiten des Artikels: "${product.name}" im Marktplatz: "${marketplace.name}" ist ein Fehler aufgetreten.\nTechnischer Fehler im: patchProductBuilder',
    );

    if (builder == null) return left(errorC1);
    final document = builder.buildDocument();
    final xmlPayload = document.toXmlString();

    final response = await patchProduct(marketplaceProductPrestaId: marketplaceProductPrestaId, xmlPayload: xmlPayload);

    return response;
  }

  Future<Either<AbstractFailure, Unit>> updateOrderStatusInMarketplace({required int orderId, required int statusId}) async {
    final builder = patchOrderStatusBuilder(orderId, statusId);
    final document = builder.buildDocument();
    final xmlPayload = document.toXmlString();

    final response = await patchOrderStatus(orderId: orderId, xmlPayload: xmlPayload);

    return response;
  }

  Future<Either<AbstractFailure, Unit>> updateCategoriesInMarketplace({
    required int productId,
    required Product product,
    required ProductPresta productPresta,
  }) async {
    final error = PrestaGeneralFailure(
      errorMessage:
          'Beim bearbeiten des Artikels: "${product.name}" im Marktplatz: "${marketplace.name}" ist ein Fehler aufgetreten.\nTechnischer Fehler im: patchProductBuilder',
    );
    final builder = patchProductCategoriesBuilder(
      id: productId,
      product: product,
      marketplaceProductPresta: productPresta,
    );

    if (builder == null) return Left(error);

    final document = builder.buildDocument();
    final xmlPayload = document.toXmlString();

    final response = await patchProduct(marketplaceProductPrestaId: productId, xmlPayload: xmlPayload);

    return response;
  }
}
