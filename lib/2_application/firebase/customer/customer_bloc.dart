import 'package:bloc/bloc.dart';
import 'package:cezeri_commerce/core/firebase_failures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../../3_domain/entities/address.dart';
import '../../../3_domain/entities/customer/customer.dart';
import '../../../3_domain/entities/settings/main_settings.dart';
import '../../../3_domain/entities/settings/tax.dart';
import '../../../3_domain/repositories/firebase/customer_repository.dart';
import '../../../3_domain/repositories/firebase/main_settings_respository.dart';

part 'customer_event.dart';
part 'customer_state.dart';

final logger = Logger();

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final CustomerRepository customerRepository;
  final MainSettingsRepository mainSettingsRepository;

  CustomerBloc({required this.customerRepository, required this.mainSettingsRepository}) : super(CustomerState.initial()) {
//? #########################################################################

    on<SetCustomerStateToInitialEvent>((event, emit) {
      emit(CustomerState.initial());
    });

//? #########################################################################

    on<GetAllCustomersEvenet>((event, emit) async {
      emit(state.copyWith(isLoadingCustomersOnObserve: true));

      final failureOrSuccess = await customerRepository.getListOfCustomers();
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (listOfCustomer) {
          emit(state.copyWith(listOfAllCustomers: listOfCustomer, selectedCustomers: [], firebaseFailure: null, isAnyFailure: false));
          add(OnSearchFieldSubmittedEvent());
        },
      );

      add(OnSearchFieldSubmittedEvent());

      emit(state.copyWith(
        isLoadingCustomersOnObserve: false,
        fosCustomersOnObserveOption: optionOf(failureOrSuccess),
      ));
    });

//? #########################################################################

    on<GetCustomerEvent>((event, emit) async {
      emit(state.copyWith(isLoadingCustomerOnObserve: true));

      final failureOrSuccess = await customerRepository.getCustomer(event.customer.id);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (customer) {
          emit(state.copyWith(customer: customer, firebaseFailure: null, isAnyFailure: false));
          add(SetCustomerControllerEvent());
        },
      );

      emit(state.copyWith(
        isLoadingCustomerOnObserve: false,
        fosCustomerOnObserveOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosCustomerOnObserveOption: none()));
    });

//? #########################################################################

    on<SetEmptyCustomerOnCreateNewCustomerEvent>((event, emit) async {
      emit(state.copyWith(isLoadingCustomerMainSettingsOnObserve: true));

      final fos = await mainSettingsRepository.getSettings();
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
    });

//? #########################################################################

    on<CreateCustomerEvent>((event, emit) async {
      emit(state.copyWith(isLoadingCustomerOnCreate: true));

      final failureOrSuccess = await customerRepository.createCustomer(state.customer!);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (customer) => emit(state.copyWith(customer: customer, firebaseFailure: null, isAnyFailure: false)),
      );

      emit(state.copyWith(
        isLoadingCustomerOnCreate: false,
        fosCustomerOnCreateOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosCustomerOnCreateOption: none()));
    });

//? #########################################################################

    on<UpdateCustomerEvent>((event, emit) async {
      emit(state.copyWith(isLoadingCustomerOnUpdate: true));

      final failureOrSuccess = await customerRepository.updateCustomer(state.customer!);
      failureOrSuccess.fold(
        (failure) => emit(state.copyWith(firebaseFailure: failure, isAnyFailure: true)),
        (customer) => emit(state.copyWith(customer: customer, firebaseFailure: null, isAnyFailure: false)),
      );

      emit(state.copyWith(
        isLoadingCustomerOnUpdate: false,
        fosCustomerOnUpdateOption: optionOf(failureOrSuccess),
      ));
      emit(state.copyWith(fosCustomerOnObserveOption: none()));
    });

//? #########################################################################

    on<SetSearchFieldTextEvent>((event, emit) async {
      emit(state.copyWith(customerSearchText: event.searchText));

      add(OnSearchFieldSubmittedEvent());
    });

    on<OnSearchFieldSubmittedEvent>((event, emit) async {
      final listOfCustomers = switch (state.customerSearchText) {
        '' => state.listOfAllCustomers,
        (_) => state.listOfAllCustomers!
            .where((e) => e.company != null
                ? e.name.toLowerCase().contains(state.customerSearchText.toLowerCase()) ||
                    e.company!.toLowerCase().contains(state.customerSearchText.toLowerCase()) ||
                    e.email.toLowerCase().contains(state.customerSearchText.toLowerCase())
                : e.name.toLowerCase().contains(state.customerSearchText.toLowerCase()) ||
                    e.email.toLowerCase().contains(state.customerSearchText.toLowerCase()))
            .toList()
      };
      if (listOfCustomers != null && listOfCustomers.isNotEmpty) listOfCustomers.sort((a, b) => b.customerNumber.compareTo(a.customerNumber));
      emit(state.copyWith(listOfFilteredCustomers: listOfCustomers));
    });

