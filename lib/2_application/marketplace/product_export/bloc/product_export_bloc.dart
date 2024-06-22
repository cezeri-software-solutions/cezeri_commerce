import 'package:bloc/bloc.dart';
import 'package:cezeri_commerce/failures/firebase_failures.dart';
import 'package:cezeri_commerce/failures/shopify_failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '/1_presentation/core/core.dart';
import '../../../../3_domain/entities/marketplace/abstract_marketplace.dart';
import '../../../../3_domain/entities/marketplace/marketplace_shopify.dart';
import '../../../../3_domain/entities/product/product.dart';
import '../../../../3_domain/entities/product/product_marketplace.dart';
import '../../../../3_domain/entities/product/product_presta.dart';
import '../../../../3_domain/repositories/firebase/marketplace_repository.dart';
import '../../../../3_domain/repositories/firebase/product_repository.dart';
import '../../../../3_domain/repositories/marketplace/marketplace_edit_repository.dart';
import '../../../../3_domain/repositories/marketplace/marketplace_import_repository.dart';
import '../../../../4_infrastructur/repositories/prestashop_api/models/models.dart';
import '../../../../4_infrastructur/repositories/shopify_api/shopify.dart';
import '../../../../failures/abstract_failure.dart';

part 'product_export_event.dart';
part 'product_export_state.dart';

class ProductExportBloc extends Bloc<ProductExportEvent, ProductExportState> {
  final ProductRepository productRepository;
  final MarketplaceRepository marketplaceRepository;
  final MarketplaceEditRepository marketplaceEditRepository;
  final MarketplaceImportRepository marketplaceImportRepository;

  ProductExportBloc({
    required this.productRepository,
    required this.marketplaceRepository,
    required this.marketplaceEditRepository,
    required this.marketplaceImportRepository,
  }) : super(ProductExportState.initial()) {
    on<SetProductExportStateToInitialEvent>(_onSetProductExportStateToInitial);
    on<GetAllProductsEvent>(_onGetAllProducts);
    on<GetAllMarketplacesEvent>(_onGetAllMarketplaces);
    on<OnProductSearchControllerChangedEvent>(_onProductSearchControllerChanged);
    on<OnProductSearchControllerClearedEvent>(_onProductSearchControllerCleared);
    on<OnSelectedAllProductsChangedEvent>(_onSelectedAllProductsChanged);
    on<OnProductSelectedEvent>(_onProductSelected);
    on<OnProductsExportToSelectedMarketplaceEvent>(_onProductsExportToSelectedMarketplace);
  }

  void _onSetProductExportStateToInitial(SetProductExportStateToInitialEvent event, Emitter<ProductExportState> emit) async {
    emit(ProductExportState.initial());
  }

  Future<void> _onGetAllProducts(GetAllProductsEvent event, Emitter<ProductExportState> emit) async {
    emit(state.copyWith(isLoadingProductsOnObserve: true));

    final fos = await productRepository.getListOfProducts(true);
    fos.fold(
      (failure) => emit(state.copyWith(firebaseFailure: failure)),
      (loadedProducts) => emit(state.copyWith(listOfAllProducts: loadedProducts)),
    );
    if (state.listOfAllProducts != null) add(OnProductSearchControllerChangedEvent());

    emit(state.copyWith(fosProductsOnObserveOption: optionOf(fos), isLoadingProductsOnObserve: false));
    emit(state.copyWith(fosProductsOnObserveOption: none()));
  }

  Future<void> _onGetAllMarketplaces(GetAllMarketplacesEvent event, Emitter<ProductExportState> emit) async {
    emit(state.copyWith(isLoadingMarketplacesOnObserve: true));

    final fos = await marketplaceRepository.getListOfMarketplaces();
    fos.fold(
      (failure) => emit(state.copyWith(firebaseFailure: failure)),
      (loadedMarketplaces) => emit(state.copyWith(listOfMarketplaces: loadedMarketplaces)),
    );

    emit(state.copyWith(fosMarketplacesOnObserveOption: optionOf(fos), isLoadingMarketplacesOnObserve: false));
    emit(state.copyWith(fosMarketplacesOnObserveOption: none()));
  }

