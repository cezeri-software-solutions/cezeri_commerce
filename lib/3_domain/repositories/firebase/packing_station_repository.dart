import 'package:dartz/dartz.dart';

import '../../../core/firebase_failures.dart';
import '../../entities/picklist/picklist.dart';
import '../../entities/product/product.dart';
import '../../entities/receipt/receipt.dart';

abstract class PackingStationRepository {
  Future<Either<FirebaseFailure, List<Product>>> getListOfProducts(List<String> productIds);
  Future<Either<FirebaseFailure, Picklist>> createPicklist(List<Receipt> listOfAppointments);
  Future<Either<FirebaseFailure, Unit>> updatePicklist(Picklist picklist);
  Future<Either<FirebaseFailure, List<Picklist>>> getListOfPicklists();
}
