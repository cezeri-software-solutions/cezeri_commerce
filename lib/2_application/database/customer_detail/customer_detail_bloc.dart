import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '/1_presentation/core/core.dart';
import '/3_domain/entities/address.dart';
import '/3_domain/entities/customer/customer.dart';
import '/3_domain/entities/receipt/receipt.dart';
import '/3_domain/entities/settings/tax.dart';
import '/3_domain/repositories/firebase/customer_repository.dart';
import '/3_domain/repositories/firebase/main_settings_respository.dart';
import '/failures/failures.dart';
import '../../../3_domain/repositories/firebase/receipt_repository.dart';

part 'customer_detail_event.dart';
part 'customer_detail_state.dart';

class CustomerDetailBloc extends Bloc<CustomerDetailEvent, CustomerDetailState> {
  final CustomerRepository customerRepository;
  final MainSettingsRepository mainSettingsRepository;
  final ReceiptRepository receiptRepository;

  CustomerDetailBloc({
    required this.customerRepository,
    required this.mainSettingsRepository,
    required this.receiptRepository,
  }) : super(CustomerDetailState.initial()) {
    on<SetCustomerDetailStatesToInitialEvent>(_onSetCustomerDetailStatesToInitial);
    on<CustomerDetailSetEmptyCustomerEvent>(_onCustomerDetailSetEmptyCustomer);
    on<CustomerDetailGetCustomerEvent>(_onCustomerDetailGetCustomer);
    on<CustomerDetailSetCustomerEvent>(_onCustomerDetailSetCustomer);
    on<CustomerDetailCreateCustomerEvent>(_onCustomerDetailCreateCustomer);
    on<CustomerDetailUpdateCustomerEvent>(_onCustomerDetailUpdateCustomer);
    on<CustomerDetailGetCustomerReceiptsEvent>(_onCustomerDetailGetCustomerReceipts);
    on<CustomerDetailSetCustomerTaxEvent>(_onCustomerDetailSetCustomerTax);
    on<CustomerDetailInvoiceTypeChangedEvent>(_onCustomerDetailInvoiceTypeChanged);
    on<CustomerDetailUpdateCustomerAddressEvent>(_onCustomerDetailUpdateCustomerAddress);
    on<CustomerDetailShownReceiptTypeChangedEvent>(_onCustomerDetailShownReceiptTypeChanged);
    on<CustomerDetailSetControllerEvent>(_onCustomerDetailSetController);
    on<CustomerDetailControllerChangedEvent>(_onCustomerDetailControllerChanged);
  }

  void _onSetCustomerDetailStatesToInitial(SetCustomerDetailStatesToInitialEvent event, Emitter<CustomerDetailState> emit) {
    emit(CustomerDetailState.initial());
  }

  void _onCustomerDetailSetEmptyCustomer(CustomerDetailSetEmptyCustomerEvent event, Emitter<CustomerDetailState> emit) async {
    emit(state.copyWith(isLoadingCustomerDetailOnObserve: true));

    final fos = await mainSettingsRepository.getSettings();
    fos.fold(
      (failure) => emit(state.copyWith(databaseFailure: failure)),
      (settings) {
        emit(state.copyWith(customer: Customer.empty().copyWith(customerNumber: settings.nextCustomerNumber)));
        add(CustomerDetailSetControllerEvent());
      },
    );

    emit(state.copyWith(isLoadingCustomerDetailOnObserve: false));
  }

  void _onCustomerDetailGetCustomer(CustomerDetailGetCustomerEvent event, Emitter<CustomerDetailState> emit) async {
    emit(state.copyWith(isLoadingCustomerDetailOnObserve: true));

    final fos = await customerRepository.getCustomer(event.customerId);
    fos.fold(
      (failure) => emit(state.copyWith(databaseFailure: failure)),
      (loadedCustomer) {
        emit(state.copyWith(customer: loadedCustomer));
        add(CustomerDetailSetControllerEvent());
        add(CustomerDetailGetCustomerReceiptsEvent());
      },
    );

    emit(state.copyWith(isLoadingCustomerDetailOnObserve: false));
  }

  void _onCustomerDetailSetCustomer(CustomerDetailSetCustomerEvent event, Emitter<CustomerDetailState> emit) {
    emit(state.copyWith(customer: event.customer));
    add(CustomerDetailSetControllerEvent());
  }

  void _onCustomerDetailCreateCustomer(CustomerDetailCreateCustomerEvent event, Emitter<CustomerDetailState> emit) async {
    emit(state.copyWith(isLoadingCustomerDetailOnCreate: true));

    final failureOrSuccess = await customerRepository.createCustomer(state.customer!);
    failureOrSuccess.fold(
      (failure) => null,
      (customer) => emit(state.copyWith(customer: customer)),
    );

    emit(state.copyWith(
      isLoadingCustomerDetailOnCreate: false,
      fosCustomerDetailOnCreateOption: optionOf(failureOrSuccess),
    ));
    emit(state.copyWith(fosCustomerDetailOnCreateOption: none()));
  }

