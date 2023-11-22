abstract class AbstractFailure {}

class MixedFailure extends AbstractFailure {
  final String? errorMessage;

  MixedFailure({required this.errorMessage});
}
