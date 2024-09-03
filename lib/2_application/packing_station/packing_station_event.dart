part of 'packing_station_bloc.dart';

abstract class PackingStationEvent {}

class SetPackingStationStateToInitialEvent extends PackingStationEvent {}

class PackgingStationGetAppointmentEvent extends PackingStationEvent {
  final Receipt appointment;
  final List<PackagingBox> listOfPackagingBoxes;

  PackgingStationGetAppointmentEvent({required this.appointment, required this.listOfPackagingBoxes});
}

class PackingStationSetAppointFromOriginalEvent extends PackingStationEvent {}

class PackgingStationGetAppointmentsEvent extends PackingStationEvent {}

class PackingsStationUpdateAppointmentEvent extends PackingStationEvent {
  final Receipt appointment;

  PackingsStationUpdateAppointmentEvent({required this.appointment});
}

class PackingStationFilterAppointmentsEvent extends PackingStationEvent {}

class SetPackingStationFilterAppointmentsEvent extends PackingStationEvent {
  final PackingStationFilter packingStationFilter;

  SetPackingStationFilterAppointmentsEvent({required this.packingStationFilter});
}

class PackingsStationUpdateAppointmentsEvent extends PackingStationEvent {
  final List<Receipt> appointments;

  PackingsStationUpdateAppointmentsEvent({required this.appointments});
}

class SetPackingStationListOfAllAppointmentsEvent extends PackingStationEvent {
  final List<Receipt> allAppointments;

  SetPackingStationListOfAllAppointmentsEvent({required this.allAppointments});
}

class PackingsStationOnAppointmentSelectedEvent extends PackingStationEvent {
  final Receipt appointment;

  PackingsStationOnAppointmentSelectedEvent({required this.appointment});
}

class PackingsStationOnAllAppointmentsSelectedEvent extends PackingStationEvent {
  final bool isSelected;

  PackingsStationOnAllAppointmentsSelectedEvent({required this.isSelected});
}

class PackingsStationGetProductsFromFirestoreEvent extends PackingStationEvent {
  final List<String> productIds;

  PackingsStationGetProductsFromFirestoreEvent({required this.productIds});
}

class PackingStationOnPickingQuantityChanged extends PackingStationEvent {
  final int index;
  final bool isSubtract;
  final bool pickCompletely;

  PackingStationOnPickingQuantityChanged({required this.index, required this.isSubtract, required this.pickCompletely});
}

class PackingStationOnPickAllEvent extends PackingStationEvent {}

class PackingStationIsPartiallyEnabledEvent extends PackingStationEvent {}

class PackingStationGenerateFromAppointmentEvent extends PackingStationEvent {
  final bool generateInvoice;

  PackingStationGenerateFromAppointmentEvent({required this.generateInvoice});
}

class PackingStationOnWeightControllerChangedEvent extends PackingStationEvent {}

class PackingStationOnPackagingBoxChangedEvent extends PackingStationEvent {
  final String packagingBoxName;

  PackingStationOnPackagingBoxChangedEvent({required this.packagingBoxName});
}

class PackingStationfindSmallestPackagingBoxEvent extends PackingStationEvent {}

class PackingSationSetShouldScanEvent extends PackingStationEvent {
  final bool value;

  PackingSationSetShouldScanEvent({required this.value});
}

class PackingStationOnEanScannedEvent extends PackingStationEvent {
  final BuildContext context;
  final String ean;

  PackingStationOnEanScannedEvent({required this.context, required this.ean});
}

//* #################################################################################################
//* #################################### Picklist ###################################################
//* #################################################################################################

class PicklistOnCreatePicklistEvent extends PackingStationEvent {
  final BuildContext context;

  PicklistOnCreatePicklistEvent({required this.context});
}

class PicklistOnSetPicklistEvent extends PackingStationEvent {
  final Picklist picklist;

  PicklistOnSetPicklistEvent({required this.picklist});
}

class PicklistGetPicklistsEvent extends PackingStationEvent {}

class PicklistOnUpdatePicklistEvent extends PackingStationEvent {}

class PicklistOnPicklistQuantityChanged extends PackingStationEvent {
  final int index;
  final bool isSubtract;
  final bool pickCompletely;

  PicklistOnPicklistQuantityChanged({required this.index, required this.isSubtract, required this.pickCompletely});
}

class PicklistOnPickAllQuantityEvent extends PackingStationEvent {}