  void _onCustomerDetailUpdateCustomer(CustomerDetailUpdateCustomerEvent event, Emitter<CustomerDetailState> emit) async {
    emit(state.copyWith(isLoadingCustomerDetailOnUpdate: true));

    final failureOrSuccess = await customerRepository.updateCustomer(state.customer!);
    failureOrSuccess.fold(
      (failure) => null,
      (customer) => emit(state.copyWith(customer: customer)),
    );

    emit(state.copyWith(
      isLoadingCustomerDetailOnUpdate: false,
      fosCustomerDetailOnUpdateOption: optionOf(failureOrSuccess),
    ));
    emit(state.copyWith(fosCustomerDetailOnUpdateOption: none()));
  }

  void _onCustomerDetailGetCustomerReceipts(CustomerDetailGetCustomerReceiptsEvent event, Emitter<CustomerDetailState> emit) async {
    emit(state.copyWith(isLoadingCustomerDetailOnObserveReceipts: true));

    final fosReceipts = await receiptRepository.getListOfReceiptsByCustomerId(state.customer!.id);
    if (fosReceipts.isRight()) {
      final receipts = fosReceipts.getRight();
      emit(state.copyWith(
        listOfCustomerOffers: receipts.where((e) => e.receiptTyp == ReceiptType.offer).toList(),
        listOfCustomerAppointments: receipts.where((e) => e.receiptTyp == ReceiptType.appointment).toList(),
        listOfCustomerDeliveryNotes: receipts.where((e) => e.receiptTyp == ReceiptType.deliveryNote).toList(),
        listOfCustomerInvoices: receipts.where((e) => e.receiptTyp == ReceiptType.invoice || e.receiptTyp == ReceiptType.credit).toList(),
        isLoadingCustomerDetailOnObserveReceipts: false,
      ));
    } else {
      emit(state.copyWith(
        receiptsFailure: fosReceipts.getLeft(),
        isLoadingCustomerDetailOnObserveReceipts: true,
      ));
    }
  }

  void _onCustomerDetailSetCustomerTax(CustomerDetailSetCustomerTaxEvent event, Emitter<CustomerDetailState> emit) {
    final updatedCustomer = state.customer?.copyWith(tax: event.tax);
    emit(state.copyWith(customer: updatedCustomer));
  }

  void _onCustomerDetailInvoiceTypeChanged(CustomerDetailInvoiceTypeChangedEvent event, Emitter<CustomerDetailState> emit) {
    final updatedCustomer = state.customer?.copyWith(customerInvoiceType: event.customerInvoiceType);
    emit(state.copyWith(customer: updatedCustomer));
  }

  void _onCustomerDetailUpdateCustomerAddress(CustomerDetailUpdateCustomerAddressEvent event, Emitter<CustomerDetailState> emit) {
    final List<Address> currentAddresses = List.from(state.customer!.listOfAddress);
    final int addressIndex = currentAddresses.indexWhere((address) => address.id == event.address.id);

    if (addressIndex == -1) {
      _addNewAddress(event.address, currentAddresses, emit);
    } else {
      _editExistingAddress(addressIndex, event.address, currentAddresses, emit);
    }
  }

  void _addNewAddress(Address newAddress, List<Address> currentAddresses, Emitter<CustomerDetailState> emit) {
    _ensureOnlyOneDefaultAddress(newAddress, currentAddresses);
    currentAddresses.add(newAddress);

    _addComplementaryAddressIfNeeded(newAddress, currentAddresses);

    emit(state.copyWith(customer: state.customer!.copyWith(listOfAddress: currentAddresses)));
  }

  void _editExistingAddress(int index, Address updatedAddress, List<Address> currentAddresses, Emitter<CustomerDetailState> emit) {
    currentAddresses[index] = updatedAddress;
    _ensureOnlyOneDefaultAddress(updatedAddress, currentAddresses);

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

  void _onCustomerDetailShownReceiptTypeChanged(CustomerDetailShownReceiptTypeChangedEvent event, Emitter<CustomerDetailState> emit) {
    emit(state.copyWith(shownReceiptType: event.type));
  }

  void _onCustomerDetailSetController(CustomerDetailSetControllerEvent event, Emitter<CustomerDetailState> emit) {
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

  void _onCustomerDetailControllerChanged(CustomerDetailControllerChangedEvent event, Emitter<CustomerDetailState> emit) {
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