//? #########################################################################

    on<OnSelectAllCustomersEvent>((event, emit) async {
      List<Customer> customers = [];
      bool isSelectedAll = false;
      if (event.isSelected) {
        isSelectedAll = true;
        customers = List.from(state.listOfFilteredCustomers!);
      }
      emit(state.copyWith(isAllCustomersSelected: isSelectedAll, selectedCustomers: customers));
    });

//? #########################################################################

    on<OnCustomerSelectedEvent>((event, emit) async {
      List<Customer> customers = List.from(state.selectedCustomers);
      if (customers.any((e) => e.id == event.customer.id)) {
        customers.removeWhere((e) => e.id == event.customer.id);
      } else {
        customers.add(event.customer);
      }
      emit(state.copyWith(
        isAllCustomersSelected:
            state.isAllCustomersSelected && customers.length < state.selectedCustomers.length ? false : state.isAllCustomersSelected,
        selectedCustomers: customers,
      ));
    });

//? #########################################################################

    on<SetCustomerTaxEvent>((event, emit) async {
      emit(state.copyWith(customer: state.customer!.copyWith(tax: event.tax)));
    });

//? #########################################################################

    on<OnCustomerInvoiceTypeChangedEvent>((event, emit) async {
      emit(state.copyWith(customer: state.customer!.copyWith(customerInvoiceType: event.customerInvoiceType)));
    });

//? #########################################################################

    on<OnAddEditCustomerAddressEvent>((event, emit) async {
      final index = state.customer!.listOfAddress.indexWhere((e) => e.id == event.address.id);
      logger.i(event.address);
      logger.i(state.customer!.listOfAddress);

      if (index == -1) {
        //* if new Address (Add Address)
        Address newAddress = event.address;
        List<Address> newListOfAddress = state.customer!.listOfAddress;
        if (newAddress.isDefault && state.customer!.listOfAddress.any((e) => e.isDefault)) {
          final idOfOldDefault = state.customer!.listOfAddress.where((e) => e.isDefault).first.id;
          final indexOfOldDefault = newListOfAddress.indexWhere((e) => e.id == idOfOldDefault);
          if (indexOfOldDefault == -1) return;
          if (newListOfAddress[indexOfOldDefault].addressType != newAddress.addressType) return;
          newListOfAddress[indexOfOldDefault] = newListOfAddress[indexOfOldDefault].copyWith(isDefault: false);
        }
        newListOfAddress = newListOfAddress..add(newAddress);
        if (newAddress.addressType == AddressType.delivery &&
            state.customer!.listOfAddress.where((e) => e.addressType == AddressType.invoice).firstOrNull == null) {
          newListOfAddress.add(newAddress.copyWith(addressType: AddressType.invoice, isDefault: true));
        }
        if (newAddress.addressType == AddressType.invoice &&
            state.customer!.listOfAddress.where((e) => e.addressType == AddressType.delivery).firstOrNull == null) {
          newListOfAddress.add(newAddress.copyWith(addressType: AddressType.delivery, isDefault: true));
        }
        emit(state.copyWith(customer: state.customer!.copyWith(listOfAddress: newListOfAddress)));
      } else {
        //* if edit Address
        List<Address> newListOfAddress = List.from(state.customer!.listOfAddress);
        newListOfAddress[index] = event.address;
        final listOfAddressIsDefault = newListOfAddress.where((e) => e.isDefault).toList();
        if (event.address.isDefault && listOfAddressIsDefault.length > 1) {
          for (int i = 0; i < newListOfAddress.length; i++) {
            if (newListOfAddress[i].id == event.address.id) continue;
            newListOfAddress[i] = newListOfAddress[i].copyWith(isDefault: false);
          }
        }
        emit(state.copyWith(customer: state.customer!.copyWith(listOfAddress: newListOfAddress)));
      }
    });

//? #########################################################################

    on<SetCustomerControllerEvent>((event, emit) async {
      Customer? customer = state.customer;
      if (customer == null) {
        emit(state.copyWith(customer: Customer.empty()));
      }
      emit(state.copyWith(
        companyNameController: TextEditingController(text: customer!.company ?? ''),
        firstNameController: TextEditingController(text: customer.firstName),
        lastNameController: TextEditingController(text: customer.lastName),
        emailController: TextEditingController(text: customer.email),
        phoneController: TextEditingController(text: customer.phone),
        phoneMobileController: TextEditingController(text: customer.phoneMobile),
        uidNumberController: TextEditingController(text: customer.uidNumber),
        taxNumberController: TextEditingController(text: customer.taxNumber),
      ));
    });

//? #########################################################################

    on<OnCustomerControllerChangedEvent>((event, emit) async {
      Customer? customer = state.customer;
      if (customer == null) {
        emit(state.copyWith(customer: Customer.empty()));
      }
      emit(state.copyWith(
        customer: state.customer!.copyWith(
          company: state.companyNameController.text,
          firstName: state.firstNameController.text,
          lastName: state.lastNameController.text,
          name: '${state.firstNameController.text} ${state.lastNameController.text}',
          email: state.emailController.text,
          phone: state.phoneController.text,
          phoneMobile: state.phoneMobileController.text,
          uidNumber: state.uidNumberController.text,
          taxNumber: state.taxNumberController.text,
        ),
      ));
    });

//? #########################################################################
  }
}
