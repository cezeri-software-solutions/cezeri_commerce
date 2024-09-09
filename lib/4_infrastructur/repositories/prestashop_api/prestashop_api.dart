import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cezeri_commerce/3_domain/entities/marketplace/marketplace_presta.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:loggy/loggy.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quiver/core.dart';
import 'package:xml/xml.dart';

import '/1_presentation/core/core.dart';
import '/3_domain/entities/product/product.dart';
import '/3_domain/entities/product/product_image.dart';
import '/3_domain/entities/product/product_marketplace.dart';
import '../../../3_domain/entities/product/product_presta.dart';
import '../../../constants.dart';
import '../../../failures/presta_failure.dart';
import 'models/models.dart';
import 'patch_builders.dart';
import 'post_builder.dart';
import 'put_builder.dart';

class PrestashopApiConfig {
  final String apiKey;
  final String webserviceUrl;

  PrestashopApiConfig({required this.apiKey, required this.webserviceUrl});
}

class PrestashopApi with UiLoggy {
  final Client _http;

  final PrestashopApiConfig _conf;

  PrestashopApi(this._http, this._conf);

  void close() => _http.close();

  //* Addresses */
  Future<Optional<AddressPresta>> getAddress(final int id) async {
    final payload = await _doGetJson(
      '${_conf.webserviceUrl}addresses/$id?ws_key=${_conf.apiKey}&output_format=JSON&display=full',
      single: true,
    );
    return payload == null ? const Optional.absent() : Optional.of(AddressesPresta.fromJson(payload).items.single);
  }

  //* Carriers */
  Future<Optional<CarrierPresta>> getCarrier(final int id) async {
    final payload = await _doGetJson(
      '${_conf.webserviceUrl}carriers/$id?ws_key=${_conf.apiKey}&output_format=JSON&display=full',
      single: true,
    );
    return payload == null ? const Optional.absent() : Optional.of(CarriersPresta.fromJson(payload).items.single);
  }

  //* Categories */
  Future<Optional<CategoryPresta>> getCategory(final int id) async {
    final payload = await _doGetJson(
      '${_conf.webserviceUrl}categories/$id?ws_key=${_conf.apiKey}&output_format=JSON&display=full',
    );
    return payload == null ? const Optional.absent() : Optional.of(CategoriesPresta.fromJson(payload).items.single);
  }

  //? DONE // TESTED
  Future<List<CategoryPresta>> getCategories() async {
    final payload = await _doGetJson(
      '${_conf.webserviceUrl}categories?ws_key=${_conf.apiKey}&output_format=JSON&display=full',
    );
    return CategoriesPresta.fromJson(payload).items;
  }

  //* Countries */
  Future<Optional<CountryPresta>> getCountry(final int id) async {
    final payload = await _doGetJson(
      '${_conf.webserviceUrl}countries/$id?ws_key=${_conf.apiKey}&output_format=JSON&display=full',
      single: true,
    );
    return payload == null ? const Optional.absent() : Optional.of(CountriesPresta.fromJson(payload).items.single);
  }

  //* Currencies */
  Future<Optional<CurrencyPresta>> getCurrency(final int id) async {
    final payload = await _doGetJson(
      '${_conf.webserviceUrl}currencies/$id?ws_key=${_conf.apiKey}&output_format=JSON&display=full',
      single: true,
    );
    return payload == null ? const Optional.absent() : Optional.of(CurrenciesPresta.fromJson(payload).items.single);
  }

  //* Customers */
  Future<Optional<CustomerPresta>> getCustomer(final int id) async {
    final payload = await _doGetJson(
      '${_conf.webserviceUrl}customers/$id?ws_key=${_conf.apiKey}&output_format=JSON&display=full',
      single: true,
    );
    return payload == null ? const Optional.absent() : Optional.of(CustomersPresta.fromJson(payload).items.single);
  }

  //* Languages */
  Future<Optional<LanguagePresta>> getLanguage(final int id) async {
    final payload = await _doGetJson(
      '${_conf.webserviceUrl}languages/$id?ws_key=${_conf.apiKey}&output_format=JSON&display=full',
    );
    return payload == null ? const Optional.absent() : Optional.of(LanguagesPresta.fromJson(payload).items.single);
  }

