part of 'products_booking_bloc.dart';

class ProductsBookingState {
  final List<BookingProduct> listOfSelectedProducts; // screen1 alle ausgwählten Artikel
  final List<Product>? listOfAllProducts;
  final List<Reorder>? listOfAllReorders;
  final List<Reorder>? listOfFilteredReorders;
  final List<BookingProduct> listOfBookingProductsFromReorders; // screen2 alle offenen Artikel
  final List<BookingProduct> selectedReorderProducts; // screen2 ausgewählte Artikel
  final FirebaseFailure? firebaseFailure;
  final bool isAnyFailure;
  final bool isLoadingProductsBookingProductsOnObserve;
  final bool isLoadingProductsBookingProductsOnUpdate;
  final bool isLoadingProductsBookingReordersOnObserve;
  final bool isLoadingProductsBookingReordersOnUpdate;
  final Option<Either<FirebaseFailure, List<Product>>> fosProductsBookingProductsOnObserveOption;
  final Option<Either<FirebaseFailure, List<Product>>> fosProductsBookingProductsOnUpdateOption;
  final Option<Either<FirebaseFailure, List<Reorder>>> fosProductsBookingReordersOnObserveOption;
  final Option<Either<FirebaseFailure, List<Reorder>>> fosProductsBookingReordersOnUpdateOption;

  //* Helpers
  final String reorderFilter;
  final bool isAllReorderProductsSelected;

  ProductsBookingState({
    required this.listOfSelectedProducts,
    required this.listOfAllProducts,
    required this.listOfAllReorders,
    required this.listOfFilteredReorders,
    required this.selectedReorderProducts,
    required this.firebaseFailure,
    required this.isAnyFailure,
    required this.isLoadingProductsBookingProductsOnObserve,
    required this.isLoadingProductsBookingProductsOnUpdate,
    required this.isLoadingProductsBookingReordersOnObserve,
    required this.isLoadingProductsBookingReordersOnUpdate,
    required this.fosProductsBookingProductsOnObserveOption,
    required this.fosProductsBookingProductsOnUpdateOption,
    required this.fosProductsBookingReordersOnObserveOption,
    required this.fosProductsBookingReordersOnUpdateOption,
    required this.reorderFilter,
    required this.isAllReorderProductsSelected,
  }) : listOfBookingProductsFromReorders = _getListOfBookingProductsFromReorders(listOfFilteredReorders);

  static List<BookingProduct> _getListOfBookingProductsFromReorders(List<Reorder>? listOfFilteredReorders) {
    if (listOfFilteredReorders == null) return [];

    List<BookingProduct> listOfBookingProducts = [];
    for (final reorder in listOfFilteredReorders) {
      for (final reorderProduct in reorder.listOfReorderProducts) {
        listOfBookingProducts.add(BookingProduct.fromReorderProduct(reorder, reorderProduct));
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
      isLoadingProductsBookingProductsOnUpdate: false,
      isLoadingProductsBookingReordersOnObserve: false,
      isLoadingProductsBookingReordersOnUpdate: false,
      fosProductsBookingProductsOnObserveOption: none(),
      fosProductsBookingProductsOnUpdateOption: none(),
      fosProductsBookingReordersOnObserveOption: none(),
      fosProductsBookingReordersOnUpdateOption: none(),
      reorderFilter: '',
      isAllReorderProductsSelected: false,
    );
  }

  ProductsBookingState copyWith({
    List<BookingProduct>? listOfSelectedProducts,
    List<Product>? listOfAllProducts,
    List<Reorder>? listOfAllReorders,
    List<Reorder>? listOfFilteredReorders,
    List<BookingProduct>? selectedReorderProducts,
    FirebaseFailure? firebaseFailure,
    bool? isAnyFailure,
    bool? isLoadingProductsBookingProductsOnObserve,
    bool? isLoadingProductsBookingProductsOnUpdate,
    bool? isLoadingProductsBookingReordersOnObserve,
    bool? isLoadingProductsBookingReordersOnUpdate,
    Option<Either<FirebaseFailure, List<Product>>>? fosProductsBookingProductsOnObserveOption,
    Option<Either<FirebaseFailure, List<Product>>>? fosProductsBookingProductsOnUpdateOption,
    Option<Either<FirebaseFailure, List<Reorder>>>? fosProductsBookingReordersOnObserveOption,
    Option<Either<FirebaseFailure, List<Reorder>>>? fosProductsBookingReordersOnUpdateOption,
    String? reorderFilter,
    bool? isAllReorderProductsSelected,
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
      isLoadingProductsBookingProductsOnUpdate: isLoadingProductsBookingProductsOnUpdate ?? this.isLoadingProductsBookingProductsOnUpdate,
      isLoadingProductsBookingReordersOnObserve: isLoadingProductsBookingReordersOnObserve ?? this.isLoadingProductsBookingReordersOnObserve,
      isLoadingProductsBookingReordersOnUpdate: isLoadingProductsBookingReordersOnUpdate ?? this.isLoadingProductsBookingReordersOnUpdate,
      fosProductsBookingProductsOnObserveOption: fosProductsBookingProductsOnObserveOption ?? this.fosProductsBookingProductsOnObserveOption,
      fosProductsBookingProductsOnUpdateOption: fosProductsBookingProductsOnUpdateOption ?? this.fosProductsBookingProductsOnUpdateOption,
      fosProductsBookingReordersOnObserveOption: fosProductsBookingReordersOnObserveOption ?? this.fosProductsBookingReordersOnObserveOption,
      fosProductsBookingReordersOnUpdateOption: fosProductsBookingReordersOnUpdateOption ?? this.fosProductsBookingReordersOnUpdateOption,
      reorderFilter: reorderFilter ?? this.reorderFilter,
      isAllReorderProductsSelected: isAllReorderProductsSelected ?? this.isAllReorderProductsSelected,
    );
  }
}
