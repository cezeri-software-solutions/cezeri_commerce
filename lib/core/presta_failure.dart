import 'abstract_failure.dart';

abstract class PrestaFailure extends AbstractFailure {}

class PrestaGeneralFailure extends PrestaFailure {
  final String? errorMessage;

  PrestaGeneralFailure({this.errorMessage});
}

class ProductHasNoMarketplaceFailure extends PrestaFailure {}
