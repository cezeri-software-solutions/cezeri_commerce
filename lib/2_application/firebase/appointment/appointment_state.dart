part of 'appointment_bloc.dart';

@immutable
class AppointmentState {
  final Receipt? appointment;
  final Customer? customer;
  final List<Receipt>? listOfAllAppointments;
  final List<Receipt>? listOfFilteredAppointments; // Der State, der im presentation layer ausgegeben wird, egal ob Suchfeld leer oder nicht
  final List<Receipt> selectedAppointments; // Ausgewählte Aufträge zum löschen oder für Massenbearbeitung
  final FirebaseFailure? firebaseFailure;
  final bool isAnyFailure;
  final bool isLoadingAppointmentOnObserve;
  final bool isLoadingAppointmentsOnObserve;
  final bool isLoadingAppointmentsFromPrestaOnObserve;
  final bool isLoadingAppointmentOnCreate;
  final bool isLoadingAppointmentOnUpdate;
  final bool isLoadingAppointmentOnDelete;
  final Option<Either<FirebaseFailure, Receipt>> fosAppointmentOnObserveOption;
  final Option<Either<FirebaseFailure, List<Receipt>>> fosAppointmentsOnObserveOption;
  final Option<Either<FirebaseFailure, List<Receipt>>> fosAppointmentsOnObserveFromPrestaOption;
  final Option<Either<FirebaseFailure, Receipt>> fosAppointmentOnCreateOption;
  final Option<Either<FirebaseFailure, Unit>> fosAppointmentOnUpdateOption;
  final Option<Either<FirebaseFailure, Unit>> fosAppointmentOnDeleteOption;

  //* --- helper --- *//
  final bool isAllAppointmentsSeledcted;
  final List<bool> isExpanded;
  final String appointmentSearchText;

  const AppointmentState({
    this.appointment,
    this.customer,
    required this.listOfAllAppointments,
    required this.listOfFilteredAppointments,
    required this.selectedAppointments,
    required this.firebaseFailure,
    required this.isAnyFailure,
    required this.isLoadingAppointmentOnObserve,
    required this.isLoadingAppointmentsOnObserve,
    required this.isLoadingAppointmentsFromPrestaOnObserve,
    required this.isLoadingAppointmentOnCreate,
    required this.isLoadingAppointmentOnUpdate,
    required this.isLoadingAppointmentOnDelete,
    required this.fosAppointmentOnObserveOption,
    required this.fosAppointmentsOnObserveOption,
    required this.fosAppointmentsOnObserveFromPrestaOption,
    required this.fosAppointmentOnCreateOption,
    required this.fosAppointmentOnUpdateOption,
    required this.fosAppointmentOnDeleteOption,
    required this.isAllAppointmentsSeledcted,
    required this.isExpanded,
    required this.appointmentSearchText,
  });

  factory AppointmentState.initial() => AppointmentState(
        appointment: null,
        customer: null,
        listOfAllAppointments: null,
        listOfFilteredAppointments: null,
        selectedAppointments: const [],
        firebaseFailure: null,
        isAnyFailure: false,
        isLoadingAppointmentOnObserve: false,
        isLoadingAppointmentsOnObserve: true,
        isLoadingAppointmentsFromPrestaOnObserve: false,
        isLoadingAppointmentOnCreate: false,
        isLoadingAppointmentOnUpdate: false,
        isLoadingAppointmentOnDelete: false,
        fosAppointmentOnObserveOption: none(),
        fosAppointmentsOnObserveOption: none(),
        fosAppointmentsOnObserveFromPrestaOption: none(),
        fosAppointmentOnCreateOption: none(),
        fosAppointmentOnUpdateOption: none(),
        fosAppointmentOnDeleteOption: none(),
        isAllAppointmentsSeledcted: false,
        isExpanded: const [],
        appointmentSearchText: '',
      );

