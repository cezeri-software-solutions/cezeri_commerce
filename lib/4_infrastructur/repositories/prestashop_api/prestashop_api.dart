import 'dart:convert';

import 'package:http/http.dart';
import 'package:loggy/loggy.dart';
import 'package:quiver/core.dart';

import '../../../3_domain/entities_presta/address_presta.dart';
import '../../../3_domain/entities_presta/country_presta.dart';
import '../../../3_domain/entities_presta/currency_presta.dart';
import '../../../3_domain/entities_presta/customer_presta.dart';
import '../../../3_domain/entities_presta/order_id_presta.dart';
import '../../../3_domain/entities_presta/order_presta.dart';

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

  //* Orders */
  Future<List<OrderIdPresta>> orderIds() async {
    final payload = await _doGet(
      '${_conf.webserviceUrl}orders?ws_key=${_conf.apiKey}&output_format=JSON',
    );

    return OrdersIdPresta.fromJson(payload).items;
  }

  Future<List<OrderPresta>> ordersFilterIdInterval(int idFrom, int idTo) async {
    final payload = await _doGet(
      '${_conf.webserviceUrl}orders?ws_key=${_conf.apiKey}&filter[id]=[$idFrom,$idTo]&output_format=JSON&display=full',
    );
    loggy.debug(payload);

    return OrdersPresta.fromJson(payload).items;
  }

  Future<Optional<OrderPresta>> order(final int id) async {
    final payload = await _doGet(
      '${_conf.webserviceUrl}orders/$id?ws_key=${_conf.apiKey}&output_format=JSON&display=full',
      single: true,
    );
    return payload == null ? const Optional.absent() : Optional.of(OrdersPresta.fromJson(payload).items.single);
  }

  //* Currencies */
  Future<Optional<CurrencyPresta>> currency(final int id) async {
    final payload = await _doGet(
      '${_conf.webserviceUrl}currencies/$id?ws_key=${_conf.apiKey}&output_format=JSON&display=full',
      single: true,
    );
    return payload == null ? const Optional.absent() : Optional.of(CurrenciesPresta.fromJson(payload).items.single);
  }

  //* Countries */
  Future<Optional<CountryPresta>> country(final int id) async {
    final payload = await _doGet(
      '${_conf.webserviceUrl}countries/$id?ws_key=${_conf.apiKey}&output_format=JSON&display=full',
      single: true,
    );
    return payload == null ? const Optional.absent() : Optional.of(CountriesPresta.fromJson(payload).items.single);
  }

  //* Addresses */
  Future<Optional<AddressPresta>> address(final int id) async {
    final payload = await _doGet(
      '${_conf.webserviceUrl}addresses/$id?ws_key=${_conf.apiKey}&output_format=JSON&display=full',
      single: true,
    );
    return payload == null ? const Optional.absent() : Optional.of(AddressesPresta.fromJson(payload).items.single);
  }

  //* Customers */
  Future<Optional<CustomerPresta>> customer(final int id) async {
    final payload = await _doGet(
      '${_conf.webserviceUrl}customers/$id?ws_key=${_conf.apiKey}&output_format=JSON&display=full',
      single: true,
    );
    return payload == null ? const Optional.absent() : Optional.of(CustomersPresta.fromJson(payload).items.single);
  }

  //* Utility methods */
  Future<dynamic> _doGet(String uri, {bool single = false}) async {
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
}

class PrestashopApiException implements Exception {
  final Response response;

  PrestashopApiException(this.response);

  @override
  String toString() {
    return '${response.statusCode}: ${response.reasonPhrase}';
  }
}