  void _onProductSearchControllerChanged(OnProductSearchControllerChangedEvent event, Emitter<ProductExportState> emit) async {
    final widthSearchText = state.productSearchController.text.toLowerCase().split(' ');

    List<Product>? listOfProducts = switch (state.productSearchController.text) {
      '' => state.listOfAllProducts,
      _ => state.listOfAllProducts!
          .where((e) => widthSearchText.every((entry) =>
              e.name.toLowerCase().contains(entry) ||
              e.ean.toLowerCase().contains(entry) ||
              e.supplier.toLowerCase().contains(entry) ||
              e.articleNumber.toLowerCase().contains(entry)))
          .toList()
    };

    if (listOfProducts != null && listOfProducts.isNotEmpty) listOfProducts.sort((a, b) => a.name.compareTo(b.name));

    emit(state.copyWith(listOfFilteredProducts: listOfProducts));
  }

  void _onProductSearchControllerCleared(OnProductSearchControllerClearedEvent event, Emitter<ProductExportState> emit) async {
    emit(state.copyWith(productSearchController: SearchController()));

    add(OnProductSearchControllerChangedEvent());
  }

  void _onSelectedAllProductsChanged(OnSelectedAllProductsChangedEvent event, Emitter<ProductExportState> emit) async {
    List<Product> products = [];
    bool isSelectedAll = false;
    if (event.isSelected) {
      isSelectedAll = true;
      products = List.from(state.listOfFilteredProducts!);
    }
    emit(state.copyWith(isSelectedAllProducts: isSelectedAll, selectedProducts: products));
  }

  void _onProductSelected(OnProductSelectedEvent event, Emitter<ProductExportState> emit) async {
    List<Product> products = List.from(state.selectedProducts);
    if (products.any((e) => e.id == event.selectedProduct.id)) {
      products.removeWhere((e) => e.id == event.selectedProduct.id);
    } else {
      products.add(event.selectedProduct);
    }
    emit(state.copyWith(
      isSelectedAllProducts: state.isSelectedAllProducts && products.length < state.selectedProducts.length ? false : state.isSelectedAllProducts,
      selectedProducts: products,
    ));
  }

