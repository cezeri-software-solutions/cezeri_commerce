import 'package:cezeri_commerce/1_presentation/core/core.dart';
import 'package:get_it/get_it.dart';

import '../../../../2_application/database/product/product_bloc.dart';
import '../../../../3_domain/entities/product/product.dart';
import '../../../../3_domain/repositories/database/general_ledger_account_repository.dart';
import '../../../../3_domain/repositories/database/main_settings_respository.dart';
import '../../../../3_domain/repositories/database/product_repository.dart';

Future<List<String>> incomingInvoiceDetailLoadAccounts(String filter) async {
  final gLAccountRepo = GetIt.I<GeneralLedgerAccountRepository>();
  final fos = await gLAccountRepo.getListOfGLAccounts();
  if (fos.isLeft()) return [];
  final gLAccounts = fos.getRight();
  final list = gLAccounts.map((e) => e.accountAsString).toList();
  return list;
}

Future<List<String>> incomingInvoiceDetailLoadProducts(String filter) async {
  final productRepo = GetIt.I<ProductRepository>();
  final fos = await productRepo.getListOfFilteredSortedProductsBySearchText(
    searchText: filter,
    currentPage: 1,
    itemsPerPage: 20,
    isSortedAsc: true,
    productsFilterValues: ProductsFilterValues.empty(),
    productsSortValue: ProductsSortValue.name,
  );
  if (fos.isLeft()) return [];
  final products = fos.getRight();
  final list = products.map((e) => e.name).toList();
  return list;
}

Future<List<String>> incomingInvoiceDetailLoadTaxRates() async {
  final settingsRepo = GetIt.I<MainSettingsRepository>();
  final fos = await settingsRepo.getSettings();
  if (fos.isLeft()) return [];
  final settings = fos.getRight();
  final list = settings.taxes.map((e) => (e).taxRate.toString()).toList();
  final sortedList = list..sort((a, b) => a.compareTo(b));
  return sortedList;
}
