import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../3_domain/entities/address.dart';
import '../../../3_domain/entities/reorder/supplier.dart';
import '../../../3_domain/entities/settings/tax.dart';
import '../../../3_domain/repositories/firebase/supplier_repository.dart';
import '../../../failures/abstract_failure.dart';

part 'supplier_event.dart';
part 'supplier_state.dart';

class SupplierBloc extends Bloc<SupplierEvent, SupplierState> {
  final SupplierRepository supplierRepository;

  SupplierBloc({required this.supplierRepository}) : super(SupplierState.initial()) {
//? #########################################################################

    on<SetSupplierStateToInitialEvent>((event, emit) {
      emit(SupplierState.initial());
    });

//? #########################################################################

    on<GetAllSuppliersEvenet>((event, emit) async {
      emit(state.copyWith(isLoadingSuppliersOnObserve: true));

      final failureOrSuccess = await supplierRepository.getListOfSuppliers();
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (listOfSupplier) {
          emit(state.copyWith(listOfAllSuppliers: listOfSupplier, selectedSuppliers: [], firebaseFailure: null, isAnyFailure: false));
          add(OnSearchFieldSubmittedEvent());
        },
      );

      add(OnSearchFieldSubmittedEvent());

      emit(state.copyWith(
        isLoadingSuppliersOnObserve: false,
        fosSuppliersOnObserveOption: optionOf(failureOrSuccess),
      ));
    });

//? #########################################################################

    on<GetSupplierEvent>((event, emit) async {
      emit(state.copyWith(isLoadingSupplierOnObserve: true));

      final failureOrSuccess = await supplierRepository.getSupplier(event.supplier.id);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (supplier) {
          emit(state.copyWith(supplier: supplier, firebaseFailure: null, isAnyFailure: false));
          add(SetSupplierControllerEvnet());
        },
      );

      emit(state.copyWith(
        isLoadingSupplierOnObserve: false,
        fosSupplierOnObserveOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosSupplierOnObserveOption: none()));
    });

//? #########################################################################

    on<SetSupplierEvent>((event, emit) async {
      emit(state.copyWith(supplier: event.supplier));
      add(SetSupplierControllerEvnet());
    });

//? #########################################################################

    on<CreateSupplierEvent>((event, emit) async {
      emit(state.copyWith(isLoadingSupplierOnCreate: true));

      final failureOrSuccess = await supplierRepository.createSupplier(state.supplier!);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (supplier) => emit(state.copyWith(supplier: supplier, firebaseFailure: null, isAnyFailure: false)),
      );

      emit(state.copyWith(
        isLoadingSupplierOnCreate: false,
        fosSupplierOnCreateOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosSupplierOnCreateOption: none()));
    });

//? #########################################################################

    on<UpdateSupplierEvent>((event, emit) async {
      emit(state.copyWith(isLoadingSupplierOnUpdate: true));

      final failureOrSuccess = await supplierRepository.updateSupplier(state.supplier!);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (supplier) => emit(state.copyWith(supplier: supplier, firebaseFailure: null, isAnyFailure: false)),
      );

      emit(state.copyWith(
        isLoadingSupplierOnUpdate: false,
        fosSupplierOnUpdateOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosSupplierOnObserveOption: none()));
    });

//? #########################################################################

    on<DeleteSelectedSuppliersEvent>((event, emit) async {
      emit(state.copyWith(isLoadingSupplierOnDelete: true));
      List<AbstractFailure> failures = [];

      for (final selectedSupplier in event.selectedSuppliers) {
        final fos = await supplierRepository.deleteSupplier(selectedSupplier.id);
        fos.fold(
          (failure) => failures.add(failure),
          (unit) => null,
        );
      }

      emit(state.copyWith(
        isLoadingSupplierOnDelete: false,
        fosSupplierOnDeleteOption: failures.isEmpty ? optionOf(const Right(unit)) : optionOf(Left(failures)),
      ));
      emit(state.copyWith(fosSupplierOnDeleteOption: none()));
    });

