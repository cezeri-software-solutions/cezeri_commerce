import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../3_domain/entities/marketplace/marketplace_presta.dart';
import '../../../constants.dart';
import '../../../failures/failures.dart';

class PrestashopRepositoryDelete {
  final MarketplacePresta marketplace;
  final Map<String, String> credentials;

  PrestashopRepositoryDelete(this.marketplace)
      : credentials = {
          'apiKey': marketplace.key,
          'url': '${marketplace.endpointUrl}${marketplace.url}${marketplace.shopSuffix}',
        };

  final supabase = GetIt.I<SupabaseClient>();

  Future<Either<AbstractFailure, Unit>> deleteProductImage(String productId, String imageId) async {
    try {
      await supabase.functions.invoke(
        'prestashop_api',
        body: jsonEncode({
          'credentials': credentials,
          'functionName': 'deleteProductImage',
          'productId': productId,
          'imageId': imageId,
        }),
      );

      return const Right(unit);
    } catch (e) {
      logger.e('Error on Marketplace ${marketplace.shortName}: $e');
      return Left(PrestaGeneralFailure(errorMessage: e.toString()));
    }
  }
}
