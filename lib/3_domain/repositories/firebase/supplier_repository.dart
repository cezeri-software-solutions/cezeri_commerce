import 'package:dartz/dartz.dart';

import '../../../failures/abstract_failure.dart';
import '../../entities/reorder/supplier.dart';

abstract class SupplierRepository {
  Future<Either<AbstractFailure, Supplier>> createSupplier(Supplier supplier);
  Future<Either<AbstractFailure, Supplier>> getSupplier(String id);
  Future<Either<AbstractFailure, List<Supplier>>> getListOfSuppliers();
  Future<Either<AbstractFailure, Supplier>> updateSupplier(Supplier supplier);
  Future<Either<AbstractFailure, Unit>> deleteSupplier(String id);
}
