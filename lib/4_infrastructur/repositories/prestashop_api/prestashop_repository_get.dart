import 'dart:convert';
import 'dart:io';

import 'package:cezeri_commerce/1_presentation/core/core.dart';
import 'package:cezeri_commerce/4_infrastructur/repositories/prestashop_api/prestashop_api.dart';
import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../3_domain/entities/marketplace/marketplace_presta.dart';
import '../../../constants.dart';
import '../../../failures/failures.dart';
import 'models/models.dart';

class PrestashopRepositoryGet {
  final MarketplacePresta marketplace;
  final Map<String, String> credentials;

  PrestashopRepositoryGet(this.marketplace)
      : credentials = {
          'apiKey': marketplace.key,
          'url': '${marketplace.endpointUrl}${marketplace.url}${marketplace.shopSuffix}',
        };

  final supabase = GetIt.I<SupabaseClient>();

  //* Categories */
  Future<Either<AbstractFailure, List<CategoryPresta>>> getCategories(MarketplacePresta marketplace) async {
    try {
      final response = await supabase.functions.invoke(
        'prestashop_api',
        body: jsonEncode({'credentials': credentials, 'functionName': 'getCategories'}),
      );

      return Right(CategoriesPresta.fromJson(response.data).items);
    } catch (e) {
      logger.e('Error: $e');
      return Left(PrestaGeneralFailure(errorMessage: e.toString()));
    }
  }

  //* Languages */
  Future<Either<AbstractFailure, List<LanguagePresta>>> getLanguages(MarketplacePresta marketplace) async {
    try {
      final response = await supabase.functions.invoke(
        'prestashop_api',
        body: jsonEncode({'credentials': credentials, 'functionName': 'getLanguages'}),
      );

      return Right(LanguagesPresta.fromJson(response.data).items);
    } catch (e) {
      logger.e('Error: $e');
      return Left(PrestaGeneralFailure(errorMessage: e.toString()));
    }
  }

  //* Images */
  Future<Either<AbstractFailure, List<ProductPrestaImage>>> getProductImages(MarketplacePresta marketplace, ProductRawPresta productRawPresta) async {
    if (productRawPresta.associations.associationsImages != null && productRawPresta.associations.associationsImages!.isNotEmpty) {
      return const Right([]);
    }

    List<ProductPrestaImage> listOfImages = [];

    if (productRawPresta.associations.associationsImages == null) return Right(listOfImages);
    for (final id in productRawPresta.associations.associationsImages!) {
      final uri = '${marketplace.fullUrl}images/products/${productRawPresta.id}/${id.id}';
      final responseImage = await http.get(
        Uri.parse(uri),
        headers: {'Authorization': 'Basic ${base64Encode(utf8.encode('${marketplace.key}:'))}'},
      );

      if (responseImage.statusCode == 200) {
        final Directory directory = await getTemporaryDirectory();
        final File file = File('${directory.path}/product_${productRawPresta.id}_${id.id}.jpg');
        final imageFile = await file.writeAsBytes(responseImage.bodyBytes);
        listOfImages.add(ProductPrestaImage(productId: id.id.toMyInt(), imageFile: imageFile));
      }
    }

    return Right(listOfImages);
  }

  //* Products */
  //* "getProductRaw gibt den Artikel so zurück, wie diese von Prestashop bereitgestellt wird"
  Future<Either<AbstractFailure, ProductRawPresta>> getProductRaw(MarketplacePresta marketplace, int productId) async {
    try {
      final response = await supabase.functions.invoke(
        'prestashop_api',
        body: jsonEncode({'credentials': credentials, 'functionName': 'getProduct', 'productId': productId}),
      );

      return Right(ProductsPresta.fromJson(response.data).items.single);
    } catch (e) {
      logger.e('Error: $e');
      return Left(PrestaGeneralFailure(errorMessage: e.toString()));
    }
  }

  //* StockAvailables */
  Future<Either<AbstractFailure, StockAvailablePresta>> getStockAvailable(MarketplacePresta marketplace, int stockAvailableId) async {
    try {
      final response = await supabase.functions.invoke(
        'prestashop_api',
        body: jsonEncode({
          'credentials': credentials,
          'functionName': 'getStockAvailable',
          'stockAvailableId': stockAvailableId,
        }),
      );

      return Right(StockAvailablesPresta.fromJson(response.data).items.single);
    } catch (e) {
      logger.e('Error: $e');
      return Left(PrestaGeneralFailure(errorMessage: e.toString()));
    }
  }

