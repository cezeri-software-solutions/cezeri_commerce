part of 'products_booking_bloc.dart';

class ProductsBookingState {
  final List<BookingProduct> listOfSelectedProducts; // screen1 alle ausgwählten Artikel
  final List<Product>? listOfAllProducts;
  final List<Reorder>? listOfAllReorders;
  final List<Reorder>? listOfFilteredReorders;
  final List<BookingProduct> listOfBookingProductsFromReorders; // screen2 alle offenen Artikel
  final List<BookingProduct> selectedReorderProducts; // screen2 ausgewählte Artikel
  final AbstractFailure? firebaseFailure;
  final bool isAnyFailure;
  final bool isLoadingProductsBookingProductsOnObserve;
  final bool isLoadingProductsBookingReordersOnObserve;
  final bool isLoadingProductsBookingOnUpdate;
  final Option<Either<AbstractFailure, List<Product>>> fosProductsBookingProductsOnObserveOption;
  final Option<Either<AbstractFailure, List<Reorder>>> fosProductsBookingReordersOnObserveOption;
  final Option<Either<AbstractFailure, Unit>> fosProductsBookingOnUpdateOption;

  //* Helpers
  final String reorderFilter;
  final bool isAllReorderProductsSelected;

  //* Controllers
  final List<TextEditingController> quantityControllers;

  ProductsBookingState({
    required this.listOfSelectedProducts,
    required this.listOfAllProducts,
    required this.listOfAllReorders,
    required this.listOfFilteredReorders,
    required this.selectedReorderProducts,
    required this.firebaseFailure,
    required this.isAnyFailure,
    required this.isLoadingProductsBookingProductsOnObserve,
    required this.isLoadingProductsBookingReordersOnObserve,
    required this.isLoadingProductsBookingOnUpdate,
    required this.fosProductsBookingProductsOnObserveOption,
    required this.fosProductsBookingReordersOnObserveOption,
    required this.fosProductsBookingOnUpdateOption,
    required this.reorderFilter,
    required this.isAllReorderProductsSelected,
    required this.quantityControllers,
  }) : listOfBookingProductsFromReorders = _getListOfBookingProductsFromReorders(listOfFilteredReorders);

  static List<BookingProduct> _getListOfBookingProductsFromReorders(List<Reorder>? listOfFilteredReorders) {
    if (listOfFilteredReorders == null) return [];

    List<BookingProduct> listOfBookingProducts = [];
    for (final reorder in listOfFilteredReorders) {
      for (final reorderProduct in reorder.listOfReorderProducts) {
        if (reorderProduct.openQuantity > 0) listOfBookingProducts.add(BookingProduct.fromReorderProduct(reorder, reorderProduct));
      }
    }

    if (listOfBookingProducts.isNotEmpty) {
      listOfBookingProducts.sort((a, b) {
        int primary = b.reorderId.compareTo(a.reorderId);
        if (primary != 0) return primary;
        return a.name.compareTo(b.name);
      });
    }

    return listOfBookingProducts;
  }

  factory ProductsBookingState.initial() {
    return ProductsBookingState(
      listOfSelectedProducts: [],
      listOfAllProducts: null,
      listOfAllReorders: null,
      listOfFilteredReorders: null,
      selectedReorderProducts: [],
      firebaseFailure: null,
      isAnyFailure: false,
      isLoadingProductsBookingProductsOnObserve: false,
      isLoadingProductsBookingReordersOnObserve: false,
      isLoadingProductsBookingOnUpdate: false,
      fosProductsBookingProductsOnObserveOption: none(),
      fosProductsBookingReordersOnObserveOption: none(),
      fosProductsBookingOnUpdateOption: none(),
      reorderFilter: '',
      isAllReorderProductsSelected: false,
      quantityControllers: [],
    );
  }

  ProductsBookingState copyWith({
    List<BookingProduct>? listOfSelectedProducts,
    List<Product>? listOfAllProducts,
    List<Reorder>? listOfAllReorders,
    List<Reorder>? listOfFilteredReorders,
    List<BookingProduct>? selectedReorderProducts,
    AbstractFailure? firebaseFailure,
    bool? isAnyFailure,
    bool? isLoadingProductsBookingProductsOnObserve,
    bool? isLoadingProductsBookingReordersOnObserve,
    bool? isLoadingProductsBookingOnUpdate,
    Option<Either<AbstractFailure, List<Product>>>? fosProductsBookingProductsOnObserveOption,
    Option<Either<AbstractFailure, List<Reorder>>>? fosProductsBookingReordersOnObserveOption,
    Option<Either<AbstractFailure, Unit>>? fosProductsBookingOnUpdateOption,
    String? reorderFilter,
    bool? isAllReorderProductsSelected,
    List<TextEditingController>? quantityControllers,
  }) {
    return ProductsBookingState(
      listOfSelectedProducts: listOfSelectedProducts ?? this.listOfSelectedProducts,
      listOfAllProducts: listOfAllProducts ?? this.listOfAllProducts,
      listOfAllReorders: listOfAllReorders ?? this.listOfAllReorders,
      listOfFilteredReorders: listOfFilteredReorders ?? this.listOfFilteredReorders,
      selectedReorderProducts: selectedReorderProducts ?? this.selectedReorderProducts,
      firebaseFailure: firebaseFailure ?? this.firebaseFailure,
      isAnyFailure: isAnyFailure ?? this.isAnyFailure,
      isLoadingProductsBookingProductsOnObserve: isLoadingProductsBookingProductsOnObserve ?? this.isLoadingProductsBookingProductsOnObserve,
      isLoadingProductsBookingReordersOnObserve: isLoadingProductsBookingReordersOnObserve ?? this.isLoadingProductsBookingReordersOnObserve,
      isLoadingProductsBookingOnUpdate: isLoadingProductsBookingOnUpdate ?? this.isLoadingProductsBookingOnUpdate,
      fosProductsBookingProductsOnObserveOption: fosProductsBookingProductsOnObserveOption ?? this.fosProductsBookingProductsOnObserveOption,
      fosProductsBookingReordersOnObserveOption: fosProductsBookingReordersOnObserveOption ?? this.fosProductsBookingReordersOnObserveOption,
      fosProductsBookingOnUpdateOption: fosProductsBookingOnUpdateOption ?? this.fosProductsBookingOnUpdateOption,
      reorderFilter: reorderFilter ?? this.reorderFilter,
      isAllReorderProductsSelected: isAllReorderProductsSelected ?? this.isAllReorderProductsSelected,
      quantityControllers: quantityControllers ?? this.quantityControllers,
    );
  }
}
