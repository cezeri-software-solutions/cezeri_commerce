import 'dart:convert';

import 'package:cezeri_commerce/1_presentation/core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xml/xml.dart';

import '../../../3_domain/entities/marketplace/marketplace_presta.dart';
import '../../../3_domain/entities/product/product.dart';
import '../../../3_domain/entities/product/product_image.dart';
import '../../../3_domain/entities/product/product_marketplace.dart';
import '../../../3_domain/entities/product/product_presta.dart';
import '../../../constants.dart';
import '../../../failures/failures.dart';
import 'builders/presta_builders.dart';
import 'prestashop_repository_get.dart';

class PrestashopRepositoryPost {
  final MarketplacePresta marketplace;
  final Map<String, String> credentials;

  PrestashopRepositoryPost(this.marketplace)
      : credentials = {
          'apiKey': marketplace.key,
          'url': '${marketplace.endpointUrl}${marketplace.url}${marketplace.shopSuffix}',
        };

  final supabase = GetIt.I<SupabaseClient>();

  Future<Either<AbstractFailure, Unit>> uploadProductImage({required String productId, required ProductImage productImage}) async {
    try {
      await supabase.functions.invoke(
        'prestashop_api',
        body: jsonEncode({
          'credentials': credentials,
          'functionName': 'uploadProductImage',
          'productId': productId,
          'productImage': {'fileName': productImage.fileName, 'fileUrl': productImage.fileUrl},
        }),
      );

      return const Right(unit);
    } catch (e) {
      logger.e('Error on Marketplace ${marketplace.shortName}: $e');
      return Left(PrestaGeneralFailure(errorMessage: e.toString()));
    }
  }

  Future<Either<AbstractFailure, int>> postProduct(String xmlPayload) async {
    try {
      final response = await supabase.functions.invoke(
        'prestashop_api',
        body: jsonEncode({
          'credentials': credentials,
          'functionName': 'postProduct',
          'xmlPayload': xmlPayload,
        }),
      );

      print('--------------------- START prestashop_repository_post / postProduct -------------------------------');
      print(response.data);
      print('--------------------- END prestashop_repository_post / postProduct -------------------------------');

      final document = XmlDocument.parse(response.data);
      final idElement = document.findAllElements('id').firstOrNull;
      if (idElement == null) return Left(PrestaGeneralFailure(errorMessage: 'No id found in response'));

      return Right(idElement.innerText.toMyInt());
    } catch (e) {
      logger.e('Error on Marketplace ${marketplace.shortName}: $e');
      return Left(PrestaGeneralFailure(errorMessage: e.toString()));
    }
  }

  Future<Either<AbstractFailure, int>> postSpecificPrice(String xmlPayload) async {
    try {
      final response = await supabase.functions.invoke(
        'prestashop_api',
        body: jsonEncode({
          'credentials': credentials,
          'functionName': 'postSpecificPrice',
          'xmlPayload': xmlPayload,
        }),
      );

      print('--------------------- START prestashop_repository_post / postSpecificPrice -------------------------------');
      print(response.data);
      print('--------------------- END prestashop_repository_post / postSpecificPrice -------------------------------');

      final document = XmlDocument.parse(response.data);
      final idElement = document.findAllElements('id').firstOrNull;
      if (idElement == null) return Left(PrestaGeneralFailure(errorMessage: 'No id found in response'));

      return Right(idElement.innerText.toMyInt());
    } catch (e) {
      logger.e('Error on Marketplace ${marketplace.shortName}: $e');
      print('e.runtimeType: ${e.runtimeType}');
      print('e: $e');
      return Left(PrestaGeneralFailure(errorMessage: e.toString()));
    }
  }

  Future<Either<AbstractFailure, int>> createNewProductInMarketplace({
    required Product product,
    required ProductMarketplace productMarketplace,
    required ProductMarketplace anotherProductMarketplaceWithSameManufacturer,
  }) async {
    final fosProductPresta = await PrestashopRepositoryGet(marketplace).getProductByReference(product.articleNumber);
    if (fosProductPresta.isLeft()) {
      logger.e('Ein Artikel mit der Artikelnummer: "${product.articleNumber}" ist bereits im Marktplatz: "${marketplace.name}" vorhanden');
      return Left(fosProductPresta.getLeft());
    }
    final aMpp = anotherProductMarketplaceWithSameManufacturer.marketplaceProduct as ProductPresta;
    final fosAnotherProductPresta = await PrestashopRepositoryGet(marketplace).getProduct(aMpp.id);
    if (fosAnotherProductPresta.isLeft()) return Left(fosAnotherProductPresta.getLeft());
    final productPrestaWithSameManufacturer = fosAnotherProductPresta.getRight();

    final builder = postProductBuilder(
      product: product,
      productMarketplace: productMarketplace,
      productPrestaWithSameManufacturer: productPrestaWithSameManufacturer,
    );
    if (builder == null) return Left(PrestaGeneralFailure(errorMessage: 'postProductBuilder konnte nicht erstellt werden'));

    final document = builder.buildDocument();
    final xmlPayload = document.toXmlString();

    final response = await postProduct(xmlPayload);
    if (response.isLeft()) return Left(response.getLeft());

    return Right(response.getRight());
  }

  Future<Either<AbstractFailure, int>> createNewSpecificPrice({required Product product, required ProductPresta productPresta}) async {
    print('--- prestashop_repository_post / createNewSpecificPrice ---');
    final fosProductPrestaRaw = await PrestashopRepositoryGet(marketplace).getProductRaw(productPresta.id);
    if (fosProductPrestaRaw.isLeft()) {
      logger.e('Ein Artikel mit der Artikelnummer: "${product.articleNumber}" ist bereits im Marktplatz: "${marketplace.name}" vorhanden');
      return Left(fosProductPrestaRaw.getLeft());
    }

    final productPrestaRaw = fosProductPrestaRaw.getRight();

    final builder = postSpecificPriceBuilder(product: product, productPrestaRaw: productPrestaRaw);
    final document = builder.buildDocument();
    final xmlPayload = document.toXmlString();

    print(document.toXmlString(pretty: true));

    final response = await postSpecificPrice(xmlPayload);
    if (response.isLeft()) return Left(response.getLeft());

    return Right(response.getRight());
  }
}
