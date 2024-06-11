part of 'receipt_bloc.dart';

@immutable
class ReceiptState {
  final Receipt? receipt;
  final Customer? customer;
  final Product? product;
  final List<Receipt>? listOfAllReceipts;
  final List<Receipt>? listOfFilteredReceipts; // Der State, der im presentation layer ausgegeben wird, egal ob Suchfeld leer oder nicht
  final List<Receipt> selectedReceipts; // Ausgewählte Aufträge zum löschen oder für Massenbearbeitung
  final List<Product>? listOfAllProducts;
  final AbstractFailure? firebaseFailure;
  final bool isAnyFailure;
  final bool isLoadingReceiptOnObserve;
  final bool isLoadingReceiptsOnObserve;
  final bool isLoadingAppointmentFromPrestaOnObserve;
  final bool isLoadingAppointmentsFromPrestaOnObserve;
  final bool isLoadingReceiptOnCreate;
  final bool isLoadingReceiptOnUpdate;
  final bool isLoadingReceiptOnDelete;
  final bool isLoadingReceiptOnGenerate;
  final bool isLoadingProductOnObserve;
  final bool isLoadingParcelLabelOnCreate;
  final Option<Either<AbstractFailure, Receipt>> fosReceiptOnObserveOption;
  final Option<Either<AbstractFailure, List<Receipt>>> fosReceiptsOnObserveOption;
  final Option<Either<AbstractFailure, Unit>> fosAppointmentOnObserveFromMarketplacesOption;
  final Option<Either<List<AbstractFailure>, Unit>> fosAppointmentsOnObserveFromMarketplacesOption;
  final Option<Either<AbstractFailure, Receipt>> fosReceiptOnCreateOption;
  final Option<Either<AbstractFailure, Unit>> fosReceiptOnUpdateOption;
  final Option<Either<AbstractFailure, Unit>> fosReceiptOnDeleteOption;
  final Option<Either<AbstractFailure, Receipt>> fosReceiptOnGenerateOption;
  final Option<Either<AbstractFailure, List<Receipt>>> fosReceiptsOnGenerateOption;
  final Option<Either<AbstractFailure, Product>> fosProductOnObserveOption;
  final Option<Either<AbstractFailure, ParcelTracking>> fosParcelLabelOnCreate;

  //* --- helper --- *//
  final bool isAllReceiptsSeledcted;
  final List<bool> isExpanded;
  final String receiptSearchText;
  final int tabValue;
  final ReceiptTyp receiptTyp;

  //* --- load Appointments from Marketplace helper --- *//
  final int numberOfToLoadAppointments;
  final int loadedAppointments;
  final String loadingText;

  const ReceiptState({
    this.receipt,
    this.customer,
    this.product,
    required this.listOfAllReceipts,
    required this.listOfFilteredReceipts,
    required this.selectedReceipts,
    required this.listOfAllProducts,
    required this.firebaseFailure,
    required this.isAnyFailure,
    required this.isLoadingReceiptOnObserve,
    required this.isLoadingReceiptsOnObserve,
    required this.isLoadingAppointmentFromPrestaOnObserve,
    required this.isLoadingAppointmentsFromPrestaOnObserve,
    required this.isLoadingReceiptOnCreate,
    required this.isLoadingReceiptOnUpdate,
    required this.isLoadingReceiptOnDelete,
    required this.isLoadingReceiptOnGenerate,
    required this.isLoadingProductOnObserve,
    required this.isLoadingParcelLabelOnCreate,
    required this.fosReceiptOnObserveOption,
    required this.fosReceiptsOnObserveOption,
    required this.fosAppointmentOnObserveFromMarketplacesOption,
    required this.fosAppointmentsOnObserveFromMarketplacesOption,
    required this.fosReceiptOnCreateOption,
    required this.fosReceiptOnUpdateOption,
    required this.fosReceiptOnDeleteOption,
    required this.fosReceiptOnGenerateOption,
    required this.fosReceiptsOnGenerateOption,
    required this.fosProductOnObserveOption,
    required this.fosParcelLabelOnCreate,
    required this.isAllReceiptsSeledcted,
    required this.isExpanded,
    required this.receiptSearchText,
    required this.tabValue,
    required this.receiptTyp,
    required this.numberOfToLoadAppointments,
    required this.loadedAppointments,
    required this.loadingText,
  });