  //? DONE // TESTED
  Future<List<LanguagePresta>> getLanguages() async {
    final payload = await _doGetJson(
      '${_conf.webserviceUrl}languages?ws_key=${_conf.apiKey}&output_format=JSON&display=full',
    );
    return LanguagesPresta.fromJson(payload).items;
  }

  //* Orders */
  Future<List<OrderIdPresta>> getOrderIds() async {
    final payload = await _doGetJson(
      '${_conf.webserviceUrl}orders?ws_key=${_conf.apiKey}&output_format=JSON',
    );

    return OrdersIdPresta.fromJson(payload).items;
  }

  Future<List<OrderPresta>> getOrdersFilterIdInterval(int idFrom, int idTo) async {
    final payload = await _doGetJson(
      '${_conf.webserviceUrl}orders?ws_key=${_conf.apiKey}&filter[id]=[$idFrom,$idTo]&output_format=JSON&display=full',
    );
    loggy.debug(payload);

    return OrdersPresta.fromJson(payload).items;
  }

  Future<Optional<OrderPresta>> getOrder(final int id) async {
    final payload = await _doGetJson(
      '${_conf.webserviceUrl}orders/$id?ws_key=${_conf.apiKey}&output_format=JSON&display=full',
      single: true,
    );
    return payload == null ? const Optional.absent() : Optional.of(OrdersPresta.fromJson(payload).items.single);
  }

  Future<Optional<XmlDocument>> getOrderAsXml(final int id) async {
    final payload = await _doGetJson(
      '${_conf.webserviceUrl}orders/$id?ws_key=${_conf.apiKey}&display=full',
      single: true,
    );
    return payload == null ? const Optional.absent() : Optional.of(payload as XmlDocument);
  }

  //* Products */
  Future<List<ProductIdPresta>> getProductIds() async {
    final payload = await _doGetJson(
      '${_conf.webserviceUrl}products?ws_key=${_conf.apiKey}&output_format=JSON',
    );

    return ProductsIdPresta.fromJson(payload).items;
  }

  Future<List<ProductIdPresta>> getProductIdsOnlyActive() async {
    final payload = await _doGetJson(
      '${_conf.webserviceUrl}products?ws_key=${_conf.apiKey}&filter[active]=[1]&output_format=JSON',
    );

    return ProductsIdPresta.fromJson(payload).items;
  }

  //? DONE // TESTED
  Future<Optional<ProductRawPresta>> getProduct(final int id, final MarketplacePresta marketplace) async {
    final payload = await _doGetJson(
      '${_conf.webserviceUrl}products?ws_key=${_conf.apiKey}&filter[id]=[$id]&output_format=JSON&display=full',
      single: true,
    );
    final optionalProductPresta = payload == null ? const Optional.absent() : Optional.of(ProductsPresta.fromJson(payload).items.single);
    if (optionalProductPresta.isNotPresent) return const Optional.absent();
    final phProductPresta = optionalProductPresta.value;
    final productPresta = await getProductImpl(phProductPresta, marketplace);
    return productPresta.isNotPresent ? const Optional.absent() : productPresta;
  }

  Future<Optional<ProductRawPresta>> getProductByReference(final String reference, final MarketplacePresta marketplace) async {
    final payload = await _doGetJson(
      '${_conf.webserviceUrl}products?ws_key=${_conf.apiKey}&filter[reference]=[$reference]&output_format=JSON&display=full',
      single: true,
    );
    if (payload is Map && payload.isEmpty || payload is List && payload.isEmpty) return const Optional.absent();
    final optionalProductPresta = payload == null ? const Optional.absent() : Optional.of(ProductsPresta.fromJson(payload).items.first);
    if (optionalProductPresta.isNotPresent) return const Optional.absent();
    final phProductPresta = optionalProductPresta.value;
    final productPresta = await getProductImpl(phProductPresta, marketplace);
    return productPresta.isNotPresent ? const Optional.absent() : productPresta;
  }

  Future<Optional<XmlDocument>> getProductAsXml(final int id) async {
    final payloadProduct = await _doGetXml(
      '${_conf.webserviceUrl}products/$id?ws_key=${_conf.apiKey}&display=full',
      single: true,
    );
    return payloadProduct == null ? const Optional.absent() : Optional.of(payloadProduct as XmlDocument);
  }

