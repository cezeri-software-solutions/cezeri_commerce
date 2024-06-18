part of 'receipt_detail_bloc.dart';

class ReceiptDetailState {
  final Receipt? receipt;
  final MainSettings? mainSettings;
  final List<AbstractMarketplace>? listOfMarketplaces;
  final Product? productByEan;
  final AbstractFailure? databaseFailure;
  final AbstractFailure? marketplacesFailure;
  final bool isLoadingReceiptOnObserve;
  final bool isLoadingReceiptOnUpdate;
  final bool isLoadingReceiptOnCreate;
  final bool isLoadingReceiptOnDelete;
  final bool isLoadingMarketplacesOnObserve;
  final bool isLoadingProductOnObserve;
  final bool isLoadingParcelLabelOnCreate;
  final Option<Either<AbstractFailure, Receipt>> fosReceiptOnObserveOption;
  final Option<Either<AbstractFailure, Unit>> fosReceiptOnUpdateOption;
  final Option<Either<AbstractFailure, Receipt>> fosReceiptOnCreateOption;
  final Option<Either<AbstractFailure, Unit>> fosReceiptOnDeleteOption;
  final Option<Either<AbstractFailure, Product>> fosProductOnObserveOption;
  final Option<Either<AbstractFailure, ParcelTracking>> fosParcelLabelOnCreate;

  const ReceiptDetailState({
    required this.receipt,
    required this.mainSettings,
    required this.listOfMarketplaces,
    required this.productByEan,
    required this.databaseFailure,
    required this.marketplacesFailure,
    required this.isLoadingReceiptOnObserve,
    required this.isLoadingReceiptOnUpdate,
    required this.isLoadingReceiptOnCreate,
    required this.isLoadingReceiptOnDelete,
    required this.isLoadingMarketplacesOnObserve,
    required this.isLoadingProductOnObserve,
    required this.isLoadingParcelLabelOnCreate,
    required this.fosReceiptOnObserveOption,
    required this.fosReceiptOnUpdateOption,
    required this.fosReceiptOnCreateOption,
    required this.fosReceiptOnDeleteOption,
    required this.fosProductOnObserveOption,
    required this.fosParcelLabelOnCreate,
  });

  factory ReceiptDetailState.initial() {
    return ReceiptDetailState(
      receipt: null,
      mainSettings: null,
      listOfMarketplaces: null,
      productByEan: null,
      databaseFailure: null,
      marketplacesFailure: null,
      isLoadingReceiptOnObserve: false,
      isLoadingReceiptOnUpdate: false,
      isLoadingReceiptOnCreate: false,
      isLoadingReceiptOnDelete: false,
      isLoadingMarketplacesOnObserve: false,
      isLoadingProductOnObserve: false,
      isLoadingParcelLabelOnCreate: false,
      fosReceiptOnObserveOption: none(),
      fosReceiptOnUpdateOption: none(),
      fosReceiptOnCreateOption: none(),
      fosReceiptOnDeleteOption: none(),
      fosProductOnObserveOption: none(),
      fosParcelLabelOnCreate: none(),
    );
  }

  ReceiptDetailState copyWith({
    Receipt? receipt,
    MainSettings? mainSettings,
    List<AbstractMarketplace>? listOfMarketplaces,
    Product? productByEan,
    AbstractFailure? databaseFailure,
    AbstractFailure? marketplacesFailure,
    bool? isLoadingReceiptOnObserve,
    bool? isLoadingReceiptOnUpdate,
    bool? isLoadingReceiptOnCreate,
    bool? isLoadingReceiptOnDelete,
    bool? isLoadingMarketplacesOnObserve,
    bool? isLoadingProductOnObserve,
    bool? isLoadingParcelLabelOnCreate,
    Option<Either<AbstractFailure, Receipt>>? fosReceiptOnObserveOption,
    Option<Either<AbstractFailure, Unit>>? fosReceiptOnUpdateOption,
    Option<Either<AbstractFailure, Receipt>>? fosReceiptOnCreateOption,
    Option<Either<AbstractFailure, Unit>>? fosReceiptOnDeleteOption,
    Option<Either<AbstractFailure, Product>>? fosProductOnObserveOption,
    Option<Either<AbstractFailure, ParcelTracking>>? fosParcelLabelOnCreate,
  }) {
    return ReceiptDetailState(
      receipt: receipt ?? this.receipt,
      mainSettings: mainSettings ?? this.mainSettings,
      listOfMarketplaces: listOfMarketplaces ?? this.listOfMarketplaces,
      productByEan: productByEan ?? this.productByEan,
      databaseFailure: databaseFailure ?? this.databaseFailure,
      marketplacesFailure: marketplacesFailure ?? this.marketplacesFailure,
      isLoadingReceiptOnObserve: isLoadingReceiptOnObserve ?? this.isLoadingReceiptOnObserve,
      isLoadingReceiptOnUpdate: isLoadingReceiptOnUpdate ?? this.isLoadingReceiptOnUpdate,
      isLoadingReceiptOnCreate: isLoadingReceiptOnCreate ?? this.isLoadingReceiptOnCreate,
      isLoadingReceiptOnDelete: isLoadingReceiptOnDelete ?? this.isLoadingReceiptOnDelete,
      isLoadingMarketplacesOnObserve: isLoadingMarketplacesOnObserve ?? this.isLoadingMarketplacesOnObserve,
      isLoadingProductOnObserve: isLoadingProductOnObserve ?? this.isLoadingProductOnObserve,
      isLoadingParcelLabelOnCreate: isLoadingParcelLabelOnCreate ?? this.isLoadingParcelLabelOnCreate,
      fosReceiptOnObserveOption: fosReceiptOnObserveOption ?? this.fosReceiptOnObserveOption,
      fosReceiptOnUpdateOption: fosReceiptOnUpdateOption ?? this.fosReceiptOnUpdateOption,
      fosReceiptOnCreateOption: fosReceiptOnCreateOption ?? this.fosReceiptOnCreateOption,
      fosReceiptOnDeleteOption: fosReceiptOnDeleteOption ?? this.fosReceiptOnDeleteOption,
      fosProductOnObserveOption: fosProductOnObserveOption ?? this.fosProductOnObserveOption,
      fosParcelLabelOnCreate: fosParcelLabelOnCreate ?? this.fosParcelLabelOnCreate,
    );
  }
}