  Future<void> _onProductsExportToSelectedMarketplace(OnProductsExportToSelectedMarketplaceEvent event, Emitter<ProductExportState> emit) async {
    emit(state.copyWith(isLoadingOnExportProducts: true));

    AbstractFailure? categoryFailure;
    List<dynamic>? marketplaceCategories;
    final fosCategories = await getAllMarketplaceCategories(event.selectedMarketplace);
    fosCategories.fold(
      (failure) => categoryFailure = failure,
      (mC) => marketplaceCategories = mC,
    );
    if (categoryFailure != null || marketplaceCategories == null) {
      if (categoryFailure != null) {
        emit(state.copyWith(fosProductsOnExportOption: optionOf(Left([categoryFailure!]))));
      }
      if (marketplaceCategories == null) {
        emit(
          state.copyWith(fosProductsOnExportOption: optionOf(Left([GeneralFailure(customMessage: 'Kategorien konnten nicht geladen werden.')]))),
        );
      }
      emit(state.copyWith(fosProductsOnExportOption: none(), isLoadingOnExportProducts: false));
      return;
    }

    if (event.selectedMarketplaceForSourceCategoires != null) {
      AbstractFailure? categorySourceFailure;
      List<dynamic>? marketplaceSourceCategories;
      final fosCategories = await getAllMarketplaceCategories(event.selectedMarketplaceForSourceCategoires!);
      fosCategories.fold(
        (failure) => categorySourceFailure = failure,
        (mC) => marketplaceSourceCategories = mC,
      );
      if (categorySourceFailure != null || marketplaceSourceCategories == null) {
        if (categorySourceFailure != null) {
          emit(state.copyWith(
            fosProductsOnExportOption: optionOf(Left([categorySourceFailure!])),
          ));
        }
        if (marketplaceSourceCategories == null) {
          emit(
            state.copyWith(
              fosProductsOnExportOption: optionOf(Left([GeneralFailure(customMessage: 'Kategorien konnten nicht geladen werden.')])),
            ),
          );
        }
        emit(state.copyWith(fosProductsOnExportOption: none(), isLoadingOnExportProducts: false));
        return;
      }

      final sourceMarketplace = event.selectedMarketplaceForSourceCategoires!;
      switch (event.selectedMarketplace.marketplaceType) {
        case MarketplaceType.prestashop:
        case MarketplaceType.shopify:
          {
            final marketplace = event.selectedMarketplace as MarketplaceShopify;
            switch (sourceMarketplace.marketplaceType) {
              case MarketplaceType.prestashop:
                {
                  final api = ShopifyApi(
                    ShopifyApiConfig(storefrontToken: marketplace.storefrontAccessToken, adminToken: marketplace.adminAccessToken),
                    marketplace.fullUrl,
                  );

                  List<ProductRawShopify>? allProductsRawShopify;
                  final fosAllProductsRawShopify = await api.getProductsAllRaw();
                  fosAllProductsRawShopify.fold(
                    (failure) {
                      return;
                    },
                    (all) => allProductsRawShopify = all,
                  );
                  if (allProductsRawShopify == null) return;

                  final categoriesPresta = marketplaceSourceCategories! as List<CategoryPresta>;
                  for (int i = 0; i < state.selectedProducts.length; i++) {
                    final product = state.selectedProducts[i];
                    if (allProductsRawShopify!.any((e) =>
                        e.title == product.name ||
                        e.variants.first.sku == product.articleNumber ||
                        (e.variants.first.barcode != '' && e.variants.first.barcode == product.ean))) {
                      continue;
                    }
                    if (i != 0) await Future.delayed(const Duration(seconds: 5));
                    emit(state.copyWith(exportCounter: i + 1));

                    final productMarketplace = product.productMarketplaces.where((e) => e.idMarketplace == sourceMarketplace.id).firstOrNull;
                    if (productMarketplace == null) {
                      emit(state.copyWith(listOfNotInMarketplaceProducts: state.listOfNotInMarketplaceProducts..add(product)));
                      continue;
                    }

                    final selectedCategoriesInMarketplaceProduct = categoriesPresta
                        .where((categoryPresta) => (productMarketplace.marketplaceProduct as ProductPresta)
                            .associations!
                            .associationsCategories!
                            .any((associationCategory) => associationCategory.id.toMyInt() == categoryPresta.id))
                        .toList();

                    final List<int> categoryIds = [];
                    for (final categoryPresta in selectedCategoriesInMarketplaceProduct) {
                      final categoryPrestaName = switch (categoryPresta.name) {
                        'Aussenpflege' => 'Aussenbereich',
                        'Innenpflege' => 'Innenraum',
                        'Auto Polierset' => 'Polier Sets',
                        'Glasreiniger' => 'Scheibenreiniger',
                        _ => categoryPresta.name,
                      };
                      final phMarketplaceCategory =
                          marketplaceCategories!.where((e) => (e as CustomCollectionShopify).title == categoryPrestaName).firstOrNull;
                      if (phMarketplaceCategory == null) {
                        // emit(state.copyWith(listOfErrorCategoryProducts: state.listOfErrorCategoryProducts..add(product)));
                        continue;
                      }
                      categoryIds.add((phMarketplaceCategory as CustomCollectionShopify).id);
                    }

                    final dynamicCategories = marketplaceCategories!
                        .where((e) => (e as CustomCollectionShopify).title == 'Neuheiten' || (e).title == 'Bestseller')
                        .toList();
                    if (dynamicCategories.isNotEmpty) {
                      categoryIds.addAll((dynamicCategories as List<CustomCollectionShopify>).map((e) => e.id).toList());
                    }

                    if (categoryIds.isEmpty && !state.listOfErrorCategoryProducts.any((e) => e.id == product.id)) {
                      emit(state.copyWith(listOfErrorCategoryProducts: state.listOfErrorCategoryProducts..add(product)));
                      continue;
                    }

                    ProductShopify? newCreatedProductShopify;
                    final fosCreatedProduct = await api.postProduct(product, categoryIds);
                    fosCreatedProduct.fold(
                      (createFailures) {
                        for (final createFailure in createFailures) {
                          if (createFailure.runtimeType == ShopifyPostProductFailure) {
                            switch ((createFailure as ShopifyPostProductFailure).postProductFailureType) {
                              case ShopifyPostProductFailureType.product:
                                emit(state.copyWith(listOfErrorProducts: state.listOfErrorProducts..add(product)));
                              case ShopifyPostProductFailureType.images:
                                emit(state.copyWith(listOfErrorImageProducts: state.listOfErrorImageProducts..add(product)));
                              case ShopifyPostProductFailureType.categories:
                                emit(state.copyWith(listOfErrorCategoryProducts: state.listOfErrorCategoryProducts..add(product)));
                              case ShopifyPostProductFailureType.stock:
                                emit(state.copyWith(listOfErrorStockProducts: state.listOfErrorStockProducts..add(product)));
                            }
                          }
                        }
                      },
                      (newCreatedMarketplaceProduct) {
                        emit(state.copyWith(listOfSuccessfulProducts: state.listOfSuccessfulProducts..add(product)));
                        newCreatedProductShopify = newCreatedMarketplaceProduct;
                      },
                    );
                    if (newCreatedProductShopify == null) {
                      emit(state.copyWith(listOfErrorMarketplaceProducts: state.listOfErrorMarketplaceProducts..add(product)));
                      continue;
                    }

                    final productMarketplaceNew = ProductMarketplace.fromMarketplaceProduct(newCreatedProductShopify!, marketplace);
                    List<ProductMarketplace> productMarketplaces = List.from(product.productMarketplaces);
                    final index = product.productMarketplaces.indexWhere((e) => e.idMarketplace == marketplace.id);
                    if (index == -1) {
                      productMarketplaces.add(productMarketplaceNew);
                    } else {
                      productMarketplaces[index] = productMarketplaceNew;
                    }
                    final updatedProduct = product.copyWith(productMarketplaces: productMarketplaces);

                    final fosUpdatedProduct = await productRepository.updateProductAndSets(updatedProduct);
                    fosUpdatedProduct.fold(
                      (failure) {
                        emit(state.copyWith(listOfErrorMarketplaceProducts: state.listOfErrorMarketplaceProducts..add(product)));
                      },
                      (_) => null,
                    );
                  }
                }
              case MarketplaceType.shopify:
              case MarketplaceType.shop:
                throw Exception('Ein Ladengeschäft kann keine Kategorien haben.');
            }
          }
        case MarketplaceType.shop:
      }
    }
    // final fos = await marketplaceRepository.getListOfMarketplaces();
    // fos.fold(
    //   (failure) => emit(state.copyWith(firebaseFailure: failure)),
    //   (loadedMarketplaces) => emit(state.copyWith(listOfMarketplaces: loadedMarketplaces)),
    // );

    // TODO:

    emit(state.copyWith(isLoadingOnExportProducts: false));
    emit(state.copyWith(fosProductsOnExportOption: none()));
  }

//* ###############################################################################################################################################
//* ###############################################################################################################################################
//* ###############################################################################################################################################

  Future<Either<AbstractFailure, List<dynamic>>> getAllMarketplaceCategories(AbstractMarketplace marketplace) async {
    AbstractFailure? failure;
    List<dynamic>? categories;
    final failureOrSuccess = await marketplaceImportRepository.getAllMarketplaceCategories(marketplace);
    failureOrSuccess.fold(
      (categoryFailure) => failure = categoryFailure,
      (loadedCategories) {
        switch (marketplace.marketplaceType) {
          case MarketplaceType.prestashop:
            {
              final marketplaceCategories = loadedCategories as List<CategoryPresta>;
              final activeCategories = marketplaceCategories.where((e) => e.active == '1').toList();
              categories = activeCategories;
            }
          case MarketplaceType.shopify:
            {
              final marketplaceCategories = loadedCategories as List<CustomCollectionShopify>;
              final activeCategories = marketplaceCategories;
              categories = activeCategories;
            }
          case MarketplaceType.shop:
            throw Exception('Ein Ladengeschäft kann keine Kategorien haben.');
        }
      },
    );
    if (failure != null) return Left(failure!);
    return Right(categories!);
  }
}