  //* StockAvailables */
  Future<Optional<StockAvailablePresta>> getStockAvailable(final int id) async {
    final payload = await _doGetJson(
      '${_conf.webserviceUrl}stock_availables/$id?ws_key=${_conf.apiKey}&output_format=JSON&display=full',
    );
    return payload == null ? const Optional.absent() : Optional.of(StockAvailablesPresta.fromJson(payload).items.single);
  }

  Future<Optional<XmlDocument>> getStockAvailableAsXml(final int id) async {
    final payload = await _doGetXml(
      '${_conf.webserviceUrl}stock_availables/$id?ws_key=${_conf.apiKey}&display=full',
    );
    return payload == null ? const Optional.absent() : Optional.of(payload as XmlDocument);
  }

  Future<List<StockAvailablePresta>> getStockAvailables() async {
    final payload = await _doGetJson(
      '${_conf.webserviceUrl}stock_availables?ws_key=${_conf.apiKey}&output_format=JSON&display=full',
    );
    return StockAvailablesPresta.fromJson(payload).items;
  }

  //? ################################## GET ENDE ######################################################################################
  //? ##################################################################################################################################
  //? ##################################################################################################################################
  //? ################################## PATCH START ###################################################################################
  //* Order
  //? DONE // TESTED
  //TODO: statt bool fos zurückgeben
  Future<bool> patchOrderStatus(final int orderId, final int statusId, final bool isPresta8) async {
    bool payload = false;
    if (isPresta8) {
      final builder = patchOrderStatusBuilder(orderId, statusId);
      final fosPayload = await _doPatch(
        '${_conf.webserviceUrl}orders/$orderId',
        builder,
      );
      fosPayload.fold(
        (failure) => payload = false,
        (unit) => payload = true,
      );
    }
    // else {
    //   final optionalOrder = await getOrderAsXml(orderId);
    //   if (optionalOrder.isNotPresent) return false;
    //   final orderAsXml = optionalOrder.value;
    //   final updatedDocument = orderStatusUpdater(orderAsXml, statusId);
    //   final payloadDoPut = await _doPut(
    //     '${_conf.webserviceUrl}orders/$orderId',
    //     updatedDocument,
    //   );
    //   payload = payloadDoPut;
    // }
    return payload;
  }

  //* Product
  //? DONE // TESTED
  Future<Either<PrestaFailure, Unit>> patchProductQuantity(
    final int marketplaceProductPrestaId,
    final int quantity,
    final MarketplacePresta marketplace,
  ) async {
    final errorC1 = PrestaGeneralFailure(
      errorMessage:
          'Artikel mit der ID: "$marketplaceProductPrestaId" konnte im Marktplatz: "${marketplace.name}" nicht gefunden werden.\nTechnischer Fehler im: getProduct',
    );

    final optionalProductPresta = await getProduct(marketplaceProductPrestaId, marketplace);
    if (optionalProductPresta.isNotPresent) return left(errorC1);
    final productPresta = optionalProductPresta.value;
    final stockAvailableId = productPresta.associations.associationsStockAvailables!.first.id;

    final errorC2 = PrestaGeneralFailure(
      errorMessage:
          'Bestandsdaten des Artikels: "${productPresta.name}" konnten im Marktplatz: "${marketplace.name}" nichgt gefunden werden.\nTechnischer Fehler im: getStockAvailableAsXml',
    );

    final errorC3 = 'Beim Aktualisieren des Artikels: "${productPresta.name}" im Marktplatz: "${marketplace.name}" ist ein Fehler aufgetreten.';

    if (marketplace.isPresta8) {
      final builder = patchStockAvailableBuilder(stockAvailableId, quantity);
      final fosPayload = await _doPatch(
        '${_conf.webserviceUrl}stock_availables/$stockAvailableId',
        builder,
      );
      fosPayload.fold(
        (failure) => left(failure.copyWith(customMessage: errorC3)),
        (unit) => right(unit),
      );
    } else {
      final optionaStockAvailableAsXml = await getStockAvailableAsXml(stockAvailableId.toMyInt());
      if (optionaStockAvailableAsXml.isNotPresent) return left(errorC2);
      final stockAvailableAsXml = optionaStockAvailableAsXml.value;
      final updatedDocument = stockAvailableUpdater(stockAvailableAsXml, quantity);
      final fosPayload = await _doPut(
        '${_conf.webserviceUrl}stock_availables/$stockAvailableId',
        updatedDocument,
      );
      fosPayload.fold(
        (failure) => left(failure.copyWith(customMessage: errorC3)),
        (unit) => right(unit),
      );
    }

    return right(unit);
  }

