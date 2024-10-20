import 'package:cezeri_commerce/2_application/database/pos/pos_bloc.dart';
import 'package:cezeri_commerce/2_application/database/receipt/receipt_bloc.dart';
import 'package:cezeri_commerce/3_domain/repositories/database/receipt_repository.dart';
import 'package:cezeri_commerce/4_infrastructur/repositories/database/receipt_repository_impl.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '2_application/database/auth/auth_bloc/auth_bloc.dart';
import '2_application/database/auth/sign_in_form/sign_in_form_bloc.dart';
import '2_application/database/auth/user_data_form/user_data_form_bloc.dart';
import '2_application/database/client/client_bloc.dart';
import '2_application/database/customer/customer_bloc.dart';
import '2_application/database/customer_detail/customer_detail_bloc.dart';
import '2_application/database/dashboard/dashboard_bloc.dart';
import '2_application/database/general_ledger_account/general_ledger_account_bloc.dart';
import '2_application/database/home/home_product/home_product_bloc.dart';
import '2_application/database/incoming_invoice/incoming_invoice_bloc.dart';
import '2_application/database/incoming_invoice_detail/incoming_invoice_detail_bloc.dart';
import '2_application/database/main_settings/main_settings_bloc.dart';
import '2_application/database/marketplace/marketplace_bloc.dart';
import '2_application/database/marketplace_product/marketplace_product_bloc.dart';
import '2_application/database/product/product_bloc.dart';
import '2_application/database/product_detail/product_detail_bloc.dart';
import '2_application/database/products_booking/products_booking_bloc.dart';
import '2_application/database/receipt_detail/receipt_detail_bloc.dart';
import '2_application/database/receipt_detail_products/receipt_detail_products_bloc.dart';
import '2_application/database/reorder/reorder_bloc.dart';
import '2_application/database/reorder_detail/reorder_detail_bloc.dart';
import '2_application/database/supplier/supplier_bloc.dart';
import '2_application/marketplace/product_export/bloc/product_export_bloc.dart';
import '2_application/marketplace/product_import/product_import_bloc.dart';
import '2_application/packing_station/packing_station_bloc.dart';
import '3_domain/repositories/database/auth_repository.dart';
import '3_domain/repositories/database/client_repository.dart';
import '3_domain/repositories/database/customer_repository.dart';
import '3_domain/repositories/database/general_ledger_account_repository.dart';
import '3_domain/repositories/database/incoming_invoice_repository.dart';
import '3_domain/repositories/database/main_settings_respository.dart';
import '3_domain/repositories/database/marketplace_repository.dart';
import '3_domain/repositories/database/packing_station_repository.dart';
import '3_domain/repositories/database/product_repository.dart';
import '3_domain/repositories/database/reorder_repository.dart';
import '3_domain/repositories/database/stat_dashboard_repository.dart';
import '3_domain/repositories/database/stat_product_repository.dart';
import '3_domain/repositories/database/supplier_repository.dart';
import '3_domain/repositories/marketplace/marketplace_edit_repository.dart';
import '3_domain/repositories/marketplace/marketplace_import_repository.dart';
import '4_infrastructur/repositories/database/auth_repository_impl.dart';
import '4_infrastructur/repositories/database/client_repository_impl.dart';
import '4_infrastructur/repositories/database/customer_repository_impl.dart';
import '4_infrastructur/repositories/database/general_ledger_account_repository_impl.dart';
import '4_infrastructur/repositories/database/incoming_invoice_repository_impl.dart';
import '4_infrastructur/repositories/database/main_settings_respository_impl.dart';
import '4_infrastructur/repositories/database/marketplace_repository_impl.dart';
import '4_infrastructur/repositories/database/packing_station_repository_impl.dart';
import '4_infrastructur/repositories/database/product_repository_impl.dart';
import '4_infrastructur/repositories/database/reorder_repository_impl.dart';
import '4_infrastructur/repositories/database/stat_dashboard_repository_impl.dart';
import '4_infrastructur/repositories/database/stat_product_repository_impl.dart';
import '4_infrastructur/repositories/database/supplier_repository_impl.dart';
import '4_infrastructur/repositories/marketplace/marketplace_edit_repository_impl.dart';
import '4_infrastructur/repositories/marketplace/marketplace_import_repository_impl.dart';

final sl = GetIt.I;