  factory ReceiptState.initial() => ReceiptState(
        receipt: null,
        customer: null,
        product: null,
        listOfAllReceipts: null,
        listOfFilteredReceipts: null,
        selectedReceipts: const [],
        listOfAllProducts: null,
        firebaseFailure: null,
        isAnyFailure: false,
        isLoadingReceiptOnObserve: false,
        isLoadingReceiptsOnObserve: true,
        isLoadingAppointmentFromPrestaOnObserve: false,
        isLoadingAppointmentsFromPrestaOnObserve: false,
        isLoadingReceiptOnCreate: false,
        isLoadingReceiptOnUpdate: false,
        isLoadingReceiptOnDelete: false,
        isLoadingReceiptOnGenerate: false,
        isLoadingProductOnObserve: false,
        isLoadingParcelLabelOnCreate: false,
        fosReceiptOnObserveOption: none(),
        fosReceiptsOnObserveOption: none(),
        fosAppointmentOnObserveFromMarketplacesOption: none(),
        fosAppointmentsOnObserveFromMarketplacesOption: none(),
        fosReceiptOnCreateOption: none(),
        fosReceiptOnUpdateOption: none(),
        fosReceiptOnDeleteOption: none(),
        fosReceiptOnGenerateOption: none(),
        fosReceiptsOnGenerateOption: none(),
        fosProductOnObserveOption: none(),
        fosParcelLabelOnCreate: none(),
        isAllReceiptsSeledcted: false,
        isExpanded: const [],
        receiptSearchText: '',
        tabValue: 0,
        receiptTyp: ReceiptTyp.appointment,
        numberOfToLoadAppointments: 0,
        loadedAppointments: 0,
        loadingText: '',
      );