  //? DONE // TESTED
  Future<bool> uploadProductImageFromUrl(String productID, ProductImage productImage) async {
    Response imageResponse = await get(Uri.parse(productImage.fileUrl));

    Uint8List imageData = imageResponse.bodyBytes;

    String getFileExtensionFromFilename(String filename) {
      int lastDot = filename.lastIndexOf('.');
      if (lastDot != -1 && lastDot != filename.length - 1) {
        return filename.substring(lastDot + 1);
      }
      return 'unknown';
    }

    String url = '${_conf.webserviceUrl}images/products/$productID/';
    String base64Auth = base64Encode(utf8.encode('${_conf.apiKey}:'));

    final fileExtension = getFileExtensionFromFilename(productImage.fileName);
    logger.i(fileExtension);

    // Erstellen des MultipartRequest
    var request = MultipartRequest('POST', Uri.parse(url))
      ..headers.addAll({'Authorization': 'Basic $base64Auth'})
      ..files.add(MultipartFile.fromBytes('image', imageData,
          filename: productImage.fileName, // Ein Dateiname für das Bild
          contentType: MediaType('image', fileExtension) // Passen Sie den Typ basierend auf Ihrem Bildtyp an
          ));

    var response = await request.send();

    if (response.statusCode == 200) {
      logger.i('Image (${productImage.fileName}) uploaded successfully');
      return true;
    } else {
      logger.e('Failed to upload image: (${productImage.fileName})');
      return false;
    }
  }

  //? DONE // TESTED
  Future<bool> deleteProductImage(String productID, String imageID) async {
    String url = '${_conf.webserviceUrl}images/products/$productID/${imageID.toMyInt()}';
    String base64Auth = base64Encode(utf8.encode('${_conf.apiKey}:'));

    var response = await delete(
      Uri.parse(url),
      headers: {'Authorization': 'Basic $base64Auth'},
    );

    if (response.statusCode == 200) {
      logger.i('Image deleted successfully');
      return true;
    } else {
      logger.e('Failed to delete image');
      logger.e(response.body);
      return false;
    }
  }

  // //TODO: statt bool fos zurückgeben
  // Future<bool> patchProductImages(final int marketplaceProductPrestaId, final int quantity, final MarketplacePresta marketplace) async {
  //   // #################################################################################################
  //   final optionalProductPresta = await getProduct(marketplaceProductPrestaId, marketplace);
  //   if (optionalProductPresta.isNotPresent) return false;
  //   final productPresta = optionalProductPresta.value;
  //   final stockAvailableId = productPresta.associations.associationsStockAvailables!.first.id;
  //   bool payload = false;
  //   if (marketplace.isPresta8) {
  //     final builder = patchStockAvailableBuilder(stockAvailableId, quantity);
  //     final fosPayload = await _doPatch(
  //       '${_conf.webserviceUrl}stock_availables/$stockAvailableId',
  //       builder,
  //     );
  //     fosPayload.fold(
  //       (failure) => payload = false,
  //       (unit) => payload = true,
  //     );
  //   } else {
  //     final optionaStockAvailableAsXml = await getStockAvailableAsXml(stockAvailableId.toMyInt());
  //     if (optionaStockAvailableAsXml.isNotPresent) return false;
  //     final stockAvailableAsXml = optionaStockAvailableAsXml.value;
  //     final updatedDocument = stockAvailableUpdater(stockAvailableAsXml, quantity);
  //     final fosPayload = await _doPut(
  //       '${_conf.webserviceUrl}stock_availables/$stockAvailableId',
  //       updatedDocument,
  //     );
  //     fosPayload.fold(
  //       (failure) => payload = false,
  //       (unit) => payload = true,
  //     );
  //   }

  //   return payload;
  // }

