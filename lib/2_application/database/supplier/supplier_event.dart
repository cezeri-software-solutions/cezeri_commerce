part of 'supplier_bloc.dart';

@immutable
abstract class SupplierEvent {}

class SetSupplierStateToInitialEvent extends SupplierEvent {}

class GetSuppliersEvenet extends SupplierEvent {
  final bool calcCount;
  final int currentPage;

  GetSuppliersEvenet({required this.calcCount, required this.currentPage});
}

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

class SupplierItemsPerPageChangedEvent extends SupplierEvent {
  final int value;

  SupplierItemsPerPageChangedEvent({required this.value});
}

//* --- Controller --- *//

class OnSupplierSearchControllerClearedEvent extends SupplierEvent {}

class SetSupplierControllerEvnet extends SupplierEvent {}

class OnSupplierControllerChangedEvent extends SupplierEvent {}
