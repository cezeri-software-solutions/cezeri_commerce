part of 'receipt_detail_bloc.dart';

class ReceiptDetailState {
  final Receipt? receipt;
  final MainSettings? mainSettings;
  final List<AbstractMarketplace>? listOfMarketplaces;
  final List<Receipt>? listOfSameReceipts;
  final Product? productByEan;
  final AbstractFailure? databaseFailure;
  final AbstractFailure? marketplacesFailure;
  final AbstractFailure? sameReceiptsFailure;
  final bool isLoadingReceiptOnObserve;
  final bool isLoadingReceiptOnUpdate;
  final bool isLoadingReceiptOnCreate;
  final bool isLoadingReceiptOnDelete;
  final bool isLoadingMarketplacesOnObserve;
  final bool isLoadingProductOnObserve;
  final bool isLoadingParcelLabelOnCreate;
  final bool isLoadingSameReceiptsOnObserve;
  final Option<Either<AbstractFailure, Receipt>> fosReceiptOnObserveOption;
  final Option<Either<AbstractFailure, Unit>> fosReceiptOnUpdateOption;
  final Option<Either<AbstractFailure, Receipt>> fosReceiptOnCreateOption;
  final Option<Either<AbstractFailure, Unit>> fosReceiptOnDeleteOption;
  final Option<Either<AbstractFailure, Product>> fosProductOnObserveOption;
  final Option<Either<AbstractFailure, ParcelTracking>> fosParcelLabelOnCreate;
  final Option<bool> triggerListenerAfterSetEmptyReceipt;

  //* Controller
  final TextEditingController internalCommentController;
  final TextEditingController globalCommentController;

  const ReceiptDetailState({
    required this.receipt,
    required this.mainSettings,
    required this.listOfMarketplaces,
    required this.listOfSameReceipts,
    required this.productByEan,
    required this.databaseFailure,
    required this.marketplacesFailure,
    required this.sameReceiptsFailure,
    required this.isLoadingReceiptOnObserve,
    required this.isLoadingReceiptOnUpdate,
    required this.isLoadingReceiptOnCreate,
    required this.isLoadingReceiptOnDelete,
    required this.isLoadingMarketplacesOnObserve,
    required this.isLoadingProductOnObserve,
    required this.isLoadingParcelLabelOnCreate,
    required this.isLoadingSameReceiptsOnObserve,
    required this.fosReceiptOnObserveOption,
    required this.fosReceiptOnUpdateOption,
    required this.fosReceiptOnCreateOption,
    required this.fosReceiptOnDeleteOption,
    required this.fosProductOnObserveOption,
    required this.fosParcelLabelOnCreate,
    required this.triggerListenerAfterSetEmptyReceipt,
    required this.internalCommentController,
    required this.globalCommentController,
  });

  factory ReceiptDetailState.initial() {
    return ReceiptDetailState(
      receipt: null,
      mainSettings: null,
      listOfMarketplaces: null,
      listOfSameReceipts: null,
      productByEan: null,
      databaseFailure: null,
      marketplacesFailure: null,
      sameReceiptsFailure: null,
      isLoadingReceiptOnObserve: false,
      isLoadingReceiptOnUpdate: false,
      isLoadingReceiptOnCreate: false,
      isLoadingReceiptOnDelete: false,
      isLoadingMarketplacesOnObserve: false,
      isLoadingProductOnObserve: false,
      isLoadingParcelLabelOnCreate: false,
      isLoadingSameReceiptsOnObserve: false,
      fosReceiptOnObserveOption: none(),
      fosReceiptOnUpdateOption: none(),
      fosReceiptOnCreateOption: none(),
      fosReceiptOnDeleteOption: none(),
      fosProductOnObserveOption: none(),
      fosParcelLabelOnCreate: none(),
      triggerListenerAfterSetEmptyReceipt: none(),
      internalCommentController: TextEditingController(),
      globalCommentController: TextEditingController(),
    );
  }

