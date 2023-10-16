import 'dart:convert';

import 'package:http/http.dart';
import 'package:loggy/loggy.dart';
import 'package:quiver/core.dart';
import 'package:xml/xml.dart';

import '../../../3_domain/entities/product/product.dart';
import '../../../3_domain/entities/product/product_marketplace.dart';
import '../../../3_domain/entities_presta/address_presta.dart';
import '../../../3_domain/entities_presta/country_presta.dart';
import '../../../3_domain/entities_presta/currency_presta.dart';
import '../../../3_domain/entities_presta/customer_presta.dart';
import '../../../3_domain/entities_presta/language_presta.dart';
import '../../../3_domain/entities_presta/order_id_presta.dart';
import '../../../3_domain/entities_presta/order_presta.dart';
import 'patch_builders.dart';

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
  Future<Optional<OrderPresta>> getProduct(final int id) async {
    final payloadProduct = await _doGetXml(
      '${_conf.webserviceUrl}products/$id?ws_key=${_conf.apiKey}&display=full',
      single: true,
    );
    return payloadProduct == null ? const Optional.absent() : Optional.of(OrdersPresta.fromJson(payloadProduct).items.single);
  }

//? ################################## GET ENDE #################################
//? #############################################################################
//? ################################## PATCH START ##############################

  Future<bool> patchProductQuantity(final int id, int quantity) async {
    final builder = productQuantityBuilder(id, quantity);
    final payload = await _doPatch(
      '${_conf.webserviceUrl}stock_availables/$id',
      builder,
    );
    return payload == false ? false : true;
  }

  Future<bool> patchProduct(final int id, Product product, ProductMarketplace productMarketplace) async {
    final languages = await getLanguages();
    final builder = productBuilder(id, product, productMarketplace, languages);
    final payload = await _doPatch(
      '${_conf.webserviceUrl}products/$id',
      builder,
    );
    final payloadQuantity = await patchProductQuantity(productMarketplace.stockAvailables!.first.id!, product.availableStock);
    return payload && payloadQuantity == true ? true : false;
  }

//? ################################## PATCH ENDE ###############################
//? #############################################################################

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
    final document = builder.buildDocument();
    final response = await _http.patch(
      Uri.parse(uri),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('${_conf.apiKey}:'))}',
        'Content-Type': 'application/xml',
      },
      body: document.toXmlString(),
    );

    print(response.body);
    print('--------------------------------');
    print(document);
    print('--------------------------------');

    if (response.statusCode == 200) {
      return true;
    }
    loggy.error(response);
    throw PrestashopApiException(response);
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
