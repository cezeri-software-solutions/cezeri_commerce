import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cezeri_commerce/1_presentation/core/extensions/string_to_int.dart';
import 'package:cezeri_commerce/3_domain/entities/marketplace/marketplace.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:logger/logger.dart';
import 'package:loggy/loggy.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quiver/core.dart';
import 'package:xml/xml.dart';

import '../../../3_domain/entities/product/product.dart';
import '../../../3_domain/entities/product/product_image.dart';
import '../../../3_domain/entities/product/product_marketplace.dart';
import '../../../3_domain/entities_presta/address_presta.dart';
import '../../../3_domain/entities_presta/carrier_presta.dart';
import '../../../3_domain/entities_presta/country_presta.dart';
import '../../../3_domain/entities_presta/currency_presta.dart';
import '../../../3_domain/entities_presta/customer_presta.dart';
import '../../../3_domain/entities_presta/language_presta.dart';
import '../../../3_domain/entities_presta/order_id_presta.dart';
import '../../../3_domain/entities_presta/order_presta.dart';
import '../../../3_domain/entities_presta/product_id_presta.dart';
import '../../../3_domain/entities_presta/product_presta.dart';
import '../../../3_domain/entities_presta/product_presta_image.dart';
import '../../../3_domain/entities_presta/stock_available_presta.dart';
import 'patch_builders.dart';
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

  Future<Optional<ProductPresta>> getProduct(final int id, final Marketplace marketplace) async {
    final payload = await _doGetJson(
      '${_conf.webserviceUrl}products?ws_key=${_conf.apiKey}&filter[id]=[$id]&output_format=JSON&display=full',
      single: true,
    );
    final optionalProductPresta = payload == null ? const Optional.absent() : Optional.of(ProductsPresta.fromJson(payload).items.single);
    if (optionalProductPresta.isNotPresent) return throw PrestashopApiException;
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
//? ################################## PATCH START ###################################################################################
  //* Order
  Future<bool> patchOrderStatus(final int orderId, final int statusId, final bool isPresta8) async {
    bool payload = false;
    if (isPresta8) {
      final builder = orderStatusBuilder(orderId, statusId);
      final payloadDoPatch = await _doPatch(
        '${_conf.webserviceUrl}orders/$orderId',
        builder,
      );
      payload = payloadDoPatch;
    }
    return payload;
  }

  //* Product
  Future<bool> patchProductQuantity(final int marketplaceProductPrestaId, final int quantity, final Marketplace marketplace) async {
    final optionalProductPresta = await getProduct(marketplaceProductPrestaId, marketplace);
    if (optionalProductPresta.isNotPresent) return false;
    final productPresta = optionalProductPresta.value;
    final stockAvailableId = productPresta.associations.associationsStockAvailables!.first.id;
    bool payload = false;
    if (marketplace.isPresta8) {
      final builder = stockAvailableBuilder(stockAvailableId, quantity);
      final payloadDoPatch = await _doPatch(
        '${_conf.webserviceUrl}stock_availables/$stockAvailableId',
        builder,
      );
      payload = payloadDoPatch;
    } else {
      final optionaStockAvailableAsXml = await getStockAvailableAsXml(stockAvailableId.toMyInt());
      if (optionaStockAvailableAsXml.isNotPresent) return false;
      final stockAvailableAsXml = optionaStockAvailableAsXml.value;
      final updatedDocument = stockAvailableUpdater(stockAvailableAsXml, quantity);
      final payloadDoPut = await _doPut(
        '${_conf.webserviceUrl}stock_availables/$stockAvailableId',
        updatedDocument,
      );
      payload = payloadDoPut;
    }

    return payload;
  }

  Future<bool> uploadProductImageFromUrl(String productID, ProductImage productImage) async {
    final logger = Logger();
    String url = '${_conf.webserviceUrl}images/products/$productID/';
    String base64Auth = base64Encode(utf8.encode('${_conf.apiKey}:'));

    Response imageResponse = await get(Uri.parse(productImage.fileUrl));

    Uint8List imageData = imageResponse.bodyBytes;

    String getFileExtensionFromFilename(String filename) {
      int lastDot = filename.lastIndexOf('.');
      if (lastDot != -1 && lastDot != filename.length - 1) {
        return filename.substring(lastDot + 1);
      }
      return 'unknown';
    }

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

  Future<bool> deleteProductImage(String productID, String imageID) async {
    final logger = Logger();
    String url = '${_conf.webserviceUrl}images/products/$productID/$imageID';
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
      return false;
    }
  }

  Future<bool> patchProductImages(final int marketplaceProductPrestaId, final int quantity, final Marketplace marketplace) async {
    // #################################################################################################
    final optionalProductPresta = await getProduct(marketplaceProductPrestaId, marketplace);
    if (optionalProductPresta.isNotPresent) return false;
    final productPresta = optionalProductPresta.value;
    final stockAvailableId = productPresta.associations.associationsStockAvailables!.first.id;
    bool payload = false;
    if (marketplace.isPresta8) {
      final builder = stockAvailableBuilder(stockAvailableId, quantity);
      final payloadDoPatch = await _doPatch(
        '${_conf.webserviceUrl}stock_availables/$stockAvailableId',
        builder,
      );
      payload = payloadDoPatch;
    } else {
      final optionaStockAvailableAsXml = await getStockAvailableAsXml(stockAvailableId.toMyInt());
      if (optionaStockAvailableAsXml.isNotPresent) return false;
      final stockAvailableAsXml = optionaStockAvailableAsXml.value;
      final updatedDocument = stockAvailableUpdater(stockAvailableAsXml, quantity);
      final payloadDoPut = await _doPut(
        '${_conf.webserviceUrl}stock_availables/$stockAvailableId',
        updatedDocument,
      );
      payload = payloadDoPut;
    }

    return payload;
  }

  Future<bool> patchProduct(
    final int marketplaceProductPrestaId,
    Product product,
    ProductMarketplace productMarketplace,
    Marketplace marketplace,
  ) async {
    final optionalProductPresta = await getProduct(marketplaceProductPrestaId, marketplace);
    if (optionalProductPresta.isNotPresent) return false;
    final productPresta = optionalProductPresta.value;
    bool payload = false;
    if (marketplace.isPresta8) {
      final builder = productBuilder(
        id: marketplaceProductPrestaId,
        product: product,
        productMarketplace: productMarketplace,
        productPresta: productPresta,
      );
      if (builder == null) return false;
      final payloadDoPatch = await _doPatch(
        '${_conf.webserviceUrl}products/$marketplaceProductPrestaId',
        builder,
      );
      payload = payloadDoPatch;
    } else {
      final optionalProductAsXml = await getProductAsXml(marketplaceProductPrestaId);
      if (optionalProductAsXml.isNotPresent) return false;
      final productAsXml = optionalProductAsXml.value;
      final updatedProductAsXml = productUpdater(
        document: productAsXml,
        product: product,
        productMarketplace: productMarketplace,
        productPresta: productPresta,
      );
      final payloadDoPut = await _doPut(
        '${_conf.webserviceUrl}products/$marketplaceProductPrestaId',
        updatedProductAsXml,
      );
      payload = payloadDoPut;
    }
    //! Update StockAvailables
    final stockAvailableId = productPresta.associations.associationsStockAvailables!.first.id;
    bool payloadQuantity = true;
    // if (marketplace.isPresta8) {
    //   final builderStockAvailables = stockAvailableBuilder(stockAvailableId, product.availableStock);
    //   final payloadDoPatchSA = await _doPatch(
    //     '${_conf.webserviceUrl}stock_availables/$stockAvailableId',
    //     builderStockAvailables,
    //   );
    //   payloadQuantity = payloadDoPatchSA;
    // } else {
    //   final optionaStockAvailableAsXml = await getStockAvailableAsXml(stockAvailableId.toMyInt());
    //   if (optionaStockAvailableAsXml.isNotPresent) return false;
    //   final stockAvailableAsXml = optionaStockAvailableAsXml.value;
    //   final updatedDocument = stockAvailableUpdater(stockAvailableAsXml, product.availableStock);
    //   final payloadDoPutSA = await _doPut(
    //     '${_conf.webserviceUrl}stock_availables/$stockAvailableId',
    //     updatedDocument,
    //   );
    //   payloadQuantity = payloadDoPutSA;
    // }
    return payload && payloadQuantity == true ? true : false;
  }

//? ################################## PATCH ENDE #####################################################################################
//? ###################################################################################################################################

  //* Utility methods */
  Future<dynamic> _doGetJson(String uri, {bool single = false}) async {
    loggy.debug('Fetching $uri');
    final response = await _http.get(Uri.parse(uri));
    loggy.debug('Received response with code ${response.statusCode}');

    if (single && response.statusCode == 404) {
      return null;
    }
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    }
    loggy.error(response);
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

  Future<bool> _doPatch(String uri, XmlBuilder builder) async {
    loggy.debug('Fetching $uri');
    print('Fetching $uri');
    print('apiKey: ${_conf.apiKey}');
    final document = builder.buildDocument();
    final response = await _http.patch(
      Uri.parse(uri),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('${_conf.apiKey}:'))}',
        'Content-Type': 'application/xml',
      },
      body: document.toXmlString(),
    );
    print('--------------------------------');
    print(response);
    print('--------------------------------');
    print(response.body);
    print('--------------------------------');
    print(document);
    print('--------------------------------');

    if (response.statusCode == 200) {
      return true;
    }
    loggy.error(response);
    print('---------- response.body START ----------------------');
    print(response.body);
    print('---------- response.body END ----------------------');
    throw PrestashopApiException(response);
  }

  Future<bool> _doPut(String uri, XmlDocument document) async {
    final response = await _http.put(
      Uri.parse(uri),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('${_conf.apiKey}:'))}',
        'Content-Type': 'application/xml',
      },
      body: document.toXmlString(),
    );

    if (response.statusCode == 200) {
      print('#################################################################################');
      print(response.body);
      print('#################################################################################');
      return true;
    }
    loggy.error(response);
    print('---------- response.body START ----------------------');
    print(response.body);
    print(response.statusCode);
    print('---------- response.body END ----------------------');
    throw PrestashopApiException(response);
  }

  Future<Optional<ProductPresta>> getProductImpl(ProductPresta phProductPresta, Marketplace marketplace) async {
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

    List<ProductPresta> listOfBundleProduct = [];
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
