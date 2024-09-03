import 'package:http/http.dart';

import 'abstract_failure.dart';

enum ShopifyFailureType { general, update, post }

enum ShopifyPostProductFailureType { product, images, categories, stock }

abstract class ShopifyFailure extends AbstractFailure {
  final ShopifyFailureType shopifyFailureType;
  ShopifyFailure({required this.shopifyFailureType}) : super(abstractFailureType: AbstractFailureType.shopify);
}

class ShopifyGeneralFailure extends ShopifyFailure {
  final String? errorMessage;

  ShopifyGeneralFailure({this.errorMessage}) : super(shopifyFailureType: ShopifyFailureType.general);
}

class ShopifyUpdateFailure extends ShopifyFailure {
  final Response? response;
  final String? customResponseMessage;
  final String? customMessage;

  ShopifyUpdateFailure({this.response, this.customResponseMessage, this.customMessage}) : super(shopifyFailureType: ShopifyFailureType.update);

  ShopifyUpdateFailure copyWith({
    Response? response,
    String? customResponseMessage,
    String? customMessage,
  }) {
    return ShopifyUpdateFailure(
      response: response ?? this.response,
      customResponseMessage: customResponseMessage ?? this.customResponseMessage,
      customMessage: customMessage ?? this.customMessage,
    );
  }
}

class ShopifyPostProductFailure extends ShopifyFailure {
  final ShopifyPostProductFailureType postProductFailureType;
  final Response? response;
  final String? customResponseMessage;
  final String? customMessage;

  ShopifyPostProductFailure({
    required this.postProductFailureType,
    this.response,
    this.customResponseMessage,
    this.customMessage,
  }) : super(shopifyFailureType: ShopifyFailureType.post);
}
