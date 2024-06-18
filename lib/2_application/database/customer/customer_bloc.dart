import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '/3_domain/entities/address.dart';
import '/3_domain/entities/customer/customer.dart';
import '/3_domain/entities/settings/main_settings.dart';
import '/3_domain/entities/settings/tax.dart';
import '/3_domain/repositories/firebase/customer_repository.dart';
import '/3_domain/repositories/firebase/main_settings_respository.dart';
import '../../../constants.dart';
import '../../../failures/abstract_failure.dart';

part 'customer_event.dart';
part 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final CustomerRepository _customerRepository;
  final MainSettingsRepository _mainSettingsRepository;

  CustomerBloc({
    required CustomerRepository customerRepository,
    required MainSettingsRepository mainSettingsRepository,
  })  : _customerRepository = customerRepository,
        _mainSettingsRepository = mainSettingsRepository,
        super(CustomerState.initial()) {
    on<SetCustomerStateToInitialEvent>(_onSetCustomerStateToInitial);
    on<GetAllCustomersEvent>(_onGetAllCustomers);
    on<GetCustomersPerPageEvent>(_onGetCustomersPerPage);
    on<SetCustomerEvent>(_onSetCustomer);
    on<GetCustomerEvent>(_onGetCustomer);
    on<SetEmptyCustomerOnCreateNewCustomerEvent>(_onSetEmptyCustomerOnCreateNewCustomer);
    on<CreateCustomerEvent>(_onCreateCustomer);
    on<UpdateCustomerEvent>(_onUpdateCustomer);
    on<DeleteSelectedCustomersEvent>(_onDeleteSelectedCustomers);
    on<CustomerSearchFieldClearedEvent>(_onOnSearchFieldCleared);
    on<OnSelectAllCustomersEvent>(_onSelectAllCustomers);
    on<OnCustomerSelectedEvent>(_onCustomerSelected);
    on<SetCustomerTaxEvent>(_onSetCustomerTax);
    on<CustomerItemsPerPageChangedEvent>(_onItemsPerPageChanged);
    on<OnCustomerInvoiceTypeChangedEvent>(_onCustomerInvoiceTypeChanged);
    on<OnAddEditCustomerAddressEvent>(_onAddEditCustomerAddress);
    on<SetCustomerControllerEvent>(_onSetCustomerController);
    on<OnCustomerControllerChangedEvent>(_onCustomerControllerChanged);
  }

  void _onSetCustomerStateToInitial(SetCustomerStateToInitialEvent event, Emitter<CustomerState> emit) async {
    emit(CustomerState.initial());
  }

  Future<void> _onGetAllCustomers(GetAllCustomersEvent event, Emitter<CustomerState> emit) async {
    emit(state.copyWith(isLoadingCustomersOnObserve: true));

    final failureOrCustomers = await _customerRepository.getListOfAllCustomers();
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
      final fosCount = await _customerRepository.getTotalNumberOfCustomersBySearchText(state.customerSearchController.text);
      fosCount.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (countNumber) => emit(state.copyWith(totalQuantity: countNumber, firebaseFailure: null, isAnyFailure: false)),
      );
    }

    final fos = await _customerRepository.getListOfCustomersPerPageBySearchText(
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

  Future<void> _onSetCustomer(SetCustomerEvent event, Emitter<CustomerState> emit) async {
    emit(state.copyWith(customer: event.customer));
    add(SetCustomerControllerEvent());
  }

  Future<void> _onGetCustomer(GetCustomerEvent event, Emitter<CustomerState> emit) async {
    emit(state.copyWith(isLoadingCustomerOnObserve: true));

    final failureOrCustomer = await _customerRepository.getCustomer(event.customer.id);
    failureOrCustomer.fold(
      (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
      (customer) {
        emit(state.copyWith(customer: customer, firebaseFailure: null, isAnyFailure: false));
        add(SetCustomerControllerEvent());
      },
    );

    emit(state.copyWith(
      isLoadingCustomerOnObserve: false,
      fosCustomerOnObserveOption: optionOf(failureOrCustomer),
    ));
    emit(state.copyWith(fosCustomerOnObserveOption: none()));
  }

  Future<void> _onSetEmptyCustomerOnCreateNewCustomer(SetEmptyCustomerOnCreateNewCustomerEvent event, Emitter<CustomerState> emit) async {
    emit(state.copyWith(isLoadingCustomerMainSettingsOnObserve: true));

    final fos = await _mainSettingsRepository.getSettings();
    fos.fold(
      (failure) => null,
      (settings) {
        emit(state.copyWith(customer: Customer.empty().copyWith(customerNumber: settings.nextCustomerNumber)));
        add(SetCustomerControllerEvent());
      },
    );

    emit(state.copyWith(
      isLoadingCustomerMainSettingsOnObserve: false,
      fosCustomerMainSettingsOnObserveOption: optionOf(fos),
    ));
    emit(state.copyWith(fosCustomerMainSettingsOnObserveOption: none()));
  }

  Future<void> _onCreateCustomer(CreateCustomerEvent event, Emitter<CustomerState> emit) async {
    emit(state.copyWith(isLoadingCustomerOnCreate: true));

    final failureOrSuccess = await _customerRepository.createCustomer(state.customer!);
    failureOrSuccess.fold(
      (failure) => null,
      (customer) => emit(state.copyWith(customer: customer, firebaseFailure: null, isAnyFailure: false)),
    );

    emit(state.copyWith(
      isLoadingCustomerOnCreate: false,
      fosCustomerOnCreateOption: optionOf(failureOrSuccess),
    ));
    emit(state.copyWith(fosCustomerOnCreateOption: none()));
  }

  Future<void> _onUpdateCustomer(UpdateCustomerEvent event, Emitter<CustomerState> emit) async {
    emit(state.copyWith(isLoadingCustomerOnUpdate: true));

    final failureOrSuccess = await _customerRepository.updateCustomer(state.customer!);
    failureOrSuccess.fold(
      (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
      (customer) => emit(state.copyWith(customer: customer, firebaseFailure: null, isAnyFailure: false)),
    );

    emit(state.copyWith(
      isLoadingCustomerOnUpdate: false,
      fosCustomerOnUpdateOption: optionOf(failureOrSuccess),
    ));
    emit(state.copyWith(fosCustomerOnUpdateOption: none()));
  }

  Future<void> _onDeleteSelectedCustomers(DeleteSelectedCustomersEvent event, Emitter<CustomerState> emit) async {
    emit(state.copyWith(isLoadingCustomerOnDelete: true));
    List<AbstractFailure> failures = [];

    for (final selectedCustomer in event.selectedCustomers) {
      final fos = await _customerRepository.deleteCustomer(selectedCustomer.id);
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
    final searchText = state.customerSearchController.text.toLowerCase();
    final filteredCustomers = switch (searchText) {
      '' => state.listOfAllCustomers,
      _ => state.listOfAllCustomers!.where((customer) {
          final searchInName = customer.name.toLowerCase().contains(searchText);
          final searchInCompany = customer.company?.toLowerCase().contains(searchText) ?? false;
          final searchInEmail = customer.email.toLowerCase().contains(searchText);
          return searchInName || searchInCompany || searchInEmail;
        }).toList()
    };

    if (filteredCustomers != null && filteredCustomers.isNotEmpty) filteredCustomers.sort((a, b) => b.customerNumber.compareTo(a.customerNumber));
    emit(state.copyWith(listOfFilteredCustomers: filteredCustomers));
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

  Future<void> _onSetCustomerTax(SetCustomerTaxEvent event, Emitter<CustomerState> emit) async {
    final updatedCustomer = state.customer?.copyWith(tax: event.tax);
    emit(state.copyWith(customer: updatedCustomer));
  }

  void _onItemsPerPageChanged(CustomerItemsPerPageChangedEvent event, Emitter<CustomerState> emit) {
    emit(state.copyWith(perPageQuantity: event.value));
    add(GetCustomersPerPageEvent(calcCount: false, currentPage: 1));
  }

  Future<void> _onCustomerInvoiceTypeChanged(OnCustomerInvoiceTypeChangedEvent event, Emitter<CustomerState> emit) async {
    final updatedCustomer = state.customer?.copyWith(customerInvoiceType: event.customerInvoiceType);
    emit(state.copyWith(customer: updatedCustomer));
  }

  Future<void> _onAddEditCustomerAddress(OnAddEditCustomerAddressEvent event, Emitter<CustomerState> emit) async {
    logger.i(event.address);
    logger.i(event.address.addressType);
    final List<Address> currentAddresses = List.from(state.customer!.listOfAddress);
    final int addressIndex = currentAddresses.indexWhere((address) => address.id == event.address.id);

    if (addressIndex == -1) {
      print('adresse NEU');
      _addNewAddress(event.address, currentAddresses, emit);
    } else {
      print('adresse VORHANDEN');
      _editExistingAddress(addressIndex, event.address, currentAddresses, emit);
    }
  }

  void _addNewAddress(Address newAddress, List<Address> currentAddresses, Emitter<CustomerState> emit) {
    _ensureOnlyOneDefaultAddress(newAddress, currentAddresses);
    currentAddresses.add(newAddress);

    _addComplementaryAddressIfNeeded(newAddress, currentAddresses);

    emit(state.copyWith(customer: state.customer!.copyWith(listOfAddress: currentAddresses)));
  }

  void _editExistingAddress(int index, Address updatedAddress, List<Address> currentAddresses, Emitter<CustomerState> emit) {
    currentAddresses[index] = updatedAddress;
    _ensureOnlyOneDefaultAddress(updatedAddress, currentAddresses);
    logger.i(currentAddresses);

    emit(state.copyWith(customer: state.customer!.copyWith(listOfAddress: currentAddresses)));
  }

  void _ensureOnlyOneDefaultAddress(Address address, List<Address> addresses) {
    if (address.isDefault) {
      for (var i = 0; i < addresses.length; i++) {
        if (addresses[i].isDefault && addresses[i].addressType == address.addressType && addresses[i] != address) {
          addresses[i] = addresses[i].copyWith(isDefault: false);
        }
      }
    }
  }

  void _addComplementaryAddressIfNeeded(Address address, List<Address> addresses) {
    if ((address.addressType == AddressType.delivery && !addresses.any((a) => a.addressType == AddressType.invoice)) ||
        (address.addressType == AddressType.invoice && !addresses.any((a) => a.addressType == AddressType.delivery))) {
      addresses.add(address.copyWith(
        addressType: address.addressType == AddressType.delivery ? AddressType.invoice : AddressType.delivery,
        isDefault: true,
      ));
    }
  }

  Future<void> _onSetCustomerController(SetCustomerControllerEvent event, Emitter<CustomerState> emit) async {
    final customer = state.customer ?? Customer.empty();
    emit(state.copyWith(
      companyNameController: TextEditingController(text: customer.company ?? ''),
      firstNameController: TextEditingController(text: customer.firstName),
      lastNameController: TextEditingController(text: customer.lastName),
      emailController: TextEditingController(text: customer.email),
      phoneController: TextEditingController(text: customer.phone),
      phoneMobileController: TextEditingController(text: customer.phoneMobile),
      uidNumberController: TextEditingController(text: customer.uidNumber),
      taxNumberController: TextEditingController(text: customer.taxNumber),
    ));
  }

  Future<void> _onCustomerControllerChanged(OnCustomerControllerChangedEvent event, Emitter<CustomerState> emit) async {
    final updatedCustomer = state.customer?.copyWith(
      company: state.companyNameController.text,
      firstName: state.firstNameController.text,
      lastName: state.lastNameController.text,
      email: state.emailController.text,
      phone: state.phoneController.text,
      phoneMobile: state.phoneMobileController.text,
      uidNumber: state.uidNumberController.text,
      taxNumber: state.taxNumberController.text,
    );

    emit(state.copyWith(customer: updatedCustomer));
  }
}
