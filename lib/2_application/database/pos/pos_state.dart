part of 'pos_bloc.dart';

class PosState {
  final Receipt receipt;
  final MainSettings? mainSettings;
  final Customer? customer;
  final MarketplaceShop? marketplace;
  final List<Product>? listOfSearchResultProducts;
  final List<Product> listOfSelectedProducts;
  final AbstractFailure? databaseFailure;
  final bool isLoadingPosOnObserve;
  final bool isLoadingPosOnCreate;
  final bool isLoadingPosOnSearchProducts;
  final Option<Either<AbstractFailure, Unit>> fosPosOnObserveOption;
  final Option<Either<AbstractFailure, List<Receipt>>> fosPosOnCreateOption;

  //* Controller
  final SearchController searchController;
  final TextEditingController eanController;
  final TextEditingController discountPercentController;
  final TextEditingController discountAmountController;
  final TextEditingController internalCommentController;
  final TextEditingController globalCommentController;

  //* Helpers
  final bool isModalSheetOpen;
  final bool printInvoice;

  const PosState({
    required this.receipt,
    required this.mainSettings,
    required this.customer,
    required this.marketplace,
    required this.listOfSearchResultProducts,
    required this.listOfSelectedProducts,
    required this.databaseFailure,
    required this.isLoadingPosOnObserve,
    required this.isLoadingPosOnCreate,
    required this.isLoadingPosOnSearchProducts,
    required this.fosPosOnObserveOption,
    required this.fosPosOnCreateOption,
    required this.searchController,
    required this.eanController,
    required this.discountPercentController,
    required this.discountAmountController,
    required this.internalCommentController,
    required this.globalCommentController,
    required this.isModalSheetOpen,
    required this.printInvoice,
  });

  factory PosState.initial() {
    return PosState(
      receipt: Receipt.empty(),
      mainSettings: null,
      customer: null,
      marketplace: null,
      listOfSearchResultProducts: null,
      listOfSelectedProducts: [],
      databaseFailure: null,
      isLoadingPosOnObserve: false,
      isLoadingPosOnCreate: false,
      isLoadingPosOnSearchProducts: false,
      fosPosOnObserveOption: none(),
      fosPosOnCreateOption: none(),
      searchController: SearchController(),
      eanController: TextEditingController(),
      discountPercentController: TextEditingController(),
      discountAmountController: TextEditingController(),
      internalCommentController: TextEditingController(),
      globalCommentController: TextEditingController(),
      isModalSheetOpen: false,
      printInvoice: true,
    );
  }

  PosState copyWith({
    Receipt? receipt,
    MainSettings? mainSettings,
    Customer? customer,
    MarketplaceShop? marketplace,
    List<Product>? listOfSearchResultProducts,
    List<Product>? listOfSelectedProducts,
    AbstractFailure? databaseFailure,
    bool? isLoadingPosOnObserve,
    bool? isLoadingPosOnCreate,
    bool? isLoadingPosOnSearchProducts,
    Option<Either<AbstractFailure, Unit>>? fosPosOnObserveOption,
    Option<Either<AbstractFailure, List<Receipt>>>? fosPosOnCreateOption,
    SearchController? searchController,
    TextEditingController? eanController,
    TextEditingController? discountPercentController,
    TextEditingController? discountAmountController,
    TextEditingController? internalCommentController,
    TextEditingController? globalCommentController,
    bool? isModalSheetOpen,
    bool? printInvoice,
  }) {
    return PosState(
      receipt: receipt ?? this.receipt,
      mainSettings: mainSettings ?? this.mainSettings,
      customer: customer ?? this.customer,
      marketplace: marketplace ?? this.marketplace,
      listOfSearchResultProducts: listOfSearchResultProducts ?? this.listOfSearchResultProducts,
      listOfSelectedProducts: listOfSelectedProducts ?? this.listOfSelectedProducts,
      databaseFailure: databaseFailure ?? this.databaseFailure,
      isLoadingPosOnObserve: isLoadingPosOnObserve ?? this.isLoadingPosOnObserve,
      isLoadingPosOnCreate: isLoadingPosOnCreate ?? this.isLoadingPosOnCreate,
      isLoadingPosOnSearchProducts: isLoadingPosOnSearchProducts ?? this.isLoadingPosOnSearchProducts,
      fosPosOnObserveOption: fosPosOnObserveOption ?? this.fosPosOnObserveOption,
      fosPosOnCreateOption: fosPosOnCreateOption ?? this.fosPosOnCreateOption,
      searchController: searchController ?? this.searchController,
      eanController: eanController ?? this.eanController,
      discountPercentController: discountPercentController ?? this.discountPercentController,
      discountAmountController: discountAmountController ?? this.discountAmountController,
      internalCommentController: internalCommentController ?? this.internalCommentController,
      globalCommentController: globalCommentController ?? this.globalCommentController,
      isModalSheetOpen: isModalSheetOpen ?? this.isModalSheetOpen,
      printInvoice: printInvoice ?? this.printInvoice,
    );
  }
}
