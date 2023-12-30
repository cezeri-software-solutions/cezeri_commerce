import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';

import '../../../3_domain/entities/marketplace/marketplace.dart';
import '../../../3_domain/entities/product/marketplace_product_presta.dart';
import '../../../3_domain/entities/product/product_marketplace.dart';
import '../../../3_domain/entities_presta/category_presta.dart';
import '../../../3_domain/repositories/firebase/marketplace_repository.dart';
import '../../../3_domain/repositories/marketplace/marketplace_import_repository.dart';
import '../../../core/firebase_failures.dart';
import '../../../core/presta_failure.dart';

part 'marketplace_product_event.dart';
part 'marketplace_product_state.dart';

class MarketplaceProductBloc extends Bloc<MarketplaceProductEvent, MarketplaceProductState> {
  final MarketplaceRepository marketplaceRepository;
  final MarketplaceImportRepository marketplaceImportRepository;

  MarketplaceProductBloc({
    required this.marketplaceRepository,
    required this.marketplaceImportRepository,
  }) : super(MarketplaceProductState.initial()) {
//? #########################################################################

    on<SetMarketplaceProductEvent>((event, emit) {
      switch (event.productMarketplace.marketplaceProduct!.marketplaceType) {
        case MarketplaceType.prestashop:
          {
            emit(state.copyWith(
              productMarketplace: event.productMarketplace,
              marketplaceProductPresta: event.productMarketplace.marketplaceProduct as MarketplaceProductPresta,
            ));
          }
        case MarketplaceType.shop:
      }
      add(GetMarketplaceCategoriesEvent());
    });

//? #########################################################################

    on<SetMarketplaceProductIsActiveEvent>((event, emit) {
      switch (state.productMarketplace!.marketplaceProduct!.marketplaceType) {
        case MarketplaceType.prestashop:
          {
            emit(state.copyWith(
              marketplaceProductPresta: state.marketplaceProductPresta!.copyWith(active: switch (event.value) { true => '1', false => '0' }),
            ));
          }
        case MarketplaceType.shop:
      }
    });

//? #########################################################################

    on<GetMarketplaceCategoriesEvent>((event, emit) async {
      emit(state.copyWith(isLoadingMarketplaceProductCategoriesOnObserve: true));

      Marketplace? marketplace;
      final fosMarketplace = await marketplaceRepository.getMarketplace(state.productMarketplace!.idMarketplace);
      fosMarketplace.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFirebaseFailure: true)),
        (loadedMarketplace) {
          marketplace = loadedMarketplace;
          emit(state.copyWith(firebaseFailure: null, isAnyFirebaseFailure: false));
        },
      );

      if (marketplace == null) throw Exception();

      final failureOrSuccess = await marketplaceImportRepository.getAllPrestaCategories(marketplace!);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(prestaFailure: failure, isAnyPrestaFailure: true)),
        (categoriesPresta) {
          emit(state.copyWith(listOfCategoriesPresta: categoriesPresta, prestaFailure: null, isAnyPrestaFailure: false));
        },
      );

      emit(state.copyWith(
          isLoadingMarketplaceProductCategoriesOnObserve: false,
          fosMarketplaceProductMarketplaceOnObserveOption: optionOf(fosMarketplace),
          fosMarketplaceProductCategoriesOnObserveOption: optionOf(failureOrSuccess)));
      emit(state.copyWith(fosMarketplaceProductMarketplaceOnObserveOption: none(), fosMarketplaceProductCategoriesOnObserveOption: none()));
    });

//? #########################################################################
  }
}
