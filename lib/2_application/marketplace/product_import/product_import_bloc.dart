import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '/1_presentation/core/core.dart';
import '../../../3_domain/entities/marketplace/abstract_marketplace.dart';
import '../../../3_domain/entities/marketplace/marketplace_presta.dart';
import '../../../3_domain/entities/marketplace/marketplace_shopify.dart';
import '../../../3_domain/entities/product/marketplace_product.dart';
import '../../../3_domain/entities/product/product_presta.dart';
import '../../../3_domain/repositories/database/main_settings_respository.dart';
import '../../../3_domain/repositories/marketplace/marketplace_import_repository.dart';
import '../../../4_infrastructur/repositories/prestashop_api/models/product_raw_presta.dart';
import '../../../4_infrastructur/repositories/shopify_api/shopify.dart';
import '../../../constants.dart';
import '../../../failures/abstract_failure.dart';

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
      bool isSuccess = true;
      emit(state.copyWith(isLoadingProductsPrestaOnObserve: true, loadedProducts: 0, numberOfToLoadProducts: 0, loadingText: ''));

      List<int>? toLoadProductsFromMarketplace;
      final fosToLoadProductsPresta = await productImportRepository.getToLoadProductsFromMarketplace(
          state.selectedMarketplace! as MarketplacePresta, event.onlyActive); //TODO: Shopify
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

      List<ProductRawPresta> loadedProductsPresta = [];
      for (final productId in toLoadProductsFromMarketplace!) {
        final fosLoadedProductPrestaFromMarketplace =
            await productImportRepository.loadProductFromMarketplace(productId, state.selectedMarketplace! as MarketplacePresta);
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

      final fos = await productImportRepository.uploadLoadedMarketplaceProductToFirestore(
        event.marketplaceProduct,
        state.selectedMarketplace!.id,
      );

      emit(state.copyWith(
        isLoadingProductOnCreate: false,
        fosProductOnCreateOption: fos.isRight() ? const Some(Right(unit)) : Some(Left(fos.getLeft())),
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
        final failureOrSuccess = await productImportRepository.uploadLoadedMarketplaceProductToFirestore(
            productPresta as ProductPresta, state.selectedMarketplace!.id); //TODO: Shopify
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

    on<LoadProductFromMarketplaceEvent>((event, emit) async {
      emit(state.copyWith(isLoadingProductPrestaOnObserve: true));

      switch (event.marketplace.marketplaceType) {
        case MarketplaceType.prestashop:
          {
            final failureOrSuccess = await productImportRepository.loadProductByIdFromPrestashopAsJson(
              event.value.toMyInt(),
              event.marketplace as MarketplacePresta,
            );
            failureOrSuccess.fold(
              (failure) => emit(state.copyWith(marketplaceFailure: failure, isAnyFailure: true)),
              (productPresta) => emit(state.copyWith(marketplaceProduct: [productPresta], marketplaceFailure: null, isAnyFailure: false)),
            );

            emit(state.copyWith(
              isLoadingProductPrestaOnObserve: false,
              fosProductPrestaOnObserveOption: optionOf(failureOrSuccess),
            ));
            emit(state.copyWith(fosProductPrestaOnObserveOption: none()));
            return;
          }
        case MarketplaceType.shopify:
          {
            final failureOrSuccess =
                await productImportRepository.loadProductByArticleNumberFromShopify(event.value, event.marketplace as MarketplaceShopify);
            failureOrSuccess.fold(
              (failure) => emit(state.copyWith(marketplaceFailure: failure, isAnyFailure: true)),
              (productPresta) => emit(state.copyWith(marketplaceProduct: productPresta, marketplaceFailure: null, isAnyFailure: false)),
            );

            emit(state.copyWith(
              isLoadingProductPrestaOnObserve: false,
              fosListProductShopifyOnObserveOption: optionOf(failureOrSuccess),
            ));
            emit(state.copyWith(fosListProductShopifyOnObserveOption: none()));
            return;
          }
        case MarketplaceType.shop:
          {
            emit(state.copyWith(isLoadingProductPrestaOnObserve: false));
            throw Exception('Aus einem Ladengeschäft können keine Artikel importiert werden.');
          }
      }
    });

//? #########################################################################
//? #########################################################################
//? #########################################################################
//? #########################################################################
//? #########################################################################
  }
}
