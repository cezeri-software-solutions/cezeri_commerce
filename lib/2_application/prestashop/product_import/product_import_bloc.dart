import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';

import '../../../3_domain/entities/marketplace/abstract_marketplace.dart';
import '../../../3_domain/entities/marketplace/marketplace_presta.dart';
import '../../../3_domain/entities_presta/product_presta.dart';
import '../../../3_domain/repositories/firebase/main_settings_respository.dart';
import '../../../3_domain/repositories/marketplace/marketplace_import_repository.dart';
import '../../../core/abstract_failure.dart';
import '../../../core/presta_failure.dart';

part 'product_import_event.dart';
part 'product_import_state.dart';

class ProductImportBloc extends Bloc<ProductImportEvent, ProductImportState> {
  final MarketplaceImportRepository productImportRepository;
  final MainSettingsRepository mainSettingsRepository;

  ProductImportBloc({required this.productImportRepository, required this.mainSettingsRepository}) : super(ProductImportState.initial()) {
//? #########################################################################

    on<SetProducImportStateToInitialEvent>((event, emit) {
      emit(ProductImportState.initial());
    });

//? #########################################################################

    on<SetSelectedMarketplaceProductImportEvent>((event, emit) {
      emit(state.copyWith(selectedMarketplace: event.marketplace));
    });

//? #########################################################################

    on<GetAllProductsFromPrestaEvent>((event, emit) async {
      final logger = Logger();
      bool isSuccess = true;
      emit(state.copyWith(isLoadingProductsPrestaOnObserve: true, loadedProducts: 0, numberOfToLoadProducts: 0, loadingText: ''));

      List<int>? toLoadProductsFromMarketplace;
      final fosToLoadProductsPresta = await productImportRepository.getToLoadProductsFromMarketplace(state.selectedMarketplace! as MarketplacePresta, event.onlyActive); //TODO: Shopify
      fosToLoadProductsPresta.fold(
        (failure) {
          isSuccess = false;
          emit(state.copyWith(isLoadingProductsPrestaOnObserve: false));
          return;
        },
        (numberOfProductsToLoad) {
          toLoadProductsFromMarketplace = numberOfProductsToLoad;
          emit(state.copyWith(numberOfToLoadProducts: numberOfProductsToLoad.length));
        },
      );

      emit(state.copyWith(loadedProducts: 0, loadingText: 'Lädt Produkte vom Marktplatz...'));

      List<ProductPresta> loadedProductsPresta = [];
      for (final productId in toLoadProductsFromMarketplace!) {
        final fosLoadedProductPrestaFromMarketplace = await productImportRepository.loadProductFromMarketplace(productId, state.selectedMarketplace! as MarketplacePresta);
        fosLoadedProductPrestaFromMarketplace.fold(
          (failure) {
            logger.e(failure);
            isSuccess = false;
          },
          (productPresta) {
            loadedProductsPresta.add(productPresta);
            emit(state.copyWith(loadedProducts: state.loadedProducts + 1));
          },
        );
        // // TODO: LÖSCHEN
        // if (loadedProductsPresta.length == 10) break;
      }

      emit(state.copyWith(
        isLoadingProductsPrestaOnObserve: false,
        listOfProductsPresta: loadedProductsPresta,
        fosProductsPrestaOnObserveOption: isSuccess ? const Some(Right(unit)) : const None(),
      ));
      emit(state.copyWith(fosProductsPrestaOnObserveOption: none()));
    });

//? #########################################################################

    on<OnUploadProductToFirestoreEvent>((event, emit) async {
      emit(state.copyWith(isLoadingProductOnCreate: true));

      bool isSuccess = true;

      final failureOrSuccess = await productImportRepository.uploadLoadedProductToFirestore(state.productPresta!, state.selectedMarketplace!.id);
      failureOrSuccess.fold(
        (failure) => isSuccess = false,
        (product) => null,
      );

      emit(state.copyWith(
        isLoadingProductOnCreate: false,
        fosProductOnCreateOption: isSuccess ? const Some(Right(unit)) : const None(),
      ));
      emit(state.copyWith(fosProductOnCreateOption: none()));
    });

//? #########################################################################

    on<OnUploadAllProductsToFirestoreEvent>((event, emit) async {
      emit(state.copyWith(
        isLoadingProductsOnCreate: true,
        loadedProducts: 0,
        numberOfToLoadProducts: state.listOfProductsPresta!.length,
        loadingText: 'Lädt Artikel zu Cezeri Commerce hoch...',
      ));

      bool isSuccess = true;

      for (final productPresta in state.listOfProductsPresta!) {
        final failureOrSuccess = await productImportRepository.uploadLoadedProductToFirestore(productPresta, state.selectedMarketplace!.id);
        failureOrSuccess.fold(
          (failure) => isSuccess = false,
          (product) => emit(state.copyWith(loadedProducts: state.loadedProducts + 1)),
        );
      }

      emit(state.copyWith(
        isLoadingProductsOnCreate: false,
        fosProductsOnCreateOption: isSuccess ? const Some(Right(unit)) : const None(),
      ));
      emit(state.copyWith(fosProductsOnCreateOption: none()));
    });

//? #########################################################################

    on<GetProductByIdAsJsonFromPrestaEvent>((event, emit) async {
      emit(state.copyWith(isLoadingProductPrestaOnObserve: true));

      final failureOrSuccess = await productImportRepository.getProductByIdFromPrestashopAsJson(event.id, event.marketplace);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(prestaFailure: failure, isAnyFailure: true)),
        (productPresta) => emit(state.copyWith(productPresta: productPresta, prestaFailure: null, isAnyFailure: false)),
      );

      emit(state.copyWith(
        isLoadingProductPrestaOnObserve: false,
        fosProductPrestaOnObserveOption: optionOf(failureOrSuccess),
      ));
    });

//? #########################################################################
//? #########################################################################
//? #########################################################################
//? #########################################################################
//? #########################################################################
  }
}
