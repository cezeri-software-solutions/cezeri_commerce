part of 'packing_station_bloc.dart';

@immutable
class PackingStationState {
  final Receipt? originalAppointment;
  final Receipt? appointment;
  final Customer? customer; //* Nur zum schauen, ob der Kunde Sammelrechnung will oder Einzelrechnung
  final Picklist? picklist;
  final List<Receipt>? listOfAllAppointments;
  final List<Receipt> listOfFilteredAppointments;
  final List<Receipt> selectedAppointments;
  final List<Product>? listOfProducts;
  final List<Picklist>? listOfPicklists;
  final AbstractFailure? firebaseFailure;
  final bool isAnyFailure;
  final bool isLoadingAppointmentOnObserve;
  final bool isLoadingAppointmentsOnObserve;
  final bool isLoadingAppointmentOnUpdate;
  final bool isLoadingProductsOnObserve;
  final bool isLoadingOnGenerateAppointments;
  final bool isLoadingPicklistsOnObserve;
  final bool isLoadingPicklistOnUpdate;
  final bool isLoadingPicklistOnCreate;
  final Option<Either<AbstractFailure, Receipt>> fosAppointmentOnObserveOption;
  final Option<Either<AbstractFailure, List<Receipt>>> fosAppointmentsOnObserveOption;
  final Option<Either<AbstractFailure, Unit>> fosAppointmentOnUpdateOption;
  final Option<Either<AbstractFailure, List<Product>>> fosProductsOnObserveOption;
  final Option<Either<AbstractFailure, List<Receipt>>> fosOnGenerateAppointmentsOption;
  final Option<Either<AbstractFailure, List<Picklist>>> fosPicklistsOnObserveOption;
  final Option<Either<AbstractFailure, Picklist>> fosPicklistOnCreateOption;
  final Option<Either<AbstractFailure, Unit>> fosPicklistOnUpdateOption;

  //* #### Helper #####

  final PackingStationFilter packingStationFilter;
  final bool isAllReceiptsSelected;
  final bool isCompletelyPicked; //* Wenn ein Artikel schonh komplett gepickt ist
  final bool isPartiallyEnabled;
  final TextEditingController weightController;
  final PackagingBox packagingBox;
  final List<PackagingBox> listOfPackagingBoxes;
  final PackagingBox? smallesPackagingBox;
  final double remainingVolumePercent;
  final bool shouldScan;

  const PackingStationState({
    required this.originalAppointment,
    required this.appointment,
    required this.customer,
    required this.picklist,
    required this.listOfAllAppointments,
    required this.listOfFilteredAppointments,
    required this.selectedAppointments,
    required this.listOfProducts,
    required this.listOfPicklists,
    required this.firebaseFailure,
    required this.isAnyFailure,
    required this.isLoadingAppointmentOnObserve,
    required this.isLoadingAppointmentsOnObserve,
    required this.isLoadingAppointmentOnUpdate,
    required this.isLoadingProductsOnObserve,
    required this.isLoadingOnGenerateAppointments,
    required this.isLoadingPicklistsOnObserve,
    required this.isLoadingPicklistOnUpdate,
    required this.isLoadingPicklistOnCreate,
    required this.fosAppointmentOnObserveOption,
    required this.fosAppointmentsOnObserveOption,
    required this.fosAppointmentOnUpdateOption,
    required this.fosProductsOnObserveOption,
    required this.fosOnGenerateAppointmentsOption,
    required this.fosPicklistsOnObserveOption,
    required this.fosPicklistOnCreateOption,
    required this.fosPicklistOnUpdateOption,
    required this.packingStationFilter,
    required this.isAllReceiptsSelected,
    required this.isCompletelyPicked,
    required this.isPartiallyEnabled,
    required this.weightController,
    required this.packagingBox,
    required this.listOfPackagingBoxes,
    required this.smallesPackagingBox,
    required this.remainingVolumePercent,
    required this.shouldScan,
  });

  factory PackingStationState.initial() => PackingStationState(
        originalAppointment: null,
        appointment: null,
        customer: null,
        picklist: null,
        listOfAllAppointments: null,
        listOfFilteredAppointments: const [],
        selectedAppointments: const [],
        listOfProducts: null,
        listOfPicklists: null,
        firebaseFailure: null,
        isAnyFailure: false,
        isLoadingAppointmentOnObserve: false,
        isLoadingAppointmentsOnObserve: false,
        isLoadingAppointmentOnUpdate: false,
        isLoadingProductsOnObserve: false,
        isLoadingOnGenerateAppointments: false,
        isLoadingPicklistsOnObserve: false,
        isLoadingPicklistOnUpdate: false,
        isLoadingPicklistOnCreate: false,
        fosAppointmentOnObserveOption: none(),
        fosAppointmentsOnObserveOption: none(),
        fosAppointmentOnUpdateOption: none(),
        fosProductsOnObserveOption: none(),
        fosOnGenerateAppointmentsOption: none(),
        fosPicklistsOnObserveOption: none(),
        fosPicklistOnCreateOption: none(),
        fosPicklistOnUpdateOption: none(),
        packingStationFilter: PackingStationFilter.paid,
        isAllReceiptsSelected: false,
        isCompletelyPicked: false,
        isPartiallyEnabled: false,
        weightController: TextEditingController(),
        packagingBox: PackagingBox.empty(),
        listOfPackagingBoxes: const [],
        smallesPackagingBox: null,
        remainingVolumePercent: 0,
        shouldScan: true,
      );

