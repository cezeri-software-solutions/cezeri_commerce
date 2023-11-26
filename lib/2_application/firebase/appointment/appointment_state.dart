part of 'appointment_bloc.dart';

@immutable
class AppointmentState {
  final Receipt? receipt;
  final Customer? customer;
  final List<Receipt>? listOfAllReceipts;
  final List<Receipt>? listOfFilteredReceipts; // Der State, der im presentation layer ausgegeben wird, egal ob Suchfeld leer oder nicht
  final List<Receipt> selectedReceipts; // Ausgewählte Aufträge zum löschen oder für Massenbearbeitung
  final FirebaseFailure? firebaseFailure;
  final bool isAnyFailure;
  final bool isLoadingReceiptOnObserve;
  final bool isLoadingReceiptsOnObserve;
  final bool isLoadingAppointmentsFromPrestaOnObserve;
  final bool isLoadingReceiptOnCreate;
  final bool isLoadingReceiptOnUpdate;
  final bool isLoadingReceiptOnDelete;
  final bool isLoadingReceiptOnGenerate;
  final Option<Either<FirebaseFailure, Receipt>> fosReceiptOnObserveOption;
  final Option<Either<FirebaseFailure, List<Receipt>>> fosReceiptsOnObserveOption;
  final Option<Either<FirebaseFailure, List<Receipt>>> fosAppointmentsOnObserveFromPrestaOption;
  final Option<Either<AbstractFailure, Unit>> fosAppointmentsOnObserveFromMarketplacesOption;
  final Option<Either<FirebaseFailure, Receipt>> fosReceiptOnCreateOption;
  final Option<Either<FirebaseFailure, Unit>> fosReceiptOnUpdateOption;
  final Option<Either<FirebaseFailure, Unit>> fosReceiptOnDeleteOption;
  final Option<Either<FirebaseFailure, Receipt>> fosReceiptOnGenerateOption;
  final Option<Either<FirebaseFailure, List<Receipt>>> fosReceiptsOnGenerateOption;

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
    required this.listOfAllReceipts,
    required this.listOfFilteredReceipts,
    required this.selectedReceipts,
    required this.firebaseFailure,
    required this.isAnyFailure,
    required this.isLoadingReceiptOnObserve,
    required this.isLoadingReceiptsOnObserve,
    required this.isLoadingAppointmentsFromPrestaOnObserve,
    required this.isLoadingReceiptOnCreate,
    required this.isLoadingReceiptOnUpdate,
    required this.isLoadingReceiptOnDelete,
    required this.isLoadingReceiptOnGenerate,
    required this.fosReceiptOnObserveOption,
    required this.fosReceiptsOnObserveOption,
    required this.fosAppointmentsOnObserveFromPrestaOption,
    required this.fosAppointmentsOnObserveFromMarketplacesOption,
    required this.fosReceiptOnCreateOption,
    required this.fosReceiptOnUpdateOption,
    required this.fosReceiptOnDeleteOption,
    required this.fosReceiptOnGenerateOption,
    required this.fosReceiptsOnGenerateOption,
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
        listOfAllReceipts: null,
        listOfFilteredReceipts: null,
        selectedReceipts: const [],
        firebaseFailure: null,
        isAnyFailure: false,
        isLoadingReceiptOnObserve: false,
        isLoadingReceiptsOnObserve: true,
        isLoadingAppointmentsFromPrestaOnObserve: false,
        isLoadingReceiptOnCreate: false,
        isLoadingReceiptOnUpdate: false,
        isLoadingReceiptOnDelete: false,
        isLoadingReceiptOnGenerate: false,
        fosReceiptOnObserveOption: none(),
        fosReceiptsOnObserveOption: none(),
        fosAppointmentsOnObserveFromPrestaOption: none(),
        fosAppointmentsOnObserveFromMarketplacesOption: none(),
        fosReceiptOnCreateOption: none(),
        fosReceiptOnUpdateOption: none(),
        fosReceiptOnDeleteOption: none(),
        fosReceiptOnGenerateOption: none(),
        fosReceiptsOnGenerateOption: none(),
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
    List<Receipt>? listOfAllReceipts,
    List<Receipt>? listOfFilteredReceipts,
    List<Receipt>? selectedReceipts,
    FirebaseFailure? firebaseFailure,
    bool? isAnyFailure,
    bool? isLoadingReceiptOnObserve,
    bool? isLoadingReceiptsOnObserve,
    bool? isLoadingAppointmentsFromPrestaOnObserve,
    bool? isLoadingReceiptOnCreate,
    bool? isLoadingReceiptOnUpdate,
    bool? isLoadingReceiptOnDelete,
    bool? isLoadingReceiptOnGenerate,
    Option<Either<FirebaseFailure, Receipt>>? fosReceiptOnObserveOption,
    Option<Either<FirebaseFailure, List<Receipt>>>? fosReceiptsOnObserveOption,
    Option<Either<FirebaseFailure, List<Receipt>>>? fosAppointmentsOnObserveFromPrestaOption,
    Option<Either<AbstractFailure, Unit>>? fosAppointmentsOnObserveFromMarketplacesOption,
    Option<Either<FirebaseFailure, Receipt>>? fosReceiptOnCreateOption,
    Option<Either<FirebaseFailure, Unit>>? fosReceiptOnUpdateOption,
    Option<Either<FirebaseFailure, Unit>>? fosReceiptOnDeleteOption,
    Option<Either<FirebaseFailure, Receipt>>? fosReceiptOnGenerateOption,
    Option<Either<FirebaseFailure, List<Receipt>>>? fosReceiptsOnGenerateOption,
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
      listOfAllReceipts: listOfAllReceipts ?? this.listOfAllReceipts,
      listOfFilteredReceipts: listOfFilteredReceipts ?? this.listOfFilteredReceipts,
      selectedReceipts: selectedReceipts ?? this.selectedReceipts,
      firebaseFailure: firebaseFailure ?? this.firebaseFailure,
      isAnyFailure: isAnyFailure ?? this.isAnyFailure,
      isLoadingReceiptOnObserve: isLoadingReceiptOnObserve ?? this.isLoadingReceiptOnObserve,
      isLoadingReceiptsOnObserve: isLoadingReceiptsOnObserve ?? this.isLoadingReceiptsOnObserve,
      isLoadingAppointmentsFromPrestaOnObserve: isLoadingAppointmentsFromPrestaOnObserve ?? this.isLoadingAppointmentsFromPrestaOnObserve,
      isLoadingReceiptOnCreate: isLoadingReceiptOnCreate ?? this.isLoadingReceiptOnCreate,
      isLoadingReceiptOnUpdate: isLoadingReceiptOnUpdate ?? this.isLoadingReceiptOnUpdate,
      isLoadingReceiptOnDelete: isLoadingReceiptOnDelete ?? this.isLoadingReceiptOnDelete,
      isLoadingReceiptOnGenerate: isLoadingReceiptOnGenerate ?? this.isLoadingReceiptOnGenerate,
      fosReceiptOnObserveOption: fosReceiptOnObserveOption ?? this.fosReceiptOnObserveOption,
      fosReceiptsOnObserveOption: fosReceiptsOnObserveOption ?? this.fosReceiptsOnObserveOption,
      fosAppointmentsOnObserveFromPrestaOption: fosAppointmentsOnObserveFromPrestaOption ?? this.fosAppointmentsOnObserveFromPrestaOption,
      fosAppointmentsOnObserveFromMarketplacesOption:
          fosAppointmentsOnObserveFromMarketplacesOption ?? this.fosAppointmentsOnObserveFromMarketplacesOption,
      fosReceiptOnCreateOption: fosReceiptOnCreateOption ?? this.fosReceiptOnCreateOption,
      fosReceiptOnUpdateOption: fosReceiptOnUpdateOption ?? this.fosReceiptOnUpdateOption,
      fosReceiptOnDeleteOption: fosReceiptOnDeleteOption ?? this.fosReceiptOnDeleteOption,
      fosReceiptOnGenerateOption: fosReceiptOnGenerateOption ?? this.fosReceiptOnGenerateOption,
      fosReceiptsOnGenerateOption: fosReceiptsOnGenerateOption ?? this.fosReceiptsOnGenerateOption,
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