  AppointmentState copyWith({
    Receipt? appointment,
    Customer? customer,
    List<Receipt>? listOfAllAppointments,
    List<Receipt>? listOfFilteredAppointments,
    List<Receipt>? selectedAppointments,
    FirebaseFailure? firebaseFailure,
    bool? isAnyFailure,
    bool? isLoadingAppointmentOnObserve,
    bool? isLoadingAppointmentsOnObserve,
    bool? isLoadingAppointmentsFromPrestaOnObserve,
    bool? isLoadingAppointmentOnCreate,
    bool? isLoadingAppointmentOnUpdate,
    bool? isLoadingAppointmentOnDelete,
    Option<Either<FirebaseFailure, Receipt>>? fosAppointmentOnObserveOption,
    Option<Either<FirebaseFailure, List<Receipt>>>? fosAppointmentsOnObserveOption,
    Option<Either<FirebaseFailure, List<Receipt>>>? fosAppointmentsOnObserveFromPrestaOption,
    Option<Either<FirebaseFailure, Receipt>>? fosAppointmentOnCreateOption,
    Option<Either<FirebaseFailure, Unit>>? fosAppointmentOnUpdateOption,
    Option<Either<FirebaseFailure, Unit>>? fosAppointmentOnDeleteOption,
    bool? isAllAppointmentsSeledcted,
    List<bool>? isExpanded,
    String? appointmentSearchText,
  }) {
    return AppointmentState(
      appointment: appointment ?? this.appointment,
      customer: customer ?? this.customer,
      listOfAllAppointments: listOfAllAppointments ?? this.listOfAllAppointments,
      listOfFilteredAppointments: listOfFilteredAppointments ?? this.listOfFilteredAppointments,
      selectedAppointments: selectedAppointments ?? this.selectedAppointments,
      firebaseFailure: firebaseFailure ?? this.firebaseFailure,
      isAnyFailure: isAnyFailure ?? this.isAnyFailure,
      isLoadingAppointmentOnObserve: isLoadingAppointmentOnObserve ?? this.isLoadingAppointmentOnObserve,
      isLoadingAppointmentsOnObserve: isLoadingAppointmentsOnObserve ?? this.isLoadingAppointmentsOnObserve,
      isLoadingAppointmentsFromPrestaOnObserve: isLoadingAppointmentsFromPrestaOnObserve ?? this.isLoadingAppointmentsFromPrestaOnObserve,
      isLoadingAppointmentOnCreate: isLoadingAppointmentOnCreate ?? this.isLoadingAppointmentOnCreate,
      isLoadingAppointmentOnUpdate: isLoadingAppointmentOnUpdate ?? this.isLoadingAppointmentOnUpdate,
      isLoadingAppointmentOnDelete: isLoadingAppointmentOnDelete ?? this.isLoadingAppointmentOnDelete,
      fosAppointmentOnObserveOption: fosAppointmentOnObserveOption ?? this.fosAppointmentOnObserveOption,
      fosAppointmentsOnObserveOption: fosAppointmentsOnObserveOption ?? this.fosAppointmentsOnObserveOption,
      fosAppointmentsOnObserveFromPrestaOption: fosAppointmentsOnObserveFromPrestaOption ?? this.fosAppointmentsOnObserveFromPrestaOption,
      fosAppointmentOnCreateOption: fosAppointmentOnCreateOption ?? this.fosAppointmentOnCreateOption,
      fosAppointmentOnUpdateOption: fosAppointmentOnUpdateOption ?? this.fosAppointmentOnUpdateOption,
      fosAppointmentOnDeleteOption: fosAppointmentOnDeleteOption ?? this.fosAppointmentOnDeleteOption,
      isAllAppointmentsSeledcted: isAllAppointmentsSeledcted ?? this.isAllAppointmentsSeledcted,
      isExpanded: isExpanded ?? this.isExpanded,
      appointmentSearchText: appointmentSearchText ?? this.appointmentSearchText,
    );
  }
}
