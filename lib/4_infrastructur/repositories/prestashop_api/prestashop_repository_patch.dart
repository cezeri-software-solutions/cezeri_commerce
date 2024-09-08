import 'dart:convert';

import 'package:cezeri_commerce/1_presentation/core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../3_domain/entities/marketplace/marketplace_presta.dart';
import '../../../constants.dart';
import '../../../failures/failures.dart';
import 'patch_builders.dart';
import 'prestashop_repository_get.dart';

class PrestashopRepositoryPatch {
  PrestashopRepositoryPatch();

  final supabase = GetIt.I<SupabaseClient>();

  Future<Either<AbstractFailure, Unit>> patchStockAvailable({
    required String ownerId,
    required MarketplacePresta marketplace,
    required String stockAvailableId,
    required String xmlPayload,
  }) async {
    try {
      await supabase.functions.invoke(
        'prestashop_api',
        body: jsonEncode({
          'marketplaceId': marketplace.id,
          'ownerId': ownerId,
          'functionName': 'patchProductQuantity',
          'stockAvailableId': stockAvailableId,
          'xmlPayload': xmlPayload,
        }),
      );

      return const Right(unit);
    } catch (e) {
      logger.e('Error: $e');
      return Left(PrestaGeneralFailure(errorMessage: e.toString()));
    }
  }

  Future<Either<AbstractFailure, Unit>> patchProductQuantity({
    required String ownerId,
    required MarketplacePresta marketplace,
    required int productId, // Artikel-ID im Marktplatz
    required int quantity,
  }) async {
    final fosProductRaw = await PrestashopRepositoryGet().getProductRaw(ownerId, marketplace, productId);
    if (fosProductRaw.isLeft()) return Left(fosProductRaw.getLeft());

    final productRaw = fosProductRaw.getRight();
    final stockAvailableId = productRaw.associations.associationsStockAvailables!.first.id;

    final builder = patchStockAvailableBuilder(stockAvailableId, quantity);
    final document = builder.buildDocument();
    final xmlPayload = document.toXmlString();

    final response = await patchStockAvailable(
      ownerId: ownerId,
      marketplace: marketplace,
      stockAvailableId: stockAvailableId,
      xmlPayload: xmlPayload,
    );

    return response;
  }
}
