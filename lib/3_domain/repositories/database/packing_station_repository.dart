import 'package:dartz/dartz.dart';

import '../../../failures/abstract_failure.dart';
import '../../entities/picklist/picklist.dart';
import '../../entities/product/product.dart';
import '../../entities/receipt/receipt.dart';

abstract class PackingStationRepository {
  Future<Either<AbstractFailure, List<Product>>> getListOfProducts(List<String> productIds);
  Future<Either<AbstractFailure, Picklist>> createPicklist(List<Receipt> listOfAppointments);
  Future<Either<AbstractFailure, Unit>> updatePicklist(Picklist picklist);
  Future<Either<AbstractFailure, List<Picklist>>> getListOfPicklists();
}
