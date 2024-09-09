import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../3_domain/entities/marketplace/marketplace_presta.dart';
import '../../../3_domain/entities/product/product_image.dart';
import '../../../constants.dart';
import '../../../failures/failures.dart';

class PrestashopRepositoryPost {
  final MarketplacePresta marketplace;
  final Map<String, String> credentials;

  PrestashopRepositoryPost(this.marketplace)
      : credentials = {
          'apiKey': marketplace.key,
          'url': '${marketplace.endpointUrl}${marketplace.url}${marketplace.shopSuffix}',
        };

  final supabase = GetIt.I<SupabaseClient>();

  Future<Either<AbstractFailure, Unit>> uploadProductImage({
    required MarketplacePresta marketplace,
    required String productId,
    required ProductImage productImage,
  }) async {
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
      logger.e('Error: $e');
      return Left(PrestaGeneralFailure(errorMessage: e.toString()));
    }
  }
}
