enum AbstractFailureType { firebase, auth, presta, shopify, mixed }

abstract class AbstractFailure {
  final AbstractFailureType abstractFailureType;

  AbstractFailure({required this.abstractFailureType});
}

class MixedFailure extends AbstractFailure {
  final String? errorMessage;

  MixedFailure({required this.errorMessage}) : super(abstractFailureType: AbstractFailureType.mixed);
}
