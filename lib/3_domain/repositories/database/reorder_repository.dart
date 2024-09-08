import 'package:dartz/dartz.dart';

import '../../../failures/abstract_failure.dart';
import '../../entities/product/booking_product.dart';
import '../../entities/reorder/reorder.dart';
import '../../enums/enums.dart';

abstract class ReorderRepository {
  Future<Either<AbstractFailure, Reorder>> createReorder(Reorder reorder);
  Future<Either<AbstractFailure, Reorder>> getReorder(String id);
  Future<Either<AbstractFailure, List<Reorder>>> getListOfReorders(GetReordersType getReorderType);
  Future<Either<AbstractFailure, Reorder>> updateReorder(Reorder reorder);
  Future<Either<AbstractFailure, Unit>> deleteReorder(String id);
  Future<Either<AbstractFailure, Unit>> deleteReorders(List<String> ids);

  Future<Either<AbstractFailure, Unit>> updateReordersFromProductsBooking(List<BookingProduct> listOfBookingProducts);
}