  //? DONE // TESTED
  Future<Either<PrestaFailure, Unit>> patchProduct(
    final int marketplaceProductPrestaId,
    Product product,
    ProductMarketplace productMarketplace,
    MarketplacePresta marketplace,
  ) async {
    final errorC1 = PrestaGeneralFailure(
      errorMessage:
          'Artikel: "${product.name}" konnte im Marktplatz: "${marketplace.name}" nicht gefunden werden.\nTechnischer Fehler im: getProduct',
    );
    final errorC2 = PrestaGeneralFailure(
      errorMessage:
          'Beim bearbeiten des Artikels: "${product.name}" im Marktplatz: "${marketplace.name}" ist ein Fehler aufgetreten.\nTechnischer Fehler im: patchProductBuilder',
    );
    final errorC3 = PrestaGeneralFailure(
      errorMessage:
          'Artikel: "${product.name}" konnte im Marktplatz: "${marketplace.name}" nicht gefunden werden.\nTechnischer Fehler im: getProductAsXml',
    );

    final errorC4 = 'Beim Aktualisieren des Artikels: "${product.name}" im Marktplatz: "${marketplace.name}" ist ein Fehler aufgetreten.';

    final optionalProductPresta = await getProduct(marketplaceProductPrestaId, marketplace);
    if (optionalProductPresta.isNotPresent) return left(errorC1);

    final productPresta = optionalProductPresta.value;
    if (marketplace.isPresta8) {
      final builder = patchProductBuilder(
        id: marketplaceProductPrestaId,
        product: product,
        productMarketplace: productMarketplace,
        productPresta: productPresta,
      );

      if (builder == null) return left(errorC2);
      final fosPayload = await _doPatch('${_conf.webserviceUrl}products/$marketplaceProductPrestaId', builder);
      fosPayload.fold(
        (failure) => left(failure.copyWith(customMessage: errorC4)),
        (unit) => right(unit),
      );
    } else {
      final optionalProductAsXml = await getProductAsXml(marketplaceProductPrestaId);
      if (optionalProductAsXml.isNotPresent) return left(errorC3);
      final productAsXml = optionalProductAsXml.value;
      final updatedProductAsXml = productUpdater(
        document: productAsXml,
        product: product,
        productMarketplace: productMarketplace,
        productPresta: productPresta,
      );
      final fosPayload = await _doPut(
        '${_conf.webserviceUrl}products/$marketplaceProductPrestaId',
        updatedProductAsXml,
      );
      fosPayload.fold(
        (failure) => left(failure.copyWith(customMessage: errorC4)),
        (unit) => right(unit),
      );
    }
    return right(unit);
  }

