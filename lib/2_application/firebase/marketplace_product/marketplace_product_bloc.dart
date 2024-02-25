import 'package:bloc/bloc.dart';
import 'package:cezeri_commerce/1_presentation/core/extensions/string_to_int.dart';
import 'package:dartz/dartz.dart';

import '../../../3_domain/entities/marketplace/abstract_marketplace.dart';
import '../../../3_domain/entities/product/product_marketplace.dart';
import '../../../3_domain/entities/product/product_presta.dart';
import '../../../3_domain/repositories/firebase/marketplace_repository.dart';
import '../../../3_domain/repositories/marketplace/marketplace_import_repository.dart';
import '../../../4_infrastructur/repositories/prestashop_api/models/category_presta.dart';
import '../../../4_infrastructur/repositories/prestashop_api/models/product_raw_presta.dart';
import '../../../4_infrastructur/repositories/shopify_api/shopify.dart';
import '../../../core/abstract_failure.dart';

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
            final phMpp = event.productMarketplace.marketplaceProduct as ProductPresta;
            final mpp = switch (phMpp.associations) {
              null => phMpp.copyWith(associations: Associations.empty().copyWith(associationsCategories: [])),
              _ => switch (phMpp.associations!.associationsCategories) {
                  null => phMpp.copyWith(associations: Associations.empty().copyWith(associationsCategories: [])),
                  _ => phMpp,
                },
            };
            final pm = event.productMarketplace.copyWith(marketplaceProduct: mpp);
            emit(state.copyWith(productMarketplace: pm, marketplaceProductPresta: mpp, defaultCategory: mpp.idCategoryDefault));
          }
        case MarketplaceType.shopify:
          {
            final phMps = event.productMarketplace.marketplaceProduct as ProductShopify;
            final pm = event.productMarketplace.copyWith(marketplaceProduct: phMps);

            emit(state.copyWith(productMarketplace: pm, marketplaceProductShopify: phMps));
          }
        case MarketplaceType.shop:
          {
            throw Exception('SHOP not implemented');
          }
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
        case MarketplaceType.shopify:
          {
            final mpProduct = state.marketplaceProductShopify!.copyWith(status: switch (event.value) { true => 'active', false => 'draft' });
            emit(state.copyWith(
              marketplaceProductShopify: mpProduct,
              productMarketplace: state.productMarketplace!.copyWith(marketplaceProduct: mpProduct),
            ));
          }
        case MarketplaceType.shop:
          {
            throw Exception('SHOP not implemented');
          }
      }
    });

//? #########################################################################

    on<SetListOfCategoriesPrestaToOriginalEvent>((event, emit) {
      final isSelected = List.generate(
        state.listOfCategoriesPrestaOriginal!.length,
        (index) => (state.productMarketplace!.marketplaceProduct as ProductPresta)
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
        case MarketplaceType.shopify:
          {
            throw Exception('SHOPIFY not implemented');
          }
        case MarketplaceType.shop:
          {
            throw Exception('SHOP not implemented');
          }
      }
    });

//? #########################################################################

    on<GetMarketplaceCategoriesEvent>((event, emit) async {
      emit(state.copyWith(isLoadingMarketplaceProductCategoriesOnObserve: true));

      AbstractMarketplace? marketplace;
      final fosMarketplace = await marketplaceRepository.getMarketplace(state.productMarketplace!.idMarketplace);
      fosMarketplace.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFirebaseFailure: true)),
        (loadedMarketplace) {
          marketplace = loadedMarketplace;
          emit(state.copyWith(firebaseFailure: null, isAnyFirebaseFailure: false));
        },
      );

      if (marketplace == null) throw Exception();

      final failureOrSuccess = await marketplaceImportRepository.getAllMarketplaceCategories(marketplace!);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(marketplaceFailure: failure, isAnyPrestaFailure: true)),
        (loadedCategories) {
          switch (state.productMarketplace!.marketplaceProduct!.marketplaceType) {
            case MarketplaceType.prestashop:
              {
                final marketplaceCategories = loadedCategories as List<CategoryPresta>;
                final activeCategories = marketplaceCategories.where((e) => e.active == '1').toList();
                final isSelected = List.generate(
                  activeCategories.length,
                  (index) => (state.productMarketplace!.marketplaceProduct as ProductPresta)
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
                  marketplaceFailure: null,
                  isExpanded: isExpanded,
                  isSelected: isSelected,
                  isAnyPrestaFailure: false,
                ));
              }
            case MarketplaceType.shopify:
              {
                final marketplaceCategories = loadedCategories as List<CustomCollectionShopify>;
                final activeCategories = marketplaceCategories;
                final isSelected = List.generate(
                  activeCategories.length,
                  (index) => (state.productMarketplace!.marketplaceProduct as ProductShopify)
                          .customCollections
                          .any((e) => e.id == activeCategories[index].id)
                      ? true
                      : false,
                );
                emit(state.copyWith(
                  listOfCategoriesShopifyOriginal: activeCategories,
                  listOfCategoriesShopify: activeCategories,
                  marketplaceFailure: null,
                  isSelected: isSelected,
                  isAnyPrestaFailure: false,
                ));
              }
            case MarketplaceType.shop:
              throw Exception('Ein Ladengeschäft kann keine Kategorien haben.');
          }
        },
      );

      emit(state.copyWith(
          isLoadingMarketplaceProductCategoriesOnObserve: false,
          fosMarketplaceProductMarketplaceOnObserveOption: optionOf(fosMarketplace),
          fosMarketplaceProductCategoriesOnObserveOption: optionOf(failureOrSuccess as Either<AbstractFailure, List<CategoryPresta>>?)));
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
        case MarketplaceType.shopify:
          {
            throw Exception('SHOPIFY not implemented');
          }
        case MarketplaceType.shop:
          {
            throw Exception('SHOP not implemented');
          }
      }
    });

//? #########################################################################
  }
}
