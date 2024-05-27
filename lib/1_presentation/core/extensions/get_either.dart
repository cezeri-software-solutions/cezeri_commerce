import 'package:dartz/dartz.dart';

extension GetLeft<T> on Either<T, dynamic> {
  T getLeft() {
    return swap().getOrElse(() => throw Exception('Unknown error!'));
  }
}

extension GetRight<T> on Either<dynamic, T> {
  T getRight() {
    return getOrElse(() => throw Exception('Unknown error!'));
  }
}