  //? DONE // TESTED
  Future<Either<PrestaFailure, Unit>> patchSetProduct(
    final int marketplaceProductPrestaId,
    Product product,
    List<Product> listOfPartOfSetArticles,
    ProductMarketplace productMarketplace,
    MarketplacePresta marketplace,
  ) async {
    final errorC1 = PrestaGeneralFailure(
      errorMessage:
          'Artikel: "${product.name}" konnte im Marktplatz: "${marketplace.name}" nicht gefunden werden.\nTechnischer Fehler im: getProduct',
    );
    final errorC2 = PrestaGeneralFailure(
      errorMessage:
          'Beim bearbeiten des Artikels: "${product.name}" im Marktplatz: "${marketplace.name}" ist ein Fehler aufgetreten.\nTechnischer Fehler im: patchProductBuilder',
    );
    final errorC3 = PrestaGeneralFailure(
      errorMessage:
          'Artikel: "${product.name}" konnte im Marktplatz: "${marketplace.name}" nicht gefunden werden.\nTechnischer Fehler im: getProductAsXml',
    );

    final errorC4 = 'Beim Aktualisieren des Artikels: "${product.name}" im Marktplatz: "${marketplace.name}" ist ein Fehler aufgetreten.';

    final optionalProductPresta = await getProduct(marketplaceProductPrestaId, marketplace);
    if (optionalProductPresta.isNotPresent) return left(errorC1);
    final productPresta = optionalProductPresta.value;

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
      final optionalPartProductPresta = await getProduct(partMarketplaceProductPresta.id, marketplace);
      if (optionalPartProductPresta.isNotPresent) {
        final e = 'Der Einzelartikel: "${partProduct.name}" des Set-Artikels konnte aus dem Marktplatz: "${marketplace.name}" nicht geladen werden';
        logger.e(e);
        return left(PrestaGeneralFailure(errorMessage: e));
      }
      final partProductPresta = optionalPartProductPresta.value;
      final quantity = product.listOfProductIdWithQuantity.where((e) => e.productId == partProduct.id).first.quantity;
      listOfPartProductsPresta.add(partProductPresta.copyWith(quantity: quantity.toString()));
    }
    if (marketplace.isPresta8) {
      final builder = patchProductBuilder(
        id: marketplaceProductPrestaId,
        product: product,
        productMarketplace: productMarketplace,
        productPresta: productPresta,
        listOfPartProductsPresta: listOfPartProductsPresta,
      );
      if (builder == null) return left(errorC2);
      final fosPayload = await _doPatch(
        '${_conf.webserviceUrl}products/$marketplaceProductPrestaId',
        builder,
      );
      fosPayload.fold(
        (failure) => left(failure.copyWith(customMessage: errorC4)),
        (unit) => right(unit),
      );
    } else {
      final optionalProductAsXml = await getProductAsXml(marketplaceProductPrestaId);
      logger.i(optionalProductAsXml.isNotPresent);
      if (optionalProductAsXml.isNotPresent) return left(errorC3);
      final productAsXml = optionalProductAsXml.value;
      final updatedProductAsXml = productUpdater(
        document: productAsXml,
        product: product,
        productMarketplace: productMarketplace,
        productPresta: productPresta,
        listOfPartProductsPresta: listOfPartProductsPresta,
      );
      final fosPayload = await _doPut(
        '${_conf.webserviceUrl}products/$marketplaceProductPrestaId',
        updatedProductAsXml,
      );
      fosPayload.fold(
        (failure) => left(failure.copyWith(customMessage: errorC4)),
        (unit) => right(unit),
      );
    }
    return right(unit);
  }

  Future<Either<PrestaFailure, Unit>> patchProductCategories(
    final int marketplaceProductPrestaId,
    Product product,
    ProductMarketplace productMarketplace,
    MarketplacePresta marketplace,
  ) async {
    final errorC1 = PrestaGeneralFailure(
      errorMessage:
          'Artikel: "${product.name}" konnte im Marktplatz: "${marketplace.name}" nicht gefunden werden.\nTechnischer Fehler im: getProduct',
    );
    final errorC2 = PrestaGeneralFailure(
      errorMessage:
          'Beim bearbeiten des Artikels: "${product.name}" im Marktplatz: "${marketplace.name}" ist ein Fehler aufgetreten.\nTechnischer Fehler im: patchProductBuilder',
    );
    final errorC3 = PrestaGeneralFailure(
      errorMessage:
          'Artikel: "${product.name}" konnte im Marktplatz: "${marketplace.name}" nicht gefunden werden.\nTechnischer Fehler im: getProductAsXml',
    );

    final errorC4 = 'Beim Aktualisieren des Artikels: "${product.name}" im Marktplatz: "${marketplace.name}" ist ein Fehler aufgetreten.';

    if (marketplace.isPresta8) {
      print('###### Presta8 #####');
      final builder = patchProductCategoriesBuilder(id: marketplaceProductPrestaId, product: product, productMarketplace: productMarketplace);

      if (builder == null) return Left(errorC2);
      final fosPayload = await _doPatch('${_conf.webserviceUrl}products/$marketplaceProductPrestaId', builder);
      fosPayload.fold(
        (failure) => left(failure.copyWith(customMessage: errorC4)),
        (unit) => right(unit),
      );
    } else {
      final optionalProductPresta = await getProduct(marketplaceProductPrestaId, marketplace);
      if (optionalProductPresta.isNotPresent) return left(errorC1);

      final productPresta = optionalProductPresta.value;

      final optionalProductAsXml = await getProductAsXml(marketplaceProductPrestaId);
      if (optionalProductAsXml.isNotPresent) return left(errorC3);
      final productAsXml = optionalProductAsXml.value;
      final updatedProductAsXml = productUpdater(
        document: productAsXml,
        product: product,
        productMarketplace: productMarketplace,
        productPresta: productPresta,
      );
      final fosPayload = await _doPut(
        '${_conf.webserviceUrl}products/$marketplaceProductPrestaId',
        updatedProductAsXml,
      );
      fosPayload.fold(
        (failure) => left(failure.copyWith(customMessage: errorC4)),
        (unit) => right(unit),
      );
    }
    return right(unit);
  }

  //? ################################## PATCH ENDE #####################################################################################
  //? ###################################################################################################################################
  //? ###################################################################################################################################
  //? ################################## POST START #####################################################################################

  //* Product
  Future<int> postProduct(
    Product product,
    ProductMarketplace productMarketplace,
    ProductMarketplace anotherProductMarketplaceWithSameManufacturer,
    MarketplacePresta marketplace,
  ) async {
    final optionalProductPresta = await getProductByReference(product.articleNumber, marketplace);
    if (optionalProductPresta.isPresent) {
      logger.e('Ein Artikel mit der Artikelnummer: "${product.articleNumber}" ist bereits im Marktplatz: "${marketplace.name}" vorhanden');
      return 0;
    }
    final aMpp = anotherProductMarketplaceWithSameManufacturer.marketplaceProduct as ProductPresta;
    final optionalAnotherProductPresta = await getProduct(aMpp.id, marketplace);
    if (optionalAnotherProductPresta.isNotPresent) return 0;
    final productPrestaWithSameManufacturer = optionalAnotherProductPresta.value;

    int payload = 0;
    final builder = postProductBuilder(
      product: product,
      productMarketplace: productMarketplace,
      productPrestaWithSameManufacturer: productPrestaWithSameManufacturer,
    );
    if (builder == null) return 0;
    final payloadDoPost = await _doPost(
      '${_conf.webserviceUrl}products/',
      builder,
    );
    payload = payloadDoPost;

    return payload;
  }

  //? ################################## POST ENDE #####################################################################################
  //? ###################################################################################################################################

  //* Utility methods */
  Future<dynamic> _doGetJson(String uri, {bool single = false}) async {
    loggy.debug('Fetching $uri');

    final headers = {'Cache-Control': 'no-cache'};

    final response = await _http.get(Uri.parse(uri), headers: headers);
    loggy.debug('Received response with code ${response.statusCode}');

    if (single && response.statusCode == 404) {
      return null;
    }
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    }
    loggy.error(response);
    logger.e(uri);
    logger.e(response.statusCode);
    logger.e(response.body);
    throw PrestashopApiException(response);
  }

  Future<dynamic> _doGetXml(String uri, {bool single = false}) async {
    loggy.debug('Fetching $uri');
    final response = await _http.get(Uri.parse(uri));
    loggy.debug('Received response with code ${response.statusCode}');

    if (single && response.statusCode != 200) {
      return null;
    }
    if (response.statusCode == 200) {
      return XmlDocument.parse(response.body);
    }
    loggy.error(response);
    throw PrestashopApiException(response);
  }

  Future<Either<PrestaUpdateFailure, Unit>> _doPatch(String uri, XmlBuilder builder) async {
    loggy.debug('Fetching $uri');
    final document = builder.buildDocument();
    final response = await _http.patch(
      Uri.parse(uri),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('${_conf.apiKey}:'))}',
        'Content-Type': 'application/xml',
      },
      body: document.toXmlString(),
    );

    if (response.statusCode == 200) {
      logger.i('Artikel _doPatch erfolgreich durchgeführt');
      return right(unit);
    }
    loggy.error(response);
    logger.e('Artikel _doPatch Fehler: ${response.body}');
    return left(PrestaUpdateFailure(response: response));
    // throw PrestashopApiException(response);
  }

  Future<Either<PrestaUpdateFailure, Unit>> _doPut(String uri, XmlDocument document) async {
    final response = await _http.put(
      Uri.parse(uri),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('${_conf.apiKey}:'))}',
        'Content-Type': 'application/xml',
      },
      body: document.toXmlString(),
    );

    if (response.statusCode == 200) {
      logger.i('Artikel _doPut erfolgreich durchgeführt');
      return right(unit);
    }
    loggy.error(response);
    logger.e(uri);
    logger.e('StatusCode: ${response.statusCode}');
    logger.e('Artikel _doPut Fehler: ${response.body}');
    return left(PrestaUpdateFailure(response: response));
    // throw PrestashopApiException(response);
  }

  //* Zum erstellen von Daten in Prestashop (z.B. das Erstellen eines Artikels)
  Future<int> _doPost(String uri, XmlBuilder builder) async {
    loggy.debug('Fetching $uri');
    final document = builder.buildDocument();
    final response = await _http.post(
      Uri.parse(uri),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('${_conf.apiKey}:'))}',
        'Content-Type': 'application/xml',
      },
      body: document.toXmlString(),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      logger.i('_doPost erfolgreich durchgeführt\nresponse.body: ${response.body}');
      final document = XmlDocument.parse(response.body);
      final idElement = document.findAllElements('id').firstOrNull;
      if (idElement == null) return 0;

      return idElement.innerText.toMyInt();
    }
    loggy.error(response);
    logger.e('_doPost Fehler: ${response.statusCode}');
    logger.e('_doPost Fehler: ${response.body}');
    // throw PrestashopApiException(response);
    return 0;
  }

  Future<Optional<ProductRawPresta>> getProductImpl(ProductRawPresta phProductPresta, MarketplacePresta marketplace) async {
    StockAvailablePresta? stockAvailablesPresta;
    List<LanguagePresta> listOfLanguagesPresta = [];

    // TODO: Wenn Variantenartikel importiert werden können ENTFERNEN
    final isVariantProduct = phProductPresta.associations.associationsStockAvailables!.length > 1;
    if (isVariantProduct) return throw PrestashopApiException;

    final idStockAvailable = phProductPresta.associations.associationsStockAvailables!.first.id;
    final optionalStockAvailablesPresta = await getStockAvailable(idStockAvailable.toMyInt());
    if (optionalStockAvailablesPresta.isNotPresent) return throw PrestashopApiException;
    stockAvailablesPresta = optionalStockAvailablesPresta.value;

    List<LanguagePresta>? marketplaceLanguages;
    if (phProductPresta.nameMultilanguage != null && phProductPresta.nameMultilanguage!.isNotEmpty) {
      listOfLanguagesPresta = await getLanguages();
      if (listOfLanguagesPresta.isEmpty) return throw PrestashopApiException;
      marketplaceLanguages = listOfLanguagesPresta;
      final germanLanguage = listOfLanguagesPresta.where((e) => e.isoCode.toUpperCase() == 'DE').firstOrNull;
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

    if (marketplaceLanguages == null && phProductPresta.nameMultilanguage != null && phProductPresta.nameMultilanguage!.isNotEmpty) {
      final phMarketplaceLanguages = await getLanguages();
      if (phMarketplaceLanguages.isNotEmpty) {
        marketplaceLanguages = phMarketplaceLanguages;
      }
    }

    List<ProductPrestaImage> listOfImages = [];
    if (phProductPresta.associations.associationsImages != null && phProductPresta.associations.associationsImages!.isNotEmpty) {
      for (final id in phProductPresta.associations.associationsImages!) {
        final uri = '${marketplace.fullUrl}images/products/${phProductPresta.id}/${id.id}';
        final responseImage = await _http.get(
          Uri.parse(uri),
          headers: {'Authorization': 'Basic ${base64Encode(utf8.encode('${marketplace.key}:'))}'},
        );

        if (responseImage.statusCode == 200) {
          final Directory directory = await getTemporaryDirectory();
          final File file = File('${directory.path}/product_${phProductPresta.id}_${id.id}.jpg');
          final imageFile = await file.writeAsBytes(responseImage.bodyBytes);
          listOfImages.add(ProductPrestaImage(productId: id.id.toMyInt(), imageFile: imageFile));
        }
      }
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
        : stockAvailablesPresta.quantity;

    final productPresta = phProductPresta.copyWith(
      quantity: quantity.toString(),
      imageFiles: listOfImages.isNotEmpty ? listOfImages : phProductPresta.imageFiles,
      marketplaceLanguages: marketplaceLanguages,
    );

    return Optional.of(productPresta);
  }
}

class PrestashopApiException implements Exception {
  final Response response;

  PrestashopApiException(this.response);

  @override
  String toString() {
    return '${response.statusCode}: ${response.reasonPhrase}';
  }
}
