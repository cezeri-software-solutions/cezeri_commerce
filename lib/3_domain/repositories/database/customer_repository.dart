import 'package:dartz/dartz.dart';

import '../../../failures/abstract_failure.dart';
import '../../entities/customer/customer.dart';

abstract class CustomerRepository {
  Future<Either<AbstractFailure, Customer>> createCustomer(Customer customer);
  Future<Either<AbstractFailure, Customer>> getCustomer(String id);
  Future<Either<AbstractFailure, int>> getTotalNumberOfCustomersBySearchText(String searchText);

  Future<Either<AbstractFailure, List<Customer>>> getListOfCustomersPerPageBySearchText({
    required String searchText,
    required int currentPage,
    required int itemsPerPage,
  });
  Future<Either<AbstractFailure, Customer>> updateCustomer(Customer customer);
  Future<Either<AbstractFailure, Unit>> deleteCustomer(String id);
  //
  Future<Either<AbstractFailure, Customer>> getCustomerByCustomerIdInMarketplace(String marketplaceId, int customerIdMarketplace);
  Future<Either<AbstractFailure, Customer>> getCustomerByEmail(String email);
}