//? #########################################################################

    on<SetSearchFieldTextEvent>((event, emit) async {
      emit(state.copyWith(supplierSearchText: event.searchText));

      add(OnSearchFieldSubmittedEvent());
    });

    on<OnSearchFieldSubmittedEvent>((event, emit) async {
      final listOfSuppliers = switch (state.supplierSearchText) {
        '' => state.listOfAllSuppliers,
        (_) => state.listOfAllSuppliers!
            .where((e) =>
                e.name.toLowerCase().contains(state.supplierSearchText.toLowerCase()) ||
                e.company.toLowerCase().contains(state.supplierSearchText.toLowerCase()) ||
                e.email.toLowerCase().contains(state.supplierSearchText.toLowerCase()))
            .toList()
      };
      if (listOfSuppliers != null && listOfSuppliers.isNotEmpty) listOfSuppliers.sort((a, b) => b.supplierNumber.compareTo(a.supplierNumber));
      emit(state.copyWith(listOfFilteredSuppliers: listOfSuppliers));
    });

//? #########################################################################

    on<OnSelectAllSuppliersEvent>((event, emit) async {
      List<Supplier> suppliers = [];
      bool isSelectedAll = false;
      if (event.isSelected) {
        isSelectedAll = true;
        suppliers = List.from(state.listOfFilteredSuppliers!);
      }
      emit(state.copyWith(isAllSuppliersSelected: isSelectedAll, selectedSuppliers: suppliers));
    });

//? #########################################################################

    on<OnSupplierSelectedEvent>((event, emit) async {
      List<Supplier> suppliers = List.from(state.selectedSuppliers);
      if (suppliers.any((e) => e.id == event.supplier.id)) {
        suppliers.removeWhere((e) => e.id == event.supplier.id);
      } else {
        suppliers.add(event.supplier);
      }
      emit(state.copyWith(
        isAllSuppliersSelected:
            state.isAllSuppliersSelected && suppliers.length < state.selectedSuppliers.length ? false : state.isAllSuppliersSelected,
        selectedSuppliers: suppliers,
      ));
    });

//? #########################################################################

    on<SetSupplierTaxEvent>((event, emit) async {
      emit(state.copyWith(supplier: state.supplier!.copyWith(tax: event.tax)));
    });

//? #########################################################################

    on<OnEditSupplierAddressEvent>((event, emit) async {
      emit(state.copyWith(
        supplier: state.supplier!.copyWith(
          street: event.address.street,
          street2: event.address.street2,
          postcode: event.address.postcode,
          city: event.address.city,
          country: event.address.country,
        ),
      ));
    });

//? #########################################################################

    on<SetSupplierControllerEvnet>((event, emit) async {
      Supplier? supplier = state.supplier;
      if (supplier == null) {
        emit(state.copyWith(supplier: Supplier.empty()));
      }
      emit(state.copyWith(
        companyNameController: TextEditingController(text: supplier!.company),
        firstNameController: TextEditingController(text: supplier.firstName),
        lastNameController: TextEditingController(text: supplier.lastName),
        emailController: TextEditingController(text: supplier.email),
        homepageController: TextEditingController(text: supplier.homepage),
        phoneController: TextEditingController(text: supplier.phone),
        phoneMobileController: TextEditingController(text: supplier.phoneMobile),
      ));
    });

//? #########################################################################

    on<OnSupplierControllerChangedEvent>((event, emit) async {
      Supplier? supplier = state.supplier;
      if (supplier == null) {
        emit(state.copyWith(supplier: Supplier.empty()));
      }
      emit(state.copyWith(
        supplier: state.supplier!.copyWith(
          company: state.companyNameController.text,
          firstName: state.firstNameController.text,
          lastName: state.lastNameController.text,
          email: state.emailController.text,
          homepage: state.homepageController.text,
          phone: state.phoneController.text,
          phoneMobile: state.phoneMobileController.text,
        ),
      ));
    });

//? #########################################################################
  }
}
