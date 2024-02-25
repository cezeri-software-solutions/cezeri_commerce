import 'package:http/http.dart';

import 'abstract_failure.dart';

enum ShopifyFailureType { general, update}

abstract class ShopifyFailure extends AbstractFailure {
  final ShopifyFailureType shopifyFailureType;
  ShopifyFailure({required this.shopifyFailureType}) : super(abstractFailureType: AbstractFailureType.shopify);
}

class ShopifyGeneralFailure extends ShopifyFailure {
  final String? errorMessage;

  ShopifyGeneralFailure({this.errorMessage}) : super(shopifyFailureType: ShopifyFailureType.general);
}

class ShopifyUpdateFailure extends ShopifyFailure {
  final Response response;
  final String? customMessage;

  ShopifyUpdateFailure({required this.response, this.customMessage}) : super(shopifyFailureType: ShopifyFailureType.update);

  ShopifyUpdateFailure copyWith({
    Response? response,
    String? customMessage,
  }) {
    return ShopifyUpdateFailure(
      response: response ?? this.response,
      customMessage: customMessage ?? this.customMessage,
    );
  }
}