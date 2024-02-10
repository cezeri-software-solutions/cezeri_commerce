part of 'appointment_bloc.dart';

@immutable
class AppointmentState {
  final Receipt? receipt;
  final Customer? customer;
  final Product? product;
  final List<Receipt>? listOfAllReceipts;
  final List<Receipt>? listOfFilteredReceipts; // Der State, der im presentation layer ausgegeben wird, egal ob Suchfeld leer oder nicht
  final List<Receipt> selectedReceipts; // Ausgewählte Aufträge zum löschen oder für Massenbearbeitung
  final List<Product>? listOfAllProducts;
  final FirebaseFailure? firebaseFailure;
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
  final bool isLoadingProductsOnObserve;
  final bool isLoadingParcelLabelOnCreate;
  final Option<Either<FirebaseFailure, Receipt>> fosReceiptOnObserveOption;
  final Option<Either<FirebaseFailure, List<Receipt>>> fosReceiptsOnObserveOption;
  final Option<Either<AbstractFailure, Unit>> fosAppointmentOnObserveFromMarketplacesOption;
  final Option<Either<AbstractFailure, Unit>> fosAppointmentsOnObserveFromMarketplacesOption;
  final Option<Either<FirebaseFailure, Receipt>> fosReceiptOnCreateOption;
  final Option<Either<FirebaseFailure, Unit>> fosReceiptOnUpdateOption;
  final Option<Either<AbstractFailure, Unit>> fosReceiptOnDeleteOption;
  final Option<Either<FirebaseFailure, Receipt>> fosReceiptOnGenerateOption;
  final Option<Either<FirebaseFailure, List<Receipt>>> fosReceiptsOnGenerateOption;
  final Option<Either<FirebaseFailure, Product>> fosProductOnObserveOption;
  final Option<Either<FirebaseFailure, List<Product>>> fosProductsOnObserveOption;
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

  const AppointmentState({
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
    required this.isLoadingProductsOnObserve,
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
    required this.fosProductsOnObserveOption,
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

  factory AppointmentState.initial() => AppointmentState(
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
        isLoadingProductsOnObserve: false,
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
        fosProductsOnObserveOption: none(),
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

  AppointmentState copyWith({
    Receipt? receipt,
    Customer? customer,
    Product? product,
    List<Receipt>? listOfAllReceipts,
    List<Receipt>? listOfFilteredReceipts,
    List<Receipt>? selectedReceipts,
    List<Product>? listOfAllProducts,
    FirebaseFailure? firebaseFailure,
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
    bool? isLoadingProductsOnObserve,
    bool? isLoadingParcelLabelOnCreate,
    Option<Either<FirebaseFailure, Receipt>>? fosReceiptOnObserveOption,
    Option<Either<FirebaseFailure, List<Receipt>>>? fosReceiptsOnObserveOption,
    Option<Either<AbstractFailure, Unit>>? fosAppointmentOnObserveFromMarketplacesOption,
    Option<Either<AbstractFailure, Unit>>? fosAppointmentsOnObserveFromMarketplacesOption,
    Option<Either<FirebaseFailure, Receipt>>? fosReceiptOnCreateOption,
    Option<Either<FirebaseFailure, Unit>>? fosReceiptOnUpdateOption,
    Option<Either<AbstractFailure, Unit>>? fosReceiptOnDeleteOption,
    Option<Either<FirebaseFailure, Receipt>>? fosReceiptOnGenerateOption,
    Option<Either<FirebaseFailure, List<Receipt>>>? fosReceiptsOnGenerateOption,
    Option<Either<FirebaseFailure, Product>>? fosProductOnObserveOption,
    Option<Either<FirebaseFailure, List<Product>>>? fosProductsOnObserveOption,
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
    return AppointmentState(
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
      isLoadingProductsOnObserve: isLoadingProductsOnObserve ?? this.isLoadingProductsOnObserve,
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
      fosProductsOnObserveOption: fosProductsOnObserveOption ?? this.fosProductsOnObserveOption,
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
