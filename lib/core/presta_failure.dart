import 'package:http/http.dart';

import 'abstract_failure.dart';

enum PrestaFailureType { general, update, hasNoMarketplace }

abstract class PrestaFailure extends AbstractFailure {
  final PrestaFailureType prestaFailureType;
  PrestaFailure({required this.prestaFailureType}) : super(abstractFailureType: AbstractFailureType.presta);
}

class PrestaGeneralFailure extends PrestaFailure {
  final String? errorMessage;

  PrestaGeneralFailure({this.errorMessage}) : super(prestaFailureType: PrestaFailureType.general);
}

class PrestaUpdateFailure extends PrestaFailure {
  final Response response;
  final String? customMessage;

  PrestaUpdateFailure({required this.response, this.customMessage}) : super(prestaFailureType: PrestaFailureType.update);

  PrestaUpdateFailure copyWith({
    Response? response,
    String? customMessage,
  }) {
    return PrestaUpdateFailure(
      response: response ?? this.response,
      customMessage: customMessage ?? this.customMessage,
    );
  }
}

class ProductHasNoMarketplaceFailure extends PrestaFailure {
  ProductHasNoMarketplaceFailure() : super(prestaFailureType: PrestaFailureType.hasNoMarketplace);
}
