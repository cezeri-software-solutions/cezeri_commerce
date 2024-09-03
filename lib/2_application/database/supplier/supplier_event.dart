part of 'supplier_bloc.dart';

@immutable
abstract class SupplierEvent {}

class SetSupplierStateToInitialEvent extends SupplierEvent {}

class GetAllSuppliersEvenet extends SupplierEvent {}

class GetSupplierEvent extends SupplierEvent {
  final Supplier supplier;

  GetSupplierEvent({required this.supplier});
}

class SetSupplierEvent extends SupplierEvent {
  final Supplier supplier;

  SetSupplierEvent({required this.supplier});
}

class CreateSupplierEvent extends SupplierEvent {}

class UpdateSupplierEvent extends SupplierEvent {}

class DeleteSelectedSuppliersEvent extends SupplierEvent {
  final List<Supplier> selectedSuppliers;

  DeleteSelectedSuppliersEvent({required this.selectedSuppliers});
}

class SetSearchFieldTextEvent extends SupplierEvent {
  final String searchText;

  SetSearchFieldTextEvent({required this.searchText});
}

class OnSearchFieldSubmittedEvent extends SupplierEvent {}

class SetSupplierTaxEvent extends SupplierEvent {
  final Tax tax;

  SetSupplierTaxEvent({required this.tax});
}

//* --- helper --- *//

class OnSelectAllSuppliersEvent extends SupplierEvent {
  final bool isSelected;

  OnSelectAllSuppliersEvent({required this.isSelected});
}

class OnSupplierSelectedEvent extends SupplierEvent {
  final Supplier supplier;

  OnSupplierSelectedEvent({required this.supplier});
}

class OnEditSupplierAddressEvent extends SupplierEvent {
  final Address address;

  OnEditSupplierAddressEvent({required this.address});
}

//* --- Controller --- *//

class SetSupplierControllerEvnet extends SupplierEvent {}

class OnSupplierControllerChangedEvent extends SupplierEvent {}