  ReceiptDetailState copyWith({
    Receipt? receipt,
    MainSettings? mainSettings,
    List<AbstractMarketplace>? listOfMarketplaces,
    List<Receipt>? listOfSameReceipts,
    Product? productByEan,
    AbstractFailure? databaseFailure,
    AbstractFailure? marketplacesFailure,
    AbstractFailure? sameReceiptsFailure,
    bool? isLoadingReceiptOnObserve,
    bool? isLoadingReceiptOnUpdate,
    bool? isLoadingReceiptOnCreate,
    bool? isLoadingReceiptOnDelete,
    bool? isLoadingMarketplacesOnObserve,
    bool? isLoadingProductOnObserve,
    bool? isLoadingParcelLabelOnCreate,
    bool? isLoadingSameReceiptsOnObserve,
    Option<Either<AbstractFailure, Receipt>>? fosReceiptOnObserveOption,
    Option<Either<AbstractFailure, Unit>>? fosReceiptOnUpdateOption,
    Option<Either<AbstractFailure, Receipt>>? fosReceiptOnCreateOption,
    Option<Either<AbstractFailure, Unit>>? fosReceiptOnDeleteOption,
    Option<Either<AbstractFailure, Product>>? fosProductOnObserveOption,
    Option<Either<AbstractFailure, ParcelTracking>>? fosParcelLabelOnCreate,
    Option<bool>? triggerListenerAfterSetEmptyReceipt,
    TextEditingController? internalCommentController,
    TextEditingController? globalCommentController,
  }) {
    return ReceiptDetailState(
      receipt: receipt ?? this.receipt,
      mainSettings: mainSettings ?? this.mainSettings,
      listOfMarketplaces: listOfMarketplaces ?? this.listOfMarketplaces,
      listOfSameReceipts: listOfSameReceipts ?? this.listOfSameReceipts,
      productByEan: productByEan ?? this.productByEan,
      databaseFailure: databaseFailure ?? this.databaseFailure,
      marketplacesFailure: marketplacesFailure ?? this.marketplacesFailure,
      sameReceiptsFailure: sameReceiptsFailure ?? this.sameReceiptsFailure,
      isLoadingReceiptOnObserve: isLoadingReceiptOnObserve ?? this.isLoadingReceiptOnObserve,
      isLoadingReceiptOnUpdate: isLoadingReceiptOnUpdate ?? this.isLoadingReceiptOnUpdate,
      isLoadingReceiptOnCreate: isLoadingReceiptOnCreate ?? this.isLoadingReceiptOnCreate,
      isLoadingReceiptOnDelete: isLoadingReceiptOnDelete ?? this.isLoadingReceiptOnDelete,
      isLoadingMarketplacesOnObserve: isLoadingMarketplacesOnObserve ?? this.isLoadingMarketplacesOnObserve,
      isLoadingProductOnObserve: isLoadingProductOnObserve ?? this.isLoadingProductOnObserve,
      isLoadingParcelLabelOnCreate: isLoadingParcelLabelOnCreate ?? this.isLoadingParcelLabelOnCreate,
      isLoadingSameReceiptsOnObserve: isLoadingSameReceiptsOnObserve ?? this.isLoadingSameReceiptsOnObserve,
      fosReceiptOnObserveOption: fosReceiptOnObserveOption ?? this.fosReceiptOnObserveOption,
      fosReceiptOnUpdateOption: fosReceiptOnUpdateOption ?? this.fosReceiptOnUpdateOption,
      fosReceiptOnCreateOption: fosReceiptOnCreateOption ?? this.fosReceiptOnCreateOption,
      fosReceiptOnDeleteOption: fosReceiptOnDeleteOption ?? this.fosReceiptOnDeleteOption,
      fosProductOnObserveOption: fosProductOnObserveOption ?? this.fosProductOnObserveOption,
      fosParcelLabelOnCreate: fosParcelLabelOnCreate ?? this.fosParcelLabelOnCreate,
      triggerListenerAfterSetEmptyReceipt: triggerListenerAfterSetEmptyReceipt ?? this.triggerListenerAfterSetEmptyReceipt,
      internalCommentController: internalCommentController ?? this.internalCommentController,
      globalCommentController: globalCommentController ?? this.globalCommentController,
    );
  }
}