  PackingStationState copyWith({
    Receipt? originalAppointment,
    Receipt? appointment,
    Customer? customer,
    Picklist? picklist,
    List<Receipt>? listOfAllAppointments,
    List<Receipt>? listOfFilteredAppointments,
    List<Receipt>? selectedAppointments,
    List<Product>? listOfProducts,
    List<Picklist>? listOfPicklists,
    AbstractFailure? firebaseFailure,
    bool? isAnyFailure,
    bool? isLoadingAppointmentOnObserve,
    bool? isLoadingAppointmentsOnObserve,
    bool? isLoadingAppointmentOnUpdate,
    bool? isLoadingProductsOnObserve,
    bool? isLoadingOnGenerateAppointments,
    bool? isLoadingPicklistsOnObserve,
    bool? isLoadingPicklistOnUpdate,
    bool? isLoadingPicklistOnCreate,
    Option<Either<AbstractFailure, Receipt>>? fosAppointmentOnObserveOption,
    Option<Either<AbstractFailure, List<Receipt>>>? fosAppointmentsOnObserveOption,
    Option<Either<AbstractFailure, Unit>>? fosAppointmentOnUpdateOption,
    Option<Either<AbstractFailure, List<Product>>>? fosProductsOnObserveOption,
    Option<Either<AbstractFailure, List<Receipt>>>? fosOnGenerateAppointmentsOption,
    Option<Either<AbstractFailure, List<Picklist>>>? fosPicklistsOnObserveOption,
    Option<Either<AbstractFailure, Picklist>>? fosPicklistOnCreateOption,
    Option<Either<AbstractFailure, Unit>>? fosPicklistOnUpdateOption,
    PackingStationFilter? packingStationFilter,
    bool? isAllReceiptsSelected,
    bool? isCompletelyPicked,
    bool? isPartiallyEnabled,
    TextEditingController? weightController,
    PackagingBox? packagingBox,
    List<PackagingBox>? listOfPackagingBoxes,
    PackagingBox? smallesPackagingBox,
    double? remainingVolumePercent,
    bool? shouldScan,
  }) {
    return PackingStationState(
      originalAppointment: originalAppointment ?? this.originalAppointment,
      appointment: appointment ?? this.appointment,
      customer: customer ?? this.customer,
      picklist: picklist ?? this.picklist,
      listOfAllAppointments: listOfAllAppointments ?? this.listOfAllAppointments,
      listOfFilteredAppointments: listOfFilteredAppointments ?? this.listOfFilteredAppointments,
      selectedAppointments: selectedAppointments ?? this.selectedAppointments,
      listOfProducts: listOfProducts ?? this.listOfProducts,
      listOfPicklists: listOfPicklists ?? this.listOfPicklists,
      firebaseFailure: firebaseFailure ?? this.firebaseFailure,
      isAnyFailure: isAnyFailure ?? this.isAnyFailure,
      isLoadingAppointmentOnObserve: isLoadingAppointmentOnObserve ?? this.isLoadingAppointmentOnObserve,
      isLoadingAppointmentsOnObserve: isLoadingAppointmentsOnObserve ?? this.isLoadingAppointmentsOnObserve,
      isLoadingAppointmentOnUpdate: isLoadingAppointmentOnUpdate ?? this.isLoadingAppointmentOnUpdate,
      isLoadingProductsOnObserve: isLoadingProductsOnObserve ?? this.isLoadingProductsOnObserve,
      isLoadingOnGenerateAppointments: isLoadingOnGenerateAppointments ?? this.isLoadingOnGenerateAppointments,
      isLoadingPicklistsOnObserve: isLoadingPicklistsOnObserve ?? this.isLoadingPicklistsOnObserve,
      isLoadingPicklistOnUpdate: isLoadingPicklistOnUpdate ?? this.isLoadingPicklistOnUpdate,
      isLoadingPicklistOnCreate: isLoadingPicklistOnCreate ?? this.isLoadingPicklistOnCreate,
      fosAppointmentOnObserveOption: fosAppointmentOnObserveOption ?? this.fosAppointmentOnObserveOption,
      fosAppointmentsOnObserveOption: fosAppointmentsOnObserveOption ?? this.fosAppointmentsOnObserveOption,
      fosAppointmentOnUpdateOption: fosAppointmentOnUpdateOption ?? this.fosAppointmentOnUpdateOption,
      fosProductsOnObserveOption: fosProductsOnObserveOption ?? this.fosProductsOnObserveOption,
      fosOnGenerateAppointmentsOption: fosOnGenerateAppointmentsOption ?? this.fosOnGenerateAppointmentsOption,
      fosPicklistsOnObserveOption: fosPicklistsOnObserveOption ?? this.fosPicklistsOnObserveOption,
      fosPicklistOnCreateOption: fosPicklistOnCreateOption ?? this.fosPicklistOnCreateOption,
      fosPicklistOnUpdateOption: fosPicklistOnUpdateOption ?? this.fosPicklistOnUpdateOption,
      packingStationFilter: packingStationFilter ?? this.packingStationFilter,
      isAllReceiptsSelected: isAllReceiptsSelected ?? this.isAllReceiptsSelected,
      isCompletelyPicked: isCompletelyPicked ?? this.isCompletelyPicked,
      isPartiallyEnabled: isPartiallyEnabled ?? this.isPartiallyEnabled,
      weightController: weightController ?? this.weightController,
      packagingBox: packagingBox ?? this.packagingBox,
      listOfPackagingBoxes: listOfPackagingBoxes ?? this.listOfPackagingBoxes,
      smallesPackagingBox: smallesPackagingBox ?? this.smallesPackagingBox,
      remainingVolumePercent: remainingVolumePercent ?? this.remainingVolumePercent,
      shouldScan: shouldScan ?? this.shouldScan,
    );
  }
}