  //* "getProduct gibt den Artikel so zurück, wie diese von Prestashop bereitgestellt wird und fürgt noch weitere Artikeldaten hinzu"
  //* Wie z.B. Multilanguage, ListOfProductImages usw.
  Future<Either<AbstractFailure, ProductRawPresta>> getProduct(MarketplacePresta marketplace, int productId) async {
    final fosProductRawPresta = await getProductRaw(marketplace, productId);
    if (fosProductRawPresta.isLeft()) return Left(fosProductRawPresta.getLeft());
    final productRawPresta = fosProductRawPresta.getRight();

    final idStockAvailable = productRawPresta.associations.associationsStockAvailables!.first.id;
    final fosStockAvailablesPresta = await getStockAvailable(marketplace, idStockAvailable.toMyInt());
    if (fosStockAvailablesPresta.isLeft()) return Left(fosStockAvailablesPresta.getLeft());
    final stockAvailablesPresta = fosStockAvailablesPresta.getRight();

    final fosMarketplaceLanguages = await getLanguages(marketplace);
    if (fosMarketplaceLanguages.isLeft()) return Left(fosProductRawPresta.getLeft());
    final marketplaceLanguages = fosMarketplaceLanguages.getRight();

    final fosListOfImages = await getProductImages(marketplace, productRawPresta);
    if (fosListOfImages.isLeft()) return Left(fosListOfImages.getLeft());
    final listOfImages = fosListOfImages.getRight();

    final productPresta = _fromRawProductToProductToUse(
      phProductPresta: productRawPresta,
      marketplace: marketplace,
      stockAvailablesPresta: stockAvailablesPresta,
      marketplaceLanguages: marketplaceLanguages,
      listOfImages: listOfImages,
    );

    return Right(productPresta);
  }
}

ProductRawPresta _fromRawProductToProductToUse({
  required ProductRawPresta phProductPresta,
  required MarketplacePresta marketplace,
  required StockAvailablePresta stockAvailablesPresta,
  required List<LanguagePresta> marketplaceLanguages,
  required List<ProductPrestaImage> listOfImages,
}) {
  // TODO: Wenn Variantenartikel importiert werden können ENTFERNEN
  final isVariantProduct = phProductPresta.associations.associationsStockAvailables!.length > 1;
  if (isVariantProduct) return throw PrestaGeneralFailure(errorMessage: 'Variantenartikel können noch nicht importiert werden');

  if (phProductPresta.nameMultilanguage != null && phProductPresta.nameMultilanguage!.isNotEmpty) {
    final germanLanguage = marketplaceLanguages.where((e) => e.isoCode.toUpperCase() == 'DE').firstOrNull;
    if (germanLanguage == null) return throw PrestashopApiException;
    final germanLanguageId = germanLanguage.id.toString();

    phProductPresta = phProductPresta.copyWith(
      quantity: stockAvailablesPresta.quantity,
      deliveryInStock: phProductPresta.deliveryInStockMultilanguage!.where((e) => e.id == germanLanguageId).first.value,
      deliveryOutStock: phProductPresta.deliveryOutStockMultilanguage!.where((e) => e.id == germanLanguageId).first.value,
      metaDescription: phProductPresta.metaDescriptionMultilanguage!.where((e) => e.id == germanLanguageId).first.value,
      metaKeywords: phProductPresta.metaKeywordsMultilanguage!.where((e) => e.id == germanLanguageId).first.value,
      metaTitle: phProductPresta.metaTitleMultilanguage!.where((e) => e.id == germanLanguageId).first.value,
      linkRewrite: phProductPresta.linkRewriteMultilanguage!.where((e) => e.id == germanLanguageId).first.value,
      name: phProductPresta.nameMultilanguage!.where((e) => e.id == germanLanguageId).first.value,
      description: phProductPresta.descriptionMultilanguage!.where((e) => e.id == germanLanguageId).first.value,
      descriptionShort: phProductPresta.descriptionShortMultilanguage!.where((e) => e.id == germanLanguageId).first.value,
      availableNow: phProductPresta.availableNowMultilanguage!.where((e) => e.id == germanLanguageId).first.value,
      availableLater: phProductPresta.availableLaterMultilanguage!.where((e) => e.id == germanLanguageId).first.value,
    );
  }

  List<ProductRawPresta> listOfBundleProduct = [];
  //* Wenn Set-Artikel auch richtig importiert und bearbeitet werden können
  // if (phProductPresta.associations.associationsProductBundle != null && phProductPresta.associations.associationsProductBundle!.isNotEmpty) {
  //   for (final id in phProductPresta.associations.associationsProductBundle!) {
  //     final bundleProduct = await getProduct(id.id.toMyInt(), marketplace);
  //     if (bundleProduct.isNotPresent) continue;
  //     listOfBundleProduct.add(bundleProduct.value);
  //   }
  // }

  final quantity = listOfBundleProduct.isNotEmpty
      ? listOfBundleProduct.map((e) => e.quantity.toMyInt()).toList().reduce((min, currentNumber) => min < currentNumber ? min : currentNumber)
      : stockAvailablesPresta.quantity.toMyInt();

  final productPresta = phProductPresta.copyWith(
    quantity: quantity.toString(),
    imageFiles: listOfImages.isNotEmpty ? listOfImages : phProductPresta.imageFiles,
    marketplaceLanguages: marketplaceLanguages,
  );

  return productPresta;
}
