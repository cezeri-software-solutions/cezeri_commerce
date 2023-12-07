import 'package:cezeri_commerce/core/firebase_failures.dart';
import 'package:dartz/dartz.dart';

import '../../entities/reorder/supplier.dart';

abstract class SupplierRepository {
  Future<Either<FirebaseFailure, Supplier>> createSupplier(Supplier supplier);
  Future<Either<FirebaseFailure, Supplier>> getSupplier(String id);
  Future<Either<FirebaseFailure, List<Supplier>>> getListOfSuppliers();
  Future<Either<FirebaseFailure, Supplier>> updateSupplier(Supplier supplier);
  Future<Either<FirebaseFailure, Unit>> deleteSupplier(String id);
}
