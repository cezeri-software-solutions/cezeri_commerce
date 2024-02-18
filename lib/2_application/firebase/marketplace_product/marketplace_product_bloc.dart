import 'package:bloc/bloc.dart';
import 'package:cezeri_commerce/1_presentation/core/extensions/string_to_int.dart';
import 'package:dartz/dartz.dart';

import '../../../3_domain/entities/marketplace/marketplace.dart';
import '../../../3_domain/entities/product/marketplace_product_presta.dart';
import '../../../3_domain/entities/product/product_marketplace.dart';
import '../../../3_domain/entities_presta/category_presta.dart';
import '../../../3_domain/entities_presta/product_presta.dart';
import '../../../3_domain/repositories/firebase/marketplace_repository.dart';
import '../../../3_domain/repositories/marketplace/marketplace_import_repository.dart';
import '../../../core/abstract_failure.dart';
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

    on<SetMarketplaceProductStatesToInitialEvent>((event, emit) {
      emit(MarketplaceProductState.initial());
    });

//? #########################################################################

    on<SetMarketplaceProductEvent>((event, emit) {
      switch (event.productMarketplace.marketplaceProduct!.marketplaceType) {
        case MarketplaceType.prestashop:
          {
            final phMpp = event.productMarketplace.marketplaceProduct as MarketplaceProductPresta;
            final mpp = switch (phMpp.associations) {
              null => phMpp.copyWith(associations: Associations.empty().copyWith(associationsCategories: [])),
              _ => switch (phMpp.associations!.associationsCategories) {
                  null => phMpp.copyWith(associations: Associations.empty().copyWith(associationsCategories: [])),
                  _ => phMpp,
                },
            };
            final pm = event.productMarketplace.copyWith(marketplaceProduct: mpp);
            emit(state.copyWith(
              productMarketplace: pm,
              marketplaceProductPresta: mpp,
              defaultCategory: mpp.idCategoryDefault,
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
            final mpProduct = state.marketplaceProductPresta!.copyWith(active: switch (event.value) { true => '1', false => '0' });
            emit(state.copyWith(
              marketplaceProductPresta: mpProduct,
              productMarketplace: state.productMarketplace!.copyWith(marketplaceProduct: mpProduct),
            ));
          }
        case MarketplaceType.shop:
      }
    });

//? #########################################################################

    on<SetListOfCategoriesPrestaToOriginalEvent>((event, emit) {
      final isSelected = List.generate(
        state.listOfCategoriesPrestaOriginal!.length,
        (index) => (state.productMarketplace!.marketplaceProduct as MarketplaceProductPresta)
                .associations!
                .associationsCategories!
                .any((e) => e.id.toMyInt() == state.listOfCategoriesPrestaOriginal![index].id)
            ? true
            : false,
      );
      final isExpanded = List.generate(isSelected.length, (index) => index == 0 || isSelected[index] ? true : false);

      emit(state.copyWith(
        listOfCategoriesPresta: state.listOfCategoriesPrestaOriginal,
        isExpanded: isExpanded,
        isSelected: isSelected,
      ));

      switch (state.productMarketplace!.marketplaceProduct!.marketplaceType) {
        case MarketplaceType.prestashop:
          {
            final mpProduct = state.marketplaceProductPresta!.copyWith(idCategoryDefault: state.defaultCategory);
            emit(state.copyWith(
              marketplaceProductPresta: mpProduct,
              productMarketplace: state.productMarketplace!.copyWith(marketplaceProduct: mpProduct),
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
          final activeCategories = categoriesPresta.where((e) => e.active == '1').toList();
          // final isExpanded = List.generate(activeCategories.length, (index) => index == 0 || index == 1 ? true : false);
          final isSelected = List.generate(
            activeCategories.length,
            (index) => (state.productMarketplace!.marketplaceProduct as MarketplaceProductPresta)
                    .associations!
                    .associationsCategories!
                    .any((e) => e.id.toMyInt() == activeCategories[index].id)
                ? true
                : false,
          );
          final isExpanded = List.generate(isSelected.length, (index) => index == 0 || isSelected[index] ? true : false);
          emit(state.copyWith(
            listOfCategoriesPrestaOriginal: activeCategories,
            listOfCategoriesPresta: activeCategories,
            prestaFailure: null,
            isExpanded: isExpanded,
            isSelected: isSelected,
            isAnyPrestaFailure: false,
          ));
        },
      );

      emit(state.copyWith(
          isLoadingMarketplaceProductCategoriesOnObserve: false,
          fosMarketplaceProductMarketplaceOnObserveOption: optionOf(fosMarketplace),
          fosMarketplaceProductCategoriesOnObserveOption: optionOf(failureOrSuccess)));
      emit(state.copyWith(fosMarketplaceProductMarketplaceOnObserveOption: none(), fosMarketplaceProductCategoriesOnObserveOption: none()));
    });

//? #########################################################################

    on<OnCategoriesIsExpandedChangedEvent>((event, emit) {
      List<bool> newListOfIsExpanded = List.from(state.isExpanded);
      newListOfIsExpanded[event.index] = !newListOfIsExpanded[event.index];
      emit(state.copyWith(isExpanded: newListOfIsExpanded));
    });

//? #########################################################################

    on<OnCategoriesIsSelectedChangedEvent>((event, emit) {
      List<bool> newListOfIsSelected = List.from(state.isSelected);
      newListOfIsSelected[event.index] = event.value;
      emit(state.copyWith(isSelected: newListOfIsSelected));
    });

//? #########################################################################

    on<OnDefaultCategoryChangedEvent>((event, emit) {
      final mpProduct = state.marketplaceProductPresta!.copyWith(idCategoryDefault: event.id.toString());

      emit(state.copyWith(
        marketplaceProductPresta: mpProduct,
        productMarketplace: state.productMarketplace!.copyWith(marketplaceProduct: mpProduct),
      ));
      add(OnCategoriesIsSelectedChangedEvent(index: event.index, value: true));
    });

//? #########################################################################

    on<OnSetUpdatedCategoriesEvent>((event, emit) {
      switch (state.productMarketplace!.marketplaceProduct!.marketplaceType) {
        case MarketplaceType.prestashop:
          {
            List<AssociationsCategory> listOfCategories = [];
            for (int i = 0; i < state.listOfCategoriesPresta!.length; i++) {
              if (state.isSelected[i]) listOfCategories.add(AssociationsCategory(id: state.listOfCategoriesPresta![i].id.toString()));
            }
            final mpProduct = state.marketplaceProductPresta!.copyWith(
              associations: state.marketplaceProductPresta!.associations!.copyWith(
                associationsCategories: listOfCategories,
              ),
            );
            emit(state.copyWith(
              marketplaceProductPresta: mpProduct,
              productMarketplace: state.productMarketplace!.copyWith(marketplaceProduct: mpProduct),
            ));
          }
        case MarketplaceType.shop:
      }
    });

//? #########################################################################
  }
}