Future<void> init() async {
  //! state management
  sl.registerFactory(() => ProductImportBloc(productImportRepository: sl(), mainSettingsRepository: sl()));
  sl.registerFactory(() => ProductExportBloc(
        productRepository: sl(),
        marketplaceRepository: sl(),
        marketplaceEditRepository: sl(),
        marketplaceImportRepository: sl(),
      ));
  sl.registerFactory(() => ProductBloc(
        productRepository: sl(),
        marketplaceEditRepository: sl(),
        mainSettingsRepository: sl(),
        supplierRepository: sl(),
      ));
  sl.registerFactory(() => ProductDetailBloc(
        productRepository: sl(),
        marketplaceEditRepository: sl(),
        mainSettingsRepository: sl(),
        supplierRepository: sl(),
        marketplaceRepository: sl(),
        statProductRepository: sl(),
        marketplaceImportRepository: sl(),
      ));
  sl.registerFactory(() => MarketplaceProductBloc(marketplaceRepository: sl(), marketplaceImportRepository: sl()));
  sl.registerFactory(() => AuthBloc(authRepository: sl(), clientRepository: sl()));
  sl.registerFactory(() => SignInFormBloc(authRepository: sl()));
  sl.registerFactory(() => UserDataFormBloc(clientRepository: sl()));
  sl.registerFactory(() => ClientBloc(clientRepository: sl()));
  sl.registerFactory(() => HomeProductBloc(productRepository: sl(), reorderRepository: sl()));
  sl.registerFactory(() => MarketplaceBloc(marketplaceRepository: sl()));
  sl.registerFactory(() => PosBloc(
        receiptRepository: sl(),
        marketplaceRepository: sl(),
        mainSettingsRepository: sl(),
        customerRepository: sl(),
        productRepository: sl(),
      ));
  sl.registerFactory(() => MainSettingsBloc(mainSettingsRepository: sl()));
  sl.registerFactory(() => ReceiptBloc(receiptRepository: sl(), productRepository: sl(), marketplaceRepository: sl()));
  sl.registerFactory(
    () => ReceiptDetailBloc(
      receiptRepository: sl(),
      marketplaceRepository: sl(),
      mainSettingsRepository: sl(),
      productRepository: sl(),
    ),
  );
  sl.registerFactory(() => ReceiptDetailProductsBloc());
  sl.registerFactory(() => PackingStationBloc(receiptRepository: sl(), customerRepository: sl(), packingStationRepository: sl()));
  sl.registerFactory(() => CustomerBloc(customerRepository: sl()));
  sl.registerFactory(() => CustomerDetailBloc(customerRepository: sl(), mainSettingsRepository: sl(), receiptRepository: sl()));
  sl.registerFactory(() => SupplierBloc(supplierRepository: sl()));
  sl.registerFactory(() => ReorderBloc(reorderRepository: sl(), supplierRepository: sl()));
  sl.registerFactory(() => ReorderDetailBloc(
      reorderRepository: sl(),
      productRepository: sl(),
      mainSettingsRepository: sl(),
      marketplaceRepository: sl(),
      statProductRepository: sl(),
      supplierRepository: sl()));
  sl.registerFactory(() => DashboardBloc(dashboardRepository: sl(), receiptRepository: sl()));
  sl.registerFactory(() => ProductsBookingBloc(productRepository: sl(), reorderRepository: sl()));

  sl.registerFactory(() => GeneralLedgerAccountBloc(gLAccountRepository: sl()));
  sl.registerFactory(() => IncomingInvoiceBloc(incomingInvoiceRepository: sl()));
  sl.registerFactory(() => IncomingInvoiceDetailBloc(incomingInvoiceRepository: sl(), supplierRepository: sl()));

  //! repositories Database
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  sl.registerLazySingleton<ClientRepository>(() => ClientRepositoryImpl(supabase: sl()));
  sl.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(marketplaceEditRepository: sl(), marketplaceRepository: sl()));
  sl.registerLazySingleton<MarketplaceRepository>(() => MarketplaceRepositoryImpl(supabase: sl()));
  sl.registerLazySingleton<MainSettingsRepository>(() => MainSettingsRepositoryImpl(supabase: sl()));
  sl.registerLazySingleton<ReceiptRepository>(
    () => ReceiptRespositoryImpl(
      productRepository: sl(),
      productImportRepository: sl(),
      customerRepository: sl(),
      mainSettingsRepository: sl(),
      marketplaceRepository: sl(),
      marketplaceEditRepository: sl(),
    ),
  );
  sl.registerLazySingleton<CustomerRepository>(() => CustomerRepositoryImpl(supabase: sl(), settingsRepository: sl()));
  sl.registerLazySingleton<SupplierRepository>(() => SupplierRepositoryImpl(supabase: sl(), settingsRepository: sl()));
  sl.registerLazySingleton<ReorderRepository>(() => ReorderRepositoryImpl(
        marketplaceEditRepository: sl(),
        productRepository: sl(),
        settingsRepository: sl(),
      ));
  sl.registerLazySingleton<PackingStationRepository>(() => PackingStationRepositoryImpl(productRepository: sl()));
  sl.registerLazySingleton<StatDashboardRepository>(() => StatDashboardRepositoryImpl(supabase: sl()));
  sl.registerLazySingleton<StatProductRepository>(() => StatProductRepositoryImpl(supabase: sl()));
  sl.registerLazySingleton<GeneralLedgerAccountRepository>(() => GeneralLedgerAccountRepositoryImpl(supabase: sl()));
  sl.registerLazySingleton<IncomingInvoiceRepository>(() => IncomingInvoiceRepositoryImpl(supabase: sl(), settingsRepository: sl()));

  //! repositories Marketplaces
  sl.registerLazySingleton<MarketplaceImportRepository>(() => MarketplaceImportRepositoryImpl(
        productRepository: sl(),
        mainSettingsRepository: sl(),
        marketplaceRepository: sl(),
      ));
  sl.registerLazySingleton<MarketplaceEditRepository>(() => const MarketplaceEditRepositoryImpl());

  //! extern
  // final firebaseAuth = FirebaseAuth.instance;
  // sl.registerLazySingleton(() => firebaseAuth);
  // final firestore = FirebaseFirestore.instance;
  // sl.registerLazySingleton(() => firestore);

  final supabase = Supabase.instance.client;
  sl.registerLazySingleton(() => supabase);
}
