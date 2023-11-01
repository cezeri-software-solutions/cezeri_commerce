import 'package:cezeri_commerce/2_application/firebase/appointment/appointment_bloc.dart';
import 'package:cezeri_commerce/3_domain/repositories/firebase/receipt_respository.dart';
import 'package:cezeri_commerce/4_infrastructur/repositories/firebase/receipt_respository_impl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import '2_application/firebase/auth/auth_bloc/auth_bloc.dart';
import '2_application/firebase/auth/sign_in_form/sign_in_form_bloc.dart';
import '2_application/firebase/auth/user_data_form/user_data_form_bloc.dart';
import '2_application/firebase/client/client_bloc.dart';
import '2_application/firebase/customer/customer_bloc.dart';
import '2_application/firebase/main_settings/main_settings_bloc.dart';
import '2_application/firebase/marketplace/marketplace_bloc.dart';
import '2_application/firebase/product/product_bloc.dart';
import '2_application/firebase/receipt_detail/receipt_detail_bloc.dart';
import '2_application/prestashop/product_import/product_import_bloc.dart';
import '3_domain/repositories/firebase/auth_repository.dart';
import '3_domain/repositories/firebase/client_repository.dart';
import '3_domain/repositories/firebase/customer_repository.dart';
import '3_domain/repositories/firebase/main_settings_respository.dart';
import '3_domain/repositories/firebase/marketplace_repository.dart';
import '3_domain/repositories/firebase/product_repository.dart';
import '3_domain/repositories/prestashop/product/product_edit_repository.dart';
import '3_domain/repositories/prestashop/product/product_import_repository.dart';
import '4_infrastructur/repositories/firebase/auth_repository_impl.dart';
import '4_infrastructur/repositories/firebase/client_repository_impl.dart';
import '4_infrastructur/repositories/firebase/customer_repository_impl.dart';
import '4_infrastructur/repositories/firebase/main_settings_respository_impl.dart';
import '4_infrastructur/repositories/firebase/marketplace_repository_impl.dart';
import '4_infrastructur/repositories/firebase/product_repository_impl.dart';
import '4_infrastructur/repositories/prestashop/product/product_edit_repository_impl.dart';
import '4_infrastructur/repositories/prestashop/product/product_import_repository_impl.dart';

final sl = GetIt.I;

Future<void> init() async {
  //! state management
  sl.registerFactory(() => ProductImportBloc(productImportRepository: sl()));
  sl.registerFactory(() => ProductBloc(productRepository: sl(), productEditRepository: sl()));
  sl.registerFactory(() => AuthBloc(authRepository: sl(), clientRepository: sl()));
  sl.registerFactory(() => SignInFormBloc(authRepository: sl()));
  sl.registerFactory(() => UserDataFormBloc(clientRepository: sl()));
  sl.registerFactory(() => ClientBloc(clientRepository: sl()));
  sl.registerFactory(() => MarketplaceBloc(marketplaceRepository: sl()));
  sl.registerFactory(() => MainSettingsBloc(mainSettingsRepository: sl()));
  sl.registerFactory(() => AppointmentBloc(receiptRepository: sl()));
  sl.registerFactory(() => CustomerBloc(customerRepository: sl()));
  sl.registerFactory(() => ReceiptDetailBloc());

  //! repositories Firebase
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(firebaseAuth: sl()));
  sl.registerLazySingleton<ClientRepository>(() => ClientRepositoryImpl(db: sl(), firebaseAuth: sl()));
  sl.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(db: sl(), firebaseAuth: sl()));
  sl.registerLazySingleton<MarketplaceRepository>(() => MarketplaceRepositoryImpl(db: sl(), firebaseAuth: sl()));
  sl.registerLazySingleton<MainSettingsRepository>(() => MainSettingsRepositoryImpl(db: sl(), firebaseAuth: sl()));
  sl.registerLazySingleton<ReceiptRepository>(
    () => ReceiptRespositoryImpl(
      db: sl(),
      firebaseAuth: sl(),
      productRepository: sl(),
      productImportRepository: sl(),
      customerRepository: sl(),
      mainSettingsRepository: sl(),
    ),
  );
  sl.registerLazySingleton<CustomerRepository>(() => CustomerRepositoryImpl(db: sl(), firebaseAuth: sl()));

  //! repositories Prestashop
  sl.registerLazySingleton<ProductImportRepository>(() => ProductImportRepositoryImpl());
  sl.registerLazySingleton<ProductEditRepository>(() => ProductEditRepositoryImpl(db: sl(), firebaseAuth: sl()));

  //! extern
  final firebaseAuth = FirebaseAuth.instance;
  sl.registerLazySingleton(() => firebaseAuth);
  final firestore = FirebaseFirestore.instance;
  sl.registerLazySingleton(() => firestore);
}
