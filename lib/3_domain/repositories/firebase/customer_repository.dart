import 'package:cezeri_commerce/core/firebase_failures.dart';
import 'package:dartz/dartz.dart';

import '../../entities/customer/customer.dart';

abstract class CustomerRepository {
  Future<Either<FirebaseFailure, Customer>> createCustomer(Customer customer);
  Future<Either<FirebaseFailure, Customer>> getCustomer(String id);
  Future<Either<FirebaseFailure, List<Customer>>> getListOfCustomers();
  Future<Either<FirebaseFailure, Customer>> updateCustomer(Customer customer);
  Future<Either<FirebaseFailure, Unit>> deleteCustomer(String id);
  //
  Future<Either<FirebaseFailure, Customer>> getCustomerByCustomerIdInMarketplace(String marketplaceId, int customerIdMarketplace);
}