  ReceiptState copyWith({
    Receipt? receipt,
    Customer? customer,
    Product? product,
    List<Receipt>? listOfAllReceipts,
    List<Receipt>? listOfFilteredReceipts,
    List<Receipt>? selectedReceipts,
    List<Product>? listOfAllProducts,
    AbstractFailure? firebaseFailure,
    bool? isAnyFailure,
    bool? isLoadingReceiptOnObserve,
    bool? isLoadingReceiptsOnObserve,
    bool? isLoadingAppointmentFromPrestaOnObserve,
    bool? isLoadingAppointmentsFromPrestaOnObserve,
    bool? isLoadingReceiptOnCreate,
    bool? isLoadingReceiptOnUpdate,
    bool? isLoadingReceiptOnDelete,
    bool? isLoadingReceiptOnGenerate,
    bool? isLoadingProductOnObserve,
    bool? isLoadingParcelLabelOnCreate,
    Option<Either<AbstractFailure, Receipt>>? fosReceiptOnObserveOption,
    Option<Either<AbstractFailure, List<Receipt>>>? fosReceiptsOnObserveOption,
    Option<Either<AbstractFailure, Unit>>? fosAppointmentOnObserveFromMarketplacesOption,
    Option<Either<List<AbstractFailure>, Unit>>? fosAppointmentsOnObserveFromMarketplacesOption,
    Option<Either<AbstractFailure, Receipt>>? fosReceiptOnCreateOption,
    Option<Either<AbstractFailure, Unit>>? fosReceiptOnUpdateOption,
    Option<Either<AbstractFailure, Unit>>? fosReceiptOnDeleteOption,
    Option<Either<AbstractFailure, Receipt>>? fosReceiptOnGenerateOption,
    Option<Either<AbstractFailure, List<Receipt>>>? fosReceiptsOnGenerateOption,
    Option<Either<AbstractFailure, Product>>? fosProductOnObserveOption,
    Option<Either<AbstractFailure, ParcelTracking>>? fosParcelLabelOnCreate,
    bool? isAllReceiptsSeledcted,
    List<bool>? isExpanded,
    String? receiptSearchText,
    int? tabValue,
    ReceiptTyp? receiptTyp,
    int? numberOfToLoadAppointments,
    int? loadedAppointments,
    String? loadingText,
  }) {
    return ReceiptState(
      receipt: receipt ?? this.receipt,
      customer: customer ?? this.customer,
      product: product ?? this.product,
      listOfAllReceipts: listOfAllReceipts ?? this.listOfAllReceipts,
      listOfFilteredReceipts: listOfFilteredReceipts ?? this.listOfFilteredReceipts,
      selectedReceipts: selectedReceipts ?? this.selectedReceipts,
      listOfAllProducts: listOfAllProducts ?? this.listOfAllProducts,
      firebaseFailure: firebaseFailure ?? this.firebaseFailure,
      isAnyFailure: isAnyFailure ?? this.isAnyFailure,
      isLoadingReceiptOnObserve: isLoadingReceiptOnObserve ?? this.isLoadingReceiptOnObserve,
      isLoadingReceiptsOnObserve: isLoadingReceiptsOnObserve ?? this.isLoadingReceiptsOnObserve,
      isLoadingAppointmentFromPrestaOnObserve: isLoadingAppointmentFromPrestaOnObserve ?? this.isLoadingAppointmentFromPrestaOnObserve,
      isLoadingAppointmentsFromPrestaOnObserve: isLoadingAppointmentsFromPrestaOnObserve ?? this.isLoadingAppointmentsFromPrestaOnObserve,
      isLoadingReceiptOnCreate: isLoadingReceiptOnCreate ?? this.isLoadingReceiptOnCreate,
      isLoadingReceiptOnUpdate: isLoadingReceiptOnUpdate ?? this.isLoadingReceiptOnUpdate,
      isLoadingReceiptOnDelete: isLoadingReceiptOnDelete ?? this.isLoadingReceiptOnDelete,
      isLoadingReceiptOnGenerate: isLoadingReceiptOnGenerate ?? this.isLoadingReceiptOnGenerate,
      isLoadingProductOnObserve: isLoadingProductOnObserve ?? this.isLoadingProductOnObserve,
      isLoadingParcelLabelOnCreate: isLoadingParcelLabelOnCreate ?? this.isLoadingParcelLabelOnCreate,
      fosReceiptOnObserveOption: fosReceiptOnObserveOption ?? this.fosReceiptOnObserveOption,
      fosReceiptsOnObserveOption: fosReceiptsOnObserveOption ?? this.fosReceiptsOnObserveOption,
      fosAppointmentOnObserveFromMarketplacesOption:
          fosAppointmentOnObserveFromMarketplacesOption ?? this.fosAppointmentOnObserveFromMarketplacesOption,
      fosAppointmentsOnObserveFromMarketplacesOption:
          fosAppointmentsOnObserveFromMarketplacesOption ?? this.fosAppointmentsOnObserveFromMarketplacesOption,
      fosReceiptOnCreateOption: fosReceiptOnCreateOption ?? this.fosReceiptOnCreateOption,
      fosReceiptOnUpdateOption: fosReceiptOnUpdateOption ?? this.fosReceiptOnUpdateOption,
      fosReceiptOnDeleteOption: fosReceiptOnDeleteOption ?? this.fosReceiptOnDeleteOption,
      fosReceiptOnGenerateOption: fosReceiptOnGenerateOption ?? this.fosReceiptOnGenerateOption,
      fosReceiptsOnGenerateOption: fosReceiptsOnGenerateOption ?? this.fosReceiptsOnGenerateOption,
      fosProductOnObserveOption: fosProductOnObserveOption ?? this.fosProductOnObserveOption,
      fosParcelLabelOnCreate: fosParcelLabelOnCreate ?? this.fosParcelLabelOnCreate,
      isAllReceiptsSeledcted: isAllReceiptsSeledcted ?? this.isAllReceiptsSeledcted,
      isExpanded: isExpanded ?? this.isExpanded,
      receiptSearchText: receiptSearchText ?? this.receiptSearchText,
      tabValue: tabValue ?? this.tabValue,
      receiptTyp: receiptTyp ?? this.receiptTyp,
      numberOfToLoadAppointments: numberOfToLoadAppointments ?? this.numberOfToLoadAppointments,
      loadedAppointments: loadedAppointments ?? this.loadedAppointments,
      loadingText: loadingText ?? this.loadingText,
    );
  }
}
