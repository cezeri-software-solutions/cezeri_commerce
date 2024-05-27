import 'package:dartz/dartz.dart';

import '../../../failures/abstract_failure.dart';
import '../../entities/customer/customer.dart';

abstract class CustomerRepository {
  Future<Either<AbstractFailure, Customer>> createCustomer(Customer customer);
  Future<Either<AbstractFailure, Customer>> getCustomer(String id);
  Future<Either<AbstractFailure, List<Customer>>> getListOfAllCustomers();
  Future<Either<AbstractFailure, Customer>> updateCustomer(Customer customer);
  Future<Either<AbstractFailure, Unit>> deleteCustomer(String id);
  //
  Future<Either<AbstractFailure, Customer>> getCustomerByCustomerIdInMarketplace(String marketplaceId, int customerIdMarketplace);
}
