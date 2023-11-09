part of 'packing_station_bloc.dart';

@immutable
class PackingStationState {
  final Receipt? originalAppointment;
  final Receipt? appointment;
  final Customer? customer; //* Nur zum schauen, ob der Kunde Sammelrechnung will oder Einzelrechnung
  final List<Receipt>? listOfAllAppointments;
  final List<Receipt> listOfFilteredAppointments;
  final List<Receipt> selectedAppointments;
  final List<Product>? listOfProducts;
  final FirebaseFailure? firebaseFailure;
  final bool isAnyFailure;
  final bool isLoadingAppointmentOnObserve;
  final bool isLoadingAppointmentsOnObserve;
  final bool isLoadingAppointmentOnUpdate;
  final bool isLoadingProductsOnObserve;
  final bool isLoadingOnGenerateAppointments;
  final Option<Either<FirebaseFailure, Receipt>> fosAppointmentOnObserveOption;
  final Option<Either<FirebaseFailure, List<Receipt>>> fosAppointmentsOnObserveOption;
  final Option<Either<FirebaseFailure, Unit>> fosAppointmentOnUpdateOption;
  final Option<Either<FirebaseFailure, List<Product>>> fosProductsOnObserveOption;
  final Option<Either<FirebaseFailure, List<Receipt>>> fosOnGenerateAppointmentsOption;

  //* #### Helper #####

  final PackingStationFilter packingStationFilter;
  final bool isAllReceiptsSelected;
  final bool isCompletelyPicked; //* Wenn ein Artikel schonh komplett gepickt ist
  final bool isPartiallyEnabled;
  final TextEditingController barcodeScannerController;

  const PackingStationState({
    required this.originalAppointment,
    required this.appointment,
    required this.customer,
    required this.listOfAllAppointments,
    required this.listOfFilteredAppointments,
    required this.selectedAppointments,
    required this.listOfProducts,
    required this.firebaseFailure,
    required this.isAnyFailure,
    required this.isLoadingAppointmentOnObserve,
    required this.isLoadingAppointmentsOnObserve,
    required this.isLoadingAppointmentOnUpdate,
    required this.isLoadingProductsOnObserve,
    required this.isLoadingOnGenerateAppointments,
    required this.fosAppointmentOnObserveOption,
    required this.fosAppointmentsOnObserveOption,
    required this.fosAppointmentOnUpdateOption,
    required this.fosProductsOnObserveOption,
    required this.fosOnGenerateAppointmentsOption,
    required this.packingStationFilter,
    required this.isAllReceiptsSelected,
    required this.isCompletelyPicked,
    required this.isPartiallyEnabled,
    required this.barcodeScannerController,
  });

  factory PackingStationState.initial() => PackingStationState(
        originalAppointment: null,
        appointment: null,
        customer: null,
        listOfAllAppointments: null,
        listOfFilteredAppointments: const [],
        selectedAppointments: const [],
        listOfProducts: null,
        firebaseFailure: null,
        isAnyFailure: false,
        isLoadingAppointmentOnObserve: false,
        isLoadingAppointmentsOnObserve: false,
        isLoadingAppointmentOnUpdate: false,
        isLoadingProductsOnObserve: false,
        isLoadingOnGenerateAppointments: false,
        fosAppointmentOnObserveOption: none(),
        fosAppointmentsOnObserveOption: none(),
        fosAppointmentOnUpdateOption: none(),
        fosProductsOnObserveOption: none(),
        fosOnGenerateAppointmentsOption: none(),
        packingStationFilter: PackingStationFilter.paid,
        isAllReceiptsSelected: false,
        isCompletelyPicked: false,
        isPartiallyEnabled: false,
        barcodeScannerController: TextEditingController(),
      );

  PackingStationState copyWith({
    Receipt? originalAppointment,
    Receipt? appointment,
    Customer? customer,
    List<Receipt>? listOfAllAppointments,
    List<Receipt>? listOfFilteredAppointments,
    List<Receipt>? selectedAppointments,
    List<Product>? listOfProducts,
    FirebaseFailure? firebaseFailure,
    bool? isAnyFailure,
    bool? isLoadingAppointmentOnObserve,
    bool? isLoadingAppointmentsOnObserve,
    bool? isLoadingAppointmentOnUpdate,
    bool? isLoadingProductsOnObserve,
    bool? isLoadingOnGenerateAppointments,
    Option<Either<FirebaseFailure, Receipt>>? fosAppointmentOnObserveOption,
    Option<Either<FirebaseFailure, List<Receipt>>>? fosAppointmentsOnObserveOption,
    Option<Either<FirebaseFailure, Unit>>? fosAppointmentOnUpdateOption,
    Option<Either<FirebaseFailure, List<Product>>>? fosProductsOnObserveOption,
    Option<Either<FirebaseFailure, List<Receipt>>>? fosOnGenerateAppointmentsOption,
    PackingStationFilter? packingStationFilter,
    bool? isAllReceiptsSelected,
    bool? isCompletelyPicked,
    bool? isPartiallyEnabled,
    TextEditingController? barcodeScannerController,
  }) {
    return PackingStationState(
      originalAppointment: originalAppointment ?? this.originalAppointment,
      appointment: appointment ?? this.appointment,
      customer: customer ?? this.customer,
      listOfAllAppointments: listOfAllAppointments ?? this.listOfAllAppointments,
      listOfFilteredAppointments: listOfFilteredAppointments ?? this.listOfFilteredAppointments,
      selectedAppointments: selectedAppointments ?? this.selectedAppointments,
      listOfProducts: listOfProducts ?? this.listOfProducts,
      firebaseFailure: firebaseFailure ?? this.firebaseFailure,
      isAnyFailure: isAnyFailure ?? this.isAnyFailure,
      isLoadingAppointmentOnObserve: isLoadingAppointmentOnObserve ?? this.isLoadingAppointmentOnObserve,
      isLoadingAppointmentsOnObserve: isLoadingAppointmentsOnObserve ?? this.isLoadingAppointmentsOnObserve,
      isLoadingAppointmentOnUpdate: isLoadingAppointmentOnUpdate ?? this.isLoadingAppointmentOnUpdate,
      isLoadingProductsOnObserve: isLoadingProductsOnObserve ?? this.isLoadingProductsOnObserve,
      isLoadingOnGenerateAppointments: isLoadingOnGenerateAppointments ?? this.isLoadingOnGenerateAppointments,
      fosAppointmentOnObserveOption: fosAppointmentOnObserveOption ?? this.fosAppointmentOnObserveOption,
      fosAppointmentsOnObserveOption: fosAppointmentsOnObserveOption ?? this.fosAppointmentsOnObserveOption,
      fosAppointmentOnUpdateOption: fosAppointmentOnUpdateOption ?? this.fosAppointmentOnUpdateOption,
      fosProductsOnObserveOption: fosProductsOnObserveOption ?? this.fosProductsOnObserveOption,
      fosOnGenerateAppointmentsOption: fosOnGenerateAppointmentsOption ?? this.fosOnGenerateAppointmentsOption,
      packingStationFilter: packingStationFilter ?? this.packingStationFilter,
      isAllReceiptsSelected: isAllReceiptsSelected ?? this.isAllReceiptsSelected,
      isCompletelyPicked: isCompletelyPicked ?? this.isCompletelyPicked,
      isPartiallyEnabled: isPartiallyEnabled ?? this.isPartiallyEnabled,
      barcodeScannerController: barcodeScannerController ?? this.barcodeScannerController,
    );
  }
}
