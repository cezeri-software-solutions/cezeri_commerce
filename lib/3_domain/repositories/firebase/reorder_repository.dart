import 'package:cezeri_commerce/core/firebase_failures.dart';
import 'package:dartz/dartz.dart';

import '../../entities/product/booking_product.dart';
import '../../entities/reorder/reorder.dart';
import '../../enums/enums.dart';

abstract class ReorderRepository {
  Future<Either<FirebaseFailure, Reorder>> createReorder(Reorder reorder);
  Future<Either<FirebaseFailure, Reorder>> getReorder(String id);
  Future<Either<FirebaseFailure, List<Reorder>>> getListOfReorders(GetReordersType getReorderType);
  Future<Either<FirebaseFailure, Reorder>> updateReorder(Reorder reorder);
  Future<Either<FirebaseFailure, Unit>> deleteReorder(String id);
  Future<Either<FirebaseFailure, Unit>> deleteReorders(List<String> ids);

  Future<Either<FirebaseFailure, Unit>> updateReordersFromProductsBooking(List<BookingProduct> listOfBookingProducts);
}
