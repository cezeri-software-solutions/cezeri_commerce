import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../3_domain/entities/marketplace/marketplace_presta.dart';
import '../../../constants.dart';
import '../../../failures/failures.dart';
import 'models/models.dart';

class PrestashopRepositoryGet {
  PrestashopRepositoryGet();

  final supabase = GetIt.I<SupabaseClient>();

  //* Categories */
  Future<Either<AbstractFailure, List<CategoryPresta>>> getCategories(String ownerId, MarketplacePresta marketplace) async {
    try {
      final response = await supabase.functions.invoke(
        'prestashop_api',
        body: jsonEncode({'marketplaceId': marketplace.id, 'ownerId': ownerId, 'functionName': 'getCategories'}),
      );

      return Right(CategoriesPresta.fromJson(response.data).items);
    } catch (e) {
      logger.e('Error: $e');
      return Left(PrestaGeneralFailure(errorMessage: e.toString()));
    }
  }

  //* Products */
  //* "getProductRaw gibt den Artikel so zurück, wie diese von Prestashop bereitgestellt wird"
  Future<Either<AbstractFailure, ProductRawPresta>> getProductRaw(String ownerId, MarketplacePresta marketplace, int productId) async {
    try {
      final response = await supabase.functions.invoke(
        'prestashop_api',
        body: jsonEncode({'marketplaceId': marketplace.id, 'ownerId': ownerId, 'functionName': 'getProduct', 'productId': productId}),
      );

      return Right(ProductsPresta.fromJson(response.data).items.single);
    } catch (e) {
      logger.e('Error: $e');
      return Left(PrestaGeneralFailure(errorMessage: e.toString()));
    }
  }

  //* "getProduct gibt den Artikel so zurück, wie diese von Prestashop bereitgestellt wird und fürgt noch weitere Artikeldaten hinzu"
  //* Wie z.B. Multilanguage, ListOfProductImages usw.
  Future<Either<AbstractFailure, ProductRawPresta>> getProduct(String ownerId, MarketplacePresta marketplace, int productId) async {
    try {
      final response = await supabase.functions.invoke(
        'prestashop_api',
        body: jsonEncode({'marketplaceId': marketplace.id, 'ownerId': ownerId, 'functionName': 'getProduct', 'productId': productId}),
      );
      // TODO:
      // final optionalProductPresta = payload == null ? const Optional.absent() : Optional.of(ProductsPresta.fromJson(payload).items.single);
      // if (optionalProductPresta.isNotPresent) return const Optional.absent();
      // final phProductPresta = optionalProductPresta.value;
      // final productPresta = await getProductImpl(phProductPresta, marketplace);
      // return productPresta.isNotPresent ? const Optional.absent() : productPresta;

      return Right(ProductRawPresta.fromJson(response.data));
    } catch (e) {
      logger.e('Error: $e');
      return Left(PrestaGeneralFailure(errorMessage: e.toString()));
    }
  }
}
