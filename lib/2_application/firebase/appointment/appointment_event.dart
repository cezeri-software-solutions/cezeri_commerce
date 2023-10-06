part of 'appointment_bloc.dart';

@immutable
abstract class AppointmentEvent {}

class SetAppointmentStateToInitialEvent extends AppointmentEvent {}

class GetAppointmentEvent extends AppointmentEvent {
  final Receipt appointment;

  GetAppointmentEvent({required this.appointment});
}

class GetAllAppointmentsEvent extends AppointmentEvent {}

class GetOpenAppointmentsEvent extends AppointmentEvent {}

class GetNewAppointmentsFromPrestaEvent extends AppointmentEvent {}

class UpdateAppointmentEvent extends AppointmentEvent {
  final Receipt appointment;

  UpdateAppointmentEvent({required this.appointment});
}

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

class OnAllAppointmentSelectedEvent extends AppointmentEvent {
  final bool isSelected;

  OnAllAppointmentSelectedEvent({required this.isSelected});
}

class OnAppointmentSelectedEvent extends AppointmentEvent {
  final Receipt appointment;

  OnAppointmentSelectedEvent({required this.appointment});
}
