part of 'home_product_bloc.dart';

enum ShowProductsBy { soldOut, underMinimumQuantity }

enum GroupProductsBy { manufacturer, supplier }

class HomeProductState {
  final List<Product>? listOfProductsOutlet; // Outlet Artikel die ausverkauft sind
  final List<Product>? listOfProductsSoldOut;
  final List<Product>? listOfProductsUnderMinimumQuantity;
  final List<Reorder>? listOfReorders;
  final List<ProductStockDifference>? listOfProductStockDifferences;
  final List<HomeProduct> listOfHomeProducts;
  final AbstractFailure? firebaseFailure;
  final bool isAnyFailure;
  final bool isLoadingHomeProductsOnObserve;
  final bool isLoadingHomeReordersOnObserve;
  final Option<Either<AbstractFailure, List<Product>>> fosHomeProductsOnObserveOption;
  final Option<Either<AbstractFailure, List<Reorder>>> fosHomeReordersOnObserveOption;
  final Option<Either<AbstractFailure, List<ProductStockDifference>>> fosHomeProductStockDiffOnObserveOption;

  //* Helpers
  final ShowProductsBy showProductsBy;
  final GroupProductsBy groupProductsBy;

  //* Helpers isExpanded
  final bool isExpandedProductsOutlet;
  final bool isExpandedProductsSoldOut;
  final bool isExpandedProductsStockDiff;

  //* Controllers
  final TextEditingController productSearchController;

  HomeProductState({
    required this.listOfProductsOutlet,
    required this.listOfProductsSoldOut,
    required this.listOfProductsUnderMinimumQuantity,
    required this.listOfReorders,
    required this.listOfProductStockDifferences,
    required this.listOfHomeProducts,
    required this.firebaseFailure,
    required this.isAnyFailure,
    required this.isLoadingHomeProductsOnObserve,
    required this.isLoadingHomeReordersOnObserve,
    required this.fosHomeProductsOnObserveOption,
    required this.fosHomeReordersOnObserveOption,
    required this.fosHomeProductStockDiffOnObserveOption,
    required this.showProductsBy,
    required this.groupProductsBy,
    required this.isExpandedProductsOutlet,
    required this.isExpandedProductsSoldOut,
    required this.isExpandedProductsStockDiff,
    required this.productSearchController,
  });

  factory HomeProductState.initial() {
    return HomeProductState(
      listOfProductsOutlet: null,
      listOfProductsSoldOut: null,
      listOfProductsUnderMinimumQuantity: null,
      listOfReorders: null,
      listOfProductStockDifferences: null,
      listOfHomeProducts: [],
      firebaseFailure: null,
      isAnyFailure: false,
      isLoadingHomeProductsOnObserve: false,
      isLoadingHomeReordersOnObserve: false,
      fosHomeProductsOnObserveOption: none(),
      fosHomeReordersOnObserveOption: none(),
      fosHomeProductStockDiffOnObserveOption: none(),
      showProductsBy: ShowProductsBy.soldOut,
      groupProductsBy: GroupProductsBy.manufacturer,
      isExpandedProductsOutlet: false,
      isExpandedProductsSoldOut: false,
      isExpandedProductsStockDiff: false,
      productSearchController: TextEditingController(),
    );
  }

  HomeProductState copyWith({
    List<Product>? listOfProductsOutlet,
    List<Product>? listOfProductsSoldOut,
    List<Product>? listOfProductsUnderMinimumQuantity,
    List<Reorder>? listOfReorders,
    List<ProductStockDifference>? listOfProductStockDifferences,
    List<HomeProduct>? listOfHomeProducts,
    AbstractFailure? firebaseFailure,
    bool? isAnyFailure,
    bool? isLoadingHomeProductsOnObserve,
    bool? isLoadingHomeReordersOnObserve,
    Option<Either<AbstractFailure, List<Product>>>? fosHomeProductsOnObserveOption,
    Option<Either<AbstractFailure, List<Reorder>>>? fosHomeReordersOnObserveOption,
    Option<Either<AbstractFailure, List<ProductStockDifference>>>? fosHomeProductStockDiffOnObserveOption,
    ShowProductsBy? showProductsBy,
    GroupProductsBy? groupProductsBy,
    bool? isExpandedProductsOutlet,
    bool? isExpandedProductsSoldOut,
    bool? isExpandedProductsStockDiff,
    TextEditingController? productSearchController,
  }) {
    return HomeProductState(
      listOfProductsOutlet: listOfProductsOutlet ?? this.listOfProductsOutlet,
      listOfProductsSoldOut: listOfProductsSoldOut ?? this.listOfProductsSoldOut,
      listOfProductsUnderMinimumQuantity: listOfProductsUnderMinimumQuantity ?? this.listOfProductsUnderMinimumQuantity,
      listOfReorders: listOfReorders ?? this.listOfReorders,
      listOfProductStockDifferences: listOfProductStockDifferences ?? this.listOfProductStockDifferences,
      listOfHomeProducts: listOfHomeProducts ?? this.listOfHomeProducts,
      firebaseFailure: firebaseFailure ?? this.firebaseFailure,
      isAnyFailure: isAnyFailure ?? this.isAnyFailure,
      isLoadingHomeProductsOnObserve: isLoadingHomeProductsOnObserve ?? this.isLoadingHomeProductsOnObserve,
      isLoadingHomeReordersOnObserve: isLoadingHomeReordersOnObserve ?? this.isLoadingHomeReordersOnObserve,
      fosHomeProductsOnObserveOption: fosHomeProductsOnObserveOption ?? this.fosHomeProductsOnObserveOption,
      fosHomeReordersOnObserveOption: fosHomeReordersOnObserveOption ?? this.fosHomeReordersOnObserveOption,
      fosHomeProductStockDiffOnObserveOption: fosHomeProductStockDiffOnObserveOption ?? this.fosHomeProductStockDiffOnObserveOption,
      showProductsBy: showProductsBy ?? this.showProductsBy,
      groupProductsBy: groupProductsBy ?? this.groupProductsBy,
      isExpandedProductsOutlet: isExpandedProductsOutlet ?? this.isExpandedProductsOutlet,
      isExpandedProductsSoldOut: isExpandedProductsSoldOut ?? this.isExpandedProductsSoldOut,
      isExpandedProductsStockDiff: isExpandedProductsStockDiff ?? this.isExpandedProductsStockDiff,
      productSearchController: productSearchController ?? this.productSearchController,
    );
  }
}
