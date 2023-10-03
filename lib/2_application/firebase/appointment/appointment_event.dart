part of 'appointment_bloc.dart';

@immutable
abstract class AppointmentEvent {}

class SetAppointmentStateToInitialEvent extends AppointmentEvent {}

class GetAllAppointmentsEvent extends AppointmentEvent {}

class GetNewAppointmentsFromPrestaEvent extends AppointmentEvent {}

class DeleteSelectedAppointmentsEvent extends AppointmentEvent {
  final List<Receipt> selectedAppointments;

  DeleteSelectedAppointmentsEvent({required this.selectedAppointments});
}

class SetSearchFieldTextAppointmentsEvent extends AppointmentEvent {
  final String searchText;

  SetSearchFieldTextAppointmentsEvent({required this.searchText});
}

class OnSearchFieldSubmittedAppointmentsEvent extends AppointmentEvent {}

//* --- helper --- *//
class SetAppointmentIsExpandedEvent extends AppointmentEvent {
  final int index;

  SetAppointmentIsExpandedEvent({required this.index});
}

class OnAppointmentSelectedEvent extends AppointmentEvent {
  final Receipt appointment;

  OnAppointmentSelectedEvent({required this.appointment});
}
