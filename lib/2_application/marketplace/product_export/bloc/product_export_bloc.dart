import 'package:bloc/bloc.dart';
import 'package:cezeri_commerce/failures/shopify_failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '/1_presentation/core/core.dart';
import '../../../../3_domain/entities/marketplace/abstract_marketplace.dart';
import '../../../../3_domain/entities/marketplace/marketplace_shopify.dart';
import '../../../../3_domain/entities/product/product.dart';
import '../../../../3_domain/entities/product/product_marketplace.dart';
import '../../../../3_domain/entities/product/product_presta.dart';
import '../../../../3_domain/repositories/database/marketplace_repository.dart';
import '../../../../3_domain/repositories/database/product_repository.dart';
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
    on<GetProductsPerPageEvent>(_onGetProductsPerPage);
    on<GetFilteredProductsBySearchTextEvent>(_onGetFilteredProductsBySearchText);
    on<ItemsPerPageChangedEvent>(_onItemsPerPageChanged);
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

  Future<void> _onGetProductsPerPage(GetProductsPerPageEvent event, Emitter<ProductExportState> emit) async {
    emit(state.copyWith(isLoadingProductsOnObserve: true));

    if (event.calcCount) {
      final fosCount = await productRepository.getNumerOfAllProducts(onlyActive: false);
      fosCount.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure)),
        (countNumber) => emit(state.copyWith(totalQuantity: countNumber, firebaseFailure: null)),
      );
    }

    final failureOrSuccess = await productRepository.getListOfProductsPerPage(
      currentPage: event.currentPage,
      itemsPerPage: state.perPageQuantity,
      onlyActive: false,
    );
    failureOrSuccess.fold(
      (failure) => emit(state.copyWith(firebaseFailure: failure)),
      (listOfProduct) {
        emit(state.copyWith(
          listOfAllProducts: listOfProduct,
          listOfFilteredProducts: listOfProduct,
          selectedProducts: [],
          currentPage: event.currentPage,
          firebaseFailure: null,
        ));
      },
    );

    emit(state.copyWith(
      isLoadingProductsOnObserve: false,
      fosProductsOnObserveOption: optionOf(failureOrSuccess),
    ));
    emit(state.copyWith(fosProductsOnObserveOption: none()));
  }

  Future<void> _onGetFilteredProductsBySearchText(GetFilteredProductsBySearchTextEvent event, Emitter<ProductExportState> emit) async {
    emit(state.copyWith(isLoadingProductsOnObserve: true));

    final fosCount = await productRepository.getNumberOfFilteredProductsBySearchText(searchText: state.productSearchController.text);
    fosCount.fold(
      (failure) => emit(state.copyWith(firebaseFailure: failure)),
      (countNumber) => emit(state.copyWith(totalQuantity: countNumber, firebaseFailure: null)),
    );

    final fosProducts = await productRepository.getListOfFilteredProductsBySearchText(
      searchText: state.productSearchController.text,
      currentPage: event.currentPage,
      itemsPerPage: state.perPageQuantity,
    );

    fosProducts.fold(
      (failure) => emit(state.copyWith(firebaseFailure: failure)),
      (listOfProduct) {
        emit(state.copyWith(
          listOfAllProducts: listOfProduct,
          listOfFilteredProducts: listOfProduct,
          selectedProducts: [],
          currentPage: event.currentPage,
          firebaseFailure: null,
        ));
      },
    );

    emit(state.copyWith(
      isLoadingProductsOnObserve: false,
      fosProductsOnObserveOption: optionOf(fosProducts),
    ));
    emit(state.copyWith(fosProductsOnObserveOption: none()));
  }

  void _onItemsPerPageChanged(ItemsPerPageChangedEvent event, Emitter<ProductExportState> emit) {
    emit(state.copyWith(perPageQuantity: event.value));
    if (state.productSearchController.text.isEmpty) {
      add(GetProductsPerPageEvent(isFirstLoad: false, calcCount: false, currentPage: 1));
    } else {
      add(GetFilteredProductsBySearchTextEvent(currentPage: 1));
    }
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
    add(GetProductsPerPageEvent(isFirstLoad: false, calcCount: true, currentPage: 1));
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

    //* Lädt alle Kategorien aus dem ausgewählten Marktplatz
    final fosCategories = await getAllMarketplaceCategories(event.selectedMarketplace);
    if (fosCategories.isLeft()) {
      emit(state.copyWith(fosProductsOnExportOption: optionOf(Left([fosCategories.getLeft()]))));
      emit(state.copyWith(fosProductsOnExportOption: none(), isLoadingOnExportProducts: false));
      return;
    }

    final marketplaceCategories = fosCategories.getRight();

    //* Wenn ein Marktplatz als Abgleichsmarktplatz ausgewählt wurde, von dem die Kategorien übernommen werden sollen
    if (event.selectedMarketplaceForSourceCategoires != null) {
      final fosCategories = await getAllMarketplaceCategories(event.selectedMarketplaceForSourceCategoires!);
      if (fosCategories.isLeft()) {
        emit(state.copyWith(fosProductsOnExportOption: optionOf(Left([fosCategories.getLeft()]))));
        emit(state.copyWith(fosProductsOnExportOption: none(), isLoadingOnExportProducts: false));
        return;
      }

      final marketplaceSourceCategories = fosCategories.getRight();

      final sourceMarketplace = event.selectedMarketplaceForSourceCategoires!;
      switch (event.selectedMarketplace.marketplaceType) {
        case MarketplaceType.prestashop:
        case MarketplaceType.shopify:
          {
            final marketplace = event.selectedMarketplace as MarketplaceShopify;
            switch (sourceMarketplace.marketplaceType) {
              case MarketplaceType.prestashop:
                {
                  final resultAllProductsRawShopify = await ShopifyRepositoryGet(marketplace).getProductsAllRaw();
                  if (resultAllProductsRawShopify.isLeft()) {
                    emit(state.copyWith(fosProductsOnExportOption: optionOf(Left([resultAllProductsRawShopify.getLeft()]))));
                    emit(state.copyWith(fosProductsOnExportOption: none(), isLoadingOnExportProducts: false));
                    return;
                  }

                  final allProductsRawShopify = resultAllProductsRawShopify.getRight();

                  final categoriesPresta = marketplaceSourceCategories as List<CategoryPresta>;
                  for (int i = 0; i < state.selectedProducts.length; i++) {
                    final product = state.selectedProducts[i];
                    if (allProductsRawShopify.any((e) =>
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
                        'Außenpflege' => 'Aussenbereich',
                        'Innenpflege' => 'Innenraum',
                        'Auto Polierset' => 'Polier Sets',
                        _ => categoryPresta.name,
                      };
                      final phMarketplaceCategory =
                          marketplaceCategories.where((e) => (e as CustomCollectionShopify).title == categoryPrestaName).firstOrNull;
                      if (phMarketplaceCategory == null) {
                        // emit(state.copyWith(listOfErrorCategoryProducts: state.listOfErrorCategoryProducts..add(product)));
                        continue;
                      }
                      categoryIds.add((phMarketplaceCategory as CustomCollectionShopify).id);
                    }

                    final dynamicCategories =
                        marketplaceCategories.where((e) => (e as CustomCollectionShopify).title == 'Neuheiten' || (e).title == 'Bestseller').toList();
                    if (dynamicCategories.isNotEmpty) {
                      categoryIds.addAll((dynamicCategories as List<CustomCollectionShopify>).map((e) => e.id).toList());
                    }

                    if (categoryIds.isEmpty && !state.listOfErrorCategoryProducts.any((e) => e.id == product.id)) {
                      emit(state.copyWith(listOfErrorCategoryProducts: state.listOfErrorCategoryProducts..add(product)));
                      continue;
                    }

                    ProductShopify? newCreatedProductShopify;
                    final resProduct = await ShopifyRepositoryPost(marketplace).createNewProductInMarketplace(
                      product: product,
                      customCollectionIds: categoryIds,
                    );
                    resProduct.fold(
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
