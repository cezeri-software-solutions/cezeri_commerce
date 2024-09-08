import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '/3_domain/entities/customer/customer.dart';
import '../../../3_domain/repositories/database/customer_repository.dart';
import '../../../failures/abstract_failure.dart';

part 'customer_event.dart';
part 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final CustomerRepository customerRepository;

  CustomerBloc({
    required this.customerRepository,
  }) : super(CustomerState.initial()) {
    on<SetCustomerStateToInitialEvent>(_onSetCustomerStateToInitial);
    on<GetAllCustomersEvent>(_onGetAllCustomers);
    on<GetCustomersPerPageEvent>(_onGetCustomersPerPage);
    on<DeleteSelectedCustomersEvent>(_onDeleteSelectedCustomers);
    on<CustomerSearchFieldClearedEvent>(_onOnSearchFieldCleared);
    on<OnSelectAllCustomersEvent>(_onSelectAllCustomers);
    on<OnCustomerSelectedEvent>(_onCustomerSelected);
    on<CustomerItemsPerPageChangedEvent>(_onItemsPerPageChanged);
  }

  void _onSetCustomerStateToInitial(SetCustomerStateToInitialEvent event, Emitter<CustomerState> emit) async {
    emit(CustomerState.initial());
  }

  Future<void> _onGetAllCustomers(GetAllCustomersEvent event, Emitter<CustomerState> emit) async {
    emit(state.copyWith(isLoadingCustomersOnObserve: true));

    final failureOrCustomers = await customerRepository.getListOfAllCustomers();
    failureOrCustomers.fold(
      (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
      (customers) {
        emit(state.copyWith(listOfAllCustomers: customers, selectedCustomers: [], firebaseFailure: null, isAnyFailure: false));
      },
    );

    emit(state.copyWith(
      isLoadingCustomersOnObserve: false,
      fosCustomersOnObserveOption: optionOf(failureOrCustomers),
    ));
    emit(state.copyWith(fosCustomersOnObserveOption: none()));
  }

  Future<void> _onGetCustomersPerPage(GetCustomersPerPageEvent event, Emitter<CustomerState> emit) async {
    emit(state.copyWith(isLoadingCustomersOnObserve: true));

    if (event.calcCount) {
      final fosCount = await customerRepository.getTotalNumberOfCustomersBySearchText(state.customerSearchController.text);
      fosCount.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (countNumber) => emit(state.copyWith(totalQuantity: countNumber, firebaseFailure: null, isAnyFailure: false)),
      );
    }

    final fos = await customerRepository.getListOfCustomersPerPageBySearchText(
      searchText: state.customerSearchController.text,
      currentPage: event.currentPage,
      itemsPerPage: state.perPageQuantity,
    );

    fos.fold(
      (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
      (listOfCustomers) {
        emit(state.copyWith(
          listOfAllCustomers: listOfCustomers,
          listOfFilteredCustomers: listOfCustomers,
          currentPage: event.currentPage,
          firebaseFailure: null,
          isAnyFailure: false,
        ));
      },
    );

    emit(state.copyWith(
      isLoadingCustomersOnObserve: false,
      fosCustomersOnObserveOption: optionOf(fos),
    ));
    emit(state.copyWith(fosCustomersOnObserveOption: none()));
  }

  Future<void> _onDeleteSelectedCustomers(DeleteSelectedCustomersEvent event, Emitter<CustomerState> emit) async {
    emit(state.copyWith(isLoadingCustomerOnDelete: true));
    List<AbstractFailure> failures = [];

    for (final selectedCustomer in event.selectedCustomers) {
      final fos = await customerRepository.deleteCustomer(selectedCustomer.id);
      fos.fold(
        (failure) => failures.add(failure),
        (unit) => null,
      );
    }

    emit(state.copyWith(
      isLoadingCustomerOnDelete: false,
      fosCustomersOnDeleteOption: failures.isEmpty ? optionOf(const Right(unit)) : optionOf(Left(failures)),
    ));
    emit(state.copyWith(fosCustomersOnDeleteOption: none()));
  }

  Future<void> _onOnSearchFieldCleared(CustomerSearchFieldClearedEvent event, Emitter<CustomerState> emit) async {
    emit(state.copyWith(customerSearchController: SearchController()));
    add(GetCustomersPerPageEvent(calcCount: true, currentPage: 1));
  }

  Future<void> _onSelectAllCustomers(OnSelectAllCustomersEvent event, Emitter<CustomerState> emit) async {
    if (event.isSelected) {
      emit(state.copyWith(selectedCustomers: state.listOfFilteredCustomers!, isAllCustomersSelected: true));
    } else {
      emit(state.copyWith(selectedCustomers: [], isAllCustomersSelected: false));
    }
  }

  Future<void> _onCustomerSelected(OnCustomerSelectedEvent event, Emitter<CustomerState> emit) async {
    final isSelected = state.selectedCustomers.any((e) => e.id == event.customer.id);
    List<Customer> updatedSelectedCustomers = List.from(state.selectedCustomers);

    if (isSelected) {
      updatedSelectedCustomers.removeWhere((e) => e.id == event.customer.id);
    } else {
      updatedSelectedCustomers.add(event.customer);
    }

    emit(state.copyWith(selectedCustomers: updatedSelectedCustomers));
  }

  void _onItemsPerPageChanged(CustomerItemsPerPageChangedEvent event, Emitter<CustomerState> emit) {
    emit(state.copyWith(perPageQuantity: event.value));
    add(GetCustomersPerPageEvent(calcCount: false, currentPage: 1));
  }
}
